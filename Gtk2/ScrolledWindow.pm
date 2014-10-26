package Gtk2::ScrolledWindow;

# $Id: ScrolledWindow.pm,v 1.8 2002/12/16 17:21:54 ggc Exp $
# Copyright 2002, G�ran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: ScrolledWindow.pm,v 1.8 2002/12/16 17:21:54 ggc Exp $';
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


