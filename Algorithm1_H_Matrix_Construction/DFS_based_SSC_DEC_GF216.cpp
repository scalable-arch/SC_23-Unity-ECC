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

#define COLS_PER_SYMBOL   16         // bits per symbol (8 �� 16)
#define SYMBOL_COUNT_RS   65535      // 255 �� 65535 (2^16 ? 1)
#define BIN_ROWS          32         // binary rows (16 �� 32)
#define TOTAL_BIN_COLS    288        // binary columns (80 �� 288)
#define MAX_SYMBOLS       18         // 2 id + 16 search

using namespace std;
unsigned int primitive_poly_GF_2_8[16][255]={0,}; // 16�� primitive polynomial ���� 255�� unique�� ����
unsigned int primitive_poly_GF_2_16[2048][65535]={0,}; // 2048���� primitive polynomial ���� 65,535�� unique �� ����
vector<unsigned int> Syndromes; // Keep Syndromes

                                // 1,048,560 (65535x16)
unsigned int H_Matrix_binary[SYMBOL_COUNT_RS*COLS_PER_SYMBOL]; // RS-code�� 255�� symbol column�� ���� cauchy matrix�� Ǯ����, �� column�� GF(2^16) ���� ��Ÿ���� �ش� �� ����
unsigned int H_Matrix[288]; 
// H_Matrix�� �� ��ġ�� ���� H-Matrix�� �� column ���� bit�� ǥ���� ���̴�.
// ex : H_Matrix (16 x 80)�� 3��° column�� (�� �Ʒ� row) 0000_0000_0000_0010 �̶�� �غ���.
// �׷��ٸ� H_Matrix[2] = 0x2 �̴�. (3��° column�� ǥ��!)
unsigned int column_index[18]; // �� column index (0~254)

unsigned long long int total_count=0;
unsigned int maximum_column_select=2; // ���� column index���� �ְ� �Ǵ� �� �˻��ϴ� flag bit
unsigned int success=0; // SSC-DEC �����ϴ� �� ǥ���ϴ� flag bit
FILE *fp; // ��� ���� ������

unsigned int conversion_to_int_format_GF_2_8(char *str_read, int m) // ���׽� ���¸� 10������ ��ȯ
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
    if(strstr(str_read,"^1+")!=NULL) // ������ ������ +1�� �ٱ� ����!
        primitive_value+=int(pow(2,1));
    if(strstr(str_read,"+1")!=NULL)
        primitive_value+=int(pow(2,0));
    

    return primitive_value;

}

void generate_primitive_poly_GF_2_8(unsigned int prim_value, int m, int prim_num) // primitive polynomial table ����
{
    unsigned int value = 0x1; // start value (0000 0001)
    int total_count = int(pow(2,m));
    int count=0;
    while (count<total_count-1){
        primitive_poly_GF_2_8[prim_num][count]=value;
        if(value>=0x80){ // m��° ���ڰ� 1�̸� primitive polynomial�� xor ����
            // value�� m+1��° ���ڸ� 0���� �ٲٰ� shift
            value=value<<(32-m+1);
            value=value>>(32-m);

            //primitive polynomial�� xor ����
            value=value^prim_value;
        }
        else // m+1��° ���ڰ� 0�̸� �������� 1ĭ shift
            value=value<<1;
        
        count++;
    }

    return;
}

unsigned int conversion_to_int_format_GF_2_16(char *str_read, int m) // ���׽� ���¸� 10������ ��ȯ
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
    if(strstr(str_read,"^1+")!=NULL) // ������ ������ +1�� �ٱ� ����!
        primitive_value+=int(pow(2,1));
    if(strstr(str_read,"+1")!=NULL)
        primitive_value+=int(pow(2,0));
    

    return primitive_value;

}

void generate_primitive_poly_GF_2_16(unsigned int prim_value, int m, int prim_num) // primitive polynomial table ����
{
    unsigned int value = 0x1; // start value (0000 0000 0000 0001)
    int total_count = int(pow(2,m));
    int count=0;
    while (count<total_count-1){
        primitive_poly_GF_2_16[prim_num][count]=value;
        if(value>=0x8000){ // m��° ���ڰ� 1�̸� primitive polynomial�� xor ����
            // value�� m+1��° ���ڸ� 0���� �ٲٰ� shift
            value=value<<(32-m+1);
            value=value>>(32-m);

            //primitive polynomial�� xor ����
            value=value^prim_value;
        }
        else // m+1��° ���ڰ� 0�̸� �������� 1ĭ shift
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
    int index[16]={0,};
    unsigned int syndrome_value;
    int column_value;
    int first_column_value, second_column_value;

    // 1. SSC Syndrome �˻�
    for(int column_index_select=0; column_index_select<depth+1; column_index_select++){
        count=1;
        while(count<65536){
            syndrome_value=0;
            temp=count;
            index_i=15;
            while(0<=index_i){
                if(temp%2==1)
                    index[index_i--]=1;
                else   
                    index[index_i--]=0;
                temp/=2;
            }

            count++;

            // Syndrome �� ���
            for(int select_column=0; select_column<16; select_column++){
                if(index[select_column]==1){
                    column_value=H_Matrix[column_index_select*16+select_column];
                    syndrome_value^=column_value;
                }
            }
            Syndromes.push_back(syndrome_value);
        }
    }

    // 2. DEC �ŵ�� �˻� (SSC ��� �����ϰ� �̱�!)
    for(int outer_column_index=0; outer_column_index<depth*16; outer_column_index++){
        for(int inner_column_index=(outer_column_index/16+1)*16; inner_column_index<(depth+1)*16; inner_column_index++){
            first_column_value=H_Matrix[outer_column_index];
            second_column_value=H_Matrix[inner_column_index];
            syndrome_value=first_column_value^second_column_value;
            Syndromes.push_back(syndrome_value);
        }
    }    

    // 3. Syndrome �ߺ� �˻�
    int before=Syndromes.size();
    //printf("Before size : %d,",before);
    sort(Syndromes.begin(), Syndromes.end());
    Syndromes.erase(unique(Syndromes.begin(),Syndromes.end()), Syndromes.end());
    int after=Syndromes.size();
    //printf("after size : %d\n",after);
    // �ߺ� ������ 1 return (�ش� column���� �����ϰ�, depth 1 ���� ��Ű��.)
    if(before==after)
        return 1;
    // �ߺ� ������ 0 return (�ٸ� column ����!)
    return 0;
}

void DFS(int start, int depth, int last_select_column_index)
{
    // SSC-DEC ã��!!!!!!!!!!!!!!!!!!!!!
    if(depth==18){
        success=1;
        fprintf(fp,"Success!\n");
        fprintf(fp,"column index (0~65534) : ");
        fprintf(fp,"1, 0, "); // identity part
        for(int index=2; index<18; index++)
            fprintf(fp,"%d, ",column_index[index]);
        fprintf(fp,"\n");
        // unique �˻�
        fprintf(fp,"Before SSC-DEC unique All syndrome num : %d\n",Syndromes.size());
        sort(Syndromes.begin(), Syndromes.end());
        Syndromes.erase(unique(Syndromes.begin(),Syndromes.end()), Syndromes.end());
        fprintf(fp,"After SSC-DEC unique All syndrome num : %d\n",Syndromes.size());
        fprintf(fp,"------ H-Matrix ------\n");
        for(int row=0; row<32; row++){
            for(int column=0; column<288; column++){
                int result_bit;
                result_bit = (H_Matrix[column]>>row) & 1;
                fprintf(fp,"%d ",result_bit);
            }
            fprintf(fp,"\n");
        }
        fflush(fp);
    }

    // 1. SSC-DEC�� ã�� ��� DFS Ż��!
    if(success==1)
        return;
    
    // 2. DFS Ż���� �ƴ�����, column ���� ���� �ְ��� �����ϸ� ���
    //printf("step 2\n");
    if(depth>maximum_column_select){
        //printf("into step 2\n");
        maximum_column_select=depth;
        fprintf(fp,"maximum column select update!\n");
        fprintf(fp,"column index (0~65534) : ");
        fprintf(fp,"1, 0, "); // identity part
        for(int index=2; index<depth; index++)
            fprintf(fp,"%d, ",column_index[index]);
        fprintf(fp,"\n");
        // unique �˻�
        // 1,218,798�� syndrome ���;���.
        fprintf(fp,"Before SSC-DEC unique All syndrome num : %d\n",Syndromes.size());
        sort(Syndromes.begin(), Syndromes.end());
        Syndromes.erase(unique(Syndromes.begin(),Syndromes.end()), Syndromes.end());
        fprintf(fp,"After SSC-DEC unique All syndrome num : %d\n",Syndromes.size());
        fprintf(fp,"------ H-Matrix ------\n");
        for(int row=0; row<32; row++){
            for(int column=0; column<288; column++){
                int result_bit;
                result_bit = (H_Matrix[column]>>row) & 1;
                fprintf(fp,"%d ",result_bit);
            }
            fprintf(fp,"\n");
        }
        fflush(fp);
    }


    // 3. SSC-DEC�� ã�� ���� column�� 1���� ����
    int last_position=65535-depth; // �� depth���� �����ϴ� column�� ������ ��ġ
    //printf("step3 \n");
    for(int column_select=last_select_column_index+1; column_select<last_position; column_select++){
        if(success==1)
            return;
        total_count++;
        if(total_count%10000==0){
            fprintf(fp,"total count (10,000����) : %llu\n",total_count);
            fflush(fp);
        }
        for(int iter=0; iter<16; iter++)
            H_Matrix[depth*16+iter]=H_Matrix_binary[column_select*16+iter];
        //printf("start SSC_DEC syndrome check\n");
        if(SSC_DEC_syndrome(depth)==1){
            //printf("column select good!\n");
            // ������ column index �߰�  
            column_index[depth]=column_select; 
            // depth �߰�
            //printf("into another DFS\n");
            //printf("depth : %d\n",depth);
            DFS(start,depth+1,column_select);
        }
    }


    return;
}


int main(int argc, char*argv[])
{ 
    // 1. GF(2^8), GF(2^16) primitive polynomial table ����
    // prim_num���� �����Ѵ�!!!!!!!!!!!!!!!!!
    FILE *fp3=fopen("GF_2^8__primitive_polynomial.txt","r");
    int primitive_count=0;
    while(1){
        char str_read[100];
        unsigned int primitive_value=0;
        fgets(str_read,100,fp3);
        primitive_value=conversion_to_int_format_GF_2_8(str_read, 8);

        generate_primitive_poly_GF_2_8(primitive_value,8,primitive_count); // ex : primitive polynomial : a^16 = a^9+a^8+a^7+a^6+a^4+a^3+a^2+1 = 0000 0011 1101 1101 = 0x03DD (O) -> �� ������ prim_num : 0
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

        generate_primitive_poly_GF_2_16(primitive_value,16,primitive_count); // ex : primitive polynomial : a^16 = a^9+a^8+a^7+a^6+a^4+a^3+a^2+1 = 0000 0011 1101 1101 = 0x03DD (O) -> �� ������ prim_num : 0
        primitive_count++;

        if(feof(fp2))
            break;
    }
    fclose(fp2);
    
    // 2. H_Matrix_binary[2040] ����
    // RS-code unshortened H-Matrix �� ��Ÿ����. (2x155 -> 16 x 2040���� binary ���·� �����, �� column�� 16bit�� ������ ǥ���ؼ� ����)
    for(int column=0; column<65535; column++){
        unsigned int first_row;
        unsigned int second_row;
        unsigned int column_value;
        for(int iter=0; iter<16; iter++){
            // Primitive polynomial (GF(2^8)) : x^8+x^6+x^4+x^3+x^2+x^1+1
            first_row = primitive_poly_GF_2_16[230][(column+iter)%65535]; // a^i
            second_row = primitive_poly_GF_2_16[230][(2*column+iter)%65535]; // a^2i
            column_value = first_row ^ (second_row<<16);
            H_Matrix_binary[column*16+iter]=column_value;
        }
    }

    // 3. column�� �����ϱ� �����ϴ� ��ġ ����
    int start=(atoi(argv[2]))*12; 
    printf("start : %d\n",start);
    int last=65535-18; // 255-10

    // 4. DFS ����
    //fp=fopen("DFS_based_SSC_DEC_result_1.txt","w");
    fp=fopen(argv[1],"w");
    fprintf(fp,"DFS Search start!!!!\n\n");
    fflush(fp);
    for(int column_select=start; column_select<=last; column_select++){
        if(success==1)
            break;
        // Primitive polynomial (GF(2^16)) : x^16+x^5+x^3+x^2+1
        // Identity part : ù��°, �ι�° column ���� (H_Matrix�� ù 16�� column �����ڱ�. Identity��!!)
        for(int iter=0; iter<32; iter++)
            H_Matrix[iter]=(1<<iter); // 1, 2, 4, 8, 16, 32, 64, 128, 256 ... ,32K

        column_index[2]=start;
        DFS(column_select, 2, column_select);
    }


    fclose(fp);


    return 0;
}
