package Gtk2::ScrolledWindow;

# $Id: ScrolledWindow.pm,v 1.9 2003/02/11 11:41:48 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: ScrolledWindow.pm,v 1.9 2003/02/11 11:41:48 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Bin;
@ISA = qw(Gtk2::Bin);

use Gtk2::Adjustment;

sub new {
    @_ < 2 ? shift->_new(undef, undef) : shift->_new(@_);
}

sub get_policy {
    my $values = shift->_get_policy;
    return wantarray ? @$values : $values;
}

1;


