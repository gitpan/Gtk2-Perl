package Gtk2::IMMultiContext;

# $Id: IMMultiContext.pm,v 1.1 2002/11/11 16:55:48 gthyni Exp $a
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: IMMultiContext.pm,v 1.1 2002/11/11 16:55:48 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

#BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::IMContext;
@ISA=qw(Gtk2::IMContext);

1;

