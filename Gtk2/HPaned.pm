package Gtk2::HPaned;

# $Id: HPaned.pm,v 1.7 2002/12/16 17:18:51 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: HPaned.pm,v 1.7 2002/12/16 17:18:51 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }


use Gtk2::Paned;
@ISA=qw(Gtk2::Paned);


1;



