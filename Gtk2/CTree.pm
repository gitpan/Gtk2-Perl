package Gtk2::CTree;

# $Id: CTree.pm,v 1.1 2002/11/11 16:55:44 gthyni Exp $
# Copyright 2002, Marin Purgar
# licensed under Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: CTree.pm,v 1.1 2002/11/11 16:55:44 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

#BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::CList;
@ISA = qw(Gtk2::CList);

1;
