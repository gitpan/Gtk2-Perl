package Gtk2::CList;

# $Id: CList.pm,v 1.2 2002/11/15 04:13:57 glade-perl Exp $
# Copyright 2002, Marin Purgar
# licensed under Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: CList.pm,v 1.2 2002/11/15 04:13:57 glade-perl Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::Container;
@ISA = qw(Gtk2::Container);

1;
