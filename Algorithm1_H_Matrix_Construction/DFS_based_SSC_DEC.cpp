#include <stdio.h>
#include <string.h>
#include <time.h>
#include <ctime>
#include<iostream>
#include<cstdlib>
#include <vector>
#include <algorithm>
#include <math.h>
#include <cstring>
#include <bitset>

using namespace std;
unsigned int primitive_poly_GF_2_8[16][255]={0,}; // 16개 primitive polynomial 각각 255개 unique한 값들
unsigned int primitive_poly_GF_2_16[2048][65535]={0,}; // 2048가지 primitive polynomial 각각 65,535개 unique 한 값들
vector<unsigned int> Syndromes; // Keep Syndromes
unsigned int H_Matrix_binary[2040]; // RS-code의 255개 symbol column을 전부 cauchy matrix로 풀었고, 각 column은 GF(2^16) 으로 나타내고 해당 값 저장
unsigned int H_Matrix[80]; 
// H_Matrix의 각 위치의 값은 H-Matrix의 각 column 값을 bit로 표현한 값이다.
// ex : H_Matrix (16 x 80)의 3번째 column이 (맨 아래 row) 0000_0000_0000_0010 이라고 해보자.
// 그렇다면 H_Matrix[2] = 0x2 이다. (3번째 column값 표현!)
unsigned int column_index[10]; // 고른 column index (0~254)
unsigned long long int total_count=0;
unsigned int maximum_column_select=2; // 뽑은 column index수가 최고가 되는 것 검사하는 flag bit
unsigned int success=0; // SSC-DEC 성공하는 것 표시하는 flag bit
FILE *fp; // 결과 파일 포인터

unsigned int conversion_to_int_format_GF_2_8(char *str_read, int m) // 다항식 형태를 10진수로 변환
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

void generate_primitive_poly_GF_2_8(unsigned int prim_value, int m, int prim_num) // primitive polynomial table 생성
{
    unsigned int value = 0x1; // start value (0000 0001)
    int total_count = int(pow(2,m));
    int count=0;
    while (count<total_count-1){
        primitive_poly_GF_2_8[prim_num][count]=value;
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

unsigned int conversion_to_int_format_GF_2_16(char *str_read, int m) // 다항식 형태를 10진수로 변환
{
    unsigned int primitive_value=0;
    if(strstr(str_read,"^15")!=NULL)
        primitive_value+=int(pow(2,15));
    if(strstr(str_read,"^14")!=NULL)
        primitive_value+=int(pow(2,14));
    if(strstr(str_read,"^13")!=NULL)
        primitive_value+=int(pow(2,13));
    if(strstr(str_read,"^12")!=NULL)
        primitive_value+=int(pow(2,12));
    if(strstr(str_read,"^11")!=NULL)
        primitive_value+=int(pow(2,11));
    if(strstr(str_read,"^10")!=NULL)
        primitive_value+=int(pow(2,10));
    if(strstr(str_read,"^9")!=NULL)
        primitive_value+=int(pow(2,9));
    if(strstr(str_read,"^8")!=NULL)
        primitive_value+=int(pow(2,8));
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

void generate_primitive_poly_GF_2_16(unsigned int prim_value, int m, int prim_num) // primitive polynomial table 생성
{
    unsigned int value = 0x1; // start value (0000 0000 0000 0001)
    int total_count = int(pow(2,m));
    int count=0;
    while (count<total_count-1){
        primitive_poly_GF_2_16[prim_num][count]=value;
        if(value>=0x8000){ // m번째 숫자가 1이면 primitive polynomial과 xor 연산
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

int SSC_DEC_syndrome(int depth)
{
    Syndromes.clear();
    int count=1,temp;
    int index_i;
    int index[8]={0,};
    unsigned int syndrome_value;
    int column_value;
    int first_column_value, second_column_value;

    // 1. SSC Syndrome 검사
    for(int column_index_select=0; column_index_select<depth+1; column_index_select++){
        count=1;
        while(count<256){
            syndrome_value=0;
            temp=count;
            index_i=7;
            while(0<=index_i){
                if(temp%2==1)
                    index[index_i--]=1;
                else   
                    index[index_i--]=0;
                temp/=2;
            }

            count++;

            // Syndrome 값 계산
            for(int select_column=0; select_column<8; select_column++){
                if(index[select_column]==1){
                    column_value=H_Matrix[column_index_select*8+select_column];
                    syndrome_value^=column_value;
                }
            }
            Syndromes.push_back(syndrome_value);
        }
    }

    // 2. DEC 신드롬 검사 (SSC 경우 제외하고 뽑기!)
    for(int outer_column_index=0; outer_column_index<depth*8; outer_column_index++){
        for(int inner_column_index=(outer_column_index/8+1)*8; inner_column_index<(depth+1)*8; inner_column_index++){
            first_column_value=H_Matrix[outer_column_index];
            second_column_value=H_Matrix[inner_column_index];
            syndrome_value=first_column_value^second_column_value;
            Syndromes.push_back(syndrome_value);
        }
    }    

    // 3. Syndrome 중복 검사
    int before=Syndromes.size();
    //printf("Before size : %d,",before);
    sort(Syndromes.begin(), Syndromes.end());
    Syndromes.erase(unique(Syndromes.begin(),Syndromes.end()), Syndromes.end());
    int after=Syndromes.size();
    //printf("after size : %d\n",after);
    // 중복 없으면 1 return (해당 column으로 진행하고, depth 1 증가 시키자.)
    if(before==after)
        return 1;
    // 중복 있으면 0 return (다른 column 뽑자!)
    return 0;
}

void DFS(int start, int depth, int last_select_column_index)
{
    // SSC-DEC 찾음!!!!!!!!!!!!!!!!!!!!!
    if(depth==10){
        success=1;
        fprintf(fp,"Success!\n");
        fprintf(fp,"column index (0~254) : ");
        fprintf(fp,"1, 0, "); // identity part
        for(int index=2; index<10; index++)
            fprintf(fp,"%d, ",column_index[index]);
        fprintf(fp,"\n");
        // unique 검사
        fprintf(fp,"Before SSC-DEC unique All syndrome num : %d\n",Syndromes.size());
        sort(Syndromes.begin(), Syndromes.end());
        Syndromes.erase(unique(Syndromes.begin(),Syndromes.end()), Syndromes.end());
        fprintf(fp,"After SSC-DEC unique All syndrome num : %d\n",Syndromes.size());
        fprintf(fp,"------ H-Matrix ------\n");
        for(int row=0; row<16; row++){
            for(int column=0; column<80; column++){
                int result_bit;
                result_bit = (H_Matrix[column]>>row) & 1;
                fprintf(fp,"%d ",result_bit);
            }
            fprintf(fp,"\n");
        }
        fflush(fp);
    }

    // 1. SSC-DEC을 찾은 경우 DFS 탈출!
    if(success==1)
        return;
    
    // 2. DFS 탈출은 아니지만, column 선택 개수 최고기록 갱신하면 출력
    //printf("step 2\n");
    if(depth>maximum_column_select){
        //printf("into step 2\n");
        maximum_column_select=depth;
        fprintf(fp,"maximum column select update!\n");
        fprintf(fp,"column index (0~254) : ");
        fprintf(fp,"1, 0, "); // identity part
        for(int index=2; index<depth; index++)
            fprintf(fp,"%d, ",column_index[index]);
        fprintf(fp,"\n");
        // unique 검사
        fprintf(fp,"Before SSC-DEC unique All syndrome num : %d\n",Syndromes.size());
        sort(Syndromes.begin(), Syndromes.end());
        Syndromes.erase(unique(Syndromes.begin(),Syndromes.end()), Syndromes.end());
        fprintf(fp,"After SSC-DEC unique All syndrome num : %d\n",Syndromes.size());
        fprintf(fp,"------ H-Matrix ------\n");
        for(int row=0; row<16; row++){
            for(int column=0; column<80; column++){
                int result_bit;
                result_bit = (H_Matrix[column]>>row) & 1;
                fprintf(fp,"%d ",result_bit);
            }
            fprintf(fp,"\n");
        }
        fflush(fp);
    }


    // 3. SSC-DEC을 찾기 위해 column을 1개씩 추출
    int last_position=255-depth; // 각 depth마다 선택하는 column의 마지막 위치
    //printf("step3 \n");
    for(int column_select=last_select_column_index+1; column_select<last_position; column_select++){
        if(success==1)
            return;
        total_count++;
        if(total_count%10000==0){
            fprintf(fp,"total count (10,000단위) : %llu\n",total_count);
            fflush(fp);
        }
        for(int iter=0; iter<8; iter++)
            H_Matrix[depth*8+iter]=H_Matrix_binary[column_select*8+iter];
        //printf("start SSC_DEC syndrome check\n");
        if(SSC_DEC_syndrome(depth)==1){
            //printf("column select good!\n");
            // 선택한 column index 추가  
            column_index[depth]=column_select; 
            // depth 추가
            //printf("into another DFS\n");
            //printf("depth : %d\n",depth);
            DFS(start,depth+1,column_select);
        }
    }


    return;
}


int main(int argc, char*argv[])
{ 
    // 1. GF(2^8), GF(2^16) primitive polynomial table 생성
    // prim_num으로 구분한다!!!!!!!!!!!!!!!!!
    FILE *fp3=fopen("GF_2^8__primitive_polynomial.txt","r");
    int primitive_count=0;
    while(1){
        char str_read[100];
        unsigned int primitive_value=0;
        fgets(str_read,100,fp3);
        primitive_value=conversion_to_int_format_GF_2_8(str_read, 8);

        generate_primitive_poly_GF_2_8(primitive_value,8,primitive_count); // ex : primitive polynomial : a^16 = a^9+a^8+a^7+a^6+a^4+a^3+a^2+1 = 0000 0011 1101 1101 = 0x03DD (O) -> 맨 오른쪽 prim_num : 0
        primitive_count++;

        if(feof(fp3))
            break;
    }
    fclose(fp3);

    FILE *fp2=fopen("GF_2^16__primitive_polynomial.txt","r");
    primitive_count=0;
    while(1){
        char str_read[100];
        unsigned int primitive_value=0;
        fgets(str_read,100,fp2);
        primitive_value=conversion_to_int_format_GF_2_16(str_read, 16);

        generate_primitive_poly_GF_2_16(primitive_value,16,primitive_count); // ex : primitive polynomial : a^16 = a^9+a^8+a^7+a^6+a^4+a^3+a^2+1 = 0000 0011 1101 1101 = 0x03DD (O) -> 맨 오른쪽 prim_num : 0
        primitive_count++;

        if(feof(fp2))
            break;
    }
    fclose(fp2);
    
    // 2. H_Matrix_binary[2040] 생성
    // RS-code unshortened H-Matrix 를 나타낸다. (2x155 -> 16 x 2040으로 binary 형태로 만들고, 각 column의 16bit는 정수로 표현해서 저장)
    for(int column=0; column<255; column++){
        unsigned int first_row;
        unsigned int second_row;
        unsigned int column_value;
        for(int iter=0; iter<8; iter++){
            // Primitive polynomial (GF(2^8)) : x^8+x^6+x^4+x^3+x^2+x^1+1
            first_row = primitive_poly_GF_2_8[4][(column+iter)%255]; // a^i
            second_row = primitive_poly_GF_2_8[4][(2*column+iter)%255]; // a^2i
            column_value = first_row ^ (second_row<<8);
            H_Matrix_binary[column*8+iter]=column_value;
        }
    }

    // 3. column을 선택하기 시작하는 위치 받음
    int start=(atoi(argv[2]))*12; 
    printf("start : %d\n",start);
    int last=245; // 255-10

    // 4. DFS 시작
    //fp=fopen("DFS_based_SSC_DEC_result_1.txt","w");
    fp=fopen(argv[1],"w");
    fprintf(fp,"DFS Search start!!!!\n\n");
    fflush(fp);
    for(int column_select=start; column_select<=last; column_select++){
        if(success==1)
            break;
        // Primitive polynomial (GF(2^16)) : x^16+x^5+x^3+x^2+1
        // Identity part : 첫번째, 두번째 column 선택 (H_Matrix의 첫 16개 column 고정박기. Identity로!!)
        for(int iter=0; iter<16; iter++)
            H_Matrix[iter]=(1<<iter); // 1, 2, 4, 8, 16, 32, 64, 128, 256 ... ,32K

        column_index[2]=start;
        DFS(column_select, 2, column_select);
    }


    fclose(fp);


    return 0;
}
