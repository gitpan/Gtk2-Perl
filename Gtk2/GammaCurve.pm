package Gtk2::GammaCurve;

# $Id: GammaCurve.pm,v 1.4 2002/12/16 17:15:16 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: GammaCurve.pm,v 1.4 2002/12/16 17:15:16 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::VBox;
use Gtk2::Curve;
@ISA = qw(Gtk2::VBox Gtk2::Curve);

sub curve {
    return ((shift->get_children)[0]->get_children)[1];
}

1;


