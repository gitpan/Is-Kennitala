use strict;

use Test::More tests => 1;

use Is::Kennitala;

my $pkg = 'Is::Kennitala';

my $kt = $pkg->new( qw< 0902862349 > );

isa_ok $kt, $pkg;


