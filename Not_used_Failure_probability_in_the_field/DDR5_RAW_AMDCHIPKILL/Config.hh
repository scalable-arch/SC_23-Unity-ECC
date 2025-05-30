#ifndef __CONFIG_HH__
#define __CONFIG_HH__

#define BIT_FIT 0.0001
#define FIT *0.000000001

#if 0
// Jaguar
// 2GB DDR-2 DIMM -> 128MB (1Gb) x4 DDR-2 chip
// # of bank 8
// row addr A[13:0]
// column address {A11, A[9:0]}
// 2 rank
//#define DEFAULT_MASK     0x0000000000000000ULL
#define DEFAULT_MASK     0xFFFFFFFFE0000000ULL

#define SBIT_MASK       (0x0000000000000000ULL|DEFAULT_MASK)
#define SWORD_MASK      (0x0000000000000000ULL|DEFAULT_MASK)
#define SCOL_MASK       (0x00000000000007FFULL|DEFAULT_MASK)
#define SROW_MASK       (0x000000000FFFC000ULL|DEFAULT_MASK)
#define SBANK_MASK      (SCOL_MASK|SROW_MASK|DEFAULT_MASK)
#define MBANK_MASK      (0x000000000FFFFFFFULL|DEFAULT_MASK)
#define MRANK_MASK      (0x000000001FFFFFFFULL|DEFAULT_MASK)
#define CHANNEL_MASK    (0xFFFFFFFFFFFFFFFFULL)
#else

// DDR5 ECC-DIMM -> 16Gb x4 chip (10 chip)
// # of bank 32
// row addr A[15:0]
// column address {A[10:0]}
// 1 rank
//#define DEFAULT_MASK     0x0000000000000000ULL

#define DEFAULT_MASK     0xFFFFFFFF00000000ULL // 1111_1111_1111_1111_1111_1111_1111_1111_0000_0000_0000_0000_0000_0000_0000_0000 (FFFFFFFF 00000000)

#define RANDOM_SBIT_MASK (0x0000000000000000ULL|DEFAULT_MASK)
#define SBIT_MASK        (0x0000000000000000ULL|DEFAULT_MASK)
#define SWORD_MASK       (0x0000000000000000ULL|DEFAULT_MASK)
#define SCOL_MASK        (0x00000000000007FFULL|DEFAULT_MASK) // 0000 8개 + _0000_0000_0000_0000_0000_0111_1111_1111 (000007FF) => column : 11bit
#define SROW_MASK        (0x00000000FFFF0000ULL|DEFAULT_MASK) // 0000 8개 + _1111_1111_1111_1111_0000_0000_0000_0000 (FFFF0000) => row : 16bit
#define SBANK_MASK       (SCOL_MASK|SROW_MASK|DEFAULT_MASK)   // 0000 8개 + _1111_1111_1111_1111_0000_0111_1111_1111 (FFFF07FF) => bank : 5bit
#define MBANK_MASK       (0x00000000FFFFFFFFULL|DEFAULT_MASK) // 0000 8개 + _1111_1111_1111_1111_1111_1111_1111_1111 (FFFFFFFF)
#define MRANK_MASK       (0x00000000FFFFFFFFULL|DEFAULT_MASK) // 0000 8개 + _1111_1111_1111_1111_1111_1111_1111_1111 (FFFFFFFF)
#define CHANNEL_MASK     (0xFFFFFFFFFFFFFFFFULL)


/*
// 16GB DDR-4 DIMM -> 1GB (8Gb) x4 DDR-4 chip
// R-EGB
// # of bank 16
// row addr A[15:0]
// column address {A[9:0]}
// 2 rank
//#define DEFAULT_MASK     0x0000000000000000ULL
#define DEFAULT_MASK     0xFFFFFFFF00000000ULL // 1111_1111_1111_1111_1111_1111_1111_1111_0000_0000_0000_0000_0000_0000_0000_0000

#define RANDOM_SBIT_MASK (0x0000000000000000ULL|DEFAULT_MASK)
#define SBIT_MASK        (0x0000000000000000ULL|DEFAULT_MASK)
#define SWORD_MASK       (0x0000000000000000ULL|DEFAULT_MASK)
#define SCOL_MASK        (0x00000000000007FFULL|DEFAULT_MASK) // 0000 8개 + _0000_0000_0000_0000_0000_0111_1111_1111 (000007FF) => 
#define SROW_MASK        (0x000000007FFF8000ULL|DEFAULT_MASK) // 0000 8개 + _0111_1111_1111_1111_1000_0000_0000_0000 (7FFF8000)
#define SBANK_MASK       (SCOL_MASK|SROW_MASK|DEFAULT_MASK)   // 0000 8개 + _0000_0000_0000_0000_0000_0111_1111_1111 
#define MBANK_MASK       (0x000000007FFFFFFFULL|DEFAULT_MASK) // 0000 8개 + _0111_1111_1111_1111_1111_1111_1111_1111 (7FFFFFFF)
#define MRANK_MASK       (0x00000000FFFFFFFFULL|DEFAULT_MASK) // 0000 8개 + _1111_1111_1111_1111_1111_1111_1111_1111 (FFFFFFFF)
#define CHANNEL_MASK     (0xFFFFFFFFFFFFFFFFULL)

*/
#endif

#endif /* __CONFIG_HH__ */