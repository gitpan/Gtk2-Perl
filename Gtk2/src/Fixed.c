/* $Id: Fixed.c,v 1.4 2002/10/20 15:53:32 ggc Exp $
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


/*
void gtkperl_fixed_append(SV* menu_shell, SV* child)
  {
    gtk_fixed_append(SvGtkMenuShell(menu_shell), SvGtkWidget(child));
  }
*/


