package Gtk2::Gdk::Drawable;

#
# Copyright (c) 2002 Guillaume Cottenceau (gc at mandrakesoft dot com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU Library General Public License
# version 2, as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#
# $Id: Drawable.pm,v 1.8 2002/11/14 21:31:56 gthyni Exp $
#


our $rcsid = '$Id: Drawable.pm,v 1.8 2002/11/14 21:31:56 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::GObject;
@ISA=qw(Gtk2::GObject);
use Gtk2::_Helpers;

sub get_size {
    my ($o) = @_;
    my $s = $o->_get_size();
    return wantarray ? @$s : $s;
}

sub draw_polygon {
    my ($drawable, $gc, $filled, $points, @rest) = @_;
    if (ref($points) eq 'ARRAY') {
	$drawable->_draw_polygon($gc, $filled, $points);
    } else {
	$drawable->_draw_polygon($gc, $filled, [ $points, @rest ]);
    }
}

sub draw_points {
    my ($drawable, $gc, $points, @rest) = @_;
    if (ref($points) eq 'ARRAY') {
	$drawable->_draw_points($gc, $points);
    } else {
	$drawable->_draw_points($gc, [ $points, @rest ]);
    }
}

sub draw_segments {
    my ($drawable, $gc, $segs, @rest) = @_;
    if (ref($segs) eq 'ARRAY') {
	$drawable->_draw_segments($gc, $segs);
    } else {
	$drawable->_draw_segments($gc, [ $segs, @rest ]);
    }
}

sub draw_lines {
    my ($drawable, $gc, $points, @rest) = @_;
    if (ref($points) eq 'ARRAY') {
	$drawable->_draw_lines($gc, $points);
    } else {
	$drawable->_draw_lines($gc, [ $points, @rest ]);
    }
}

sub draw_pixmap {
    Gtk2::_Helpers::deprecated('draw_drawable', @_);
}

sub draw_bitmap {
    Gtk2::_Helpers::deprecated('draw_drawable', @_);
}

1;



