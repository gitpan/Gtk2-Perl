/* $Id: VScrollbar.c,v 1.5 2003/02/11 13:19:37 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV* gtkperl_vscrollbar__new(char* class, SV* adjustment)
{
    return gtk2_perl_new_object(gtk_vscrollbar_new(SvGtkAdjustment_nullok(adjustment)));
}



