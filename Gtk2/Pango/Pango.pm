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
# $Id: Pango.pm,v 1.3 2002/12/16 17:55:22 ggc Exp $
#

package Gtk2::Pango::Pango;

our $rcsid = '$Id: Pango.pm,v 1.3 2002/12/16 17:55:22 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use base qw(Gtk2::_Object);

# This enums isn't reported by the gtype system as enum, strange; we -need- to use numeric values, thus
# PangoWeight
sub WEIGHT_ULTRALIGHT { 200 }
sub WEIGHT_LIGHT { 300 }
sub WEIGHT_NORMAL { 400 }
sub WEIGHT_BOLD { 700 }
sub WEIGHT_ULTRABOLD { 800 }
sub WEIGHT_HEAVY { 900 }

1;
