package Gtk2::TreeSelection;

# Copyright 2002, Marin Purgar <numessiah@users.sourceforge.net>
# licensed under Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: TreeSelection.pm,v 1.6 2002/11/21 21:15:55 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::GObject;
@ISA=qw(Gtk2::GObject);

sub get_selected {
    my ($o) = @_;
    my $s = $o->_get_selected();
    return @$s if wantarray;
    return @$s ? $s : undef;
}

# returns (model, row0..rowN)
sub get_selected_rows {
  die "Gtk2::TreeSelection::get_selected_rows not available in gtk+ versions < 2.1.0"
    unless Gtk2->CHECK_VERSION(2,1,0);
  my ($o) = @_;
  my $s = $o->_get_selected_rows();
  return(@$s);
}

1;
