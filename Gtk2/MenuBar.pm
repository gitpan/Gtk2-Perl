package Gtk2::MenuBar;

# $Id: MenuBar.pm,v 1.3 2002/12/16 17:20:49 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: MenuBar.pm,v 1.3 2002/12/16 17:20:49 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::MenuShell;
@ISA=qw(Gtk2::MenuShell);

1;

