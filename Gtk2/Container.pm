package Gtk2::Container;

# $Id: Container.pm,v 1.8 2002/11/09 16:23:15 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Container.pm,v 1.8 2002/11/09 16:23:15 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::Widget;
@ISA = qw(Gtk2::Widget);

use Gtk2::_Helpers;

sub border_width {
    Gtk2::_Helpers::deprecated('set_border_width', @_);
}

sub get_children {
    my $s = shift->_get_children();
    return wantarray ? @$s : $s;
}

1;
