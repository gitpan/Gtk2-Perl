package Gtk2::OldEditable;

# $Id: OldEditable.pm,v 1.5 2002/12/16 17:21:00 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: OldEditable.pm,v 1.5 2002/12/16 17:21:00 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

#BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use base qw(Gtk2::Widget Gtk2::Editable);


1;
