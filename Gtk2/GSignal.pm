package Gtk2::GSignal;

# $Id: GSignal.pm,v 1.19 2002/12/16 17:16:25 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: GSignal.pm,v 1.19 2002/12/16 17:16:25 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::GClosure;
use Gtk2::Gdk::Event;

# "pass-thru" functions below is there for a reason:
# to make copies all SVs used by signalhandlers so they do not get overwritten
# do not change or remove without understanding how it works!

sub connect {
    my ($class, $target, $name, $callback, $data) = @_;
    $class->_connect($target,$name,$callback,$data);
}

sub connect_swapped {
    my ($class, $target, $name, $callback, $data) = @_;
    $class->_connect_swapped($target,$name,$callback,$data);
}

sub connect_menu {
    my ($class, $target, $name, $callback, $data,$type) = @_;
    #print "CONNECT: $target,$name,$callback,$data,$type\n";
    $class->_connect_menu($target,$name,$callback,$data,$type);
}

1;
