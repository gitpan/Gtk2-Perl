package Gtk2::GType;

# $Id: GType.pm,v 1.6 2002/12/16 17:17:24 ggc Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: GType.pm,v 1.6 2002/12/16 17:17:24 ggc Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;

BEGIN { do 'Gtk2/_config.pm'; $@ and die }


sub FUNDAMENTAL_SHIFT	{2}
sub MAKE_FUNDAMENTAL { my $n = shift; $n << FUNDAMENTAL_SHIFT }

# Constant fundamental types, introduced by g_type_init().
sub INVALID	{ MAKE_FUNDAMENTAL(0) }
sub NONE	{ MAKE_FUNDAMENTAL(1) }
sub INTERFACE	{ MAKE_FUNDAMENTAL(2) }
sub CHAR	{ MAKE_FUNDAMENTAL(3) }
sub UCHAR	{ MAKE_FUNDAMENTAL(4) }
sub BOOLEAN	{ MAKE_FUNDAMENTAL(5) }
sub INT		{ MAKE_FUNDAMENTAL(6) }
sub UINT	{ MAKE_FUNDAMENTAL(7) }
sub LONG	{ MAKE_FUNDAMENTAL(8) }
sub ULONG	{ MAKE_FUNDAMENTAL(9) }
sub INT64	{ MAKE_FUNDAMENTAL(10) }
sub UINT64	{ MAKE_FUNDAMENTAL(11) }
sub ENUM	{ MAKE_FUNDAMENTAL(12) }
sub FLAGS	{ MAKE_FUNDAMENTAL(13) }
sub FLOAT	{ MAKE_FUNDAMENTAL(14) }
sub DOUBLE	{ MAKE_FUNDAMENTAL(15) }
sub STRING	{ MAKE_FUNDAMENTAL(16) }
sub POINTER	{ MAKE_FUNDAMENTAL(17) }
sub BOXED	{ MAKE_FUNDAMENTAL(18) }
sub PARAM	{ MAKE_FUNDAMENTAL(19) }
sub OBJECT	{ MAKE_FUNDAMENTAL(20) }

1;

