/* $Id: OptionMenu.c,v 1.8 2003/01/17 18:46:01 dlacroix Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

#include "gtk2-perl.h"

int gtkperl_option_menu_get_type(char* class)
{
    return GTK_TYPE_OPTION_MENU;
}

SV* gtkperl_option_menu_new(char* class)
{
    return gtk2_perl_new_object(gtk_option_menu_new());
}

void gtkperl_option_menu_set_menu(SV* option_menu, SV* menu)
{
    gtk_option_menu_set_menu(SvGtkOptionMenu(option_menu), SvGtkWidget(menu));
}

void gtkperl_option_menu_set_history(SV *option_menu, int index)
{
    gtk_option_menu_set_history(SvGtkOptionMenu(option_menu), index);
}

int gtkperl_option_menu_get_history(SV *option_menu)
{
    return gtk_option_menu_get_history(SvGtkOptionMenu(option_menu));
}

