package Gtk2::CellRendererPixbuf;

# $Id: CellRendererPixbuf.pm,v 1.3 2002/12/16 17:08:40 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: CellRendererPixbuf.pm,v 1.3 2002/12/16 17:08:40 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }

use Gtk2::CellRenderer;
@ISA=qw(Gtk2::CellRenderer);

sub pixbuf { shift->get_set('pixbuf', @_) }
sub pixbuf_expander_open { shift->get_set('pixbuf_expander_open', @_) }
sub pixbuf_expander_closed { shift->get_set('pixbuf_expander_closed', @_) }

1;

