package Gtk2::Gdk::Pixmap;

# $Id: Pixmap.pm,v 1.9 2003/03/04 13:33:01 joered Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Pixmap.pm,v 1.9 2003/03/04 13:33:01 joered Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Gdk::Drawable;
@ISA = qw(Gtk2::Gdk::Drawable);

sub create_from_xpm_d
  {
    my ($class, $window, $xparent_color, $data) = @_;
    my ($map, $mask) = @{$class->_create_from_xpm_d($window, $xparent_color, $data, wantarray)};
    wantarray ? ($map,$mask) : $map;
  }

sub create_from_xpm
  {
    my ($class, $window, $xparent_color, $filename) = @_;
    my ($map, $mask) = @{$class->_create_from_xpm($window, $xparent_color, $filename, wantarray)};
    wantarray ? ($map,$mask) : $map;
  }

1;



