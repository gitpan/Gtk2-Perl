package Gtk2::Button;

# $Id: Button.pm,v 1.10 2002/12/16 17:07:59 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Button.pm,v 1.10 2002/12/16 17:07:59 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Bin;
@ISA = qw(Gtk2::Bin);

use Gtk2::_Helpers;
# button probably needs these
use Gtk2::GSignal;
use Gtk2::Label;
use Gtk2::Stock;


sub new {
    Gtk2::_Helpers::check_usage(\@_, [], [ 'string label' ]);
    return @_ > 1 ? shift->new_with_label(@_) : shift->_new;
}

1;
