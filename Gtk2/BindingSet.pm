package Gtk2::BindingSet;

# $Id: BindingSet.pm,v 1.2 2002/12/16 17:06:53 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: BindingSet.pm,v 1.2 2002/12/16 17:06:53 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

#BEGIN { do 'Gtk2/_config.pm'; $@ and die }

# not a GObject
use Gtk2::_Object;
@ISA=qw(Gtk2::_Object);


1;

