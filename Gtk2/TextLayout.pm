package Gtk2::TextLayout;

# $Id: TextLayout.pm,v 1.2 2002/11/19 14:37:10 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: TextLayout.pm,v 1.2 2002/11/19 14:37:10 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

#BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::GObject;
@ISA=qw(Gtk2::GObject);


1;

