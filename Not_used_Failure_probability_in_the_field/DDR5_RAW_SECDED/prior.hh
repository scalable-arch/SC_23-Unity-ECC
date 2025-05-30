/**
 * @file: prior.hh
 * @author: Jungrae Kim <dale40@gmail.com>
 * Prior ECC work declaration
 */

#ifndef __PRIOR_HH__
#define __PRIOR_HH__

#include "ECC.hh"

//------------------------------------------------------------------------------
// SEC-DED on 40-bit interface
//------------------------------------------------------------------------------
class SECDED40b : public ECC {
public:
    SECDED40b();
};

#endif