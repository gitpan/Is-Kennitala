use strict;

use Test::More tests => 2;

use Is::Kennitala qw< :all >;

is( checksum('0111582699'), 9 );
is( checksum('0902862349'), 4 );







