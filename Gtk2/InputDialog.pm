package Gtk2::InputDialog;

# $Id: InputDialog.pm,v 1.3 2002/12/16 17:20:26 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: InputDialog.pm,v 1.3 2002/12/16 17:20:26 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Dialog;
@ISA = qw(Gtk2::Dialog);

sub save_button {
    return (shift->get_children)[0]->get_children->[2]->get_children->[0];
}

sub close_button {
    return (shift->get_children)[0]->get_children->[2]->get_children->[1];
}

1;


