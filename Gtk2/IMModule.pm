package Gtk2::IMModule;

# $Id: IMModule.pm,v 1.2 2002/12/16 17:20:23 ggc Exp $a
# Copyright 2002, G�ran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: IMModule.pm,v 1.2 2002/12/16 17:20:23 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

#BEGIN { do 'Gtk2/_config.pm'; $@ and die }

# not a GObject
use Gtk2::_Object;
@ISA=qw(Gtk2::_Object);


1;

