package Gtk2::Adjustment;

# $Id: Adjustment.pm,v 1.5 2002/11/09 16:23:15 gthyni Exp $
# Copyright 2002, G�ran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Adjustment.pm,v 1.5 2002/11/09 16:23:15 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::Object;
@ISA=qw(Gtk2::Object);

sub value
  {
    my ($self, $value) = @_;
    my $v = $self->get_value;
    $self->set_value($value) if defined $value;
    $v;
  }

sub lower
  {
    my ($self, $value) = @_;
    my $v = $self->get_lower;
    $self->set_lower($value) if defined $value;
    $v;
  }

sub upper
  {
    my ($self, $value) = @_;
    my $v = $self->get_upper;
    $self->set_upper($value) if defined $value;
    $v;
  }

sub step_increment
  {
    my ($self, $value) = @_;
    my $v = $self->get_step_increment;
    $self->set_step_increment($value) if defined $value;
    $v;
  }

sub page_increment
  {
    my ($self, $value) = @_;
    my $v = $self->get_page_increment;
    $self->set_page_increment($value) if defined $value;
    $v;
  }

sub page_size
  {
    my ($self, $value) = @_;
    my $v = $self->get_page_size;
    $self->set_page_size($value) if defined $value;
    $v;
  }


1;

