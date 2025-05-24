/*
** 체크해야 할 것
 (1) conservative : BL32 묶음 내에서 error가 다른 chip에서 나오는가 (1-bit error는 내부 OECC에서 고쳐서 나온다.)
   => on/off 가능하도록 만들기 [일단 끄고 하자.]
 (2) 

*/


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
// 필요로 하면 변경하기
#define CHANNEL_WIDTH 40
#define CHIP_NUM 10
#define DATA_CHIP_NUM 8 // sub-channel마다 data chip 개수
#define CHIP_WIDTH 4
#define BLHEIGHT 32 // RECC가 검사해야 하는 Burst length (ondie ecc의 redundancy는 제외하고 BL32만 검사한다. conservative mode 조건 고려하기)
#define SYMBOL_SIZE 8 // RECC에서 시행하는 symbol size (8이면 GF(2^8))

#define OECC_CW_LEN 136 // ondie ecc의 codeword 길이 (bit 단위)
#define OECC_DATA_LEN 128 // ondie ecc의 dataward 길이 (bit 단위)
#define OECC_REDUN_LEN 8 // ondie ecc의 redundancy 길이 (bit 단위)

#define RECC_CW_LEN 80 // rank-level ecc의 codeword 길이 (bit 단위)
#define RECC_DATA_LEN 64 // rank-level ecc의 dataward 길이 (bit 단위)
#define RECC_REDUN_LEN 16 // rank-level ecc의 redundancy 길이 (bit 단위)

#define RECC_REDUN_SYMBOL_NUM 2 // rank-level ecc의 redundancy 길이 (symbol 단위)
#define RECC_CW_SYMBOL_NUM 10 // rank-level ecc의 codeword 길이 (symbol 단위)

#define RUN_NUM 1000000000 // 실행 횟수 10억 번!

#define CONSERVATIVE_MODE 0 // Rank-level ECC에서 Conservative mode on/off (키면 chip position도 기록해서 다른 chip correction 하면 cacheline 전체를 DUE 처리!)

//configuration over

using namespace std;
unsigned int primitive_poly[16][256]={0,}; // 16가지 primitive polynomial 각각 256개 unique 한 값들 (각 row의 맨 끝에는 0을 나타낸다.) ex : primitive_poly[4][254] = a^254, primitive_poly[4][255] = 0 (prim_num=4인 경우이고, primitive_poly = x^8+x^6+x^4+x^3+x^2+x^1+1)
vector<unsigned int> SSC_Syndromes; // Keep Syndromes
vector<unsigned int> DEC_Syndromes; // Keep Syndromes
unsigned int H_Matrix_SEC[OECC_REDUN_LEN][OECC_CW_LEN]; // 8 x 136
unsigned int H_Matrix_SSC_DEC[RECC_REDUN_SYMBOL_NUM][RECC_CW_SYMBOL_NUM]; // 2 x 10
unsigned int DEC_Syndrome[9][10][8][8]={0,}; // SSC_DEC에서 DEC의 syndrome을 저장하는 table => [i][j][n][m]을 나타내며 신드롬 S1_S0 총 16bit 정보를 각각 저장한다. 
                                        // DEC_Syndrome[3][5][1][5] : i=3(4번째 chip), j=5(6번째 chip)에서 각각 1bit error가 발생했다. => i=0 ~ 8, j=i+1 ~ 9
                                        // error 값은 'i' chip에서는 a^n이다. 즉, n=1이면 0000_0010이니 4번째 chip의 7번쨰 bit에서 error가 발생했다.
                                        // error 값은 'j' chip에서는 a^m이다. 즉, m=5이면 0010_0000이니 6번째 chip의 3번째 bit에서 error가 발생했다.
enum OECC_TYPE {NO_OECC=0, HSIAO=1}; // oecc_type
enum FAULT_TYPE {BER_100=100, BER_330=330, BER_1000=1000, BER_3300=3300, BER_10000=10000, BER_33000=33000, BER_100000=100000, BER_330000=330000, BER_1000000=1000000, BER_3300000=3300000, BER_10000000=10000000, BER_33000000=33000000, BER_100000000=100000000, BER_330000000=330000000, BER_1000000000=1000000000}; // ber_type
enum RECC_TYPE {AMDCHIPKILL=0, SSC_DEC=1, NO_RECC=2}; // recc_type
enum RESULT_TYPE {NE=0, CE=1, DUE=2, SDC=3}; // result_type

// 지정한 정수에서, 몇번째 비트만 읽어서 반환하는 함수
int getAbit(unsigned short x, int n) { 
  return (x & (1 << n)) >> n;
}

// 다항식 형태를 10진수로 변환
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
    if(strstr(str_read,"^1+")!=NULL) // 무조건 다음에 +1은 붙기 때문!
        primitive_value+=int(pow(2,1));
    if(strstr(str_read,"+1")!=NULL)
        primitive_value+=int(pow(2,0));
    

    return primitive_value;
}

// primitive polynomial table 생성
void generate_primitive_poly(unsigned int prim_value, int m, int prim_num)
{
    unsigned int value = 0x1; // start value (0000 0001)
    int total_count = int(pow(2,m));
    int count=0;
    while (count<total_count-1){ // count : 0~254
        primitive_poly[prim_num][count]=value;
        if(value>=0x80){ // m번째 숫자가 1이면 primitive polynomial과 xor 연산
            // value의 m+1번째 숫자를 0으로 바꾸고 shift
            value=value<<(32-m+1);
            value=value>>(32-m);

            //primitive polynomial과 xor 연산
            value=value^prim_value;
        }
        else // m+1번째 숫자가 0이면 왼쪽으로 1칸 shift
            value=value<<1;
        
        count++;
    }

    return;
}

// DEC_Syndrome table 생성
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

// OECC, RECC, FAULT TYPE 각각의 type을 string으로 지정. 이것을 기준으로 뒤에서 error injection, oecc, recc에서 어떻게 할지 바뀐다!!!
void oecc_recc_fault_type_assignment(string &OECC, string &BER, string &RECC, int *oecc_type, int *ber_type, int*recc_type, int oecc, int ber, int recc)
{
    // 1. OECC TYPE 지정
    // int oecc, int fault, int recc는 main함수 매개변수 argv로 받은 것이다. run.py에서 변경 가능
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
    switch (ber){
        case BER_100:
             BER.replace(BER.begin(), BER.end(),"BER_10^-2");
            *ber_type=BER_100;
            break;       
        case BER_330:
            BER.replace(BER.begin(), BER.end(),"BER_3*10^-2");
            *ber_type=BER_330;
            break;
        case BER_1000:
            BER.replace(BER.begin(), BER.end(),"BER_10^-3");
            *ber_type=BER_1000;
            break;
        case BER_3300:
            BER.replace(BER.begin(), BER.end(),"BER_3*10^-3");
            *ber_type=BER_3300;
            break;
        case BER_10000:
            BER.replace(BER.begin(), BER.end(),"BER_10^-4");
            *ber_type=BER_10000;
            break;
        case BER_33000:
            BER.replace(BER.begin(), BER.end(),"BER_3*10^-4");
            *ber_type=BER_33000;
            break;
        case BER_100000:
            BER.replace(BER.begin(), BER.end(),"BER_10^-5");
            *ber_type=BER_100000;
            break;
        case BER_330000:
            BER.replace(BER.begin(), BER.end(),"BER_3*10^-5");
            *ber_type=BER_330000;
            break;
        case BER_1000000:
            BER.replace(BER.begin(), BER.end(),"BER_10^-6");
            *ber_type=BER_1000000;
            break;     
        case BER_3300000:
            BER.replace(BER.begin(), BER.end(),"BER_3*10^-6");
            *ber_type=BER_3300000;
            break;
        case BER_10000000:
            BER.replace(BER.begin(), BER.end(),"BER_10^-7");
            *ber_type=BER_10000000;
            break;
        case BER_33000000:
            BER.replace(BER.begin(), BER.end(),"BER_3*10^-7");
            *ber_type=BER_33000000;
            break;
        case BER_100000000:
            BER.replace(BER.begin(), BER.end(),"BER_10^-8");
            *ber_type=BER_100000000;
            break;
        case BER_330000000:
            BER.replace(BER.begin(), BER.end(),"BER_3*10^-8");
            *ber_type=BER_330000000;
            break;
        case BER_1000000000:
            BER.replace(BER.begin(), BER.end(),"BER_10^-9");
            *ber_type=BER_1000000000;
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

// error injection
void error_injection(unsigned int Chip_array[][OECC_CW_LEN], int oecc_type, int ber_type, int recc_type)
{
    // -> OECC 있으면 각 chip 내부의 0~135b, OECC 없으면 각 chip내부의 0~136b
    // -> RECC 있으면 chip 0~9까지, RECC 없으면 chip 0~7까지

    // OECC, RECC 둘 다 없는 경우
    if(oecc_type==NO_OECC && recc_type==NO_RECC){
        for(int Error_chip_pos=0; Error_chip_pos<DATA_CHIP_NUM; Error_chip_pos++){ // 0~7번쨰 chip까지
            for(int Fault_pos=0; Fault_pos<OECC_DATA_LEN; Fault_pos++){ // 0~127b 까지
                if((int)((double)((rand()<<15) | (rand()&0) | rand()))  % ber_type==0) // rand의 범위가 0 ~ 32767 까지이므로 이를 확장함
                    Chip_array[Error_chip_pos][Fault_pos]^=1;
            }
        }
    }
    
    // OECC 없고, RECC 있는 경우
    else if(oecc_type==NO_OECC && recc_type!=NO_RECC){
        for(int Error_chip_pos=0; Error_chip_pos<CHIP_NUM; Error_chip_pos++){ // 0~9번쨰 chip까지
            for(int Fault_pos=0; Fault_pos<OECC_DATA_LEN; Fault_pos++){ // 0~127b 까지
                if((int)((double)((rand()<<15) | (rand()&0) | rand()))  % ber_type==0) // rand의 범위가 0 ~ 32767 까지이므로 이를 확장함
                    Chip_array[Error_chip_pos][Fault_pos]^=1;
            }
        }
    }

    // OECC 있고, RECC 없는 경우
    else if(oecc_type!=NO_OECC && recc_type==NO_RECC){
        for(int Error_chip_pos=0; Error_chip_pos<DATA_CHIP_NUM; Error_chip_pos++){ // 0~7번쨰 chip까지
            for(int Fault_pos=0; Fault_pos<OECC_CW_LEN; Fault_pos++){ // 0~135b 까지
                if((int)((double)((rand()<<15) | (rand()&0) | rand()))  % ber_type==0) // rand의 범위가 0 ~ 32767 까지이므로 이를 확장함
                    Chip_array[Error_chip_pos][Fault_pos]^=1;
            }
        }
    }

    // OECC, RECC 둘 다 있는 경우
    else if(oecc_type!=NO_OECC && recc_type!=NO_RECC){
        for(int Error_chip_pos=0; Error_chip_pos<CHIP_NUM; Error_chip_pos++){ // 0~9번쨰 chip까지
            for(int Fault_pos=0; Fault_pos<OECC_CW_LEN; Fault_pos++){ // 0~135b 까지
                if((int)((double)((rand()<<15) | (rand()&0) | rand()))  % ber_type==0) // rand의 범위가 0 ~ 32767 까지이므로 이를 확장함
                    Chip_array[Error_chip_pos][Fault_pos]^=1;
            }
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
        
        // 0, 4, 8, .... 60
        for(int column=0; column<16; column++)
            row_value=row_value^(H_Matrix_SEC[row][column] * Chip_array[Fault_Chip_position][column*4]);
        // 1, 5, 9, .... 61
        for(int column=16; column<32; column++)
            row_value=row_value^(H_Matrix_SEC[row][column] * Chip_array[Fault_Chip_position][(column-16)*4+1]);
        // 2, 6, 10, .... 62
        for(int column=32; column<48; column++)
            row_value=row_value^(H_Matrix_SEC[row][column] * Chip_array[Fault_Chip_position][(column-32)*4+2]);
        // 3, 7, 11, .... 63
        for(int column=48; column<64; column++)
            row_value=row_value^(H_Matrix_SEC[row][column] * Chip_array[Fault_Chip_position][(column-48)*4+3]);

        // 64, 68, 72, .... 124
        for(int column=64; column<80; column++)
            row_value=row_value^(H_Matrix_SEC[row][column] * Chip_array[Fault_Chip_position][64+(column-64)*4]);
        // 65, 69, 73, ... 125
        for(int column=80; column<96; column++)
            row_value=row_value^(H_Matrix_SEC[row][column] * Chip_array[Fault_Chip_position][64+(column-80)*4+1]);
        // 66, 70, 74, ... 126
        for(int column=96; column<112; column++)
            row_value=row_value^(H_Matrix_SEC[row][column] * Chip_array[Fault_Chip_position][64+(column-96)*4+2]);
        // 67, 71, 75, ... 127
        for(int column=112; column<128; column++)
            row_value=row_value^(H_Matrix_SEC[row][column] * Chip_array[Fault_Chip_position][64+(column-112)*4+3]);

        // 128, 129, 130, 131
        for(int column=128; column<132; column++)
            row_value=row_value^(H_Matrix_SEC[row][column] * Chip_array[Fault_Chip_position][128+column%CHIP_WIDTH]);
        // 132, 133, 134, 135
        for(int column=132; column<136; column++)
            row_value=row_value^(H_Matrix_SEC[row][column] * Chip_array[Fault_Chip_position][132+column%CHIP_WIDTH]);

        //for(int column=0; column<OECC_CW_LEN; column++)
        //   row_value=row_value^(H_Matrix_SEC[row][column] * Chip_array[Fault_Chip_position][column]);
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
        // 1-bit error 일때만 error correction 진행
        if(cnt==OECC_REDUN_LEN){
            if(0<=error_pos && error_pos<16)
                Chip_array[Fault_Chip_position][error_pos*CHIP_WIDTH]^=1;
            else if(16<=error_pos && error_pos<32)
                Chip_array[Fault_Chip_position][(error_pos-16)*CHIP_WIDTH+1]^=1;
            else if(32<=error_pos && error_pos<48)
                Chip_array[Fault_Chip_position][(error_pos-32)*CHIP_WIDTH+2]^=1;
            else if(48<=error_pos && error_pos<64)
                Chip_array[Fault_Chip_position][(error_pos-48)*CHIP_WIDTH+3]^=1;
            
            else if(64<=error_pos && error_pos<80)
                Chip_array[Fault_Chip_position][64+(error_pos-64)*CHIP_WIDTH]^=1;
            else if(80<=error_pos && error_pos<96)
                Chip_array[Fault_Chip_position][64+(error_pos-80)*CHIP_WIDTH+1]^=1;
            else if(96<=error_pos && error_pos<112)
                Chip_array[Fault_Chip_position][64+(error_pos-96)*CHIP_WIDTH+2]^=1;
            else if(112<=error_pos && error_pos<128)
                Chip_array[Fault_Chip_position][64+(error_pos-112)*CHIP_WIDTH+3]^=1;

            else if(128<=error_pos && error_pos<132)
                Chip_array[Fault_Chip_position][128+error_pos%CHIP_WIDTH]^=1;
            else if(132<=error_pos && error_pos<136)
                Chip_array[Fault_Chip_position][132+error_pos%CHIP_WIDTH]^=1;
        
            //Chip_array[Fault_Chip_position][error_pos]^=1; // error correction (bit-flip)
            return;
        }
    }

    // Error가 발생하지 않았거나, 발생했지만 1-bit error는 아닌 경우이다.
    // 이 경우에는 correction을 진행하지 않는다.
    return;
}

int SDC_check(int BL, unsigned int Chip_array[][OECC_CW_LEN], int oecc_type, int recc_type)
{
    // Cacheline 에서 1이 남아있는지 검사
    // -> RECC 있으면 chip 0~9까지, RECC 없으면 chip 0~7까지

    int error_check=0;
    
    // RECC 없는 경우
    if(recc_type==NO_RECC){
        for(int Error_chip_pos=0; Error_chip_pos<DATA_CHIP_NUM; Error_chip_pos++){ // 0~7번쨰 chip까지
            for(int Fault_pos=BL*4; Fault_pos<(BL+2)*4; Fault_pos++){ // 0~127b 까지
                if(Chip_array[Error_chip_pos][Fault_pos]==1){
                    error_check++;
                    return error_check;
                } 
            }
        }
    }
    
    // RECC 있는 경우
    else if(recc_type!=NO_RECC){
        for(int Error_chip_pos=0; Error_chip_pos<CHIP_NUM; Error_chip_pos++){ // 0~9번쨰 chip까지
            for(int Fault_pos=BL*4; Fault_pos<(BL+2)*4; Fault_pos++){ // 0~127b 까지
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
    // Cacheline 2개 전체에서 1이 남아있는지 검사
    // -> RECC 있으면 chip 0~9까지, RECC 없으면 chip 0~7까지

    int error_check=0;
 
    // RECC 없는 경우   
    if(recc_type==NO_RECC){
        for(int Error_chip_pos=0; Error_chip_pos<DATA_CHIP_NUM; Error_chip_pos++){ // 0~7번쨰 chip까지
            for(int Fault_pos=0; Fault_pos<OECC_DATA_LEN; Fault_pos++){ // 0~127b 까지
                if(Chip_array[Error_chip_pos][Fault_pos]==1){
                    error_check++;
                    return error_check;
                }
            }
        }
    }
    
    // OECC 없고, RECC 있는 경우
    else if(recc_type!=NO_RECC){
        for(int Error_chip_pos=0; Error_chip_pos<CHIP_NUM; Error_chip_pos++){ // 0~9번쨰 chip까지
            for(int Fault_pos=0; Fault_pos<OECC_DATA_LEN; Fault_pos++){ // 0~127b 까지
                if(Chip_array[Error_chip_pos][Fault_pos]==1){
                    error_check++;
                    return error_check;
                }
            }
        }
    }

    return error_check;
}

// AMDCHIPKILL
// 여기는 configuration 자동화 안 시켰음 (나중에 channel size, BL등을 바꿀거면 여기는 주의해서 보기!!)
void error_correction_recc_AMDCHIPKILL(int BL, int *result_type_recc, set<int> &error_chip_position, unsigned int Chip_array[][OECC_CW_LEN])
{
    // primitive polynomial : x^8+x^4+x^3+x^2+1
    /*
        (1) Syndrome이 모두 0이면 => return NE
        (2) Syndrome이 0이 아니고, SSC의 syndrome과 일치하면 SSC 진행 [S1/S0이 a^0~a^9중 하나] => return CE
        (3) Syndrome이 0이 아니고, SSC의 syndrome과 일치하지 않으면 => return DUE
    */
    
    // codeword 생성
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

    // Syndrome 계산
    // S0 = (a^exponent0) ^ (a^exponent1) ^ (a^exponent2) ... ^(a^exponent9)
    // S1 = (a^exponent0) ^ (a^[exponent1+1]) ^ (a^[exponent2+2]) ... ^ (a^[exponent9+9])
    // S0 계산
    unsigned int S0=0,S1=0;
    for(int symbol_index=0; symbol_index<RECC_CW_SYMBOL_NUM; symbol_index++){ // 0~9
        unsigned exponent=255; // 0000_0000이면 255 (해당 사항만 예외케이스!)
        unsigned symbol_value=0; // 0000_0000 ~ 1111_1111
        // ex : codeword의 첫 8개 bit가 0 1 0 1 1 1 0 0 이면
        // symbol_value는 (0<<7) ^ (1<<6) ^ (0<<5) ^ (1<<4) ^ (1<<3) ^ (1<<2) ^ (0<<1) ^ (0<<0) = 0101_1100 이다.
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


    // S1 계산
    for(int symbol_index=0; symbol_index<RECC_CW_SYMBOL_NUM; symbol_index++){ // 0~9
        unsigned exponent=255; // 0000_0000이면 255 (해당 사항만 예외케이스!)
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
    // 신드롬이 0이 아니고, correction 진행 안한 경우
    *result_type_recc=DUE;
    
    return;
}

void error_correction_recc_SSC_DEC(int BL, int *result_type_recc, set<int> &error_chip_position, unsigned int Chip_array[][OECC_CW_LEN])
{
    // primitive polynomial : x^8+x^6+x^4+x^3+x^2+x^1+1 (prim_num=4)
    /*
    /*
        (1) Syndrome이 모두 0이면 => return NE
        (2) Syndrome이 0이 아니고, SSC의 syndrome과 일치하면 SSC 진행 [S1/S0이 a^0~a^9중 하나] => return CE
        (3) Syndrome이 0이 아니고, DEC의 syndrome과 일치하면 DEC 진행 => return CE
        (3) Syndrome이 0이 아니고, SSC, DEC의 syndrome과 일치하지 않으면 => return DUE
    */
    
    // codeword 생성
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

    // Syndrome 계산
    // S0 = (a^exponent0) ^ (a^exponent1) ^ (a^exponent2) ... ^(a^exponent9)
    // S1 = (a^exponent0) ^ (a^[exponent1+1]) ^ (a^[exponent2+2]) ... ^ (a^[exponent9+9])
    // S0 계산
    unsigned int S0=0,S1=0;
    for(int symbol_index=0; symbol_index<RECC_CW_SYMBOL_NUM; symbol_index++){ // 0~9
        unsigned exponent=255; // 0000_0000이면 255 (해당 사항만 예외케이스!)
        unsigned symbol_value=0; // 0000_0000 ~ 1111_1111
        unsigned codeword_symbol_binary=0; // codeword의 symbol마다의 값을 8-bit 으로 표현 => codeword = 0100_0000, ... 이면 첫번째 symbol 값인 0100_0000을 나타낸다.
        unsigned codeword_symbol=0; // codeword의 symbol마다 값 => codeword = c0(8bit), c1(8bit), c2(8bit), ... c9(8bit) => codeword = 0100_0000, ... 이면 첫번째 symbol 값인 0100_0000(a^6) 즉, 6을 나타낸다.
        int count=SYMBOL_SIZE-1;

        // codeword의 각 8bit 마다 symbol 형태로 구하기 => codeword = c0, c1, c2 ... c9 (각각 8bit symbol의 지수를 나타낸다.)
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

        // S0 계산
        if(H_Matrix_SSC_DEC[0][symbol_index]!=255 && codeword_symbol!=255){ // H_Matrix의 해당 부분이 0이 아닌 경우, codeword의 해당 경우에서 error가 발생한 경우 (8bit이 all'0s이 아닌 경우)
            symbol_value=primitive_poly[4][(H_Matrix_SSC_DEC[0][symbol_index] + codeword_symbol) % 255]; // a^(25+c0), a^(39+c1), a^(63+c2) ... a^(0+c8) 
            S0^=symbol_value;
        }
    }

    // S1 계산
    for(int symbol_index=0; symbol_index<RECC_CW_SYMBOL_NUM; symbol_index++){ // 0~9
        unsigned exponent=255; // 0000_0000이면 255 (해당 사항만 예외케이스!)
        unsigned symbol_value=0; // 0000_0000 ~ 1111_1111
        unsigned codeword_symbol_binary=0; // codeword의 symbol마다의 값을 8-bit 으로 표현 => codeword = 0100_0000, ... 이면 첫번째 symbol 값인 0100_0000을 나타낸다.
        unsigned codeword_symbol=0; // codeword의 symbol마다 값 => codeword = c0(8bit), c1(8bit), c2(8bit), ... c9(8bit) => codeword = 0100_0000, ... 이면 첫번째 symbol 값인 0100_0000(a^6) 즉, 6을 나타낸다.
        int count=SYMBOL_SIZE-1;

        // codeword의 각 8bit 마다 symbol 형태로 구하기 => codeword = c0, c1, c2 ... c9 (각각 8bit symbol의 지수를 나타낸다.)
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
    // ex : RAW_RAW_1000000.S => OECC, RECC 둘 다 없고 BER : 10^-6인 경우
    // ex : HSIAO_AMDCHIPKILL_10000.S => OECC : SEC, RECC : AMDCHIPKILL, BER : 10^-4인 경우
    string OECC="X", RECC="X", BER="X"; // => 파일 이름 생성을 위한 변수들. 그 이후로는 안쓰인다.
    int oecc_type, recc_type, ber_type; // => on-die ECC, Rank-level ECC, fault_type 분류를 위해 쓰이는 변수. 뒤에서도 계속 사용된다.
    oecc_recc_fault_type_assignment(OECC, BER, RECC, &oecc_type, &ber_type, &recc_type, atoi(argv[1]), atoi(argv[2]), atoi(argv[3]));
    
    string Result_file_name = OECC + "_" + RECC + "_" + BER + ".S";
    FILE *fp3=fopen(Result_file_name.c_str(),"w"); // c_str : string class에서 담고 있는 문자열을 c에서의 const char* 타입으로 변환하여 반환해주는 편리한 멤버함수

    // 4. 여기서부터 반복문 시작 (RUN_NUM 횟수만큼)
    // DIMM 설정 (Channel에 있는 chip 구성을 기본으로 한다.)
    // DDR4 : x4 chip 기준으로 18개 chip이 있다. 각 chip은 on-die ECC codeword 136b이 있다.
    // DDR5 : x4 chip 기준으로 10개 chip이 있다. 각 chip은 on-die ECC codeword 136b이 있다.

    unsigned int Chip_array[CHIP_NUM][OECC_CW_LEN]; // 전체 chip 구성 (BL34 기준. [data : BL32, OECC-redundancy : BL2])
    int CE_cnt=0, DUE_cnt=0, SDC_cnt=0; // Yield_cnt : 각 cacheline 2개 검사할때마다 CE/NE인 경우, No_Yield_cnt : 각 cacheline 2개 검사할때마다 DUE/SDC인 경우 (Yield_cnt + No_Yield_cnt) = 100%
    srand((unsigned int)time(NULL)); // 난수 시드값 계속 변화
    for(int runtime=0; runtime<RUN_NUM; runtime++){
        if(runtime%1000000==0){
            fprintf(fp3,"\n===============\n");
            fprintf(fp3,"Runtime : %d/%d\n",runtime,RUN_NUM);
            fprintf(fp3,"CE_cnt : %d\n",CE_cnt);
            fprintf(fp3,"DUE_cnt : %d\n",DUE_cnt);
            fprintf(fp3,"SDC_cnt : %d\n",SDC_cnt);
            fprintf(fp3,"\n===============\n");
            fflush(fp3);
        }
        // 4-1. 10개 chip의 136b 전부를 0으로 초기화 (no-error)
        // 이렇게 하면 굳이 encoding을 안해도 된다. no-error라면 syndrome이 0으로 나오기 때문!
        for(int i=0; i<CHIP_NUM; i++)
            memset(Chip_array[i], 0, sizeof(unsigned int) * OECC_CW_LEN); 

        // 4-2. Error injection
        // chip 전부에 대해 각 bit마다 BER 기준으로 bit-flip 발생
        // OECC 있으면 각 chip의 0~135b까지, OECC 없으면 각 chip의 0~127b까지
        // RECC 있으면 chip 0~9까지, RECC 없으면 chip 0~7까지
        error_injection(Chip_array, oecc_type, ber_type, recc_type);

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

                    // DUE 검사 2
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

                    // DUE 검사 2
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
                
                // SDC, DUE 검사
                // int error_check=Yield_check(Chip_array, oecc_type, ber_type, recc_type);
                break;

            case SSC_DEC:  // Conservative mode는 끄고 진행할거다!!!!!!
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
                        if(error_chip_position.size()==1)
                            isConservative=isConservative;
                        else if(error_chip_position.size()==2)
                            isConservative=1;
                        else if(error_chip_position.size()==3){
                            if(error_chip_position.count(-1)==0) // -1 없는 경우
                                isConservative=1;
                        }
                        else if(error_chip_position.size()>=4)
                            isConservative=1;
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
                        if(error_chip_position.size()==1)
                            isConservative=isConservative;
                        else if(error_chip_position.size()==2)
                            isConservative=1;
                        else if(error_chip_position.size()==3){
                            if(error_chip_position.count(-1)==0) // -1 없는 경우
                                isConservative=1;
                        }
                        else if(error_chip_position.size()>=4)
                            isConservative=1;
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
                // cacheline 2개에서 1이 남아 잇는지 검사 (1이 남아 있으면 error가 남아 있고 rank-level ECC는 없으니 SDC)
                {
                    int error_check=Yield_check(Chip_array, oecc_type, recc_type);
                    final_result = (error_check>0) ? SDC : CE;
                }
                break;

            default:
                break;
        }

        // 4-5. Yield 체크
        // 최종 update (2개 cacheline 전부 고려)
        // Yield(CE/NE), No_Yield_cnt(DUE,SDC)
        CE_cnt   += (final_result==CE)  ? 1 : 0;
        DUE_cnt  += (final_result==DUE) ? 1 : 0;
        SDC_cnt  += (final_result==SDC) ? 1 : 0;
    }
    // for문 끝!!

    // 최종 update
    fprintf(fp3,"\n===============\n");
    fprintf(fp3,"Runtime : %d/%d\n",RUN_NUM,RUN_NUM);
    fprintf(fp3,"CE_cnt : %d\n",CE_cnt);
    fprintf(fp3,"DUE_cnt : %d\n",DUE_cnt);
    fprintf(fp3,"SDC_cnt : %d\n",SDC_cnt);
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
