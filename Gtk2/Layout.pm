package Gtk2::Layout;

# $Id: Layout.pm,v 1.4 2002/12/16 17:20:39 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Layout.pm,v 1.4 2002/12/16 17:20:39 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Container;
@ISA = qw(Gtk2::Container);

use Gtk2::Adjustment;

# now we can use new without adjustments if we don't have an
sub new
  {
    my $class = shift;
    return $class->_new(undef,undef) if scalar @_ < 1;
    $class->_new(@_);
  }

sub freeze {
    Gtk2::_Helpers::deprecated('freeze', @_);
}

sub thaw {
    Gtk2::_Helpers::deprecated('thaw', @_);
}

sub get_size {
    my $s = shift->_get_size;
    return wantarray ? @$s : $s;
}

1;


