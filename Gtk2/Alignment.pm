package Gtk2::Alignment;

# $Id: Alignment.pm,v 1.5 2002/11/09 16:23:15 gthyni Exp $
# Copyright 2002, G�ran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Alignment.pm,v 1.5 2002/11/09 16:23:15 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::Bin;
@ISA=qw(Gtk2::Bin);


1;

