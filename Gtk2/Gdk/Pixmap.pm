package Gtk2::Gdk::Pixmap;

# $Id: Pixmap.pm,v 1.8 2002/12/16 17:24:19 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Pixmap.pm,v 1.8 2002/12/16 17:24:19 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Gdk::Drawable;
@ISA = qw(Gtk2::Gdk::Drawable);

sub create_from_xpm_d
  {
    my ($class, $window, $xparent_color, $data) = @_;
    #$data = join('', @$data) if ref $data;
    my ($map, $mask) = @{$class->_create_from_xpm_d($window, $xparent_color, $data, wantarray)};
    wantarray ? ($map,$mask) : $map;
  }

1;



