package Gtk2::OptionMenu;

# $Id: OptionMenu.pm,v 1.6 2002/12/16 17:21:01 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: OptionMenu.pm,v 1.6 2002/12/16 17:21:01 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Button;
@ISA=qw(Gtk2::Button);


1;

