#!/usr/bin/perl

use 5.006;
use strict 'vars', 'refs', 'subs';
use warnings;
use lib '.';

# Copyright 2002, Dermot Musgrove, Göran Thyni
#
# This script is a light weight version of
# compile-widget.pl
#
# This script is released under the same conditions as Perl, that
# is, either of the following:
#
# a) the GNU General Public License as published by the Free
# Software Foundation; either version 1, or (at your option) any
# later version.
#
# b) the Artistic License.
#
# $Id: fast-compile.pl,v 1.14 2002/12/11 12:42:07 gthyni Exp $
#

use Carp;
$Carp::Verbose = 1;
*Carp::croak = sub { print STDERR @_; exit 1 };

my $pwd = `pwd`; 
chop $pwd;
push @INC, $pwd; 

sub compile
{
    my ($dir, $module) = @_;
    if ($module =~ /\.pm$/) {
        my $path = $dir ? "${dir}\/${module}" : $module;
	print STDERR "Compiling ${path} ";
	require "${path}";
	$path =~ s/\.pm\s*//;
	$path =~ s{/}{::}g;
	my $version = $path->VERSION || 'NOT SET!';
	print STDERR "- DONE version $version\n";
    }
}

for my $dir qw(Gtk2 Gtk2/Gdk Gtk2/Gdk/Event Gtk2/Pango Gtk2/Atk)
  {
    opendir(DIR, $dir) || die "can't opendir $dir: $!";
    foreach my $module (sort readdir DIR) {
      next if $module =~ /^_[a-z]/;
      next if $module eq 'Test.pm';
      compile $dir,$module;
    }
    closedir DIR;
  }
compile '','Gtk2.pm';

print "All widgets are compiled\n";
0;
