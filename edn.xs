#define PERL_NO_GET_CONTEXT

extern "C" {

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

}
  
#undef do_open
#undef do_close
  

#include <cstdio>
#include <string>
#include "edn-cpp/edn.hpp"

using edn::EdnNode;
using edn::NodeType;
using edn::read;

static SV*
nodeToSV(const EdnNode& e) {
  dTHX;
  
  if (e.type == edn::EdnInt) {
    return newSViv(std::stoi(e.value));
  } else if (e.type == edn::EdnNil) {
    return nullptr;
  } else if (e.type == edn::EdnSymbol) {
    return newSVpvn(e.value.c_str(), e.value.length());
  } else if (e.type == edn::EdnKeyword) {
    return newSVpvn(e.value.c_str() + 1, e.value.length() - 1);
  } else if (e.type == edn::EdnString) {
    return newSVpvn(e.value.c_str(), e.value.length());
  } else if (e.type == edn::EdnTagged) {
    return newSVpvn(e.value.c_str(), e.value.length());
  } else if (e.type == edn::EdnList || e.type == edn::EdnSet || e.type == edn::EdnVector) {
    AV *av = newAV();
    int idx = 0;
    for (auto i = begin(e.values); i != end(e.values); ++i) {
      av_store(av, idx++, nodeToSV(*i));
    }
    return newRV_noinc((SV*) av);
  } else if (e.type == edn::EdnMap) {
    HV *hv = newHV();
    for (auto i = begin(e.values); i != end(e.values); ++i) {
      SV *key = nodeToSV(*i);
      SV *value = nodeToSV(*(++i));
      hv_store_ent(hv, key, value, 0);
    }
    return newRV_noinc((SV*) hv);
  } else {
    throw "Don't understand node type";
  }
}

static SV*
decode_edn(SV *str) {
  SV* sv;
  
  dTHX;
  SvUPGRADE(str, SVt_PV);

  std::string mstr(SvPVX(str), SvCUR(str));
  try {
    EdnNode e = read(mstr);
    sv = nodeToSV(e);
  } catch (const char *foo) {
    std::cerr << foo << std::endl;
  }
  
  return sv;
}


MODULE = edn      PACKAGE = edn

PROTOTYPES: ENABLE
  
  
void read(SV *str)
  PPCODE:
{
  PUTBACK; str = decode_edn(str); SPAGAIN;
  XPUSHs(str);
}


