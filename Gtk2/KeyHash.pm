package Gtk2::KeyHash;

# $Id: KeyHash.pm,v 1.3 2002/12/16 17:20:35 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: KeyHash.pm,v 1.3 2002/12/16 17:20:35 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

#BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Gdk::Keymap;
@ISA=qw(Gtk2::Gdk::Keymap);


1;
