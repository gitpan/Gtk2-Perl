/* $Id: List.c,v 1.6 2002/11/15 06:26:20 glade-perl Exp $
 * Copyright 2002, Marin Purgar
 * licensed under Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

/* LIST */

GList* SvGList_of_objects(SV* itemarrayref)
{
    GList* list = 0;
    int numitems = av_len((AV *) SvRV(itemarrayref));
    int n;
    GtkObject* item = 0;
    for (n = 0; n <= numitems; n++) {
        item = SvGtkObject(*av_fetch((AV*) SvRV(itemarrayref), n, 0));
        list = g_list_append(list, item);
    }
    return list; 
}

SV* gtkperl_list_new(char* class)
{
    return gtk2_perl_new_object(gtk_list_new());
}

void gtkperl_list_insert_items(SV* list, SV* items, int position)
{
    gtk_list_insert_items(SvGtkList(list), SvGList_of_objects(items), position); 
}

void gtkperl_list_append_items(SV* list, SV* items)
{
    gtk_list_append_items(SvGtkList(list), SvGList_of_objects(items)); 
}

void gtkperl_list_prepend_items(SV* list, SV* items)
{
    gtk_list_prepend_items(SvGtkList(list), SvGList_of_objects(items)); 
}

void gtkperl_list_remove_items(SV* list, SV* items)
{
    gtk_list_remove_items(SvGtkList(list), SvGList_of_objects(items)); 
}

void gtkperl_list_remove_items_no_unref(SV* list, SV* items)
{
    gtk_list_remove_items_no_unref(SvGtkList(list), SvGList_of_objects(items)); 
}

void gtkperl_list_set_selection_mode(SV* list, SV* mode)
{
    gtk_list_set_selection_mode(SvGtkList(list), SvGtkSelectionMode(mode));
}

void gtkperl_clear_items(SV* list, int start, int end)
{
    gtk_list_clear_items(SvGtkList(list), start, end);
}

void gtkperl_list_select_item(SV* list, int item)
{
    gtk_list_select_item(SvGtkList(list), item);
}

void gtkperl_list_unselect_item(SV* list, int item)
{
    gtk_list_unselect_item(SvGtkList(list), item);
}

void gtkperl_list_select_child(SV* list, SV* child)
{
    gtk_list_select_child(SvGtkList(list), SvGtkWidget(child));
}

void gtkperl_list_unselect_child(SV* list, SV* child)
{
    gtk_list_unselect_child(SvGtkList(list), SvGtkWidget(child));
}

int gtkperl_list_child_position(SV* list, SV* child)
{
    return gtk_list_child_position(SvGtkList(list), SvGtkWidget(child));
}

void gtkperl_list_start_selection(SV* list) {gtk_list_start_selection(SvGtkList(list));}
void gtkperl_list_end_selection(SV* list)   {gtk_list_end_selection(SvGtkList(list));}
void gtkperl_list_select_all(SV* list)      {gtk_list_select_all(SvGtkList(list));}
void gtkperl_list_unselect_all(SV* list)    {gtk_list_unselect_all(SvGtkList(list));}
void gtkperl_list_toggle_add_mode(SV* list) {gtk_list_toggle_add_mode(SvGtkList(list));}
void gtkperl_list_toggle_focus_row(SV* list){gtk_list_toggle_focus_row(SvGtkList(list));}
void gtkperl_list_undo_selection(SV* list)  {gtk_list_undo_selection(SvGtkList(list));}
void gtkperl_list_end_drag_selection(SV* list)   {gtk_list_end_drag_selection(SvGtkList(list));}

void gtkperl_list_toggle_row(SV* list, SV* item)      
{
    gtk_list_toggle_row(SvGtkList(list), SvGtkWidget(item));
}

/*
  void        gtk_list_extend_selection       (GtkList *list,
                                               GtkScrollType scroll_type,
                                               gfloat position,
                                               gboolean auto_start_selection);
  void        gtk_list_scroll_horizontal      (GtkList *list,
                                               GtkScrollType scroll_type,
                                               gfloat position);
  void        gtk_list_scroll_vertical        (GtkList *list,
                                               GtkScrollType scroll_type,
                                               gfloat position);
*/
