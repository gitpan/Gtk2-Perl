package Gtk2::FileSelection;

# $Id: FileSelection.pm,v 1.6 2002/11/12 20:29:23 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: FileSelection.pm,v 1.6 2002/11/12 20:29:23 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::Dialog;
@ISA=qw(Gtk2::Dialog);

# PASSTHRU function

 sub ok_button
  {
    use Gtk2::Button;
    shift->_ok_button(@_);
  }

  sub cancel_button
  {
    use Gtk2::Button;
    shift->_cancel_button(@_);
  }

1;


