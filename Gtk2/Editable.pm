package Gtk2::Editable;

# $Id: Editable.pm,v 1.9 2002/12/16 17:13:21 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Editable.pm,v 1.9 2002/12/16 17:13:21 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

# NOT a GObject
use Gtk2::_Object;
@ISA = qw(Gtk2::_Object);


sub get_selection_bounds {
    my $b = shift->_get_selection_bounds;
    return wantarray ? @$b : $b;
}

1;
