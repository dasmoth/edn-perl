package edn;

use 5.014002;
use strict;
use warnings;
use Carp;

require Exporter;
use AutoLoader;

our @ISA = qw(Exporter);

our $VERSION = '0.01';

require XSLoader;
XSLoader::load('edn', $VERSION);

1;
__END__

# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

edn - Perl extension for blah blah blah

=head1 SYNOPSIS

  use edn
  blah blah blah

=head1 DESCRIPTION

Stub documentation for edn.

Blah blah blah.

=head2 EXPORT

None by default.


=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Thomas Down <thomas@biodalliance.org>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.14.2 or,
at your option, any later version of Perl 5 you may have available.


=cut
