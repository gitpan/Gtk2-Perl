package Gtk2::List;

# $Id: List.pm,v 1.6 2002/12/16 17:20:45 ggc Exp $
# Copyright 2002, Marin Purgar
# licensed under Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: List.pm,v 1.6 2002/12/16 17:20:45 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Container;
@ISA = qw(Gtk2::Container);

1;
