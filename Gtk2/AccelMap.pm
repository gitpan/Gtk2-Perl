package Gtk2::AccelMap;

# $Id: AccelMap.pm,v 1.1 2002/11/11 16:55:43 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: AccelMap.pm,v 1.1 2002/11/11 16:55:43 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

#BEGIN { do 'Gtk2/_config.pm'; }


use Gtk2::AccelGroup;

# not a GObject
use Gtk2::_Object;
@ISA=qw(Gtk2::_Object);


1;


