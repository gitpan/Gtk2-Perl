/* $Id: Statusbar.c,v 1.6 2002/11/16 07:33:48 glade-perl Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

/* ALL DONE */
SV* gtkperl_statusbar_new(char* class)
{
    return gtk2_perl_new_object(gtk_statusbar_new());
}

int gtkperl_statusbar_get_context_id(SV* statusbar, gchar* context_description)
{
    return  gtk_statusbar_get_context_id(SvGtkStatusbar(statusbar), context_description);
}

int gtkperl_statusbar_push(SV* statusbar, int context_id, gchar* text)
{
    return gtk_statusbar_push(SvGtkStatusbar(statusbar), context_id, text);
}

void gtkperl_statusbar_pop(SV* statusbar, int context_id)
{
    gtk_statusbar_pop(SvGtkStatusbar(statusbar), context_id);
}

void gtkperl_statusbar_remove(SV* statusbar, int context_id, int message_id)
{
    gtk_statusbar_remove(SvGtkStatusbar(statusbar), context_id, message_id);
}

void gtkperl_statusbar_set_has_resize_grip(SV* statusbar, int setting)
{
    gtk_statusbar_set_has_resize_grip(SvGtkStatusbar(statusbar), setting);
}

int gtkperl_statusbar_get_has_resize_grip(SV* statusbar)
{
    return  gtk_statusbar_get_has_resize_grip(SvGtkStatusbar(statusbar));
}

