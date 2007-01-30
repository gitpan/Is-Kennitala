use strict;

use Test::More tests => 12;

use Is::Kennitala qw< :all >;

for my $m ( 1 .. 12 ) {
    my $kt = Is::Kennitala->new( sprintf q<09%02d862349>, $m );
    cmp_ok $kt->month, '==', $m;
}






