package Gtk2::CellRenderer;

# $Id: CellRenderer.pm,v 1.6 2002/12/16 17:08:48 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: CellRenderer.pm,v 1.6 2002/12/16 17:08:48 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Object;
@ISA=qw(Gtk2::Object);

1;

