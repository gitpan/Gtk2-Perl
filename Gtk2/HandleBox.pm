package Gtk2::HandleBox;

# $Id: HandleBox.pm,v 1.3 2002/12/16 17:17:44 ggc Exp $
# Copyright 2002, G�ran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: HandleBox.pm,v 1.3 2002/12/16 17:17:44 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Bin;
@ISA = qw(Gtk2::Bin);

1;


