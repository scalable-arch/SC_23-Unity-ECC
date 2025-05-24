#include <stdio.h>

/*
(1) 아래 000 => 첫 16개 column (5C3+5C4+5C5  = 16) => 이거만 special case!!! Systematic-format 고려
(2) 아래 001 => 두번째 16개 column (5C1+5C3+5C5 = 16)
(3) 아래 010 => 세번째 16개 column (5C1+5C3+5C5 = 16)
(4) 아래 100 => 네번째 16개 column (5C1+5C3+5C5 = 16)
(5) 아래 011 => 다섯번쨰 16개 column (5C1+5C3+5C5 = 16)
(6) 아래 101 => 여섯번째 16개 column (5C1+5C3+5C5 = 16)
(7) 아래 110 => 일곱번째 16개 column (5C1+5C3+5C5 = 16)
(8) 아래 111 => 여덟번째 16개 column (5C1+5C3+5C5 = 16)
*/

int main()
{
    FILE *fp=fopen("hello.txt","w");
    unsigned int H_Matrix[8][136]={0,};

    // Parity
    H_Matrix[0][128]=1;
    H_Matrix[1][129]=1;
    H_Matrix[2][130]=1;
    H_Matrix[3][131]=1;
    H_Matrix[4][132]=1;
    H_Matrix[5][133]=1;
    H_Matrix[6][134]=1;
    H_Matrix[7][135]=1;


    // first 32 column ~ fourth 32 column
    for(int index=0; index<4; index++){
        // 5C0
        H_Matrix[0][index*32]=0, H_Matrix[1][index*32]=0, H_Matrix[2][index*32]=0, H_Matrix[3][index*32]=0, H_Matrix[4][index*32]=0, H_Matrix[5][index*32]=0, H_Matrix[6][index*32]=0, H_Matrix[7][index*32]=0;

        // 5C1
        H_Matrix[0][index*32+1]=1, H_Matrix[1][index*32+1]=0, H_Matrix[2][index*32+1]=0, H_Matrix[3][index*32+1]=0, H_Matrix[4][index*32+1]=0, H_Matrix[5][index*32+1]=0, H_Matrix[6][index*32+1]=0, H_Matrix[7][index*32+1]=0;
        H_Matrix[0][index*32+2]=0, H_Matrix[1][index*32+2]=1, H_Matrix[2][index*32+2]=0, H_Matrix[3][index*32+2]=0, H_Matrix[4][index*32+2]=0, H_Matrix[5][index*32+2]=0, H_Matrix[6][index*32+2]=0, H_Matrix[7][index*32+2]=0;
        H_Matrix[0][index*32+3]=0, H_Matrix[1][index*32+3]=0, H_Matrix[2][index*32+3]=1, H_Matrix[3][index*32+3]=0, H_Matrix[4][index*32+3]=0, H_Matrix[5][index*32+3]=0, H_Matrix[6][index*32+3]=0, H_Matrix[7][index*32+3]=0;
        H_Matrix[0][index*32+4]=0, H_Matrix[1][index*32+4]=0, H_Matrix[2][index*32+4]=0, H_Matrix[3][index*32+4]=1, H_Matrix[4][index*32+4]=0, H_Matrix[5][index*32+4]=0, H_Matrix[6][index*32+4]=0, H_Matrix[7][index*32+4]=0;
        H_Matrix[0][index*32+5]=0, H_Matrix[1][index*32+5]=0, H_Matrix[2][index*32+5]=0, H_Matrix[3][index*32+5]=0, H_Matrix[4][index*32+5]=1, H_Matrix[5][index*32+5]=0, H_Matrix[6][index*32+5]=0, H_Matrix[7][index*32+5]=0;

        // 5C2
        H_Matrix[0][index*32+6]=1, H_Matrix[1][index*32+6]=1, H_Matrix[2][index*32+6]=0, H_Matrix[3][index*3+6]=0, H_Matrix[4][index*32+6]=0, H_Matrix[5][index*32+6]=0, H_Matrix[6][index*32+6]=0, H_Matrix[7][index*32+6]=0;
        H_Matrix[0][index*32+7]=1, H_Matrix[1][index*32+7]=0, H_Matrix[2][index*32+7]=1, H_Matrix[3][index*32+7]=0, H_Matrix[4][index*32+7]=0, H_Matrix[5][index*32+7]=0, H_Matrix[6][index*32+7]=0, H_Matrix[7][index*32+7]=0;
        H_Matrix[0][index*32+8]=1, H_Matrix[1][index*32+8]=0, H_Matrix[2][index*32+8]=0, H_Matrix[3][index*32+8]=1, H_Matrix[4][index*32+8]=0, H_Matrix[5][index*32+8]=0, H_Matrix[6][index*32+8]=0, H_Matrix[7][index*32+8]=0;
        H_Matrix[0][index*32+9]=1, H_Matrix[1][index*32+9]=0, H_Matrix[2][index*32+9]=0, H_Matrix[3][index*32+9]=0, H_Matrix[4][index*32+9]=1, H_Matrix[5][index*32+9]=0, H_Matrix[6][index*32+9]=0, H_Matrix[7][index*32+9]=0;
        H_Matrix[0][index*32+10]=0, H_Matrix[1][index*32+10]=1, H_Matrix[2][index*32+10]=1, H_Matrix[3][index*32+10]=0, H_Matrix[4][index*32+10]=0, H_Matrix[5][index*32+10]=0, H_Matrix[6][index*32+10]=0, H_Matrix[7][index*32+10]=0;
        H_Matrix[0][index*32+11]=0, H_Matrix[1][index*32+11]=1, H_Matrix[2][index*32+11]=0, H_Matrix[3][index*32+11]=1, H_Matrix[4][index*32+11]=0, H_Matrix[5][index*32+11]=0, H_Matrix[6][index*32+11]=0, H_Matrix[7][index*32+11]=0;
        H_Matrix[0][index*32+12]=0, H_Matrix[1][index*32+12]=1, H_Matrix[2][index*32+12]=0, H_Matrix[3][index*32+12]=0, H_Matrix[4][index*32+12]=1, H_Matrix[5][index*32+12]=0, H_Matrix[6][index*32+12]=0, H_Matrix[7][index*32+12]=0;
        H_Matrix[0][index*32+13]=0, H_Matrix[1][index*32+13]=0, H_Matrix[2][index*32+13]=1, H_Matrix[3][index*32+13]=1, H_Matrix[4][index*32+13]=0, H_Matrix[5][index*32+13]=0, H_Matrix[6][index*32+13]=0, H_Matrix[7][index*32+13]=0;
        H_Matrix[0][index*32+14]=0, H_Matrix[1][index*32+14]=0, H_Matrix[2][index*32+14]=1, H_Matrix[3][index*32+14]=0, H_Matrix[4][index*32+14]=1, H_Matrix[5][index*32+14]=0, H_Matrix[6][index*32+14]=0, H_Matrix[7][index*32+14]=0;
        H_Matrix[0][index*32+15]=0, H_Matrix[1][index*32+15]=0, H_Matrix[2][index*32+15]=0, H_Matrix[3][index*32+15]=1, H_Matrix[4][index*32+15]=1, H_Matrix[5][index*32+15]=0, H_Matrix[6][index*32+15]=0, H_Matrix[7][index*32+15]=0;

        // 5C3
        H_Matrix[0][index*32+16]=1, H_Matrix[1][index*32+16]=1, H_Matrix[2][index*32+16]=1, H_Matrix[3][index*32+16]=0, H_Matrix[4][index*32+16]=0, H_Matrix[5][index*32+16]=0, H_Matrix[6][index*32+16]=0, H_Matrix[7][index*32+16]=0;
        H_Matrix[0][index*32+17]=0, H_Matrix[1][index*32+17]=1, H_Matrix[2][index*32+17]=1, H_Matrix[3][index*32+17]=1, H_Matrix[4][index*32+17]=0, H_Matrix[5][index*32+17]=0, H_Matrix[6][index*32+17]=0, H_Matrix[7][index*32+17]=0;
        H_Matrix[0][index*32+18]=0, H_Matrix[1][index*32+18]=0, H_Matrix[2][index*32+18]=1, H_Matrix[3][index*32+18]=1, H_Matrix[4][index*32+18]=1, H_Matrix[5][index*32+18]=0, H_Matrix[6][index*32+18]=0, H_Matrix[7][index*32+18]=0;
        H_Matrix[0][index*32+19]=1, H_Matrix[1][index*32+19]=0, H_Matrix[2][index*32+19]=1, H_Matrix[3][index*32+19]=1, H_Matrix[4][index*32+19]=0, H_Matrix[5][index*32+19]=0, H_Matrix[6][index*32+19]=0, H_Matrix[7][index*32+19]=0;
        H_Matrix[0][index*32+20]=1, H_Matrix[1][index*32+20]=1, H_Matrix[2][index*32+20]=0, H_Matrix[3][index*32+20]=0, H_Matrix[4][index*32+20]=1, H_Matrix[5][index*32+20]=0, H_Matrix[6][index*32+20]=0, H_Matrix[7][index*32+20]=0;
        H_Matrix[0][index*32+21]=0, H_Matrix[1][index*32+21]=1, H_Matrix[2][index*32+21]=1, H_Matrix[3][index*32+21]=0, H_Matrix[4][index*32+21]=1, H_Matrix[5][index*32+21]=0, H_Matrix[6][index*32+21]=0, H_Matrix[7][index*32+21]=0;
        H_Matrix[0][index*32+22]=1, H_Matrix[1][index*32+22]=1, H_Matrix[2][index*32+22]=0, H_Matrix[3][index*32+22]=1, H_Matrix[4][index*32+22]=0, H_Matrix[5][index*32+22]=0, H_Matrix[6][index*32+22]=0, H_Matrix[7][index*32+22]=0;
        H_Matrix[0][index*32+23]=1, H_Matrix[1][index*32+23]=0, H_Matrix[2][index*32+23]=1, H_Matrix[3][index*32+23]=0, H_Matrix[4][index*32+23]=1, H_Matrix[5][index*32+23]=0, H_Matrix[6][index*32+23]=0, H_Matrix[7][index*32+23]=0;
        H_Matrix[0][index*32+24]=0, H_Matrix[1][index*32+24]=1, H_Matrix[2][index*32+24]=0, H_Matrix[3][index*32+24]=1, H_Matrix[4][index*32+24]=1, H_Matrix[5][index*32+24]=0, H_Matrix[6][index*32+24]=0, H_Matrix[7][index*32+24]=0;
        H_Matrix[0][index*32+25]=1, H_Matrix[1][index*32+25]=0, H_Matrix[2][index*32+25]=0, H_Matrix[3][index*32+25]=1, H_Matrix[4][index*32+25]=1, H_Matrix[5][index*32+25]=0, H_Matrix[6][index*32+25]=0, H_Matrix[7][index*32+25]=0;

        // 5C4
        H_Matrix[0][index*32+26]=0, H_Matrix[1][index*32+26]=1, H_Matrix[2][index*32+26]=1, H_Matrix[3][index*32+26]=1, H_Matrix[4][index*32+26]=1, H_Matrix[5][index*32+26]=0, H_Matrix[6][index*32+26]=0, H_Matrix[7][index*32+26]=0;
        H_Matrix[0][index*32+27]=1, H_Matrix[1][index*32+27]=0, H_Matrix[2][index*32+27]=1, H_Matrix[3][index*32+27]=1, H_Matrix[4][index*32+27]=1, H_Matrix[5][index*32+27]=0, H_Matrix[6][index*32+27]=0, H_Matrix[7][index*32+27]=0;
        H_Matrix[0][index*32+28]=1, H_Matrix[1][index*32+28]=1, H_Matrix[2][index*32+28]=0, H_Matrix[3][index*32+28]=1, H_Matrix[4][index*32+28]=1, H_Matrix[5][index*32+28]=0, H_Matrix[6][index*32+28]=0, H_Matrix[7][index*32+28]=0;
        H_Matrix[0][index*32+29]=1, H_Matrix[1][index*32+29]=1, H_Matrix[2][index*32+29]=1, H_Matrix[3][index*32+29]=0, H_Matrix[4][index*32+29]=1, H_Matrix[5][index*32+29]=0, H_Matrix[6][index*32+29]=0, H_Matrix[7][index*32+29]=0;
        H_Matrix[0][index*32+30]=1, H_Matrix[1][index*32+30]=1, H_Matrix[2][index*32+30]=1, H_Matrix[3][index*32+30]=1, H_Matrix[4][index*32+30]=0, H_Matrix[5][index*32+30]=0, H_Matrix[6][index*32+30]=0, H_Matrix[7][index*32+30]=0;

        // 5C5
        H_Matrix[0][index*32+31]=1, H_Matrix[1][index*32+31]=1, H_Matrix[2][index*32+31]=1, H_Matrix[3][index*32+31]=1, H_Matrix[4][index*32+31]=1, H_Matrix[5][index*32+31]=0, H_Matrix[6][index*32+31]=0, H_Matrix[7][index*32+31]=0;
    }

    // LAST 3 rows
    /*
        각 32개 단위로 column들의 맨 아래 3개 row의 합이 각각 다르도록 만든다. 즉, 32bit 단위로 bound 된다. (mis-correction이 되는 경우에도 32 bit bound 내부로 mis-correction 되도록 하기! => Chipkill로 고칠 수 있다.)
        0~31 => 111
        32~63 => 110
        64~95 => 101
        96~127 => 011
    */

    // first 32 column => 111
    for(int index=0; index<32; index++){
        H_Matrix[5][index]=1;
        H_Matrix[6][index]=1;
        H_Matrix[7][index]=1;
    }
    // second 32 column => 110
    for(int index=32; index<64; index++){
        H_Matrix[5][index]=1;
        H_Matrix[6][index]=1;
    }
    //third 32 column => 101
    for(int index=64; index<96; index++){
        H_Matrix[5][index]=1;
        H_Matrix[7][index]=1;
    }
    // fourth 32 column => 011
    for(int index=96; index<128; index++){
        H_Matrix[6][index]=1;
        H_Matrix[7][index]=1;
    }

    // print!!!
    for(int row=0; row<8; row++){
        for(int column=0; column<136; column++)
            fprintf(fp,"%d ",H_Matrix[row][column]);
        fprintf(fp,"\n");
    }

    return 0;
}

