package Gtk2::Gdk::Event::WindowState;

# $Id: WindowState.pm,v 1.2 2002/11/09 16:23:15 gthyni Exp $
# Copyright 2002, G�ran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: WindowState.pm,v 1.2 2002/11/09 16:23:15 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

#BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::Gdk::Event;
@ISA=qw(Gtk2::Gdk::Event);

1;



