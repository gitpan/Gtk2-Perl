package Gtk2::MessageDialog;

# $Id: MessageDialog.pm,v 1.3 2003/03/18 00:19:41 muppetman Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: MessageDialog.pm,v 1.3 2003/03/18 00:19:41 muppetman Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Dialog;
@ISA = qw(Gtk2::Dialog);


1;


