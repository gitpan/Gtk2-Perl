package Gtk2::ToggleButton;

# $Id: ToggleButton.pm,v 1.7 2002/11/28 13:40:14 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: ToggleButton.pm,v 1.7 2002/11/28 13:40:14 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::Button;
@ISA=qw(Gtk2::Button);

sub new
  {
    my $self = shift;
    scalar @_ ? $self->new_with_label(@_) : $self->_new;
  }

sub active
  {
    my ($self, $flag) = @_;
    my $f = $self->get_active;
    $self->set_active($flag) if defined $flag;
    $f;
  }

sub set_active {
  my ($self, $flag) = @_;
  $flag = TRUE unless defined $flag;
  $self->_set_active($flag);
}

1;

