package EDN::Boolean;

use strict;

sub new {
    shift;
    my $v = shift;
    return $v ? $EDN::Boolean::true : $EDN::Boolean::false;
}

sub _new {
    my ($class, $v) = @_;
    bless \$v, $class;
}

use overload fallback => 1,
    '""' => sub {
                   my $self = shift;
                   return $$self ? 'true' : 'false';
                },
    'bool' => sub {
        my $self = shift;
        return $$self;
    };

our $true = EDN::Boolean->_new(1);
our $false = EDN::Boolean->_new(0);

1;
