/* $Id: VScale.c,v 1.4 2002/10/20 15:53:32 ggc Exp $
 * Copyright 2002, G�ran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

#include "gtk2-perl.h"

SV* gtkperl_vscale_new(char* class, SV* adjustment)
{
    return gtk2_perl_new_object(gtk_vscale_new(SvGtkAdjustment(adjustment)));
}

