package Gtk2::SizeGroup;

# $Id: SizeGroup.pm,v 1.1 2002/11/11 19:50:29 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: SizeGroup.pm,v 1.1 2002/11/11 19:50:29 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

#BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::GObject;
@ISA=qw(Gtk2::GObject);

1;
