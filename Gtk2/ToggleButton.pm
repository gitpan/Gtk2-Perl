package Gtk2::ToggleButton;

# $Id: ToggleButton.pm,v 1.10 2003/01/21 15:14:39 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: ToggleButton.pm,v 1.10 2003/01/21 15:14:39 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Button;
@ISA = qw(Gtk2::Button);

sub new {
    my $self = shift;
    @_ ? $self->new_with_label(@_) : $self->_new;
}

sub active {
    my ($self, $flag) = @_;
    my $f = $self->get_active;
    $self->set_active($flag) if @_ == 2;
    $f;
}

sub set_active {
    my ($self, $flag) = @_;
    $flag = 1 if @_ == 1;
    $self->_set_active($flag);
}

1;

