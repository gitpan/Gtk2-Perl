package Gtk2::TreeViewColumn;

# $Id: TreeViewColumn.pm,v 1.7 2002/11/21 15:34:17 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: TreeViewColumn.pm,v 1.7 2002/11/21 15:34:17 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::Object;
@ISA=qw(Gtk2::Object);

sub TRUE  {1}
sub FALSE {0}

sub new_with_attributes
  {
    my ($class, $title, $cell, @args) = @_;
    my $obj = $class->new;
    $obj->set_title($title || '');
    $obj->pack_start($cell, TRUE);
    while (@args)
      {
	$obj->add_attribute($cell, shift @args, shift @args);
      }
    $obj;
  }


# --- helper functions

# set_fixed_width doesn't allow set strictly the column width..
sub set_minmax_width {
    my ($self, $width) = @_;
    $self->set_min_width($width);
    $self->set_max_width($width);
}

1;

