package Gtk2::GLib;

# $Id: GLib.pm,v 1.3 2002/11/20 18:01:32 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: GLib.pm,v 1.3 2002/11/20 18:01:32 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

#@EXPORT=qw(CLAMP);
use base qw (Gtk2::_Object);


sub CLAMP
{
  my ($class, $x, $low, $high) = @_;
  return $high if $x > $high;
  return $low if $x < $low;
  return $x;
}

1;

