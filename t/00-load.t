use strict;

use Test::More tests => 1;

use_ok 'Is::Kennitala';

diag sprintf q<Testing %s v%s, Perl %f, %s>,
	'Is::Kennitala',
	$Is::Kennitala::VERSION,
	$],
	$^X;
