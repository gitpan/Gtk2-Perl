package Gtk2::VScrollbar;

# $Id: VScrollbar.pm,v 1.4 2003/02/10 11:35:13 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: VScrollbar.pm,v 1.4 2003/02/10 11:35:13 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Scrollbar;
@ISA = qw(Gtk2::Scrollbar);

sub new {
    Gtk2::_Helpers::check_usage(\@_, [], [ 'Gtk2::Adjustment adjustment' ]);
    return @_ > 1 ? shift->_new(@_) : shift->_new(undef);
}

1;

