package Gtk2::Container;

# $Id: Container.pm,v 1.10 2002/12/16 17:11:33 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Container.pm,v 1.10 2002/12/16 17:11:33 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Widget;
@ISA = qw(Gtk2::Widget);

use Gtk2::_Helpers;

sub border_width {
    Gtk2::_Helpers::deprecated('set_border_width', @_);
}

sub get_children {
    my $s = shift->_get_children;
    return wantarray ? @$s : $s;
}

1;
