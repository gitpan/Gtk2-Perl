/* $Id: Fixed.c,v 1.5 2002/12/11 11:50:40 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"


SV* gtkperl_fixed_new(char* class)
{
    return gtk2_perl_new_object(gtk_fixed_new());
}

void gtkperl_fixed_put(SV* fixed, SV* widget, int x, int y)
{
    gtk_fixed_put(SvGtkFixed(fixed), SvGtkWidget(widget), x, y);
}

void gtkperl_fixed_move(SV* fixed, SV* widget, int x, int y)
{
    gtk_fixed_move(SvGtkFixed(fixed), SvGtkWidget(widget), x, y);
}

/* void gtk_fixed_set_has_window (GtkFixed *fixed, gboolean has_window) */
void gtkperl_fixed_set_has_window(SV* fixed, int has_window)
{
    gtk_fixed_set_has_window(SvGtkFixed(fixed), has_window);
}

/* gboolean gtk_fixed_get_has_window (GtkFixed *fixed) */
int gtkperl_fixed_get_has_window(SV* fixed)
{
    return gtk_fixed_get_has_window(SvGtkFixed(fixed));
}
