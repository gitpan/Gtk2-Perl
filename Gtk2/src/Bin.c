/* $Id: Bin.c,v 1.3 2002/11/03 07:39:36 glade-perl Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV* gtkperl_bin_get_child(SV *bin)
{
    return gtk2_perl_new_object(gtk_bin_get_child(SvGtkBin(bin)));
}

