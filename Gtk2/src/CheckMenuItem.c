/* $Id: CheckMenuItem.c,v 1.4 2002/11/04 01:13:03 glade-perl Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"



SV*  gtkperl_check_menu_item_new(char* class)
{
    return gtk2_perl_new_object_from_pointer(gtk_check_menu_item_new(), class);
}

SV*  gtkperl_check_menu_item_new_with_label(char* class, gchar* label)
{
    return gtk2_perl_new_object_from_pointer(gtk_check_menu_item_new_with_label(label), class);
}

SV*  gtkperl_check_menu_item_new_with_mnemonic(char* class, gchar* label)
{
    return gtk2_perl_new_object_from_pointer(gtk_check_menu_item_new_with_mnemonic(label), class);
}

int gtkperl_check_menu_item_get_active(SV *check_menu_item)
{
    return gtk_check_menu_item_get_active(SvGtkCheckMenuItem(check_menu_item));
}

void gtkperl_check_menu_item_set_active(SV *check_menu_item, int is_active)
{
    gtk_check_menu_item_set_active(SvGtkCheckMenuItem(check_menu_item), is_active);
}

int gtkperl_check_menu_item_get_inconsistent(SV *check_menu_item)
{
    return gtk_check_menu_item_get_inconsistent(SvGtkCheckMenuItem(check_menu_item));
}

void gtkperl_check_menu_item_set_inconsistent(SV* check_menu_item, int val)
{
    gtk_check_menu_item_set_inconsistent(SvGtkCheckMenuItem(check_menu_item), val);
}

void gtkperl_check_menu_item_toggled(SV* check_menu_item)
{
    gtk_check_menu_item_toggled(SvGtkCheckMenuItem(check_menu_item));
}

/*
Deprecated
#define     gtk_check_menu_item_set_state
void        gtk_check_menu_item_set_show_toggle
                                            (GtkCheckMenuItem *menu_item,
                                             gboolean always);
*/

