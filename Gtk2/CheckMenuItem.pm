package Gtk2::CheckMenuItem;

# $Id: CheckMenuItem.pm,v 1.5 2003/01/21 15:14:39 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: CheckMenuItem.pm,v 1.5 2003/01/21 15:14:39 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::MenuItem;
@ISA=qw(Gtk2::MenuItem);

sub active {
    my ($self, $flag) = @_;
    my $ret = $self->get_active;
    $self->set_active($flag) if @_ == 2;
    $ret;
}

1;

