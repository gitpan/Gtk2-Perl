package Gtk2::Gdk::Color;

# $Id: Color.pm,v 1.6 2002/11/12 16:20:53 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Color.pm,v 1.6 2002/11/12 16:20:53 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::_Boxed;
@ISA = qw(Gtk2::_Boxed);


sub red
  {
    my ($self, $v) = @_;
    my $ret = $self->get_red;
    $self->set_red($v) if defined $v;
    $ret;
  }

sub blue
  {
    my ($self, $v) = @_;
    my $ret = $self->get_blue;
    $self->set_blue($v) if defined $v;
    $ret;
  }

sub green
  {
    my ($self, $v) = @_;
    my $ret = $self->get_green;
    $self->set_green($v) if defined $v;
    $ret;
  }


1;
