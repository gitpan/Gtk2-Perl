package Gtk2::InputDialog;

# $Id: InputDialog.pm,v 1.2 2002/11/09 16:23:15 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: InputDialog.pm,v 1.2 2002/11/09 16:23:15 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::Dialog;
@ISA = qw(Gtk2::Dialog);

sub save_button {
    return (shift->get_children)[0]->get_children->[2]->get_children->[0];
}

sub close_button {
    return (shift->get_children)[0]->get_children->[2]->get_children->[1];
}

1;


