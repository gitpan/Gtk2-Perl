/* $Id: ItemFactory.c,v 1.10 2003/02/03 11:00:17 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV* gtkperl_item_factory__new(char* class, int container_type, gchar* path, SV* accel_group)
{
    GtkAccelGroup* ag = SvIV(accel_group) ? SvGtkAccelGroup(accel_group) : NULL;
    return
	gtk2_perl_new_object_from_pointer(gtk_item_factory_new(container_type, path, ag), 
					  class);
}

/* NOT IMPLEMENTED YET
void        gtk_item_factory_construct      (GtkItemFactory *ifactory,
                                             GtkType container_type,
                                             const gchar *path,
                                             GtkAccelGroup *accel_group);
void        gtk_item_factory_add_foreign    (GtkWidget *accel_widget,
                                             const gchar *full_path,
                                             GtkAccelGroup *accel_group,
                                             guint keyval,
                                             GdkModifierType modifiers);
GtkItemFactory* gtk_item_factory_from_widget
                                            (GtkWidget *widget);
G_CONST_RETURN gchar* gtk_item_factory_path_from_widget
                                            (GtkWidget *widget);
GtkWidget*  gtk_item_factory_get_item       (GtkItemFactory *ifactory,
                                             const gchar *path);
*/

SV* gtkperl_item_factory_get_widget(SV *ifactory, gchar *path)
{
    return gtk2_perl_new_object_nullok(gtk_item_factory_get_widget(SvGtkItemFactory(ifactory), path));
}

/*
GtkWidget*  gtk_item_factory_get_widget_by_action
                                            (GtkItemFactory *ifactory,
                                             guint action);
GtkWidget*  gtk_item_factory_get_item_by_action
                                            (GtkItemFactory *ifactory,
                                             guint action);
*/

/*  create_item(s|s_ac)? if mangled in perl before calling this one */
void gtkperl_item_factory__create_item(SV *ifactory,
				       gchar* path, SV* accelerator, 
				       SV* action, SV* type,
				       SV* callback_type)
{
    GtkItemFactoryEntry* e = g_malloc0(sizeof(GtkItemFactoryEntry));
    e->path = path;
    e->accelerator = (accelerator == &PL_sv_undef) ? NULL : SvPV_nolen(accelerator);
    e->callback = NULL;
    e->callback_action = (action == &PL_sv_undef) ? 0 : SvUV(action);
    e->item_type = (type == &PL_sv_undef) ? NULL : SvPV_nolen(type);
    gtk_item_factory_create_item(SvGtkItemFactory(ifactory), e, 
				 NULL,
				 (callback_type == &PL_sv_undef) ? 1 : SvUV(callback_type));
}

/*
void        gtk_item_factory_delete_item    (GtkItemFactory *ifactory,
                                             const gchar *path);
void        gtk_item_factory_delete_entry   (GtkItemFactory *ifactory,
                                             GtkItemFactoryEntry *entry);
void        gtk_item_factory_delete_entries (GtkItemFactory *ifactory,
                                             guint n_entries,
                                             GtkItemFactoryEntry *entries);
void        gtk_item_factory_popup          (GtkItemFactory *ifactory,
                                             guint x,
                                             guint y,
                                             guint mouse_button,
                                             guint32 time);
void        gtk_item_factory_popup_with_data
                                            (GtkItemFactory *ifactory,
                                             gpointer popup_data,
                                             GtkDestroyNotify destroy,
                                             guint x,
                                             guint y,
                                             guint mouse_button,
                                             guint32 time);
gpointer    gtk_item_factory_popup_data     (GtkItemFactory *ifactory);
gpointer    gtk_item_factory_popup_data_from_widget
                                            (GtkWidget *widget);
GtkItemFactory* gtk_item_factory_from_path  (const gchar *path);
void        gtk_item_factory_create_menu_entries
                                            (guint n_entries,
                                             GtkMenuEntry *entries);
void        gtk_item_factories_path_delete  (const gchar *ifactory_path,
                                             const gchar *path);
void        gtk_item_factory_set_translate_func
                                            (GtkItemFactory *ifactory,
                                             GtkTranslateFunc func,
                                             gpointer data,
                                             GtkDestroyNotify notify);
*/


