/* $Id: Tooltips.c,v 1.7 2002/10/30 20:30:35 borup Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV* gtkperl_tooltips_new(char* class)
{
    return gtk2_perl_new_object(gtk_tooltips_new());
}

void gtkperl_tooltips_enable(SV *tt)
{
    gtk_tooltips_enable(SvGtkTooltips(tt));
}

void gtkperl_tooltips_disable(SV *tt)
{
    gtk_tooltips_disable(SvGtkTooltips(tt));
}

void gtkperl_tooltips_set_delay(SV* tooltips, int delay)
{
    gtk_tooltips_set_delay(SvGtkTooltips(tooltips), delay);
}

void gtkperl_tooltips__set_tip(SV* tooltips, SV* widget, gchar* text, SV* tip_private)
{
    const gchar * g_tip_private = NULL;
    if (tip_private != &PL_sv_undef)
	g_tip_private = SvPV_nolen(tip_private);
    gtk_tooltips_set_tip(SvGtkTooltips(tooltips), SvGtkWidget(widget), text, g_tip_private);
}


/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
