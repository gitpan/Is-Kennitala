package Is::Kennitala;
use strict;

use base qw< Exporter >;

our $VERSION = '0.01';

use List::Util qw< sum >;

our (%EXPORT_TAGS, @EXPORT_OK);

%EXPORT_TAGS = (
	all => [ @EXPORT_OK = qw<
                                valid checksum
                                person company
                                year month day
    > ],
);

=head1 NAME

Is::Kennitala - Validate and process Icelandic identity numbers

=head1 SYNOPSIS

    # Functional interface
    use Is::Kennitala qw< :all >;

    my $kt = '0902862349'; # Yours truly

    if ( valid $kt ) {
        # Extract YYYY-MM-DD
        my $year  = year  $kt;
        my $month = month $kt
        my $day   = day   $kt;

        # ...
    }

    # OO interface that doesn't pollute your namespace
    use Is::Kennitala;

    my $kt = Is::Kennitala->new( '0902862349' );

    if ( $kt->valid and $kt->person ) {
        printf "You are a Real Boy(TM) born on %d-%d-%d\n",
            $kt->year, $kt->month, $kt->day;
    } elsif ( $kt->valid and $kt->comany ) {
        warn "Begone, you spawn of capitalims!";
    } else {
        die "EEEK!";
    }

=head1 DESCRIPTION

A I<kennitala> (Icelandic: I<identity number>) is a 10 digit unique
identity number given to persons and corporations in Iceland. This
module provides an interface for validating these numbers and
extracting information from them.

=cut

use overload '""' => sub { ${ +shift } };

=head1 METHODS & FUNCTIONS

=head2 new

Optional constructor which takes a valid kennitala or a fragment as
its argument. Returns an object that L<stringifies|overload> to
whatever string is provided.

If a fragment is provided functions in this package that need
information from the omitted part (such as L</year>) will not work.

=cut

sub new
{
    my ( $pkg, $kt ) = @_;

    bless \$kt => $pkg;
}

=head2 valid

Takes a 9-10 character kennitala and returns true if its checksum is
valid, false otherwise.

=cut

sub checksum; # pre-declare to duck error
sub valid
{
    my $kt = ref $_[0] ? ${$_[0]} : $_[0];

    my $summed   = substr $kt, 0, 9;
    my $unsummed = substr $kt, 0, 8;
    my $sum = checksum $unsummed;

    $summed eq $unsummed . $sum;
}

=head2 checksum

Takes a the first 8 characters of a kennitala and returns the 9th
checksum digit.

=cut

sub checksum
{
    my $kt = ref $_[0] ? ${$_[0]} : $_[0];
	my @num = unpack q<(A)*>, $kt;

	my $sum =
		sum
			# Day
			3 * $num[0],
			2 * $num[1],
			# Month
			7 * $num[2],
			6 * $num[3],
			# Year
			5 * $num[4],
			4 * $num[5],
			# Serial
			3 * $num[6],
			2 * $num[7];

	(11 - $sum % 11) % 11;
}

=head2 person

Returns true if the kennitala belongs to an individual, false
otherwise.

=cut

sub person
{
    my $kt = ref $_[0] ? ${$_[0]} : $_[0];

    $kt =~ / ^ [0-2] /x;
}

=head2 company

Returns true if the kennitala belongs to a company, false
otherwise.

=cut

sub company
{
    my $kt = ref $_[0] ? ${$_[0]} : $_[0];

    $kt =~ / ^ [3-5] /x
}

=head2 year

Return the four-digit year part of the kennitala. For this function to
work a complete 10-digit number must have been provided.

=cut

sub year
{
    my $kt = ref $_[0] ? ${$_[0]} : $_[0];
    my $yy = substr $kt, 4, 2;
    my $c  = substr $kt, 9, 1;
    ($c == 0 ? 2000 : 1000) + ($c . $yy);
}

=head2 month

Return the two-digit month part of the kennitala.

=cut

sub month
{
    my $kt = ref $_[0] ? ${$_[0]} : $_[0];

    substr $kt, 2, 2;
}

=head2 day

Return the two-digit day part of the kennitala.

=cut

sub day
{
    my $kt = ref $_[0] ? ${$_[0]} : $_[0];

    substr $kt, 0, 2;
}

=head1 CAVEATS

Only supports identity numbers assigned between the years 1800-2099

=head1 BUGS

Please report any bugs that aren't already listed at
L<http://rt.cpan.org/Dist/Display.html?Queue=Is-Kennitala> to
L<http://rt.cpan.org/Public/Bug/Report.html?Queue=Is-Kennitala>

=head1 SEE ALSO

L<http://www.hagstofa.is/?PageID=1474>

=head1 AUTHOR

E<AElig>var ArnfjE<ouml>rE<eth> Bjarmason <avar@cpan.org>

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
