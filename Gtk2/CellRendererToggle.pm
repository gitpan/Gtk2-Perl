package Gtk2::CellRendererToggle;

# Copyright 2002, Marin Purgar <numessiah@users.sourceforge.net>
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: CellRendererToggle.pm,v 1.2 2002/11/09 16:43:38 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::CellRenderer;
@ISA=qw(Gtk2::CellRenderer);

1;

