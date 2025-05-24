#include <assert.h>

#include "ECC.hh"
#include "FaultDomain.hh"
#include "DomainGroup.hh"
#include "codec.hh"
#include "hsiao.hh"

#define CHANNEL_WIDTH 40
#define CHIP_NUM 8
#define DATA_CHIP_NUM 8 // sub-channel마다 data chip 개수
#define CHIP_WIDTH 4
#define BLHEIGHT 32 // RECC가 검사해야 하는 Burst length (ondie ecc의 redundancy는 제외하고 BL32만 검사한다. conservative mode 조건 고려하기)
#define SYMBOL_SIZE 8 // RECC에서 시행하는 symbol size (8이면 GF(2^8))

#define OECC_CW_LEN 136 // ondie ecc의 codeword 길이 (bit 단위)
#define OECC_DATA_LEN 128 // ondie ecc의 dataward 길이 (bit 단위)
#define OECC_REDUN_LEN 8 // ondie ecc의 redundancy 길이 (bit 단위)

#define RECC_CW_LEN 64 // rank-level ecc의 codeword 길이 (bit 단위)
#define RECC_DATA_LEN 64 // rank-level ecc의 dataward 길이 (bit 단위)
#define RECC_REDUN_LEN 16 // rank-level ecc의 redundancy 길이 (bit 단위)

#define RECC_REDUN_SYMBOL_NUM 2 // rank-level ecc의 redundancy 길이 (symbol 단위)
#define RECC_CW_SYMBOL_NUM 10 // rank-level ecc의 codeword 길이 (symbol 단위)

#define RUN_NUM 10000000 // 실행 횟수

#define CONSERVATIVE_MODE 0 // Rank-level ECC에서 Conservative mode on/off (키면 chip position도 기록해서 다른 chip correction 하면 cacheline 전체를 DUE 처리!)

unsigned int H_Matrix_SEC[OECC_REDUN_LEN][OECC_CW_LEN]; // 8 x 136

extern std::default_random_engine randomGenerator;

//------------------------------------------------------------------------------
ErrorType worse2ErrorType(ErrorType a, ErrorType b) {
    //if ((a==SDC) || (b==SDC)) {
    //    return SDC;
    //}
    if ((a==DUE) || (b==DUE)) {
        return DUE;
    }
    return (a>b) ? a : b;
}

//------------------------------------------------------------------------------
ErrorType ECC::decode(FaultDomain *fd, CacheLine &errorBlk) {
    ErrorType result;

    // clear corrected position information
    clear();

    // do decoding
    result = decodeInternal(fd, errorBlk);

    if (doPostprocess) {
        result = postprocess(fd, result);
    }
    return result;
}

ErrorType ECC::decodeInternal(FaultDomain *fd, CacheLine &errorBlk) {
    // find appropriate CODEC
    Codec *codec = NULL;
    for (auto it = configList.begin(); it != configList.end(); it++) {
        if (   (fd->getRetiredChipCount() <= it->maxDeviceRetirement)
            && (fd->getRetiredPinCount() <= it->maxPinRetirement) ) {
            codec = it->codec;
            //assert((codec->getBitN()%errorBlk.getChannelWidth())==0);
        }
    }
    if (codec==NULL) { if (errorBlk.isZero()) return NE; else return SDC; }

    // ECCWord msg = {(codec->getBitN())*2, (codec->getBitK())*2};
    // ECCWord decoded = {(codec->getBitN())*2, (codec->getBitK())*2};

    // ErrorType result = NE, newResult;
    ErrorType result=NE;
    int newResult;
    int final_result, final_result_1=CE, final_result_2=CE;
    int isConservative=0;
    //std::cout << "========================" << std::endl;
    //std::cout << "this is errorBlk blocks (before OECC) " << std::endl;
    //errorBlk.print(stdout);

    //int Failure_rate=10000; // bit error injection rate
    
    std::uniform_int_distribution<unsigned long long> randDist = std::uniform_int_distribution<unsigned long long>(0, ULLONG_MAX);
    unsigned long long randValue;
    unsigned long long randValue2;
    
    /*
    
    for(int count=0; count<errorBlk.getBitN(); count++){
        randValue2=rand()%Failure_rate; // 0~999
        if(randValue2==0){ // 1 bit error injection
            while(1){
                randValue=rand()%errorBlk.getBitN(); // 0~1279
                if(errorBlk.returnindex(randValue)==0){
                    errorBlk.invBit(randValue);
                    break;
                }
            }
        }
    }

    */

    // on-die ECC 실행 (있으면!!)
    ////////////////////////////////////

    // H_Matrix 설정
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

    for(int Fault_chip_position=0; Fault_chip_position<CHIP_NUM; Fault_chip_position++){
        unsigned int Syndromes[OECC_REDUN_LEN]; // 8 x 1
        unsigned int OECC_codeword[OECC_CW_LEN]; // 136 bit

        // codeword 생성
        // 첫번째 chip : index[0~15] = 40*(0~15)+0+0
        // 첫번째 chip : index[16~31] = 40*(0~15)+0+1
        // 첫번쨰 chip : index[32~47] = 40*(0~15)+0+2
        // 첫번째 chip : index[48~63] = 40*(0~15)+0+3
        for(int index=0; index<16; index++)
            OECC_codeword[index]=errorBlk.returnindex(errorBlk.getChannelWidth()*index+Fault_chip_position*CHIP_WIDTH);
        for(int index=16; index<32; index++)
            OECC_codeword[index]=errorBlk.returnindex(errorBlk.getChannelWidth()*(index-16)+Fault_chip_position*CHIP_WIDTH+1);
        for(int index=32; index<48; index++)
            OECC_codeword[index]=errorBlk.returnindex(errorBlk.getChannelWidth()*(index-32)+Fault_chip_position*CHIP_WIDTH+2);
        for(int index=48; index<64; index++)
            OECC_codeword[index]=errorBlk.returnindex(errorBlk.getChannelWidth()*(index-48)+Fault_chip_position*CHIP_WIDTH+3);
        // 첫번째 chip : index[64~79] = 40*(16~31)+0+0
        // 첫번째 chip : index[80~95] = 40*(16~31)+0+1
        // 첫번쨰 chip : index[96~111] = 40*(16~31)+0+2
        // 첫번째 chip : index[112~127] = 40*(16~31)+0+3
        for(int index=64; index<80; index++)
            OECC_codeword[index]=errorBlk.returnindex(errorBlk.getChannelWidth()*(index-48)+Fault_chip_position*CHIP_WIDTH);
        for(int index=80; index<96; index++)
            OECC_codeword[index]=errorBlk.returnindex(errorBlk.getChannelWidth()*(index-64)+Fault_chip_position*CHIP_WIDTH+1);
        for(int index=96; index<112; index++)
            OECC_codeword[index]=errorBlk.returnindex(errorBlk.getChannelWidth()*(index-80)+Fault_chip_position*CHIP_WIDTH+2);
        for(int index=112; index<128; index++)
            OECC_codeword[index]=errorBlk.returnindex(errorBlk.getChannelWidth()*(index-96)+Fault_chip_position*CHIP_WIDTH+3);
        // 첫번째 chip : index[128~131] = 40*32+0+0~3
        // 첫번째 chip : index[132~135] = 40*33+0+0~3
        for(int index=128; index<132; index++)
            OECC_codeword[index]=errorBlk.returnindex(errorBlk.getChannelWidth()*32+Fault_chip_position*CHIP_WIDTH+index%CHIP_WIDTH);
        for(int index=132; index<136; index++)
            OECC_codeword[index]=errorBlk.returnindex(errorBlk.getChannelWidth()*33+Fault_chip_position*CHIP_WIDTH+index%CHIP_WIDTH);


        // 두번째 chip : index[0~15] = 40*(0~15)+4+0
        // 두번째 chip : index[16~31] = 40*(0~15)+4+1
        // 두번쨰 chip : index[32~47] = 40*(0~15)+4+2
        // 두번째 chip : index[48~63] = 40*(0~15)+4+3

        // 두번째 chip : index[64~79] = 40*(16~31)+4+0
        // 두번째 chip : index[80~95] = 40*(16~31)+4+1
        // 두번쨰 chip : index[96~111] = 40*(16~31)+4+2
        // 두번째 chip : index[112~127] = 40*(16~31)+4+3

        // 두번째 chip : index[128~131] = 40*32+4+0~3
        // 두번째 chip : index[132~135] = 40*33+4+0~3
        

        // Syndromes = H * C^T
        for(int row=0; row<OECC_REDUN_LEN; row++){
            unsigned int row_value=0;
            for(int column=0; column<OECC_CW_LEN; column++)
                row_value=row_value^(H_Matrix_SEC[row][column] * OECC_codeword[column]);
                //row_value=row_value^(H_Matrix_SEC[row][column] * Chip_array[Fault_Chip_position][column]);
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
                //printf("\nerror correction! error_pos : %d\n",error_pos);
                // 첫번째 chip : OECC_codeword[0~15] => errorblk[40*(0~15)+0+0]
                // 첫번째 chip : OECC_codeword[16~31] => errorblk[40*(0~15)+0+1]
                // 첫번째 chip : OECC_codeword[32~47] => errorblk[40*(0~15)+0+2]
                // 첫번째 chip : OECC_codeword[48~63] => errorblk[40*(0~15)+0+3]
                if(0<=error_pos && error_pos<64)
                    errorBlk.inverterBit(errorBlk.getChannelWidth()*(error_pos%16)+Fault_chip_position*CHIP_WIDTH+error_pos/16);
                
                //errorBlk.inverterBit(errorBlk.getChannelWidth()*(error_pos/CHIP_WIDTH)+Fault_chip_position*CHIP_WIDTH+error_pos%CHIP_WIDTH);

                // 첫번째 chip : OECC_codeword[64~79] => errorblk[40*(16~31)+0+0]
                // 첫번째 chip : OECC_codeword[80~95] => errorblk[40*(16~31)+0+1]
                // 첫번째 chip : OECC_codeword[96~111] => errorblk[40*(16~31)+0+2]
                // 첫번째 chip : OECC_codeword[112~127] => errorblk[40*(16~31)+0+3]
                else if(64<=error_pos && error_pos<128)
                    errorBlk.inverterBit(errorBlk.getChannelWidth()*(16+error_pos%16)+Fault_chip_position*CHIP_WIDTH+error_pos/16-4);
                
                // 첫번째 chip : OECC_codeword[128~131] => errorblk[40*32+0+0~3]
                else if(128<=error_pos && error_pos<132)
                    errorBlk.inverterBit(errorBlk.getChannelWidth()*32+Fault_chip_position*CHIP_WIDTH+error_pos%CHIP_WIDTH);

                // 첫번째 chip : OECC_codeword[132~135] => errorblk[40*33+0+0~3]
                else if(132<=error_pos && error_pos<136)
                    errorBlk.inverterBit(errorBlk.getChannelWidth()*33+Fault_chip_position*CHIP_WIDTH+error_pos%CHIP_WIDTH);

                // 두번째 chip : OECC_codeword[0~15] => errorblk[40*(0~15)+4+0]
                // 두번째 chip : OECC_codeword[16~31] => errorblk[40*(0~15)+4+1]
                // 두번째 chip : OECC_codeword[32~47] => errorblk[40*(0~15)+4+2]
                // 두번째 chip : OECC_codeword[48~63] => errorblk[40*(0~15)+4+3]

                // 두번째 chip : OECC_codeword[64~79] => errorblk[40*(16~31)+4+0]
                // 두번째 chip : OECC_codeword[80~95] => errorblk[40*(16~31)+4+1]
                // 두번째 chip : OECC_codeword[96~111] => errorblk[40*(16~31)+4+2]
                // 두번째 chip : OECC_codeword[112~127] => errorblk[40*(16~31)+4+3]

                // 두번째 chip : OECC_codeword[128~131] => errorblk[40*32+4+0~3]
                // 두번째 chip : OECC_codeword[132~135] => errorblk[40*33+4+0~3]
                break;
            }
        }
    }

    //std::cout << "========================" << std::endl;
    //std::cout << "this is errorBlk blocks (After OECC) " << std::endl;
    //errorBlk.print(stdout);

    ////////////////////////////////////

    // cacheline 2개에서 1이 남아 잇는지 검사 (1이 남아 있으면 error가 남아 있고 rank-level ECC는 없으니 SDC)
    //  DDR5 : 1280/40 (31~16)

    for(int index=0; index<errorBlk.returnindex(errorBlk.getChannelWidth()*BLHEIGHT); index++){ // 0~(32*32-1)
        if(errorBlk.returnindex(index)==1){
            final_result=SDC;
            break;
        }
    }

    if(final_result==CE || final_result==NE)
        result=CE;
    else if(final_result==DUE)
        result=DUE;
    else if(final_result==SDC)
        result=SDC;

    return result;
}

//------------------------------------------------------------------------------
unsigned long long ECC::getInitialRetiredBlkCount(FaultDomain *fd, Fault *fault) {
    double cellFaultRate = fault->getCellFaultRate();
    if (cellFaultRate==0) {
        return 0;
    } else {
        int blkSize = fd->getChannelWidth() * fd->getBeatHeight();
        double goodBlkProb = pow(1-cellFaultRate, blkSize);
        unsigned long long totalBlkCount = ((MRANK_MASK^DEFAULT_MASK)+1)*fd->getChannelWidth()/blkSize;
        std::binomial_distribution<int> distribution(totalBlkCount, goodBlkProb);
        unsigned long long goodBlkCount = distribution(randomGenerator);
        unsigned long long badBlkCount = totalBlkCount - goodBlkCount;
        return badBlkCount;
    }
}

