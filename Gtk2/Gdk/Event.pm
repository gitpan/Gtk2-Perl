package Gtk2::Gdk::Event;

# $Id: Event.pm,v 1.12 2002/12/16 17:24:12 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Event.pm,v 1.12 2002/12/16 17:24:12 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Gdk;

use Gtk2::Gdk::Event::Button;
use Gtk2::Gdk::Event::Client;
use Gtk2::Gdk::Event::Configure;
use Gtk2::Gdk::Event::Crossing;
use Gtk2::Gdk::Event::DND;
use Gtk2::Gdk::Event::Expose;
use Gtk2::Gdk::Event::Focus;
use Gtk2::Gdk::Event::Key;
use Gtk2::Gdk::Event::Motion;
use Gtk2::Gdk::Event::NoExpose;
use Gtk2::Gdk::Event::Property;
use Gtk2::Gdk::Event::Proximity;
use Gtk2::Gdk::Event::Scroll;
use Gtk2::Gdk::Event::Selection;
use Gtk2::Gdk::Event::Setting;
use Gtk2::Gdk::Event::WindowState;
use Gtk2::Gdk::Event::Visibility;

sub get_type { shift->type; }

sub get_coords {
    my $values = shift->_get_coords;
    return wantarray ? (defined $values && ref($values) eq 'ARRAY' ? @$values : undef) : $values;
}

sub get_root_coords {
    my $values = shift->_get_root_coords;
    return wantarray ? (defined $values && ref($values) eq 'ARRAY' ? @$values : undef) : $values;
}

1;

__END__




