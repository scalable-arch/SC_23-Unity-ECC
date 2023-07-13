/**
 * @file: hsiao.cc
 * @author: Jungrae Kim <dale40@gmail.com>
 * CODEC implementation (HSIAO)
 */

#include <stdio.h>
#include <string.h>
#include <limits.h>
#include <stdlib.h>
#include <math.h>
#include "hsiao.hh"

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

#define RUN_NUM 1000000000 // 실행 횟수

#define CONSERVATIVE_MODE 0 // Rank-level ECC에서 Conservative mode on/off (키면 chip position도 기록해서 다른 chip correction 하면 cacheline 전체를 DUE 처리!)


//--------------------------------------------------------------------
//// From "A Class of Optimal Minimum Odd-weight-column SEC-DED Codes" / Hsiao / 1970
//// (40,32) code
//// 8C1 (=8) + 8C3 (=56) + 8C5 (=8 e.a.)
//// total weight = 8 + 3*56 + 5*8 = 216
//// average number of 1s in each row = 27
//// average number of 1s in Hb = 26

unsigned int primitive_poly[16][256]={0,}; 
unsigned int H_Matrix_SSC_DEC[RECC_REDUN_SYMBOL_NUM][RECC_CW_SYMBOL_NUM]; // 2 x 10
unsigned int DEC_Syndrome[9][10][8][8]={0,}; // SSC_DEC에서 DEC의 syndrome을 저장하는 table => [i][j][n][m]을 나타내며 신드롬 S1_S0 총 16bit 정보를 각각 저장한다. 
                                        // DEC_Syndrome[3][5][1][5] : i=3(4번째 chip), j=5(6번째 chip)에서 각각 1bit error가 발생했다. => i=0 ~ 8, j=i+1 ~ 9
                                        // error 값은 'i' chip에서는 a^n이다. 즉, n=1이면 0000_0010이니 4번째 chip의 7번쨰 bit에서 error가 발생했다.
                                        // error 값은 'j' chip에서는 a^m이다. 즉, m=5이면 0010_0000이니 6번째 chip의 3번째 bit에서 error가 발생했다.

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
                    /*           8                          8                        8                     8            --> # of columns =    */
uint8_t HSIAO_PT[] = {1, 1, 1, 1, 1, 1, 1, 1,  0, 0, 1, 0, 0, 1, 1, 0,  0, 1, 0, 0, 1, 0, 0, 1,  1, 0, 0, 1, 0, 0, 0, 0,
                      1, 1, 1, 0, 0, 0, 0, 0,  1, 1, 1, 1, 1, 1, 1, 1,  0, 0, 1, 0, 0, 1, 1, 0,  0, 1, 0, 0, 1, 0, 0, 1,
                      0, 0, 0, 1, 1, 1, 0, 0,  1, 1, 1, 0, 0, 0, 0, 0,  1, 1, 1, 1, 1, 1, 1, 1,  0, 0, 1, 0, 0, 1, 1, 0,
                      0, 0, 0, 1, 0, 0, 1, 1,  0, 0, 0, 1, 1, 1, 0, 0,  1, 1, 1, 0, 0, 0, 0, 0,  1, 1, 1, 1, 1, 1, 1, 1, 
                      0, 0, 0, 1, 0, 0, 0, 0,  0, 0, 0, 1, 0, 0, 1, 1,  0, 0, 0, 1, 1, 1, 0, 0,  1, 1, 1, 0, 0, 0, 0, 0,
                      1, 0, 0, 1, 0, 0, 0, 0,  0, 0, 0, 1, 0, 0, 0, 0,  0, 0, 0, 1, 0, 0, 1, 1,  0, 0, 0, 1, 1, 1, 0, 0, 
                      0, 1, 0, 0, 1, 0, 0, 1,  1, 0, 0, 1, 0, 0, 0, 0,  0, 0, 0, 1, 0, 0, 0, 0,  0, 0, 0, 1, 0, 0, 1, 1,  //
                      0, 0, 1, 0, 0, 1, 1, 0,  0, 1, 0, 0, 1, 0, 0, 1,  1, 0, 0, 1, 0, 0, 0, 0,  0, 0, 0, 1, 0, 0, 0, 0};

Hsiao::Hsiao(const char *name, int _bitN, int _bitR)
    : BinaryLinearCodec(name, _bitN, _bitR) {
    // G matrix calculation from P matrix (tranposed)
    // G (kxn) = (Ik | P)
    //           MSB   LSB
    for (int i=0; i<bitK; i++) {
        // map Parity (tranposed) matrix
        for (int j=0; j<bitR; j++) {
            gMatrix[i*bitN+j] = HSIAO_PT[j*bitK+i];
        }
        // map indentity matrix, Ik
        for (int j=bitR; j<bitN; j++) {
            gMatrix[i*bitN+j] = ((i==(j-bitR)) ? 1 : 0);
        }
    }

    // H matrix calculation from P matrix (tranposed)
    // H (rxn) = (Pt | I(n-k))
    //           MSB      LSB
    for (int i=0; i<bitR; i++) {
        // map indentity matrix, I(n-k)
        for (int j=0; j<bitR; j++) {
            hMatrix[i*bitN+j] = ((i==j) ? 1 : 0);
        }
        // map Parity (tranposed) matrix
        for (int j=bitR; j<bitN; j++) {
            hMatrix[i*bitN+j] = HSIAO_PT[i*bitK+(j-bitR)];
        }
    }


    //print(stdout);
    verifyMatrix();
}

ErrorType Hsiao::decode(unsigned codeword[], unsigned decoded[], std::set<int>* correctedPos) {

    // step 1: GF(2^8) primitive polynomial table 생성
    // prim_num으로 구분한다!!!!!!!!!!!!!!!!!

    FILE *fp=fopen("GF_2^8__primitive_polynomial.txt","r");
    int primitive_count=0;
    //unsigned int primitive_poly[16][256]={0,}; 
    // 16가지 primitive polynomial 각각 256개 unique 한 값들 (각 row의 맨 끝에는 0을 나타낸다.) 
    // ex : primitive_poly[4][254] = a^254, primitive_poly[4][255] = 0 
    // (prim_num=4인 경우이고, primitive_poly = x^8+x^6+x^4+x^3+x^2+x^1+1)
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

    // H-Matrix setting
    H_Matrix_SSC_DEC[0][0]=25,H_Matrix_SSC_DEC[0][1]=39,H_Matrix_SSC_DEC[0][2]=63,H_Matrix_SSC_DEC[0][3]=108,H_Matrix_SSC_DEC[0][4]=141,H_Matrix_SSC_DEC[0][5]=184,H_Matrix_SSC_DEC[0][6]=215,H_Matrix_SSC_DEC[0][7]=230,H_Matrix_SSC_DEC[0][8]=0,H_Matrix_SSC_DEC[0][9]=255;
    H_Matrix_SSC_DEC[1][0]=50,H_Matrix_SSC_DEC[1][1]=78,H_Matrix_SSC_DEC[1][2]=126,H_Matrix_SSC_DEC[1][3]=216,H_Matrix_SSC_DEC[1][4]=27,H_Matrix_SSC_DEC[1][5]=113,H_Matrix_SSC_DEC[1][6]=175,H_Matrix_SSC_DEC[1][7]=205,H_Matrix_SSC_DEC[1][8]=255,H_Matrix_SSC_DEC[1][9]=0;
    
    generate_DEC_Syndrome();

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

    // S0 = a^p, S1= a^q (a^0 ~ a^254)
    unsigned int p,q;
    for(int prim_exponent=0; prim_exponent<255; prim_exponent++){
        if(S0==primitive_poly[4][prim_exponent])
            p=prim_exponent;
        if(S1==primitive_poly[4][prim_exponent])
            q=prim_exponent;
    }
    //printf("S0 : %d(a^%d), S1 : %d(a^%d)\n",S0,p,S1,q);

    // printf("S0 : %d, S1 : %d\n",S0,S1);

    //printf("S0 : %d\n",S0);
    // NE 'or' SDC
    if(S0==0 && S1==0){
        // printf("Syndrome all Zero!!!\n");
        for(int index=0; index<RECC_CW_LEN; index++)
            decoded[index]=codeword[index];
        // error 유무 검사
        int error_check=0;
        for(int index=0; index<RECC_CW_LEN; index++){
            if(codeword[index]==1){ // error 발생
                error_check=1;
                break;
            }
        }
        if(error_check)
            return SDC;
        else
            return NE;
    }
    
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
                    codeword[error_chip_position_index*SYMBOL_SIZE+symbol_index]^=getAbit(error_value, SYMBOL_SIZE-1-symbol_index); // error_value >> 7, error_value >> 6 ... error_value >> 0
                    //Chip_array[error_chip_position_index][BL*4+symbol_index]^=getAbit(error_value, SYMBOL_SIZE-1-symbol_index); // error_value >> 7, error_value >> 6 ... error_value >> 0
                }

                correctedPos->insert(error_chip_position_index);
                for(int index=0; index<RECC_CW_LEN; index++)
                    decoded[index]=codeword[index];

                // error 유무 검사
                int error_check=0;
                for(int index=0; index<RECC_CW_LEN; index++){
                    if(codeword[index]==1){ // error 발생
                        error_check=1;
                        break;
                    }
                }
                if(error_check)
                    return SDC;
                else
                    return CE;
            }
        }
    }
    // error chip 위치가 8번째인 경우
    else if(S0!=0 && S1==0){
        for(int symbol_index=0; symbol_index<SYMBOL_SIZE; symbol_index++){ // 0~7
            codeword[64+symbol_index]^=getAbit(S0, SYMBOL_SIZE-1-symbol_index); // S0 >> 7, S0 >> 6 ... S0 >> 0
            // Chip_array[8][BL*4+symbol_index]^=getAbit(S0, SYMBOL_SIZE-1-symbol_index); // S0 >> 7, S0 >> 6 ... S0 >> 0
        }

        correctedPos->insert(8);
        for(int index=0; index<RECC_CW_LEN; index++)
            decoded[index]=codeword[index];

        // error 유무 검사
        int error_check=0;
        for(int index=0; index<RECC_CW_LEN; index++){
            if(codeword[index]==1){ // error 발생
                error_check=1;
                break;
            }
        }
        if(error_check)
            return SDC;
        else
            return CE;
    }
    // error chip 위치가 9번째인 경우
    else if(S0==0 && S1!=0){
        for(int symbol_index=0; symbol_index<SYMBOL_SIZE; symbol_index++){ // 0~7
            codeword[64+symbol_index]^=getAbit(S1, SYMBOL_SIZE-1-symbol_index); // S1 >> 7, S1 >> 6 ... S1 >> 0
        }


        correctedPos->insert(9);
        for(int index=0; index<RECC_CW_LEN; index++)
            decoded[index]=codeword[index];
        // error 유무 검사
        int error_check=0;
        for(int index=0; index<RECC_CW_LEN; index++){
            if(codeword[index]==1){ // error 발생
                error_check=1;
                break;
            }
        }
        if(error_check)
            return SDC;
        else
            return CE;
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
                        codeword[i*SYMBOL_SIZE+SYMBOL_SIZE-n-1]^=1; // n=0이면 0000_0001이니 'i' chip의 해당 BL 부분의 8번째 bit에서 error가 발생
                        codeword[j*SYMBOL_SIZE+SYMBOL_SIZE-m-1]^=1; // m=5이면 0010_0000이니 'j' chip의 해당 BL 부분의 3번쨰 bit에서 error가 발생
                        //Chip_array[i][BL*4+SYMBOL_SIZE-n-1]^=1; // n=0이면 0000_0001이니 'i' chip의 해당 BL 부분의 8번째 bit에서 error가 발생
                        //Chip_array[j][BL*4+SYMBOL_SIZE-m-1]^=1; // m=5이면 0010_0000이니 'j' chip의 해당 BL 부분의 3번쨰 bit에서 error가 발생
                        
                        correctedPos->insert(i);
                        correctedPos->insert(j);
                        printf("2-bit error correction!\n");
                        // 해당 cacheline에서 이전에 2-bit correction 한 적 있다.
                        if(correctedPos->count(-1)){
                            printf("second 2-bit error correction! DUE!!\n");
                            correctedPos->insert(-2);
                        }
                        // 해당 cacheline에서 처음 2-bit correction 진행 
                        else
                            correctedPos->insert(-1);

                        for(int index=0; index<RECC_CW_LEN; index++)
                            decoded[index]=codeword[index];
                        // error 유무 검사
                        int error_check=0;
                        for(int index=0; index<RECC_CW_LEN; index++){
                            if(codeword[index]==1){ // error 발생
                                error_check=1;
                                break;
                            }
                        }
                        if(error_check)
                            return SDC;
                        else
                            return CE;
                    }
                }
            }
        }
    }

    /////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////

    // DUE 처리
    return DUE;
}

bool Hsiao::genSyndrome(ECCWord *msg) {
    bool synError = false;
    // use H matrix to calculate syndrom
    // output = H (rxn) x input (nx1)
    for (int i=bitR-1; i>=0; i--) {
        syndrom[i] = 0;
        for (int j=bitN-1; j>=0; j--) {
            syndrom[i] ^= (msg->getBit(j) & hMatrix[i*bitN+j]); // hMatrix[i][j]
        }
        if (syndrom[i]) {
            synError = true;
        }
    }
    return synError;
}

void Hsiao::verifyMatrix()
{
    /*
    int max_row_weight = 0;
    int min_row_weight = INT_MAX;
    for (int i=0; i<bitR; i++) {
        int row_weight = 0;
        for (int j=0; j<bitN; j++) {
            row_weight += hMatrix[i*bitN+j];
        }
        if (row_weight > max_row_weight) max_row_weight = row_weight;
        if (row_weight < min_row_weight) min_row_weight = row_weight;
    }

    if ((max_row_weight - min_row_weight) > 1) {
        printf("max row weight : %d, min row weight : %d\n",max_row_weight, min_row_weight);
        fprintf(stderr, "Invalid Hsiao matrix: Max row weight: %d Min row weight: %d\n", max_row_weight, min_row_weight);
        exit(-1);
    }

    */

    // G x Ht = 0
    for (int i=0; i<bitK; i++) {
        for (int j=0; j<bitR; j++) {
            int temp = 0;
            for (int k=0; k<bitN; k++) {
                temp ^= gMatrix[i*bitN+k] & hMatrix[j*bitN+k];
            }
            if (temp!=0) {
                fprintf(stderr, "BAD H and G matrix %d\n", i);
                exit(-1);
            }
        }
    }
}

