perl-edn
========

Simple [EDN](https://github.com/edn-format/edn) reader and writer for
Perl.

It uses [edn-cpp](https://github.com/shaunxcode/edn-cpp) under the
hood to do the parsing.

This isn't intended as a definitive EDN library, capable of perfectly
round-tripping any EDN.  Rather, it's a pragmatic solution for turning
common EDN (notably responses from the Datomic REST adapter) into
usable Perl data structures.  In particular, keywords become strings,
maps become Perl hashes, and vectors, lists, and sets all become Perl
arrays.

In the long run,
[Transit](https://github.com/cognitect/transit-format) may be a better
solution for communication between Perl and systems which currently
speak EDN.

Usage
-----

           use edn;
           use Data::Dumper;
           print Dumper(edn::read('{:foo "bar" :baz {:quux [1 2 3 4 "blibble"]}}'))

           $VAR1 = {
            'baz' => {
              'quux' => [
                         1,
                         2,
                         3,
                         4,
                         'blibble'
                        ]
            },
            'foo' => 'bar'
          };

          print(edn::write(foo => "bar", baz => 42, quux => [1, "foo", {a => 105}]})
          {:baz 42 :quux [1 "foo" {:a 105}] :foo "bar"}
