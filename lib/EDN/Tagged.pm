package EDN::Tagged;

use strict;

sub new {
    my ($class, $tag, $content) = @_;
    bless {tag      => $tag,
           content  => $content}, $class;
}

1;
