package Gtk2::DND;

# $Id: DND.pm,v 1.1 2002/11/11 16:55:45 gthyni Exp $
# Copyright 2002, G�ran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: DND.pm,v 1.1 2002/11/11 16:55:45 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

#BEGIN { do 'Gtk2/_config.pm'; }

# not a GObject
use Gtk2::_Object;
@ISA=qw(Gtk2::_Object);


1;


