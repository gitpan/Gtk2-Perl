package Gtk2::RadioButton;

# $Id: RadioButton.pm,v 1.7 2002/12/16 17:21:33 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: RadioButton.pm,v 1.7 2002/12/16 17:21:33 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::CheckButton;
@ISA = qw(Gtk2::CheckButton);

use Gtk2::_Helpers;

sub new {
    Gtk2::_Helpers::check_usage(\@_, [ 'Gtk2::GSList group' ], [ 'Gtk2::GSList group', 'string label' ]);
    return @_ > 2 ? shift->new_with_label(@_) : shift->_new(@_);
}


1;

