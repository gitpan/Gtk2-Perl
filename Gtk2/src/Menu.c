/* $Id: Menu.c,v 1.7 2002/11/05 11:31:23 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

int gtkperl_menu_get_type(char* class)
{
    return GTK_TYPE_MENU;
}

SV* gtkperl_menu_new(char* class)
{
    return gtk2_perl_new_object(gtk_menu_new());
}

/* NOT IMPLENTED YET inside comments
void        gtk_menu_set_screen             (GtkMenu *menu,
                                             GdkScreen *screen);
#define     gtk_menu_append                 (menu,child)
#define     gtk_menu_prepend                (menu,child)
#define     gtk_menu_insert                 (menu,child,pos)
void        gtk_menu_reorder_child          (GtkMenu *menu,
                                             GtkWidget *child,
                                             gint position);
*/

void gtkperl_menu_popup(SV* menu, SV* parent_menu_shell, SV* parent_menu_item, 
			SV* func, SV* data, int button, int activate_time)
{
    
    gtk_menu_popup(SvGtkMenu(menu), 
		   SvIV(parent_menu_shell) ? SvGtkWidget(parent_menu_shell) : NULL,
		   SvIV(parent_menu_item)  ? SvGtkWidget(parent_menu_item)  : NULL, 
		   NULL, // SvIV(func) ? func : NULL, // FIXME, will bomb if used
		   data, 
		   button, activate_time);
}

/*
void        gtk_menu_set_accel_group        (GtkMenu *menu,
                                             GtkAccelGroup *accel_group);
GtkAccelGroup* gtk_menu_get_accel_group     (GtkMenu *menu);
void        gtk_menu_set_accel_path         (GtkMenu *menu,
                                             const gchar *accel_path);
void        gtk_menu_set_title              (GtkMenu *menu,
                                             const gchar *title);
gboolean    gtk_menu_get_tearoff_state      (GtkMenu *menu);
G_CONST_RETURN gchar* gtk_menu_get_title    (GtkMenu *menu);

void        gtk_menu_popdown                (GtkMenu *menu);
void        gtk_menu_reposition             (GtkMenu *menu);
GtkWidget*  gtk_menu_get_active             (GtkMenu *menu);
void        gtk_menu_set_active             (GtkMenu *menu,
                                             guint index);
void        gtk_menu_set_tearoff_state      (GtkMenu *menu,
                                             gboolean torn_off);
void        gtk_menu_attach_to_widget       (GtkMenu *menu,
                                             GtkWidget *attach_widget,
                                             GtkMenuDetachFunc detacher);
void        gtk_menu_detach                 (GtkMenu *menu);
GtkWidget*  gtk_menu_get_attach_widget      (GtkMenu *menu);
*/
