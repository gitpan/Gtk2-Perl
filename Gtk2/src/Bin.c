/* $Id: Bin.c,v 1.4 2003/02/03 10:57:33 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV* gtkperl_bin_get_child(SV *bin)
{
    return gtk2_perl_new_object_nullok(gtk_bin_get_child(SvGtkBin(bin)));
}

