use strict;

use Test::More tests => 31;

use Is::Kennitala qw< :all >;

for my $d ( 1 .. 31 ) {
    my $kt = Is::Kennitala->new( sprintf q<%02d02862349>, $d );
    cmp_ok $kt->day, '==', $d;
}






