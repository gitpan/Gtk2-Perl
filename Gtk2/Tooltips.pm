package Gtk2::Tooltips;

# $Id: Tooltips.pm,v 1.6 2002/11/09 16:23:15 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Tooltips.pm,v 1.6 2002/11/09 16:23:15 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::Object;
@ISA=qw(Gtk2::Object);

use Gtk2::_Helpers;

sub set_tip {
    Gtk2::_Helpers::check_usage(\@_, [ 'Gtk2::Widget widget', 'string tip_text' ],
				     [ 'Gtk2::Widget widget', 'string tip_text', 'string tip_private' ]);
    my ($self, $widget, $text, $private) = @_;
    $self->_set_tip($widget, $text, $private || undef);
}


1;
