package Gtk2::Gdk::Event::Expose;

# $Id: Expose.pm,v 1.4 2002/11/12 22:32:10 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Expose.pm,v 1.4 2002/11/12 22:32:10 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::Gdk::Event;
@ISA=qw(Gtk2::Gdk::Event);

sub area
  {
    use Gtk2::Gdk::Rectangle;
    $_[0]->_area;
  }

1;



