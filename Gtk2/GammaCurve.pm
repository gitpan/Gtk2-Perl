package Gtk2::GammaCurve;

# $Id: GammaCurve.pm,v 1.3 2002/11/09 16:23:15 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: GammaCurve.pm,v 1.3 2002/11/09 16:23:15 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::VBox;
use Gtk2::Curve;
@ISA = qw(Gtk2::VBox Gtk2::Curve);

sub curve {
    return ((shift->get_children)[0]->get_children)[1];
}

1;


