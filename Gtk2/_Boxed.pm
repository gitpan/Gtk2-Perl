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
# This is the mother class for all non-GObject classes, so that we
# can free the associated memory on demand, when we allocated it.
#

package Gtk2::_Boxed;

our $rcsid = '$Id: _Boxed.pm,v 1.1 2002/11/12 16:20:50 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }


1;
