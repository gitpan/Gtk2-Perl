package Gtk2::ListStore;

# $Id: ListStore.pm,v 1.10 2002/11/22 14:38:02 ggc Exp $
# Copyright 2002, G�ran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: ListStore.pm,v 1.10 2002/11/22 14:38:02 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; }

use Gtk2::TreeModel;
@ISA = ('Gtk2::TreeModel');

sub new
  {
    my ($class, @more) = @_;
    # for (@more) { print "PTYPE = $_ \n"; }
    my $num = scalar @more;
    return $class->_new(0, []) if $num == 0;
    return $class->_new($num, $more[0]) if ref $more[0];
    return $class->_new($num, [@more]);
  }

# --- helper functions

# Append a new row, set the values, return the TreeIter
sub append_set {
    my ($model, $values) = @_;
    my $iter = Gtk2::TreeIter->new();
    $model->append($iter);
    $model->set($iter, $values);
    return $iter;
}

1;


