package Gtk2::Text;

# $Id: Text.pm,v 1.3 2002/12/16 17:22:48 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Text.pm,v 1.3 2002/12/16 17:22:48 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use base qw(Gtk2::OldEditable);

sub new {
  __PACKAGE__->_new($_[1], $_[2]);
}

sub hadjustment  { shift->get_set('hadjustment', @_) }
sub vadjustment  { shift->get_set('vadjustment', @_) }

*hadj = \&hadjustment;
*vadj = \&vadjustment;


1;

