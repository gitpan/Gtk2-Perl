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
# $Id: Pango.pm,v 1.1 2002/11/20 18:06:07 gthyni Exp $
#

package Gtk2::Pango::Pango;

our $rcsid = '$Id: Pango.pm,v 1.1 2002/11/20 18:06:07 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use base qw(Gtk2::_Object);

# These enums aren't reported by the gtype system as enums, strange; we -need- to use numeric values, thus
# PangoStyle
sub STYLE_NORMAL { 0 }
sub STYLE_OBLIQUE { 1 }
sub STYLE_ITALIC { 2 }

# PangoVariant
sub VARIANT_NORMAL { 0 }
sub VARIANT_SMALL_CAPS { 1 }

# PangoWeight
sub WEIGHT_ULTRALIGHT { 200 }
sub WEIGHT_LIGHT { 300 }
sub WEIGHT_NORMAL { 400 }
sub WEIGHT_BOLD { 700 }
sub WEIGHT_ULTRABOLD { 800 }
sub WEIGHT_HEAVY { 900 }

# PangoStretch
sub STRETCH_ULTRA_CONDENSED { 0 }
sub STRETCH_EXTRA_CONDENSED { 1 }
sub STRETCH_CONDENSED { 2 }
sub STRETCH_SEMI_CONDENSED { 3 }
sub STRETCH_NORMAL { 4 }
sub STRETCH_SEMI_EXPANDED { 5 }
sub STRETCH_EXPANDED { 6 }
sub STRETCH_EXTRA_EXPANDED { 7 }
sub STRETCH_ULTRA_EXPANDE { 8 }

# PangoFontMask
sub FONT_MASK_FAMILY  { 1 << 0 }
sub FONT_MASK_STYLE   { 1 << 1 }
sub FONT_MASK_VARIANT { 1 << 2 }
sub FONT_MASK_WEIGHT  { 1 << 3 }
sub FONT_MASK_STRETCH { 1 << 4 }
sub FONT_MASK_SIZE    { 1 << 5 }

1;
