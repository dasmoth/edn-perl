#define PERL_NO_GET_CONTEXT

extern "C" {

#include "EXTERN.h"
#include "perl.h"
#include "embed.h"
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
hashKeyToSV(const EdnNode& e) {
  dTHX;

  if (e.type == edn::EdnKeyword) {
    return newSVpvn(e.value.c_str() + 1, e.value.length() - 1);
  } else {
    return newSVpvn(e.value.c_str(), e.value.length());
  }
}

static SV*
nodeToSV(const EdnNode& e) {
  dTHX;

  if (e.type == edn::EdnInt || e.type == edn::EdnFloat) {
    // originally converted to an IV first, but this fails for large ints.
    // Should maybe go back to special-casing small ints at some point.
    return newSVpvn(e.value.c_str(), e.value.length());
  } else if (e.type == edn::EdnNil) {
    // Undef seems the closes Perl concept to nil, but doesn't work
    // as values in maps, so may need rethinking.
    return &PL_sv_undef;
  } else if (e.type == edn::EdnSymbol) {
    return newSVpvn(e.value.c_str(), e.value.length());
  } else if (e.type == edn::EdnKeyword) {
    SV *kw = newSVpvn(e.value.c_str() + 1, e.value.length() - 1);
    SV *ref = newRV_noinc((SV*) kw);
    sv_bless(ref, gv_stashpv("EDN::Keyword", 0));
    return ref;
  } else if (e.type == edn::EdnBool) {
    if (e.value == "true") {
      return get_sv("EDN::Boolean::true", 0);
    } else {
      return get_sv("EDN::Boolean::false", 0);
    }
  } else if (e.type == edn::EdnString) {
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
      SV *key = hashKeyToSV(*i);
      SV *value = nodeToSV(*(++i));
      hv_store_ent(hv, key, value, 0);
    }
    return newRV_noinc((SV*) hv);
  } else if (e.type == edn::EdnTagged) {
    HV *tagged = newHV();
    hv_store_ent(tagged, newSVpvn("tag", 3) , nodeToSV(e.values.front()), 0);
    hv_store_ent(tagged, newSVpvn("content", 7), nodeToSV(e.values.back()), 0);
    SV *ref = newRV_noinc((SV*) tagged);
    sv_bless(ref, gv_stashpv("EDN::Tagged", 0));
    return ref;
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
    croak(foo);
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


