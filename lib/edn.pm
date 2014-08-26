package edn;

use 5.014002;
use strict;
use warnings;
use Carp;
use Scalar::Util qw(looks_like_number);

use EDN::Keyword;
use EDN::Tagged;
use EDN::Boolean;

require Exporter;
use AutoLoader;

our @ISA = qw(Exporter);

our $VERSION = '0.01';

require XSLoader;
XSLoader::load('edn', $VERSION);

sub write {
    my $obj = shift;
    my $type = ref $obj;
    if ($type eq 'HASH') {
        return '{' . join(' ', map {':' . $_ . ' ' . edn::write($obj->{$_})} keys($obj)) . '}';
    } elsif ($type eq 'ARRAY') {
        return '[' . join(' ', map {edn::write($_)} @$obj) . ']';
    } elsif ($type eq '') {
        if (looks_like_number($obj)) {
            return $obj
        } else {
            return '"' . $obj . '"';
        }
    } elsif ($type eq 'EDN::Keyword') {
        return ':' . $$obj;
    } elsif ($type eq 'EDN::Tagged') {
        return '#' . $obj->{'tag'} . edn::write($obj->{'content'});
    } elsif ($type eq 'EDN::Boolean') {
        return '' . $obj;
    } else {
        die "Don't understand $type"
    }
}

1;
__END__

# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

edn - Read and write EDN format

=head1 SYNOPSIS

  use edn;
  $data = edn::read('(:foo "bar" :baz [1 2 3])');

=head1 DESCRIPTION

Stub documentation for edn.

Blah blah blah.

=head1 SEE ALSO

https://github.com/edn-format/edn

=head1 AUTHOR

Thomas Down <thomas@biodalliance.org>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.2 or,
at your option, any later version of Perl 5 you may have available.


=cut
