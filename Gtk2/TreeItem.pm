package Gtk2::TreeItem;

# $Id: TreeItem.pm,v 1.3 2002/12/16 17:23:08 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: TreeItem.pm,v 1.3 2002/12/16 17:23:08 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

#BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Item;
@ISA=qw(Gtk2::Item);


1;



