package Gtk2::Image;

# $Id: Image.pm,v 1.7 2002/12/06 20:44:36 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Image.pm,v 1.7 2002/12/06 20:44:36 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::Misc;
@ISA=qw(Gtk2::Misc);

use Gtk2::Gdk::Pixmap;

sub get_pixmap {
    my $values = shift->_get_pixmap;
    return wantarray ? @$values : $values;
}

sub get_stock {
    my $values = shift->_get_stock;
    return wantarray ? @$values : $values;
}

1;

