package Gtk2::AccelGroup;

# $Id: AccelGroup.pm,v 1.4 2003/02/16 11:38:08 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: AccelGroup.pm,v 1.4 2003/02/16 11:38:08 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::GObject;
@ISA=qw(Gtk2::GObject);

#/* --- accel flags --- */
# enum  GtkAccelFlags
use constant VISIBLE => 1 << 0;  # display in GtkAccelLabel?
use constant LOCKED  => 1 << 1;  # is it removable?
use constant MASK    => 0x07;

1;

