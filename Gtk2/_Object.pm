package Gtk2::_Object;

# $Id: _Object.pm,v 1.12 2003/02/09 20:23:05 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

# This is internal class which should be parent to
# all classes in Gtk2, gobjects or not.

our $rcsid = '$Id: _Object.pm,v 1.12 2003/02/09 20:23:05 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

use strict;
use Carp;
use vars qw($loader %loaded $AUTOLOAD);

use Gtk2::GType;
use Gtk2::_Helpers;

do 'Gtk2/_loader.pm';

use constant TRUE  => 1;
use constant FALSE => 0;

# these is a bootstrap function to load the class

sub backtrace {
    my $s;
    for (my $i = 1; caller($i); $i++) {
	my ($package, $file, $line, $func) = caller($i);
	$s .= "\t$func() called from $file:$line\n";
    }
    $s;
}

sub AUTOLOAD
  {
    return if $AUTOLOAD =~ /::DESTROY$/;
    #print "AUTOLOAD 1: ", join(';', @_), "\n";
    #print "AUTOLOAD 2: $AUTOLOAD\n";
    my $class = shift;
    die "Is gtk2-perl missing $AUTOLOAD ?\nCall trace:\n".backtrace() if ref $class || $loaded{$class};
    $loaded{$class} = 1;
    #print "dynamically loading $class...\n";
    eval "use $class";
    die $@ if $@;
    my $func = (split /::/, $AUTOLOAD)[-1];
    my $rc = eval { $class->$func(@_) };
    if ( $@ ) {
	my $exc = $@;
	$exc =~ s/\s+at\s+.*?line\s+\d+\.\n$//;
	croak $exc;
    }
    return $rc;
  }

1;


