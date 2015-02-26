package EDN::Literal;

use strict;

sub new {
    my ($class, $k) = @_;
    bless \$k, $class;
}

1;
