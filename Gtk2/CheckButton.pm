package Gtk2::CheckButton;

# $Id: CheckButton.pm,v 1.6 2002/11/13 22:28:54 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: CheckButton.pm,v 1.6 2002/11/13 22:28:54 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::ToggleButton;
@ISA=qw(Gtk2::ToggleButton);

sub new {
    Gtk2::_Helpers::check_usage(\@_, [], [ 'string label' ]);
    return @_ > 1 ? shift->new_with_label(@_) : shift->_new;
}

1;

