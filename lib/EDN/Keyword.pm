package EDN::Keyword;

use strict;

sub new {
    my ($class, $k) = @_;
    bless \$k, $class;
}

use overload fallback => 1,
    '""' => sub {
                  my $self = shift;
                  return ':' . $$self;
                };

1;
