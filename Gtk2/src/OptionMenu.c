/* $Id: OptionMenu.c,v 1.7 2002/10/23 09:13:56 gthyni Exp $
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

