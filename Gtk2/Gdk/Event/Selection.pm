package Gtk2::Gdk::Event::Selection;

# $Id: Selection.pm,v 1.4 2002/12/16 17:24:55 ggc Exp $
# Copyright 2002, G�ran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Selection.pm,v 1.4 2002/12/16 17:24:55 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Gdk::Event;
@ISA = qw(Gtk2::Gdk::Event);

1;



