#include "prior.hh"
#include "hsiao.hh"
#include "FaultDomain.hh"

//------------------------------------------------------------------------------
// SEC-DED on 72-bit interface
//------------------------------------------------------------------------------
SECDED40b::SECDED40b() : ECC(LINEAR) {
    configList.push_back({0, 0, new Hsiao("SEC-DED (Hsiao)\t10\t4\t", 40, 8)});
}