package Gtk2::IconFactory;

# $Id: IconFactory.pm,v 1.2 2002/12/16 17:19:34 ggc Exp $a
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: IconFactory.pm,v 1.2 2002/12/16 17:19:34 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

#BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::GObject;
@ISA=qw(Gtk2::GObject);


1;

