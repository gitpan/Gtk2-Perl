package Gtk2::Label;

# $Id: Label.pm,v 1.8 2002/11/20 19:54:48 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Label.pm,v 1.8 2002/11/20 19:54:48 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }


use Gtk2::Misc;
@ISA = qw(Gtk2::Misc);

# Allows calling it without any text argument
sub new {
    my ($self, $text) = @_;
    $self->_new($text || '');
}

sub set
  {
    my ($self, $text) = @_;
    $self->set_text($text);
  }

sub get_selection_bounds {
    my $values = shift->_get_selection_bounds();
    return wantarray ? @$values : $values;
}

sub get_layout_offsets {
    my $values = shift->_get_layout_offsets();
    return wantarray ? @$values : $values;
}

1;


