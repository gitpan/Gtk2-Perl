package Gtk2::Menu;

# $Id: Menu.pm,v 1.7 2002/12/16 17:20:51 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Menu.pm,v 1.7 2002/12/16 17:20:51 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::MenuShell;
@ISA=qw(Gtk2::MenuShell);

use Gtk2::MenuItem;
use Gtk2::MenuBar;

1;

