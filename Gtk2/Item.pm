package Gtk2::Item;

# $Id: Item.pm,v 1.7 2002/12/16 17:20:33 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Item.pm,v 1.7 2002/12/16 17:20:33 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }


use Gtk2::Bin;
@ISA=qw(Gtk2::Bin);

1;
