/* $Id: Scale.c,v 1.4 2002/10/21 11:41:23 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

#include "gtk2-perl.h"

void gtkperl_scale_set_digits(SV* scale, int digits)
{
    gtk_scale_set_digits(SvGtkScale(scale), digits);
}

void gtkperl_scale_set_value_pos(SV* scale, SV* pos)
{
    gtk_scale_set_value_pos(SvGtkScale(scale), SvGtkPositionType(pos));
}

void gtkperl_scale_set_draw_value(SV* scale, int draw_value)
{
    gtk_scale_set_draw_value(SvGtkScale(scale), draw_value != 0);
}

