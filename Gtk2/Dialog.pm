package Gtk2::Dialog;

# $Id: Dialog.pm,v 1.6 2002/11/12 20:29:23 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Dialog.pm,v 1.6 2002/11/12 20:29:23 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::Window;
@ISA = qw(Gtk2::Window);

sub vbox
  {
    use Gtk2::VBox;
    shift->_vbox(@_);
  }

1;


