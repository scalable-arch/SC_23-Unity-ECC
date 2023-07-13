#include "prior.hh"
#include "hsiao.hh"
#include "FaultDomain.hh"

//------------------------------------------------------------------------------
// AMCDHIPKILL on 40-bit interface
// AMDCHIPKILL on 2 beat (total 80-bit)
//------------------------------------------------------------------------------
AMDCHIPKILL80b::AMDCHIPKILL80b() : ECC(AMD) {
    configList.push_back({0, 0, new Hsiao("AMDCHIPKILL \t10\t4\t", 40, 8)});
}