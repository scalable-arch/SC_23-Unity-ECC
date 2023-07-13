#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <ctime>
#include<iostream>
#include<cstdlib>
#include <vector>
#include <set>
#include <algorithm>
#include <math.h>
#include <cstring>

// Configuration 
#define CHANNEL_WIDTH 40
#define CHIP_NUM 10
#define DATA_CHIP_NUM 8 // # of data chips per each sub-channel
#define CHIP_WIDTH 4
#define BLHEIGHT 32 // Burst length tha RL-ECC has to check (BL32 (no OD-ECC redundancy). considering conservative mode)
#define SYMBOL_SIZE 8 // RL-ECC symbol size (GF(2^8): 8-bit symbol)

#define OECC_CW_LEN 136 // OD-ECC codeword length
#define OECC_DATA_LEN 128 // OD-ECC dataword length
#define OECC_REDUN_LEN 8 // OD-ECC redundancy length

#define RECC_CW_LEN 80 // RL-ECC codeword length
#define RECC_DATA_LEN 64 // RL-ECC dataword length
#define RECC_REDUN_LEN 16 // RL-ECC redundancy length

#define RECC_REDUN_SYMBOL_NUM 2 // # of RL-ECC redundancy symbols
#define RECC_CW_SYMBOL_NUM 10 // # of RL-ECC codeword symbols

#define RUN_NUM 1000000000 // iteration time (1 billion)

#define CONSERVATIVE_MODE 1 // 1: Conservavie mode, 0: Restrained mode
//configuration over

using namespace std;
unsigned int primitive_poly[16][256]={0,}; // 16 types of primitive polynomial, each has 256 unique values, ex : primitive_poly[4][254] = a^254, primitive_poly[4][255] = 0 (prim_num=4, primitive_poly = x^8+x^6+x^4+x^3+x^2+x^1+1)
vector<unsigned int> SSC_Syndromes; // Keep Syndromes
vector<unsigned int> DEC_Syndromes; // Keep Syndromes
unsigned int H_Matrix_SEC[OECC_REDUN_LEN][OECC_CW_LEN]; // 8 x 136
unsigned int H_Matrix_SSC_DEC[RECC_REDUN_SYMBOL_NUM][RECC_CW_SYMBOL_NUM]; // 2 x 10
unsigned int DEC_Syndrome[9][10][8][8]={0,}; // Unity ECC: DEC syndrome table => [i][j][n][m] total 16bit (S1, S0 syndromes). 
                                        // DEC_Syndrome[3][5][1][5] : i=3(4th chip), j=5(6th chip) each has 1bit error. => i=0 ~ 8, j=i+1 ~ 9
                                        // error value: 'i'th chip a^n. If n=1, 0000_0010 => 4th chip, 7th bit error occurs.
                                        // error value: 'j'th chip a^m. If m=5, 0010_0000 => 6th chip, 3th bit error occurs.
enum OECC_TYPE {NO_OECC=0, HSIAO=1}; // oecc_type
enum FAULT_TYPE {SE_NE_NE=0, SE_SE_NE=1, SE_SE_SE=2, CHIPKILL_NE_NE=3, CHIPKILL_SE_NE=4, CHIPKILL_CHIPKILL_NE=5, DE_NE_NE=6, DE_DE_NE=7, DE_DE_DE=8, CHIPKILL_DE_NE=9}; // error_type
enum RECC_TYPE {AMDCHIPKILL=0, SSC_DEC=1, NO_RECC=2}; // recc_type
enum RESULT_TYPE {NE=0, CE=1, DUE=2, SDC=3}; // result_type

// A function that reads only the specified bit from an integer and returns it.
int getAbit(unsigned short x, int n) { 
  return (x & (1 << n)) >> n;
}

// Converting a polynomial expression into decimal form.
unsigned int conversion_to_int_format(char *str_read, int m)
{
    unsigned int primitive_value=0;
    if(strstr(str_read,"^7")!=NULL)
        primitive_value+=int(pow(2,7));
    if(strstr(str_read,"^6")!=NULL)
        primitive_value+=int(pow(2,6));
    if(strstr(str_read,"^5")!=NULL)
        primitive_value+=int(pow(2,5));
    if(strstr(str_read,"^4")!=NULL)
        primitive_value+=int(pow(2,4));
    if(strstr(str_read,"^3")!=NULL)
        primitive_value+=int(pow(2,3));
    if(strstr(str_read,"^2")!=NULL)
        primitive_value+=int(pow(2,2));
    if(strstr(str_read,"^1+")!=NULL) // "+1" always gets added next, no matter what!
        primitive_value+=int(pow(2,1));
    if(strstr(str_read,"+1")!=NULL)
        primitive_value+=int(pow(2,0));
    

    return primitive_value;
}

// Generating a primitive polynomial table.
void generate_primitive_poly(unsigned int prim_value, int m, int prim_num)
{
    unsigned int value = 0x1; // start value (0000 0001)
    int total_count = int(pow(2,m));
    int count=0;
    while (count<total_count-1){ // count : 0~254
        primitive_poly[prim_num][count]=value;
        if(value>=0x80){ // If the m-th bit is 1, perform XOR operation with the primitive polynomial.
            // Set the (m+1)-th bit of the value to 0 and shift.
            value=value<<(32-m+1);
            value=value>>(32-m);

            //primitive polynomial과 xor 연산
            value=value^prim_value;
        }
        else // If the (m+1)-th bit is 0, shift one bit to the left.
            value=value<<1;
        
        count++;
    }

    return;
}

// Generating the DEC_Syndrome table.
void generate_DEC_Syndrome()
{
    unsigned int value;
    unsigned int S0,S1;
    for(int i=0; i<9; i++){
        for(int j=i+1; j<10; j++){
            for(int n=0; n<8; n++){
                for(int m=0; m<8; m++){
                    if(0<=i && i<j && j<=7){
                        S0=primitive_poly[4][H_Matrix_SSC_DEC[0][i]+n] ^ primitive_poly[4][H_Matrix_SSC_DEC[0][j]+m]; // i=0, j=1 => S0 = (a^25+n) ^ (a^39+m)
                        S1=primitive_poly[4][H_Matrix_SSC_DEC[1][i]+n] ^ primitive_poly[4][H_Matrix_SSC_DEC[1][j]+m]; // i=0, j=1 => S1 = (a^50+n) ^ (a^78+m)
                    }
                    else if(0<=i && i<=7 && j==8){
                        S0=primitive_poly[4][H_Matrix_SSC_DEC[0][i]+n] ^ primitive_poly[4][m]; // i=0, j=8 => S0 = (a^25+n) ^ (a^m)
                        S1=primitive_poly[4][H_Matrix_SSC_DEC[1][i]+n] ^ 0; // i=0, j=8 => S0 = (a^50+n) ^ 0 = a^(50+n)
                    }
                    else if(0<=i && i<=7 && j==9){
                        S0=primitive_poly[4][H_Matrix_SSC_DEC[0][i]+n] ^ 0; // i=0, j=9 => S0 = (a^25+n) ^ 0 = a^(25+n)
                        S1=primitive_poly[4][H_Matrix_SSC_DEC[1][i]+n] ^ primitive_poly[4][m]; // i=0, j=9 => S1 = (a^50+n) ^ (a^m)
                    }
                    else if(i==8 && j==9){
                        S0=primitive_poly[4][n]; // i=8, j=9 => S0 = (a^n)
                        S1=primitive_poly[4][m]; // i=8, j=9 => S1 = (a^m)
                    }
                    
                    value=S0+(S1<<8);
                    DEC_Syndrome[i][j][n][m]=value;
                }
            }
        }
    }
    return;
}

// Set the type of OECC, RECC, and FAULT TYPE as a string. This will determine how to handle error injection, OECC, and RECC later on!!
void oecc_recc_fault_type_assignment(string &OECC, string &FAULT, string &RECC, int *oecc_type, int *fault_type, int*recc_type, int oecc, int fault, int recc)
{
    // 1. Specify OECC TYPE
    // int oecc, int fault, and int recc are passed as arguments to the main function through argv, which can be changed in run.py.
    switch (oecc){
        case NO_OECC:
            OECC.replace(OECC.begin(), OECC.end(),"RAW");
            *oecc_type=NO_OECC;
            break;
        case HSIAO:
            OECC.replace(OECC.begin(), OECC.end(),"HSIAO");
            *oecc_type=HSIAO;
            break;
        default:
            break;
    }
    switch (fault){
        case SE_NE_NE:
            FAULT.replace(FAULT.begin(), FAULT.end(),"SE_NE_NE");
            *fault_type=SE_NE_NE;
            break;
        case SE_SE_NE:
            FAULT.replace(FAULT.begin(), FAULT.end(),"SE_SE_NE");
            *fault_type=SE_SE_NE;
            break;
        case SE_SE_SE:
            FAULT.replace(FAULT.begin(), FAULT.end(),"SE_SE_SE");
            *fault_type=SE_SE_SE;
            break;
        case CHIPKILL_NE_NE:
            FAULT.replace(FAULT.begin(), FAULT.end(),"CHIPKILL_NE_NE");
            *fault_type=CHIPKILL_NE_NE;
            break;
        case CHIPKILL_SE_NE:
            FAULT.replace(FAULT.begin(), FAULT.end(),"CHIPKILL_SE_NE");
            *fault_type=CHIPKILL_SE_NE;
            break;
        case CHIPKILL_CHIPKILL_NE:
            FAULT.replace(FAULT.begin(), FAULT.end(),"CHIPKILL_CHIPKILL_NE");
            *fault_type=CHIPKILL_CHIPKILL_NE;
            break;
        case DE_NE_NE:
            FAULT.replace(FAULT.begin(), FAULT.end(),"DE_NE_NE");
            *fault_type=DE_NE_NE;
            break;
        case DE_DE_NE:
            FAULT.replace(FAULT.begin(), FAULT.end(),"DE_DE_NE");
            *fault_type=DE_DE_NE;
            break;
        case DE_DE_DE:
            FAULT.replace(FAULT.begin(), FAULT.end(),"DE_DE_DE");
            *fault_type=DE_DE_DE;
            break;
        case CHIPKILL_DE_NE:
            FAULT.replace(FAULT.begin(), FAULT.end(),"CHIPKILL_DE_NE");
            *fault_type=CHIPKILL_DE_NE;
            break;
        default:
            break;
    }
    switch (recc){
        // (80,64) SSC [8b symbol] 'or' (40,32) SSC (4b symbol)
        case AMDCHIPKILL: 
            RECC.replace(RECC.begin(), RECC.end(),"AMDCHIPKILL");
            *recc_type=AMDCHIPKILL;
            break;
        // (80, 64) SSC-DEC (8b symbol)
        case SSC_DEC:
            RECC.replace(RECC.begin(), RECC.end(),"SSC_DEC");
            *recc_type=SSC_DEC;
            break;
        case NO_RECC:
            RECC.replace(RECC.begin(), RECC.end(),"RAW");
            *recc_type=NO_RECC;
            break;
        default:
            break;
    }
    return;
}

// SE injection (Single Error injection)
void error_injection_SE(int Fault_Chip_position, unsigned int Chip_array[][OECC_CW_LEN], int oecc_type)
{
    int Fault_pos;
    if(oecc_type==NO_OECC){
        Fault_pos = rand()%OECC_DATA_LEN; // 0~127
    }
    else if(oecc_type==HSIAO){
        Fault_pos = rand()%OECC_CW_LEN; // 0~135
    }

    Chip_array[Fault_Chip_position][Fault_pos]^=1;
    return;
}

// DE injection (Double Error injection)
void error_injection_DE(int Fault_Chip_position, unsigned int Chip_array[][OECC_CW_LEN], int oecc_type)
{
    int First_fault_pos;
    int Second_fault_pos;
    if(oecc_type==NO_OECC){
        First_fault_pos = rand()%OECC_DATA_LEN; // 0~127
    }
    else if(oecc_type==HSIAO){
        First_fault_pos = rand()%OECC_CW_LEN; // 0~135
    }

    while(1){
        if(oecc_type==NO_OECC){
            Second_fault_pos = rand()%OECC_DATA_LEN; // 0~127
        }
        else if(oecc_type==HSIAO){
            Second_fault_pos = rand()%OECC_CW_LEN; // 0~135
        }
        if(First_fault_pos!=Second_fault_pos)
            break;
    }

    Chip_array[Fault_Chip_position][First_fault_pos]^=1;
    Chip_array[Fault_Chip_position][Second_fault_pos]^=1;
    return;
}

// Chipkill injection
void error_injection_CHIPKILL(int Fault_Chip_position, unsigned int Chip_array[][OECC_CW_LEN], int oecc_type)
{
    if(oecc_type==NO_OECC){
        for(int Fault_pos=0; Fault_pos<OECC_DATA_LEN; Fault_pos++){ // 0~127
            if(rand()%2!=0) // 0(no error) 'or' 1(bit-flip)
                Chip_array[Fault_Chip_position][Fault_pos]^=1;
        }
    }
    else if(oecc_type==HSIAO){
        for(int Fault_pos=0; Fault_pos<OECC_CW_LEN; Fault_pos++){ // 0~135
            if(rand()%2!=0) // 0(no error) 'or' 1(bit-flip)
                Chip_array[Fault_Chip_position][Fault_pos]^=1;
        }
    }

    return;
}

// OECC 1bit correction
void error_correction_oecc(int Fault_Chip_position, unsigned int Chip_array[][OECC_CW_LEN])
{
    unsigned int Syndromes[OECC_REDUN_LEN]; // 8 x 1
    
    // Syndromes = H * C^T
    for(int row=0; row<OECC_REDUN_LEN; row++){
        unsigned int row_value=0;
        for(int column=0; column<OECC_CW_LEN; column++)
            row_value=row_value^(H_Matrix_SEC[row][column] * Chip_array[Fault_Chip_position][column]);
        Syndromes[row]=row_value;
    }

    // error correction (Check Syndromes)
    int cnt=0;
    for(int error_pos=0; error_pos<OECC_CW_LEN; error_pos++){
        cnt=0;
        for(int row=0; row<OECC_REDUN_LEN; row++){
            if(Syndromes[row]==H_Matrix_SEC[row][error_pos])
                cnt++;
            else
                break;
        }
    // Error correction is performed only when a 1-bit error occurs.
        if(cnt==OECC_REDUN_LEN){
            Chip_array[Fault_Chip_position][error_pos]^=1; // error correction (bit-flip)
            return;
        }
    }

    // Correction is not performed in cases where no error occurs or when the error is not a 1-bit error.
    return;
}

int SDC_check(int BL, unsigned int Chip_array[][OECC_CW_LEN], int oecc_type, int recc_type)
{
    // Check if there is still a 1 in the cacheline.
    // -> If there is RECC, check chips 0 to 9. If there is no RECC, check chips 0 to 7.

    int error_check=0;
    
    // No RECC
    if(recc_type==NO_RECC){
        for(int Error_chip_pos=0; Error_chip_pos<DATA_CHIP_NUM; Error_chip_pos++){ // 0~7th chip
            for(int Fault_pos=BL*4; Fault_pos<(BL+2)*4; Fault_pos++){ // 0~127b
                if(Chip_array[Error_chip_pos][Fault_pos]==1){
                    error_check++;
                    return error_check;
                } 
            }
        }
    }
    
    // RECC
    else if(recc_type!=NO_RECC){
        for(int Error_chip_pos=0; Error_chip_pos<CHIP_NUM; Error_chip_pos++){ // 0~9th chip
            for(int Fault_pos=BL*4; Fault_pos<(BL+2)*4; Fault_pos++){ // 0~127b
                if(Chip_array[Error_chip_pos][Fault_pos]==1){
                    error_check++;
                    return error_check;
                }
            }
        }
    }

    return error_check;
}

int Yield_check(unsigned int Chip_array[][OECC_CW_LEN], int oecc_type, int recc_type)
{
    // Check if there is still a 1 in the entire two cachelines.
    // -> If there is RECC, check chips 0 to 9. If there is no RECC, check chips 0 to 7.

    int error_check=0;
 
    // No RECC
    if(recc_type==NO_RECC){
        for(int Error_chip_pos=0; Error_chip_pos<DATA_CHIP_NUM; Error_chip_pos++){ // 0~7th chip
            for(int Fault_pos=0; Fault_pos<OECC_DATA_LEN; Fault_pos++){ // 0~127b
                if(Chip_array[Error_chip_pos][Fault_pos]==1){
                    error_check++;
                    return error_check;
                }
            }
        }
    }
    
    // RECC
    else if(recc_type!=NO_RECC){
        for(int Error_chip_pos=0; Error_chip_pos<CHIP_NUM; Error_chip_pos++){ // 0~9th chip
            for(int Fault_pos=0; Fault_pos<OECC_DATA_LEN; Fault_pos++){ // 0~127b
                if(Chip_array[Error_chip_pos][Fault_pos]==1){
                    error_check++;
                    return error_check;
                }
            }
        }
    }

    return error_check;
}

// AMDChipkill
// Configuration automation has not been implemented here (if you want to change the channel size, BL, etc. later, be careful when reviewing this section!!)
void error_correction_recc_AMDCHIPKILL(int BL, int *result_type_recc, set<int> &error_chip_position, unsigned int Chip_array[][OECC_CW_LEN])
{
    // Primitive polynomial: x^8 + x^4 + x^3 + x^2 + 1
    /*
        (1) If all Syndromes are 0 => return NE
        (2) If Syndromes are not 0 and match the syndrome of SSC [S1/S0 is one of a^0~a^9] => proceed with SSC => return CE
        (3) If Syndromes are not 0 and do not match the syndrome of SSC => return DUE
    */
    
    // Generate codeword 
    unsigned int codeword[RECC_CW_LEN];
    for(int column=0; column<CHIP_NUM; column++){ // 0~9
        //printf("chip index : %d,",column/8);
        for(int symbol_index=BL*4; symbol_index<(BL+2)*4; symbol_index++){ // 0~7, 8~15, 16~23 ... 
            int chip_index=column; // 0~9
            //printf("symbol_index : %d, ",symbol_index);
            codeword[chip_index*8+(symbol_index)%8]=Chip_array[chip_index][symbol_index];
        }
        //printf("\n");
    }

    //printf("\ncodeword : ");
    //for(int column=0; column<RECC_CW_LEN; column++)
    //    printf("%d ",codeword[column]);
    //printf("\n");

    // Calculate Syndrome
    // S0 = (a^exponent0) ^ (a^exponent1) ^ (a^exponent2) ... ^(a^exponent9)
    // S1 = (a^exponent0) ^ (a^[exponent1+1]) ^ (a^[exponent2+2]) ... ^ (a^[exponent9+9])
    // Calculate S0
    unsigned int S0=0,S1=0;
    for(int symbol_index=0; symbol_index<RECC_CW_SYMBOL_NUM; symbol_index++){ // 0~9
        unsigned exponent=255; // 0000_0000: 255 (exceptional case!)
        unsigned symbol_value=0; // 0000_0000 ~ 1111_1111
        // Example: If the first 8 bits of the codeword are 0 1 0 1 1 1 0 0,
        // the symbol_value is (0<<7) ^ (1<<6) ^ (0<<5) ^ (1<<4) ^ (1<<3) ^ (1<<2) ^ (0<<1) ^ (0<<0) = 0101_1100.
        for(int symbol_value_index=0; symbol_value_index<SYMBOL_SIZE; symbol_value_index++){ // 8-bit symbol
            symbol_value^=(codeword[symbol_index*8+symbol_value_index] << (SYMBOL_SIZE-1-symbol_value_index)); // <<7, <<6, ... <<0
        }
        for(int prim_exponent=0; prim_exponent<255; prim_exponent++){
            if(symbol_value==primitive_poly[0][prim_exponent]){
                exponent=prim_exponent;
                break;
            }
        }
        //printf("symbol_index : %d, symbol_value : %d\n",symbol_index, symbol_value);

        if(exponent!=255) // S0 = (a^exponent0) ^ (a^exponent1) ^ (a^exponent2) ... ^(a^exponent9)
            S0^=primitive_poly[0][exponent];
    }


    // Calculate S1
    for(int symbol_index=0; symbol_index<RECC_CW_SYMBOL_NUM; symbol_index++){ // 0~9
        unsigned exponent=255; // 0000_0000: 255 (exceptional case!)
        unsigned symbol_value=0; // 0000_0000 ~ 1111_1111
        for(int symbol_value_index=0; symbol_value_index<SYMBOL_SIZE; symbol_value_index++){ // 8-bit symbol
            symbol_value^=(codeword[symbol_index*8+symbol_value_index] << (SYMBOL_SIZE-1-symbol_value_index)); // <<7, <<6, ... <<0
        }
        for(int prim_exponent=0; prim_exponent<255; prim_exponent++){
            if(symbol_value==primitive_poly[0][prim_exponent]){
                exponent=prim_exponent;
                break;
            }
        }
        
        if(exponent!=255) // S1 = (a^exponent0) ^ (a^[exponent1+1]) ^ (a^[exponent2+2]) ... ^ (a^[exponent9+9])
            S1^=primitive_poly[0][(exponent+symbol_index)%255];
    }

    // S0 = a^p, S1= a^q (a^0 ~ a^254)
    unsigned int p,q;
    for(int prim_exponent=0; prim_exponent<255; prim_exponent++){
        if(S0==primitive_poly[0][prim_exponent])
            p=prim_exponent;
        if(S1==primitive_poly[0][prim_exponent])
            q=prim_exponent;
    }
    //printf("S0 : %d(a^%d), S1 : %d(a^%d)\n",S0,p,S1,q);

    //printf("S0 : %d\n",S0);
    if(S0==0 && S1==0){ // NE (No Error)
        *result_type_recc=NE;
        return;
    }
    
    // CE 'or' DUE
    // error chip position
    int error_chip_position_recc;
    error_chip_position_recc=(q+255-p)%255;

    // Table
    if(0<=error_chip_position_recc && error_chip_position_recc < CHIP_NUM){ // CE (error chip location : 0~9)
        // printf("CE case! error correction start!\n");
        //error correction
        for(int symbol_index=0; symbol_index<SYMBOL_SIZE; symbol_index++){ // 0~7
            Chip_array[error_chip_position_recc][BL*4+symbol_index]^=getAbit(S0, SYMBOL_SIZE-1-symbol_index); // S0 >> 7, S0 >> 6 ... S0 >> 0
        }
        // printf("CE case! error correction done!\n");     

        // return result type recc (CE), error chip position
        error_chip_position.insert(error_chip_position_recc);
        *result_type_recc=CE;
        return;
    }
    // Table End!!!!!
    
    // DUE
    // When the syndrome is not 0 and no correction has been made.
    *result_type_recc=DUE;
    
    return;
}

void error_correction_recc_SSC_DEC(int BL, int *result_type_recc, set<int> &error_chip_position, unsigned int Chip_array[][OECC_CW_LEN])
{
    // Primitive polynomial: x^8 + x^6 + x^4 + x^3 + x^2 + x^1 + 1 (prim_num=4)
    /*
        (1) If all Syndromes are 0 => return NE
        (2) If Syndromes are not 0 and match the syndrome of SSC [S1/S0 is one of a^0~a^9] => proceed with SSC => return CE
        (3) If Syndromes are not 0 and match the syndrome of DEC => proceed with DEC => return CE
        (4) If Syndromes are not 0 and do not match the syndrome of SSC or DEC => return DUE
    */
    
    // Generate codeword
    unsigned int codeword[RECC_CW_LEN];
    for(int column=0; column<CHIP_NUM; column++){ // 0~9
        //printf("chip index : %d,",column/8);
        for(int symbol_index=BL*4; symbol_index<(BL+2)*4; symbol_index++){ // 0~7, 8~15, 16~23 ... 
            int chip_index=column; // 0~9
            //printf("symbol_index : %d, ",symbol_index);
            codeword[chip_index*8+(symbol_index)%8]=Chip_array[chip_index][symbol_index];
        }
        //printf("\n");
    }

    // Calculate Syndrome
    // S0 = (a^exponent0) ^ (a^exponent1) ^ (a^exponent2) ... ^(a^exponent9)
    // S1 = (a^exponent0) ^ (a^[exponent1+1]) ^ (a^[exponent2+2]) ... ^ (a^[exponent9+9])
    // Calculate S0
    unsigned int S0=0,S1=0;
    for(int symbol_index=0; symbol_index<RECC_CW_SYMBOL_NUM; symbol_index++){ // 0~9
        unsigned exponent=255; // 0000_0000: 255 (Exceptional cases!)
        unsigned symbol_value=0; // 0000_0000 ~ 1111_1111
        unsigned codeword_symbol_binary=0; // Each symbol in the codeword is represented by an 8-bit value. For example, if the codeword is 0100_0000, ..., it represents the value of the first symbol, 0100_0000.
        unsigned codeword_symbol=0; // Each symbol in the codeword has a value. For example, if the codeword is c0(8bit), c1(8bit), c2(8bit), ..., c9(8bit) and is equal to 0100_0000, ..., it represents the value of the first symbol, 0100_0000 (a^6), which corresponds to the value 6.
        int count=SYMBOL_SIZE-1;

        // Convert each 8-bit segment of the codeword to its corresponding symbol form. For example, if the codeword is c0, c1, c2, ..., c9 (each representing the exponent of an 8-bit symbol).
        for(int codeword_index=symbol_index*SYMBOL_SIZE; codeword_index<(symbol_index+1)*SYMBOL_SIZE; codeword_index++){ // 0~7, 8~15, 16~23, ... , 72~29
            codeword_symbol_binary^=(codeword[codeword_index]<<count);
            count--;
        }
        
        for(int prim_exponent=0; prim_exponent<256; prim_exponent++){
            if(primitive_poly[4][prim_exponent] == codeword_symbol_binary){
                codeword_symbol=prim_exponent; // c0, c1, c2, ..., c9 (each representing the exponent of an 8-bit symbol).
                break;
            }
        }

        // Calculate S0
        if(H_Matrix_SSC_DEC[0][symbol_index]!=255 && codeword_symbol!=255){ // If the corresponding part of the H_Matrix is not 0, an error has occurred in the codeword in the corresponding position (if the 8-bit segment is not all 0s).
            symbol_value=primitive_poly[4][(H_Matrix_SSC_DEC[0][symbol_index] + codeword_symbol) % 255]; // a^(25+c0), a^(39+c1), a^(63+c2) ... a^(0+c8) 
            S0^=symbol_value;
        }
    }

    // Calculate S1
    for(int symbol_index=0; symbol_index<RECC_CW_SYMBOL_NUM; symbol_index++){ // 0~9
        unsigned exponent=255; // 0000_0000: 255 (exceptional case!)
        unsigned symbol_value=0; // 0000_0000 ~ 1111_1111
        unsigned codeword_symbol_binary=0; // Each symbol in the codeword is represented by an 8-bit value. For example, if the codeword is 0100_0000, ..., it represents the value of the first symbol, 0100_0000.
        unsigned codeword_symbol=0; // Each symbol in the codeword has a value. For example, if the codeword is c0(8bit), c1(8bit), c2(8bit), ..., c9(8bit) and is equal to 0100_0000, ..., it represents the value of the first symbol, 0100_0000 (a^6), which corresponds to the value 6.
        int count=SYMBOL_SIZE-1;

        // Convert each 8-bit segment of the codeword to its corresponding symbol form. For example, if the codeword is c0, c1, c2, ..., c9 (each representing the exponent of an 8-bit symbol).
        for(int codeword_index=symbol_index*SYMBOL_SIZE; codeword_index<(symbol_index+1)*SYMBOL_SIZE; codeword_index++){ // 0~7, 8~15, 16~23, ... , 72~29
            codeword_symbol_binary^=(codeword[codeword_index]<<count);
            count--;
        }
        
        for(int prim_exponent=0; prim_exponent<256; prim_exponent++){
            if(primitive_poly[4][prim_exponent] == codeword_symbol_binary){
                codeword_symbol=prim_exponent; // c0, c1, c2 ... c9 (각각 8bit symbol의 exponent를 나타낸다.)
                break;
            }
        }

        // S1 계산
        if(H_Matrix_SSC_DEC[1][symbol_index]!=255 && codeword_symbol!=255){ // H_Matrix의 해당 부분이 0이 아닌 경우, codeword의 해당 경우에서 error가 발생한 경우 (8bit이 all'0s이 아닌 경우)
            symbol_value=primitive_poly[4][(H_Matrix_SSC_DEC[1][symbol_index] + codeword_symbol) % 255]; // a^(50+c0), a^(78+c1), a^(126+c2) ... a^(0+c9) 
            S1^=symbol_value;
        }
    }


    //printf("S0 : %d, S1 : %d\n",S0,S1);
    if(S0==0 && S1==0){ // NE (No Error)
        *result_type_recc=NE;
        return;
    }

    // S0 = a^p, S1= a^q (a^0 ~ a^255[all'0s])
    unsigned int p,q;
    for(int prim_exponent=0; prim_exponent<256; prim_exponent++){
        if(S0==primitive_poly[4][prim_exponent])
            p=prim_exponent;
        if(S1==primitive_poly[4][prim_exponent])
            q=prim_exponent;
    }
    //printf("S0 : %d(a^%d), S1 : %d(a^%d)\n",S0,p,S1,q);


    /////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////
    // Error correction
    // SSC
    // error chip 위치가 0~7번째인 경우
    if(S0!=0 && S1!=0){
        int error_position=(q+255-p)%255;
        for(int error_chip_position_index=0; error_chip_position_index<8; error_chip_position_index++){ // error_position = 25, 39, 63, ... 230
            if(error_position == H_Matrix_SSC_DEC[0][error_chip_position_index]){
                int error_value = primitive_poly[4][((p+255)-error_position)%255]; // a^n

                for(int symbol_index=0; symbol_index<SYMBOL_SIZE; symbol_index++){ // 0~7
                    Chip_array[error_chip_position_index][BL*4+symbol_index]^=getAbit(error_value, SYMBOL_SIZE-1-symbol_index); // error_value >> 7, error_value >> 6 ... error_value >> 0
                }

                error_chip_position.insert(error_chip_position_index);
                *result_type_recc=CE;
                return;
            }
        }
    }
    // error chip 위치가 8번째인 경우
    else if(S0!=0 && S1==0){
        for(int symbol_index=0; symbol_index<SYMBOL_SIZE; symbol_index++){ // 0~7
            Chip_array[8][BL*4+symbol_index]^=getAbit(S0, SYMBOL_SIZE-1-symbol_index); // S0 >> 7, S0 >> 6 ... S0 >> 0
        }

        error_chip_position.insert(8);
        *result_type_recc=CE;
        return;
    }
    // error chip 위치가 9번째인 경우
    else if(S0==0 && S1!=0){
        for(int symbol_index=0; symbol_index<SYMBOL_SIZE; symbol_index++){ // 0~7
            Chip_array[9][BL*4+symbol_index]^=getAbit(S1, SYMBOL_SIZE-1-symbol_index); // S1 >> 7, S1 >> 6 ... S1 >> 0
        }

        error_chip_position.insert(9);
        *result_type_recc=CE;
        return;     
    }
    /////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////

    /////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////
    // DEC
    int syndrome=S0+(S1<<8);
    for(int i=0; i<9; i++){
        for(int j=i+1; j<10; j++){
            for(int n=0; n<8; n++){
                for(int m=0; m<8; m++){
                    if(syndrome==DEC_Syndrome[i][j][n][m]){
                        Chip_array[i][BL*4+SYMBOL_SIZE-n-1]^=1; // n=0이면 0000_0001이니 'i' chip의 해당 BL 부분의 8번째 bit에서 error가 발생
                        Chip_array[j][BL*4+SYMBOL_SIZE-m-1]^=1; // m=5이면 0010_0000이니 'j' chip의 해당 BL 부분의 3번쨰 bit에서 error가 발생
                        
                        error_chip_position.insert(i);
                        error_chip_position.insert(j); // 서로 다른 chip 위치 2개를 저장하니, conservative mode를 킨다면 무조건 DUE이다!!!!

                        // 이전에 2-bit error correction 한 적 있다.
                        if(error_chip_position.count(-1))
                            error_chip_position.insert(-2);
                        // 해당 cacheline에서 처음 2-bit correction 진행 
                        else
                            error_chip_position.insert(-1);

                        *result_type_recc=CE;
                        return;
                    }
                }
            }
        }
    }

    /////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////

    // DUE 처리
    *result_type_recc=DUE;
    return;
}

int main(int argc, char* argv[])
{
    // 1. GF(2^8) primitive polynomial table 생성
    // prim_num으로 구분한다!!!!!!!!!!!!!!!!!
    FILE *fp=fopen("GF_2^8__primitive_polynomial.txt","r");
    int primitive_count=0;
    while(1){
        char str_read[100];
        unsigned int primitive_value=0;
        fgets(str_read,100,fp);
        primitive_value=conversion_to_int_format(str_read, 8);

        generate_primitive_poly(primitive_value,8,primitive_count); // ex : primitive polynomial : a^16 = a^9+a^8+a^7+a^6+a^4+a^3+a^2+1 = 0000 0011 1101 1101 = 0x03DD (O) -> 맨 오른쪽 prim_num : 0
        primitive_count++;

        if(feof(fp))
            break;
    }
    fclose(fp);

    // 2. H_Matrix 설정
    // SEC : OECC
    FILE *fp4=fopen("H_Matrix_SEC.txt","r");
    while(1){
        unsigned int value;
        for(int row=0; row<OECC_REDUN_LEN; row++){
            for(int column=0; column<OECC_CW_LEN; column++){
                fscanf(fp4,"%d ",&value);
                H_Matrix_SEC[row][column]=value;
                //printf("%d ",H_Matrix_binary[row][column]);
            }
        }
        if(feof(fp4))
            break;
    }
    fclose(fp4);

    // AMDCHIPKILL은 따로 H-Matrix 입력하지 않는다.
    // SSC_DEC : RECC (2 x 10 형태 [Shortened RS-code의 H-Matrix])
    /* H-Matrix는 아래 모양과  같다. (2 x 10 형태)
        | a^25, a^39, a^63, a^108, a^141, a^184, a^215, a^230, a^0, 0 |
        | a^50, a^78, a^126, a^216, a^27, a^113, a^175, a^205, 0, a^0 |

        표시 의미 : a^25(primitive_poly[4][25]), a^0(primitive_poly[4][0]), 0(primitive_poly[4][255])
    */

    H_Matrix_SSC_DEC[0][0]=25,H_Matrix_SSC_DEC[0][1]=39,H_Matrix_SSC_DEC[0][2]=63,H_Matrix_SSC_DEC[0][3]=108,H_Matrix_SSC_DEC[0][4]=141,H_Matrix_SSC_DEC[0][5]=184,H_Matrix_SSC_DEC[0][6]=215,H_Matrix_SSC_DEC[0][7]=230,H_Matrix_SSC_DEC[0][8]=0,H_Matrix_SSC_DEC[0][9]=255;
    H_Matrix_SSC_DEC[1][0]=50,H_Matrix_SSC_DEC[1][1]=78,H_Matrix_SSC_DEC[1][2]=126,H_Matrix_SSC_DEC[1][3]=216,H_Matrix_SSC_DEC[1][4]=27,H_Matrix_SSC_DEC[1][5]=113,H_Matrix_SSC_DEC[1][6]=175,H_Matrix_SSC_DEC[1][7]=205,H_Matrix_SSC_DEC[1][8]=255,H_Matrix_SSC_DEC[1][9]=0;
    generate_DEC_Syndrome(); // DEC의 syndrome table 생성

    // 3. 출력 파일 이름 설정 & oecc/fault/recc type 설정 (main 함수의 argv parameter로 받는다.
    // run.py에서 변경 가능!!!

    // 파일명 예시
    // ex : HSIAO_AMDCHIPKILL_SE_NE_NE -> OECC에는 HSIAO(SEC), RECC에는 AMDCHIPKILL, FAULT는 3chip중에서 1개 chip에만 1bit(SE[Single Error]) 발생하고 나머지 2개 chip에는 error가 발생하지 않는(NE[No Error]) 경우
    // ex : RAW_SSC_DEC_CHIPKILL_SE_NE -> OECC는 없다 (RAW), RECC에는 SSC_DEC, FAULT는 3chip중에서 2개 chip에 error가 발생하고 (1개는 chipkill, 1개는 SE) 나머지 1개는 NE 이다.
    string OECC="X", RECC="X", FAULT="X"; // => 파일 이름 생성을 위한 변수들. 그 이후로는 안쓰인다.
    int oecc_type, recc_type,fault_type; // => on-die ECC, Rank-level ECC, fault_type 분류를 위해 쓰이는 변수. 뒤에서도 계속 사용된다.
    oecc_recc_fault_type_assignment(OECC, FAULT, RECC, &oecc_type, &fault_type, &recc_type, atoi(argv[1]), atoi(argv[2]), atoi(argv[3]));
    
    string Result_file_name = OECC + "_" + RECC + "_" + FAULT + ".S";
    FILE *fp3=fopen(Result_file_name.c_str(),"w"); // c_str : string class에서 담고 있는 문자열을 c에서의 const char* 타입으로 변환하여 반환해주는 편리한 멤버함수

    // 4. 여기서부터 반복문 시작 (1억번)
    // DIMM 설정 (Channel에 있는 chip 구성을 기본으로 한다.)
    // DDR4 : x4 chip 기준으로 18개 chip이 있다. 각 chip은 on-die ECC codeword 136b이 있다.
    // DDR5 : x4 chip 기준으로 10개 chip이 있다. 각 chip은 on-die ECC codeword 136b이 있다.

    unsigned int Chip_array[CHIP_NUM][OECC_CW_LEN]; // 전체 chip 구성 (BL34 기준. [data : BL32, OECC-redundancy : BL2])
    int CE_cnt=0, DUE_cnt=0, SDC_cnt=0; // CE, DUE, SDC 횟수
    srand((unsigned int)time(NULL)); // 난수 시드값 계속 변화
    for(int runtime=0; runtime<RUN_NUM; runtime++){
        if(runtime%1000000==0){
            fprintf(fp3,"\n===============\n");
            fprintf(fp3,"Runtime : %d/%d\n",runtime,RUN_NUM);
            fprintf(fp3,"CE : %d\n",CE_cnt);
            fprintf(fp3,"DUE : %d\n",DUE_cnt);
            fprintf(fp3,"SDC : %d\n",SDC_cnt);
            fprintf(fp3,"\n===============\n");
	    fflush(fp3);
        }
        // 4-1. 10개 chip의 136b 전부를 0으로 초기화 (no-error)
        // 이렇게 하면 굳이 encoding을 안해도 된다. no-error라면 syndrome이 0으로 나오기 때문!
        for(int i=0; i<CHIP_NUM; i++)
            memset(Chip_array[i], 0, sizeof(unsigned int) * OECC_CW_LEN); 

        // 4-2. Error injection
        // [1] 3개의 chip을 선택 (Fault_Chip_position)
        // [2] error injection (SE, CHIPKILL, NE) [각각 다른 위치의 chip 3개 뽑기 (0~9)]
        // [3] chipkill은 각 bit마다 50% 확률로 bit/flip 발생
        vector<int> Fault_Chip_position;
        for (;;) {
            Fault_Chip_position.clear();
            if(recc_type==NO_RECC){
                Fault_Chip_position.push_back(rand()%DATA_CHIP_NUM); // Fault_Chip_position[0] // 0~7
                Fault_Chip_position.push_back(rand()%DATA_CHIP_NUM); // Fault_Chip_position[1] // 0~7
                Fault_Chip_position.push_back(rand()%DATA_CHIP_NUM); // Fault_Chip_position[2] // 0~7
                }
            else{
                Fault_Chip_position.push_back(rand()%CHIP_NUM); // Fault_Chip_position[0] // 0~9
                Fault_Chip_position.push_back(rand()%CHIP_NUM); // Fault_Chip_position[1] // 0~9
                Fault_Chip_position.push_back(rand()%CHIP_NUM); // Fault_Chip_position[2] // 0~9
            }
    
            if (Fault_Chip_position[0] != Fault_Chip_position[1] && Fault_Chip_position[1] != Fault_Chip_position[2] && 
            Fault_Chip_position[0] != Fault_Chip_position[2]) break;
        }

        switch (fault_type){
            case SE_NE_NE: // 1bit
                error_injection_SE(Fault_Chip_position[0],Chip_array, oecc_type);
                break; 
            case SE_SE_NE: // 1bit + 1bit
                error_injection_SE(Fault_Chip_position[0],Chip_array, oecc_type);
                error_injection_SE(Fault_Chip_position[1],Chip_array, oecc_type);
                break;
            case SE_SE_SE: // 1bit + 1bit + 1bit
                error_injection_SE(Fault_Chip_position[0],Chip_array, oecc_type);
                error_injection_SE(Fault_Chip_position[1],Chip_array, oecc_type);
                error_injection_SE(Fault_Chip_position[2],Chip_array, oecc_type);
                break;
            case CHIPKILL_NE_NE: // chipkill
                error_injection_CHIPKILL(Fault_Chip_position[0],Chip_array, oecc_type);
                break;
            case CHIPKILL_SE_NE: // chipkill + 1bit
                error_injection_CHIPKILL(Fault_Chip_position[0],Chip_array, oecc_type);
                error_injection_SE(Fault_Chip_position[1],Chip_array, oecc_type);
                break;
            case CHIPKILL_CHIPKILL_NE: // chipkill + chipkill
                error_injection_CHIPKILL(Fault_Chip_position[0],Chip_array, oecc_type);
                error_injection_CHIPKILL(Fault_Chip_position[1],Chip_array, oecc_type);
                break;
            case DE_NE_NE:
                error_injection_DE(Fault_Chip_position[0],Chip_array, oecc_type);
                break;
            case DE_DE_NE:
                error_injection_DE(Fault_Chip_position[0],Chip_array, oecc_type);
                error_injection_DE(Fault_Chip_position[1],Chip_array, oecc_type);
                break;
            case DE_DE_DE:
                error_injection_DE(Fault_Chip_position[0],Chip_array, oecc_type);
                error_injection_DE(Fault_Chip_position[1],Chip_array, oecc_type);
                error_injection_DE(Fault_Chip_position[2],Chip_array, oecc_type);
                break;
            case CHIPKILL_DE_NE:
                error_injection_CHIPKILL(Fault_Chip_position[0],Chip_array, oecc_type);
                error_injection_DE(Fault_Chip_position[1],Chip_array, oecc_type);            
            default:
                break;
        }


        // 4-3. OECC
        // [1] Error를 넣은 chip에 대해서 SEC 실행
        // SEC : 136개의 1-bit error syndrome에 대응하면 correction 진행. 아니면 안함 (mis-correction을 최대한 막아보기 위함이다.)
        switch(oecc_type){
            case NO_OECC:
                break;
            case HSIAO: // 어차피 error 없으면 NE로 간주하고 correction 안하고 그냥 내보낼 것이다.
                if(recc_type==NO_RECC){
                    for(int Error_chip_pos=0; Error_chip_pos<DATA_CHIP_NUM; Error_chip_pos++) // 0~7
                        error_correction_oecc(Error_chip_pos, Chip_array);
                }
                else{
                    for(int Error_chip_pos=0; Error_chip_pos<CHIP_NUM; Error_chip_pos++) // 0~9
                        error_correction_oecc(Error_chip_pos, Chip_array);
                }
                break;
            default:
                break;
        }

        /*
        4-4. RECC

        1. 각 BL2씩 묶어서 RECC 진행
            (1) Syndrome이 모두 0이면 => return NE
            (2) Syndrome이 0이 아니고, SSC의 syndrome과 일치하면 SSC 진행 [S1/S0이 a^0~a^9중 하나] => return CE
                -> 이때, error 발생 chip 위치는 CE 일때만 return 한다. (0~9). 이때만 의미가 있기 때문!
            (3) Syndrome이 0이 아니고, SSC의 syndrome과 일치하지 않으면 => return DUE
            (4) NE/CE return 했는데, 0이 아닌 값이 남아있으면 SDC (error 감지 못한 것이기 때문! 또는 mis-correction)

        2. Cacheline 단위로 (BL16) conservative 확인
            (1) CE : 8개 RECC 결과에서 SDC,DUE가 없고 전부 NE/CE 이고, error 발생 chip 위치(0~9)가 전부 같은 경우에만 CE로 처리 (NE는 고려 X. Error가 발생하지 않았기 때문!)
            (2) DUE : 8개 RECC 결과에서 SDC가 없고, 1개라도 DUE가 있는 경우 [나머지는 NE/CE]
                ** AMDCHIPKILL만 적용되는 조건! => 또는 전부 NE/CE이지만 error 발생 chip 위치가 다른 경우
            (3) SDC : 8개의 RECC 결과에서 SDC가 1개라도 있는 경우

        3. Cacheline 2개 (BL32) conservative 확인
            (1) CE : 2개 cacheline이 전부 CE인 경우
            (2) DUE : 2개 cacheline에서 SDC가 없고 1개라도 DUE가 있는 경우
            (3) SDC : 2개 cacheline에서 1개라도 SDC가 있는 경우
        
        */
        
        // 여기는 configuration 자동화 안 시켰음 (나중에 channel size, BL등을 바꿀거면 여기는 주의해서 보기!!)
        set<int> error_chip_position; // RECC(BL2 단위)마다 error 발생한 chip 위치 저장 (CE인 경우에만 저장)
        int result_type_recc; // NE, CE, DUE, SDC 저장
        int first_cacheline_conservative,second_cacheline_conservative;
        int final_result, final_result_1=CE,final_result_2=CE; // 각각 2개 cachline 고려한 최종 결과, 첫번째 cacheline, 두번째 cacheline 검사 결과
        int isConservative=0;
        switch(recc_type){ 
            case AMDCHIPKILL: // GF(2^8) 기준
                // 첫번째 cacheline
                for(int BL=0; BL<16; BL+=2){ // BL<16
                    error_correction_recc_AMDCHIPKILL(BL, &result_type_recc, error_chip_position, Chip_array);

                    // SDC 검사 (1이 남아있으면 SDC)
                    if(result_type_recc==CE || result_type_recc==NE){
                        int error_check=SDC_check(BL, Chip_array, oecc_type, recc_type);
                        if(error_check){
                            result_type_recc=SDC;
                        }
                    }
                    // DUE 검사 1
                    if(result_type_recc==DUE || final_result_1==DUE)
                        final_result_1=DUE;
                    else{ // 둘 중 우선순위가 큰 값 (SDC > CE > NE), 이전에 DUE가 나온 적이 없는 경우에만 들어갈 수 있다.
                        final_result_1 = (final_result_1>result_type_recc) ? final_result_1 : result_type_recc;
                    }

                    // DUE 검사 2 (Conservative mode 켜져있을 때만 진행!!)
                    // 다른 chip에서 Correction 진행한 적 있으면 true로 켜진다. => DUE 위함
                    if(CONSERVATIVE_MODE)
                        isConservative = (error_chip_position.size()>1) ? 1 : isConservative;
                }

                if(final_result_1==NE || final_result_1==CE){
                    final_result_1 = (isConservative) ? DUE : CE;
                }

                // 두번째 cacheline
                error_chip_position.clear();
                isConservative=0;
                for(int BL=16; BL<32; BL+=2){ // BL : 16~31
                    error_correction_recc_AMDCHIPKILL(BL, &result_type_recc, error_chip_position, Chip_array);

                    // SDC 검사 (1이 남아있으면 SDC)
                    if(result_type_recc==CE || result_type_recc==NE){
                        int error_check=SDC_check(BL, Chip_array, oecc_type, recc_type);
                        if(error_check){
                            result_type_recc=SDC;
                        }
                    }
                    // DUE 검사 1
                    if(result_type_recc==DUE || final_result_2==DUE)
                        final_result_2=DUE;
                    else{ // 둘 중 우선순위가 큰 값 (SDC > CE > NE), 이전에 DUE가 나온 적이 없는 경우에만 들어갈 수 있다.
                        final_result_2 = (final_result_2>result_type_recc) ? final_result_2 : result_type_recc;
                    }

                    // DUE 검사 2 (Conservative mode 켜져있을 때만 진행!!)
                    // 다른 chip에서 Correction 진행한 적 있으면 true로 켜진다. => DUE 위함
                    if(CONSERVATIVE_MODE)
                        isConservative = (error_chip_position.size()>1) ? 1 : isConservative;
                }

                if(final_result_2==NE || final_result_2==CE){
                    final_result_2 = (isConservative) ? DUE : CE;
                }


                // 2개 cacheline 비교해서 최종결과 update
                // SDC : 2개 cacheline 중에서 1개라도 SDC가 있으면 전체는 SDC
                // DUE : 2개 cacheline 중에서 SDC가 없고, 1개라도 DUE가 있으면 전체는 DUE
                // CE : 그 외 경우 (둘 다 CE)
                final_result = (final_result_1 > final_result_2) ? final_result_1 : final_result_2;
                break;

            case SSC_DEC: 
                // 첫번째 cacheline
                for(int BL=0; BL<16; BL+=2){ // BL<16
                    error_correction_recc_SSC_DEC(BL, &result_type_recc, error_chip_position, Chip_array);

                    // SDC 검사 (1이 남아있으면 SDC)
                    if(result_type_recc==CE || result_type_recc==NE){
                        int error_check=SDC_check(BL, Chip_array, oecc_type, recc_type);
                        if(error_check){
                            result_type_recc=SDC;
                        }
                    }
                    // DUE 검사 1
                    if(result_type_recc==DUE || final_result_1==DUE)
                        final_result_1=DUE;
                    else{ // 둘 중 우선순위가 큰 값 (SDC > CE > NE), 이전에 DUE가 나온 적이 없는 경우에만 들어갈 수 있다.
                        final_result_1 = (final_result_1>result_type_recc) ? final_result_1 : result_type_recc;
                    }

                    // DUE 검사 2 (Conservative mode 켜져있을 때만 진행!!)
                    // CorrectedPos 크기 : 1 => 1chip correction만 진행한 경우 => 타당!
                    // CorrectedPos 크기 : 2 => 1chip correction 2가지 진행 => DUE 처리! (2-bit correction 하면 무조건 크기 3이상!)
                    // CorrectedPos 크기 : 3 => 2-bit correction 1번만 처리 또는 chip위치 3개 처리. 즉, -1 없으면 DUE 처리! (-2는 여기에 없다!)
                    // CorrectedPos 크기 : 4이상 => DUE 처리!
                    if(CONSERVATIVE_MODE){
                        isConservative = (error_chip_position.size()>1) ? 1 : isConservative;
                    }
                }

                if(final_result_1==NE || final_result_1==CE){
                    final_result_1 = (isConservative) ? DUE : CE;
                }

                // 두번째 cacheline
                error_chip_position.clear();
                isConservative=0;
                for(int BL=16; BL<32; BL+=2){ // BL : 16~31
                    error_correction_recc_SSC_DEC(BL, &result_type_recc, error_chip_position, Chip_array);

                    // SDC 검사 (1이 남아있으면 SDC)
                    if(result_type_recc==CE || result_type_recc==NE){
                        int error_check=SDC_check(BL, Chip_array, oecc_type, recc_type);
                        if(error_check){
                            result_type_recc=SDC;
                        }
                    }
                    // DUE 검사 1
                    if(result_type_recc==DUE || final_result_2==DUE)
                        final_result_2=DUE;
                    else{ // 둘 중 우선순위가 큰 값 (SDC > CE > NE), 이전에 DUE가 나온 적이 없는 경우에만 들어갈 수 있다.
                        final_result_2 = (final_result_2>result_type_recc) ? final_result_2 : result_type_recc;
                    }

                    // DUE 검사 2 (Conservative mode 켜져있을 때만 진행!!)
                    // CorrectedPos 크기 : 1 => 1chip correction만 진행한 경우 => 타당!
                    // CorrectedPos 크기 : 2 => 1chip correction 2가지 진행 => DUE 처리! (2-bit correction 하면 무조건 크기 3이상!)
                    // CorrectedPos 크기 : 3 => 2-bit correction 1번만 처리 또는 chip위치 3개 처리. 즉, -1 없으면 DUE 처리! (-2는 여기에 없다!)
                    // CorrectedPos 크기 : 4이상 => DUE 처리!
                    if(CONSERVATIVE_MODE){
                        isConservative = (error_chip_position.size()>1) ? 1 : isConservative;
                    }
                }

                if(final_result_2==NE || final_result_2==CE){
                    final_result_2 = (isConservative) ? DUE : CE;
                }

                // 2개 cacheline 비교해서 최종결과 update
                // SDC : 2개 cacheline 중에서 1개라도 SDC가 있으면 전체는 SDC
                // DUE : 2개 cacheline 중에서 SDC가 없고, 1개라도 DUE가 있으면 전체는 DUE
                // CE : 그 외 경우 (둘 다 CE)
                final_result = (final_result_1 > final_result_2) ? final_result_1 : final_result_2;
                break;
            case NO_RECC:
                int error_check;
                error_check = Yield_check(Chip_array, oecc_type, recc_type);
                final_result = (error_check>0) ? SDC : CE;
                break;
            default:
                break;
        }

        // 4-5. CE/DUE/SDC 체크
        // 최종 update (2개 cacheline 전부 고려)
        // CE, DUE, SDC 개수 세기
        CE_cnt   += (final_result==CE)  ? 1 : 0;
        DUE_cnt  += (final_result==DUE) ? 1 : 0;
        SDC_cnt  += (final_result==SDC) ? 1 : 0;
            
    }
    // for문 끝!!

    // 최종 update
    fprintf(fp3,"\n===============\n");
    fprintf(fp3,"Runtime : %d\n",RUN_NUM);
    fprintf(fp3,"CE : %d\n",CE_cnt);
    fprintf(fp3,"DUE : %d\n",DUE_cnt);
    fprintf(fp3,"SDC : %d\n",SDC_cnt);
    fprintf(fp3,"\n===============\n");
    fflush(fp3);

    // 최종 update (소숫점 표현)
    fprintf(fp3,"\n===============\n");
    fprintf(fp3,"Runtime : %d\n",RUN_NUM);
    fprintf(fp3,"CE : %.11f\n",(double)CE_cnt/(double)RUN_NUM);
    fprintf(fp3,"DUE : %.11f\n",(double)DUE_cnt/(double)RUN_NUM);
    fprintf(fp3,"SDC : %.11f\n",(double)SDC_cnt/(double)RUN_NUM);
    fprintf(fp3,"\n===============\n");
    fflush(fp3);

    fclose(fp3);


    return 0;
}
