package Gtk2::GObject;

# $Id: GObject.pm,v 1.20 2002/11/22 18:25:16 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: GObject.pm,v 1.20 2002/11/22 18:25:16 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use base qw(Gtk2::_Object);


sub set_data
  {
    my ($self, $key, $data) = @_;
    #print STDERR "SET: $data\n";
    $self->_set_data($key,$data);
  }

sub get_data
  {
    my ($self, $key) = @_;
    my $ret = $self->_get_data($key);
    #print STDERR "GET: $ret\n";
    $ret;
  }

sub set {
    my $self = shift;
    if (@_ % 2 == 1) {
	print STDERR "WARNING: odd number of parameters given to Gtk2::GObject::set, ignoring last parameter\n";
	pop;
    }
    my %properties = @_;
    while (my ($name, $value) = each %properties) {
	$self->set_property($name, $value);
    }
}

sub get {
    my $self = shift;
    my @values = map { $self->get_property($_) } @_;
    return wantarray ? @values : (@values == 1 ? $values[0] : \@values);
}

sub get_set {
  my ($self, $prop, $arg) = @_;
  my $ret = $self->get_property($prop); 
  $self->set_property($prop, $arg) if defined($arg);
  return $ret;
}


sub list_properties {
    my $properties = shift->_list_properties();
    return wantarray ? @$properties : $properties;
}

sub find_property {
    my ($self, $property_name) = @_;
    foreach ($self->_list_properties()) {
	return $_ if ($_->{name} eq $property_name);
    }
    return undef;
}

use Gtk2::GSignal;

sub signal_connect { Gtk2::GSignal->connect(@_) }
sub signal_connect_swapped { Gtk2::GSignal->connect_swapped(@_) }
sub signal_disconnect { Gtk2::GSignal->disconnect(@_) }
sub signal_stop_emission_by_name { Gtk2::GSignal->stop_emission_by_name(@_) }

1;


