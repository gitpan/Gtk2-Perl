package Gtk2::_Object;

# $Id: _Object.pm,v 1.10 2002/11/28 14:24:32 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

# This is internal class which should be parent to
# all classes in Gtk2, gobjects or not.

our $rcsid = '$Id: _Object.pm,v 1.10 2002/11/28 14:24:32 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

use vars qw($loader %loaded);

do 'Gtk2/_loader.pm';

use Gtk2::GType;
use Gtk2::_Helpers;

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
    $class->$func(@_);
  }

1;


