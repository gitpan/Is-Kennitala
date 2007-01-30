=head1 NAME

Makefile.PL - L<Module::Install> based build system

=cut

use strict;

use inc::Module::Install;

name 'Is-Kennitala';

author 'Ævar Arnfjörð Bjarmason <avar@cpan.org>';
license 'perl';

abstract_from 'Kennitala.pm';
version_from  'Kennitala.pm';

requires 'List::Util' => 0;

auto_install;

WriteAll;
