package Gtk2::Gdk::Window;

# $Id: Window.pm,v 1.13 2003/02/19 12:11:21 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Window.pm,v 1.13 2003/02/19 12:11:21 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Gdk::Drawable;
@ISA = qw(Gtk2::Gdk::Drawable);

# enum GdkWindowClass
use constant GDK_INPUT_OUTPUT => 0;
use constant GDK_INPUT_ONLY   => 1;

# enum GdkWindowAttributesType
use constant WA_TITLE	  => 1 << 1;
use constant WA_X	  => 1 << 2;
use constant WA_Y	  => 1 << 3;
use constant WA_CURSOR	  => 1 << 4;
use constant WA_COLORMAP  => 1 << 5;
use constant WA_VISUAL	  => 1 << 6;
use constant WA_WMCLASS   => 1 << 7;
use constant WA_NOREDIR   => 1 << 8;

# Size restriction enumeration.
# enum GdkWindowHints
use constant HINT_POS	      => 1 << 0;
use constant HINT_MIN_SIZE    => 1 << 1;
use constant HINT_MAX_SIZE    => 1 << 2;
use constant HINT_BASE_SIZE   => 1 << 3;
use constant HINT_ASPECT      => 1 << 4;
use constant HINT_RESIZE_INC  => 1 << 5;
use constant HINT_WIN_GRAVITY => 1 << 6;
use constant HINT_USER_POS    => 1 << 7;
use constant HINT_USER_SIZE   => 1 << 8;

#/* Currently, these are the same values numerically as in the
# * X protocol. If you change that, gdkwindow-x11.c/gdk_window_set_geometry_hints() will need fixing.
# enum  GdkGravity
use constant GRAVITY_NORTH_WEST => 1;
use constant GRAVITY_NORTH      => 2;
use constant GRAVITY_NORTH_EAST => 3;
use constant GRAVITY_WEST       => 4;
use constant GRAVITY_CENTER     => 5;
use constant GRAVITY_EAST       => 6;
use constant GRAVITY_SOUTH_WEST => 7;
use constant GRAVITY_SOUTH      => 8;
use constant GRAVITY_SOUTH_EAST => 9;
use constant GRAVITY_STATIC     => 10;

# enum GdkWindowEdge
use constant EDGE_NORTH_WEST => 0;
use constant EDGE_NORTH      => 1;
use constant EDGE_NORTH_EAST => 2;
use constant EDGE_WEST       => 3;
use constant EDGE_EAST       => 4;
use constant EDGE_SOUTH_WEST => 5;
use constant EDGE_SOUTH      => 6;
use constant EDGE_SOUTH_EAST => 7;

sub at_pointer {
    my $values = shift->_at_pointer;
    return wantarray ? @$values : $values;
}

sub new_foreign {
    Gtk2::_Helpers::deprecated('foreign_new', @_);
}

sub get_pointer {
    my $values = shift->_get_pointer;
    return wantarray ? @$values : $values;
}

sub get_geometry {
    my $values = shift->_get_geometry;
    return wantarray ? @$values : $values;
}

sub get_position {
    my $values = shift->_get_position;
    return wantarray ? @$values : $values;
}

sub get_origin {
    my $values = shift->_get_origin;
    return wantarray ? @$values : $values;
}

sub get_root_origin {
    my $values = shift->_get_root_origin;
    return wantarray ? @$values : $values;
}
    
1;



