package Gtk2::Viewport;

# $Id: Viewport.pm,v 1.3 2002/12/16 17:23:44 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Viewport.pm,v 1.3 2002/12/16 17:23:44 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Bin;
@ISA = qw(Gtk2::Bin);

use Gtk2::Adjustment;

# now we can use new without adjustments if we don't have an
sub new
  {
    my $class = shift;
    return $class->_new(undef,undef) if scalar @_ < 1;
    $class->_new(@_);
  }

1;


