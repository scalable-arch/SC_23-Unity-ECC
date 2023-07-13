#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <math.h>

#include "Config.hh"
#include "Tester.hh"
#include "Scrubber.hh"
#include "FaultDomain.hh"
#include "DomainGroup.hh"
#include "codec.hh"

//------------------------------------------------------------------------------
char errorName[][10] = {"NE ",
                        "CE ",
                        "DE ",
#ifdef DUE_BREAKDOWN
						"DPa","DNE",
#endif
                        "SDC"
#ifdef DUE_BREAKDOWN
					   ,"SEr"
#endif

						};

//------------------------------------------------------------------------------
void TesterSystem::reset() {
    for (int i=0; i<MAX_YEAR; i++) {
        RetireCntYear[i] = 0l;
        DUECntYear[i] = 0l;
        SDCCntYear[i] = 0l;
	}
}

//------------------------------------------------------------------------------
void TesterSystem::printSummary(FILE *fd, long runNum) {
    fprintf(fd, "After %ld runs\n", runNum);
    fprintf(fd, "Retire\n");
    for (int yr=1; yr<MAX_YEAR; yr++) {
        fprintf(fd, "%.11f\n", (double)RetireCntYear[yr]/runNum);
    }
    fprintf(fd, "DUE\n");
    for (int yr=1; yr<MAX_YEAR; yr++) {
        fprintf(fd, "%.11f\n", (double)DUECntYear[yr]/runNum);
    }
    fprintf(fd, "SDC\n");
    for (int yr=1; yr<MAX_YEAR; yr++) {
        fprintf(fd, "%.11f\n", (double)SDCCntYear[yr]/runNum);
    }
    fflush(fd);
}

//------------------------------------------------------------------------------
double TesterSystem::advance(double faultRate) {
    double result = -log(1.0f - (double) rand() / ((long long) RAND_MAX+1)) / faultRate;
    //printf("- %f\n", result);
    return result;
}

//------------------------------------------------------------------------------
void TesterSystem::test(DomainGroup *dg, ECC *ecc, Scrubber *scrubber, long runCnt, char* filePrefix, int faultCount, std::string *faults) {
    assert(faultCount<=1);  // either no or 1 inherent fault

    Fault *inherentFault = NULL;
    // create log file
    std::string nameBuffer = std::string(filePrefix)+".S";


    if (faultCount==1) {    // no inherent fault
        nameBuffer = nameBuffer+"."+faults[0];
        inherentFault = Fault::genRandomFault(faults[0], NULL);
        dg->setInherentFault(inherentFault);
    }


    FILE *fd = fopen(nameBuffer.c_str(), "w");
    assert(fd!=NULL);

    // reset statistics
    reset();

    // for runCnt times
    for (long runNum=0; runNum<runCnt; runNum++) {
        if ((runNum==100) || ((runNum!=0)&&(runNum%1000000==0))) {
            printSummary(fd, runNum);
        }
        if (runNum%10000000==0) {
        //if (runNum%1000000==0) {
            printf("Processing %ldth iteration\n", runNum);
        }

        //printf("runNum : %ld\n",runNum);

        if (inherentFault!=NULL) {
            dg->setInitialRetiredBlkCount(ecc);
        }

        double hr = 0.;

        while (true) {
            // 1. Advance
            // Poisson function 기반으로 fault injection time 예측
            // MAX_YEAR를 넘어가기 전까지는 계속 fault injection. 누적으로 진행! 
            // hr는 hour 단위이다!! 즉, 1년이면 24 * 365 = 8,760 이다.
            double prevHr = hr;
            hr += advance(dg->getFaultRate());

            if (hr > (MAX_YEAR-1)*24*365) {
                break;
            }

            // 2. scrub soft errors (흠....)
            scrubber->scrub(dg, hr);

            // 3. generate a fault
            // Fault domain에 들어 있는 Fault Range (FR) 중에서 임의로 1개 선택
            FaultDomain *fd = dg->pickRandomFD();

            // 4. generate an error and decode it
            // Intersect 방법을 통해 CE/DUE/SDC 판별
            ErrorType result = fd->genSystemRandomFaultAndTest(ecc);

            // 5. process result
			// default : PF retirement
            if ((result==CE)&&ecc->getDoRetire()&&(fd->getRetiredBlkCount() > ecc->getMaxRetiredBlkCount())) {
//printf("%d %llu %llu\n", ecc->getDoRetire(), fd->getRetiredBlkCount(), ecc->getMaxRetiredBlkCount());
                printf("CE, hours %lf (%lfyrs)\n",hr,hr/(24*365));
                for (int i=0; i<MAX_YEAR; i++) {
                    if (hr < i*24*365) {
                        RetireCntYear[i]++;
                    }
                }
                break;
            } else if (result==DUE) {
                printf("DUE, hours %lf (%lfyrs)\n",hr,hr/(24*365));
                for (int i=0; i<MAX_YEAR; i++) {
                    if (hr < i*24*365) {
                        DUECntYear[i]++;
                    }
                }
                break;
            } else if (result==SDC) {
                printf("SDC hours %lf (%lfyrs)\n", hr, hr/(24*365));
                for (int i=0; i<MAX_YEAR; i++) {
                    if (hr < i*24*365) {
                        SDCCntYear[i]++;
                    }
                }
                break;
            } 
        }
        // while문 종료

        dg->clear();
        ecc->clear();
    }
    // for문 종료
    printSummary(fd, runCnt);

    fclose(fd);
}