package Gtk2::Combo;

# $Id: Combo.pm,v 1.3 2002/11/21 16:12:14 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Combo.pm,v 1.3 2002/11/21 16:12:14 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::HBox;
@ISA = qw(Gtk2::HBox);


sub set_popdown_strings {
    my ($self, $val, @rest) = @_;
    if (ref($val) eq 'ARRAY') {
	$self->_set_popdown_strings($val);
    } else {
	$self->_set_popdown_strings([ $val, @rest ]);
    }
}

1;


