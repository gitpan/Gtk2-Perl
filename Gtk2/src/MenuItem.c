/* $Id: MenuItem.c,v 1.7 2002/11/04 01:13:03 glade-perl Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV* gtkperl_menu_item_new(char* class)
{
    return gtk2_perl_new_object(gtk_menu_item_new());
}

SV* gtkperl_menu_item_new_with_label(char* class, gchar* label)
{
    return gtk2_perl_new_object(gtk_menu_item_new_with_label(label));
}

SV* gtkperl_menu_item_new_with_mnemonic(char* class, gchar* label)
{
    return gtk2_perl_new_object(gtk_menu_item_new_with_mnemonic(label));
}

/* NOT IMPLEMENTED YET
void        gtk_menu_item_set_right_justified(GtkMenuItem *menu_item,gboolean right_justified);
*/

void gtkperl_menu_item_set_submenu(SV *menu_item, SV *submenu)
{
    gtk_menu_item_set_submenu(SvGtkMenuItem(menu_item), SvGtkWidget(submenu));
}

void gtkperl_menu_item_activate(SV *menu_item)
{
    gtk_menu_item_activate(SvGtkMenuItem(menu_item));
}

/*
void        gtk_menu_item_set_accel_path    (GtkMenuItem *menu_item,
                                             const gchar *accel_path);
void        gtk_menu_item_remove_submenu    (GtkMenuItem *menu_item);
void        gtk_menu_item_select            (GtkMenuItem *menu_item);
void        gtk_menu_item_deselect          (GtkMenuItem *menu_item);
void        gtk_menu_item_toggle_size_request(GtkMenuItem *menu_item,gint *requisition);
void        gtk_menu_item_toggle_size_allocate(GtkMenuItem *menu_item,gint allocation);
#define     gtk_menu_item_right_justify     (menu_item)
gboolean    gtk_menu_item_get_right_justified(GtkMenuItem *menu_item);
GtkWidget*  gtk_menu_item_get_submenu       (GtkMenuItem *menu_item);
*/
