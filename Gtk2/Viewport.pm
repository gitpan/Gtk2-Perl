package Gtk2::Viewport;

# $Id: Viewport.pm,v 1.2 2002/11/09 16:23:15 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Viewport.pm,v 1.2 2002/11/09 16:23:15 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

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


