package Gtk2::IMMultiContext;

# $Id: IMMultiContext.pm,v 1.2 2002/12/16 17:20:25 ggc Exp $a
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: IMMultiContext.pm,v 1.2 2002/12/16 17:20:25 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

#BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::IMContext;
@ISA=qw(Gtk2::IMContext);

1;

