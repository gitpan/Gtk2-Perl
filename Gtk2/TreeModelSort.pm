package Gtk2::TreeModelSort;

# Copyright 2002, Marin Purgar <numessiah@users.sourceforge.net>
# licensed under Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: TreeModelSort.pm,v 1.3 2002/12/16 17:23:19 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

#BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::GObject;
@ISA=qw(Gtk2::GObject);

1;
