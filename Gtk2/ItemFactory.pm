package Gtk2::ItemFactory;

# $Id: ItemFactory.pm,v 1.10 2002/12/16 17:20:31 ggc Exp $a
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: ItemFactory.pm,v 1.10 2002/12/16 17:20:31 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Object;
@ISA=qw(Gtk2::Object);

sub new
  {
    my $self = shift;
    push @_, undef if @_ < 3;
    no warnings;
    $self->_new(@_);
  }

sub create_item
{
  my ($factory, $entry, $callback_data, $callback_type) = @_;
  my ($path, $accelerator, $callback, $action, $type);

  if (ref($entry) eq 'ARRAY') {
      ($path, $accelerator, $callback, $action, $type) = @$entry;
  } elsif (ref($entry) eq 'HASH') {
      ($path, $accelerator, $callback, $action, $type) = @$entry{qw(path accelerator callback action type)};
  } else {
      die "FATAL: can't guess datatype of entries";
  }

  $factory->_create_item($path, $accelerator || undef, $action || undef, $type || undef, $callback_type || undef);
#  print STDERR "CREATED ITEM: ", join(':', $factory->get_widget($path), @$entry), "\n";
  if ($callback)
    {
      $path =~ s/_//g; # no underscroes here please
      Gtk2::GSignal->connect_menu($factory->get_widget($path), 'activate',
				  $callback, $callback_data, $action);
    }
}

sub create_items_ac
  {
    my ($factory, $entries, $callback_data, $callback_type) = @_;
    for my $entry (@$entries) 
      {
	$factory->create_item($entry, $callback_data, $callback_type);
      }
  }

sub create_items {
  my ($factory, $entries, $callback_data) = @_;
  $factory->create_items_ac($entries, $callback_data, 1);
}

1;

