package Gtk2::KeyHash;

# $Id: KeyHash.pm,v 1.2 2002/11/11 20:06:33 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: KeyHash.pm,v 1.2 2002/11/11 20:06:33 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

#BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::Gdk::Keymap;
@ISA=qw(Gtk2::Gdk::Keymap);


1;
