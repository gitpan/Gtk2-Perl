package Gtk2::Gdk::Pixmap;

# $Id: Pixmap.pm,v 1.7 2002/11/27 13:18:16 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Pixmap.pm,v 1.7 2002/11/27 13:18:16 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

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



