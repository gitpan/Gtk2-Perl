package Gtk2::Text;

# $Id: Text.pm,v 1.2 2002/11/20 19:30:03 gthyni Exp $
# Copyright 2002, G�ran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Text.pm,v 1.2 2002/11/20 19:30:03 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use base qw(Gtk2::OldEditable);

sub new {
  __PACKAGE__->_new($_[1], $_[2]);
}

sub hadjustment  { shift->get_set('hadjustment', @_) }
sub vadjustment  { shift->get_set('vadjustment', @_) }

*hadj = \&hadjustment;
*vadj = \&vadjustment;


1;

