package Gtk2::Gdk::Event::Button;

# $Id: Button.pm,v 1.3 2002/12/16 17:24:49 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Button.pm,v 1.3 2002/12/16 17:24:49 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Gdk::Event;
@ISA=qw(Gtk2::Gdk::Event);

1;



