package Gtk2::ButtonBox;

# $Id: ButtonBox.pm,v 1.6 2002/11/09 16:23:15 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: ButtonBox.pm,v 1.6 2002/11/09 16:23:15 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::Box;
@ISA = ('Gtk2::Box');

# Button box styles
sub DEFAULT_STYLE { 'default_style' }
sub SPREAD { 'spread' }
sub EDGE { 'edge' }
sub START { 'start' }
sub _END { 'end' }
# GtkButtonBoxStyle;

1;



