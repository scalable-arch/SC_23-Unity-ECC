/**
 * @file: prior.hh
 * @author: Jungrae Kim <dale40@gmail.com>
 * Prior ECC work declaration
 */

#ifndef __PRIOR_HH__
#define __PRIOR_HH__

#include "ECC.hh"

//------------------------------------------------------------------------------
// AMDCHIPKILL on 40-bit interface
// AMDCHIPKILL on 2 beat (total 80-bit)
//------------------------------------------------------------------------------
class AMDCHIPKILL80b : public ECC {
public:
    AMDCHIPKILL80b();
};

#endif