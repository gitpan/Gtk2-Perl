package Gtk2::ItemFactoryEntry;

# $Id: ItemFactoryEntry.pm,v 1.4 2002/12/16 17:20:28 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: ItemFactoryEntry.pm,v 1.4 2002/12/16 17:20:28 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::_Boxed;
@ISA = qw(Gtk2::_Boxed);

1;
