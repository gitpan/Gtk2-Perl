package Gtk2::Gdk::Event;

# $Id: Event.pm,v 1.13 2003/02/16 11:38:08 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Event.pm,v 1.13 2003/02/16 11:38:08 gthyni Exp $';
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

# enum GdkEventMask
use constant EXPOSURE_MASK		=> 1 << 1;
use constant POINTER_MOTION_MASK	=> 1 << 2;
use constant POINTER_MOTION_HINT_MASK => 1 << 3;
use constant BUTTON_MOTION_MASK	=> 1 << 4;
use constant BUTTON1_MOTION_MASK	=> 1 << 5;
use constant BUTTON2_MOTION_MASK	=> 1 << 6;
use constant BUTTON3_MOTION_MASK	=> 1 << 7;
use constant BUTTON_PRESS_MASK	=> 1 << 8;
use constant BUTTON_RELEASE_MASK	=> 1 << 9;
use constant KEY_PRESS_MASK		=> 1 << 10;
use constant KEY_RELEASE_MASK	=> 1 << 11;
use constant ENTER_NOTIFY_MASK	=> 1 << 12;
use constant LEAVE_NOTIFY_MASK	=> 1 << 13;
use constant FOCUS_CHANGE_MASK	=> 1 << 14;
use constant STRUCTURE_MASK		=> 1 << 15;
use constant PROPERTY_CHANGE_MASK	=> 1 << 16;
use constant VISIBILITY_NOTIFY_MASK	=> 1 << 17;
use constant PROXIMITY_IN_MASK	=> 1 << 18;
use constant PROXIMITY_OUT_MASK	=> 1 << 19;
use constant SUBSTRUCTURE_MASK	=> 1 << 20;
use constant SCROLL_MASK            => 1 << 21;
use constant ALL_EVENTS_MASK	=> 0x3FFFFE;


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




