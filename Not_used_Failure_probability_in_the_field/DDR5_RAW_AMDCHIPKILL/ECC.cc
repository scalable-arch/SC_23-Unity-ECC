#include <assert.h>

#include "ECC.hh"
#include "FaultDomain.hh"
#include "DomainGroup.hh"
#include "codec.hh"
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

#define RUN_NUM 10000000 // 실행 횟수

#define CONSERVATIVE_MODE 0 // Rank-level ECC에서 Conservative mode on/off (키면 chip position도 기록해서 다른 chip correction 하면 cacheline 전체를 DUE 처리!)


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
    //std::cout << "this is errorBlk blocks " << std::endl;
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

        // Fill my code here!!!!

    ////////////////////////////////////

    // Rank-level ECC

    // 첫번째 cacheline
    //  DDR5 : 1280/40 (31~16)
    for (int i=errorBlk.getBitN()/codec->getBitN()-1; i>=errorBlk.getBitN()/codec->getBitN()/2; i-=2) { // 31, 29, ... 17
        //msg.extract(&errorBlk, layout, i, errorBlk.getChannelWidth());
        // printf("errorBlk.getBitN() : %d, codec->getBitN() : %d\n",errorBlk.getBitN(),codec->getBitN());
        //printf("getBiN *2 : %d\n",codec->getBitN()*2);
        unsigned int msg[codec->getBitN()*2]; 
        unsigned int decoded[codec->getBitN()*2];

        // codeword 생성
        for(int symbol_index=0; symbol_index<errorBlk.getChannelWidth()/4; symbol_index++){ // 0~9
            msg[symbol_index*8+0] = errorBlk.returnindex(errorBlk.getChannelWidth()*(i-1)+symbol_index*4+0);
            msg[symbol_index*8+1] = errorBlk.returnindex(errorBlk.getChannelWidth()*(i-1)+symbol_index*4+1);
            msg[symbol_index*8+2] = errorBlk.returnindex(errorBlk.getChannelWidth()*(i-1)+symbol_index*4+2);
            msg[symbol_index*8+3] = errorBlk.returnindex(errorBlk.getChannelWidth()*(i-1)+symbol_index*4+3);
            msg[symbol_index*8+4] = errorBlk.returnindex(errorBlk.getChannelWidth()*(i)+symbol_index*4+0);
            msg[symbol_index*8+5] = errorBlk.returnindex(errorBlk.getChannelWidth()*(i)+symbol_index*4+1);
            msg[symbol_index*8+6] = errorBlk.returnindex(errorBlk.getChannelWidth()*(i)+symbol_index*4+2);
            msg[symbol_index*8+7] = errorBlk.returnindex(errorBlk.getChannelWidth()*(i)+symbol_index*4+3);
        }
        for(int index=0; index<RECC_CW_LEN; index++)
            decoded[index]=msg[index];


        // error 유무 검사
        int error_check=0;
        for(int index=0; index<codec->getBitN()*2; index++){
            if(msg[index]==1){ // error 발생
                error_check=1;
                break;
            }
        }

        //std::cout << "this is "<< i << "th burst received codeword" << std::endl;
        //for(int index=0; index<codec->getBitN()*2; index++)
        //    printf("%d ",msg[index]);
        //printf("\n");
        // msg.print();

        if (error_check==0) {        // error-free region of a block -> skip
            final_result_1 = NE;
        } else {
            newResult = codec->decode(msg, decoded, &correctedPosSet);
        }
        
        // DUE 검사 1
        if(newResult==DUE || final_result_1==DUE)
            final_result_1=DUE;
        else{ // 둘 중 우선순위가 큰 값 (SDC > CE > NE), 이전에 DUE가 나온 적이 없는 경우에만 들어갈 수 있다.
            final_result_1 = (final_result_1>newResult) ? final_result_1 : newResult;
        }

        // DUE 검사 2
        isConservative=(correctedPosSet.size()>1) ? 1 : isConservative;

        //std::cout << "this is "<< i << "th burst decoded codeword" << std::endl;
        //for(int index=0; index<codec->getBitN()*2; index++)
        //    printf("%d ",decoded[index]);
        //printf("\n");
        //decoded.print();
    }
    
    if(final_result_1==NE || final_result_1==CE){
        final_result_1 = (isConservative) ? DUE : CE;
    }

    // 두번째 cacheline
    //  DDR5 : 1280/40 (15~0)
    correctedPosSet.clear();
    isConservative=0;
    for (int i=errorBlk.getBitN()/codec->getBitN()/2-1; i>=0; i-=2) { // 15, 13, ... 1
        //msg.extract(&errorBlk, layout, i, errorBlk.getChannelWidth());
        // printf("errorBlk.getBitN() : %d, codec->getBitN() : %d\n",errorBlk.getBitN(),codec->getBitN());
        //printf("getBiN *2 : %d\n",codec->getBitN()*2);
        unsigned int msg[codec->getBitN()*2]; 
        unsigned int decoded[codec->getBitN()*2];

        // codeword 생성
        for(int symbol_index=0; symbol_index<errorBlk.getChannelWidth()/4; symbol_index++){ // 0~9
            msg[symbol_index*8+0] = errorBlk.returnindex(errorBlk.getChannelWidth()*(i-1)+symbol_index*4+0);
            msg[symbol_index*8+1] = errorBlk.returnindex(errorBlk.getChannelWidth()*(i-1)+symbol_index*4+1);
            msg[symbol_index*8+2] = errorBlk.returnindex(errorBlk.getChannelWidth()*(i-1)+symbol_index*4+2);
            msg[symbol_index*8+3] = errorBlk.returnindex(errorBlk.getChannelWidth()*(i-1)+symbol_index*4+3);
            msg[symbol_index*8+4] = errorBlk.returnindex(errorBlk.getChannelWidth()*(i)+symbol_index*4+0);
            msg[symbol_index*8+5] = errorBlk.returnindex(errorBlk.getChannelWidth()*(i)+symbol_index*4+1);
            msg[symbol_index*8+6] = errorBlk.returnindex(errorBlk.getChannelWidth()*(i)+symbol_index*4+2);
            msg[symbol_index*8+7] = errorBlk.returnindex(errorBlk.getChannelWidth()*(i)+symbol_index*4+3);
        }

        for(int index=0; index<RECC_CW_LEN; index++)
            decoded[index]=msg[index];
        


        // error 유무 검사
        int error_check=0;
        for(int index=0; index<codec->getBitN()*2; index++){
            if(msg[index]==1){ // error 발생
                error_check=1;
                break;
            }
        }

        //std::cout << "this is "<< i << "th burst received codeword" << std::endl;
        //for(int index=0; index<codec->getBitN()*2; index++)
        //    printf("%d ",msg[index]);
        //printf("\n");
        // msg.print();

        if (error_check==0) {        // error-free region of a block -> skip
            final_result_2 = NE;
        } else {
            newResult = codec->decode(msg, decoded, &correctedPosSet);
        }
        
        // DUE 검사 1
        if(newResult==DUE || final_result_2==DUE)
            final_result_2=DUE;
        else{ // 둘 중 우선순위가 큰 값 (SDC > CE > NE), 이전에 DUE가 나온 적이 없는 경우에만 들어갈 수 있다.
            final_result_2 = (final_result_2>newResult) ? final_result_2 : newResult;
        }

        // DUE 검사 2
        isConservative=(correctedPosSet.size()>1) ? 1 : isConservative;

        //std::cout << "this is "<< i << "th burst decoded codeword" << std::endl;
        //for(int index=0; index<codec->getBitN()*2; index++)
        //    printf("%d ",decoded[index]);
        //printf("\n");
    }

    if(final_result_2==NE || final_result_2==CE){
        final_result_2 = (isConservative) ? DUE : CE;
    }

    final_result = (final_result_1 > final_result_2) ? final_result_1 : final_result_2;

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

