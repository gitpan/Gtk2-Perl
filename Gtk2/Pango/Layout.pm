package Gtk2::Pango::Layout;

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
# $Id: Layout.pm,v 1.5 2002/11/14 21:31:56 gthyni Exp $
#

our $rcsid = '$Id: Layout.pm,v 1.5 2002/11/14 21:31:56 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::GObject;
@ISA = qw(Gtk2::GObject);

sub get_size {
    my $s = shift->_get_size();
    return wantarray ? @$s : $s;
}

sub get_pixel_size {
    my $s = shift->_get_pixel_size();
    return wantarray ? @$s : $s;
}

1;