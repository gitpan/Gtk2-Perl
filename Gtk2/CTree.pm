package Gtk2::CTree;

# $Id: CTree.pm,v 1.2 2002/12/16 17:12:06 ggc Exp $
# Copyright 2002, Marin Purgar
# licensed under Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: CTree.pm,v 1.2 2002/12/16 17:12:06 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

#BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::CList;
@ISA = qw(Gtk2::CList);

1;
