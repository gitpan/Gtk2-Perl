package Gtk2::HSeparator;

# $Id: HSeparator.pm,v 1.6 2002/12/16 17:19:10 ggc Exp $
# Copyright 2002, G�ran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: HSeparator.pm,v 1.6 2002/12/16 17:19:10 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }


use Gtk2::Separator;
@ISA=qw(Gtk2::Separator);


1;


