package Gtk2::SelectionData;

# $Id: SelectionData.pm,v 1.6 2002/12/16 17:21:56 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: SelectionData.pm,v 1.6 2002/12/16 17:21:56 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::Gdk::Selection;


sub data
  {
    my ($self) = @_;
    my @atoms = ();
    for (my $i = 0; ; $i++) {
      my $atom = $self->data_atom($i);
      last unless defined $atom;
      push @atoms, $atom;
    }
    return wantarray ? @atoms : [@atoms];
  }

1;



