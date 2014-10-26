package Gtk2::Button;

# $Id: Button.pm,v 1.9 2002/11/12 20:29:23 gthyni Exp $
# Copyright 2002, G�ran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Button.pm,v 1.9 2002/11/12 20:29:23 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

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
