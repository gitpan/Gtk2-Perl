package Gtk2::ProgressBar;

# $Id: ProgressBar.pm,v 1.6 2002/12/16 17:21:24 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: ProgressBar.pm,v 1.6 2002/12/16 17:21:24 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Progress;
@ISA=qw(Gtk2::Progress);


sub text
  {
    my ($self,$text) = @_;
    my $ut = $self->get_text;
    $self->set_text($text) if defined $text;
    $ut;
  }

sub fraction
  {
    my ($self,$frac) = @_;
    my $ut = $self->get_fraction;
    $self->set_fraction($frac) if defined $frac;
    $ut;
  }

sub orientation
  {
    my ($self,$ori) = @_;
    my $ut = $self->get_orientation;
    $self->set_orientation($ori) if defined $ori;
    $ut;
  }


1;


