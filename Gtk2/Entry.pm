package Gtk2::Entry;

# $Id: Entry.pm,v 1.7 2002/11/09 16:23:15 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Entry.pm,v 1.7 2002/11/09 16:23:15 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::Widget;
use Gtk2::Editable;
@ISA = qw(Gtk2::Widget Gtk2::Editable);

use Gtk2::_Helpers;

sub new {
    Gtk2::_Helpers::check_usage(\@_, [], [ 'string text' ]);
    my $entry = shift->_new();
    @_ and $entry->set_text(@_);
    return $entry;
}


1;
