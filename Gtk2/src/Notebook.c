/* $Id: Notebook.c,v 1.7 2002/11/13 22:50:10 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV* gtkperl_notebook_new(char* class)
{
    return gtk2_perl_new_object_from_pointer(gtk_notebook_new(), class);
}

void gtkperl_notebook__append_page(SV *notebook, SV *child, SV *tab_label)
{
    gtk_notebook_append_page(SvGtkNotebook(notebook), SvGtkWidget(child), SvGtkWidget_nullok(tab_label));
}

/* NOT IMPLEMENTED YET
void        gtk_notebook_append_page_menu   (GtkNotebook *notebook,
                                             GtkWidget *child,
                                             GtkWidget *tab_label,
                                             GtkWidget *menu_label);
*/

void gtkperl_notebook_prepend_page(SV *notebook, SV *child, SV *tab_label)
{
    gtk_notebook_prepend_page(SvGtkNotebook(notebook), SvGtkWidget(child), SvGtkWidget(tab_label));
}

/*
void        gtk_notebook_prepend_page_menu  (GtkNotebook *notebook,
                                             GtkWidget *child,
                                             GtkWidget *tab_label,
                                             GtkWidget *menu_label);
*/

void gtkperl_notebook_insert_page(SV *notebook, SV *child, SV *tab_label, int position)
{
    gtk_notebook_insert_page(SvGtkNotebook(notebook), SvGtkWidget(child), SvGtkWidget(tab_label), position);
}

/*
void        gtk_notebook_insert_page_menu   (GtkNotebook *notebook,
                                             GtkWidget *child,
                                             GtkWidget *tab_label,
                                             GtkWidget *menu_label,
                                             gint position);
*/

void gtkperl_notebook_remove_page(SV *notebook, int page_num)
{
    gtk_notebook_remove_page(SvGtkNotebook(notebook), page_num);
}

void gtkperl_notebook_next_page(SV *notebook)
{
    gtk_notebook_next_page(SvGtkNotebook(notebook));
}

void gtkperl_notebook_prev_page(SV *notebook)
{
    gtk_notebook_prev_page(SvGtkNotebook(notebook));
}

/*
void        gtk_notebook_reorder_child      (GtkNotebook *notebook,
                                             GtkWidget *child,
                                             gint position);
*/

void gtkperl_notebook_set_tab_pos(SV* notebook, SV* pos)
{
    gtk_notebook_set_tab_pos(SvGtkNotebook(notebook), SvGtkPositionType(pos));
}

void gtkperl_notebook_set_show_tabs(SV *notebook, int show_tabs)
{
    gtk_notebook_set_show_tabs(SvGtkNotebook(notebook), show_tabs);
}


void gtkperl_notebook_set_show_border(SV *notebook, int show_border)
{
    gtk_notebook_set_show_border(SvGtkNotebook(notebook), show_border);
}

void gtkperl_notebook_set_scrollable(SV *notebook, int scrollable)
{
    gtk_notebook_set_scrollable(SvGtkNotebook(notebook), scrollable);
}

void gtkperl_notebook_popup_enable(SV *notebook)
{
    gtk_notebook_popup_enable(SvGtkNotebook(notebook));
}

void gtkperl_notebook_popup_disable(SV *notebook)
{
    gtk_notebook_popup_disable(SvGtkNotebook(notebook));
}

/*
Deprecated
void        gtk_notebook_set_tab_border     (GtkNotebook *notebook,
                                             guint border_width);
*/

int gtkperl_notebook_get_current_page(SV *notebook)
{
    return gtk_notebook_get_current_page(SvGtkNotebook(notebook));
}

void gtkperl_notebook_set_menu_label_text(SV *notebook, SV* child, gchar* menu_text)
{
    gtk_notebook_set_menu_label_text(SvGtkNotebook(notebook), 
        SvGtkWidget(child), menu_text);
}

void gtkperl_notebook_set_tab_label_packing(SV *notebook, SV* child, 
    int expand, int fill, SV* pack_type)
{
    gtk_notebook_set_tab_label_packing(SvGtkNotebook(notebook), 
        SvGtkWidget(child), expand, fill, SvGtkPackType(pack_type));
}

/* GtkWidget* gtk_notebook_get_nth_page (GtkNotebook *notebook, gint page_num) */
SV* gtkperl_notebook_get_nth_page(SV* notebook, int page_num)
{
    return gtk2_perl_new_object(gtk_notebook_get_nth_page(SvGtkNotebook(notebook), page_num));
}

/* gint gtk_notebook_page_num (GtkNotebook *notebook, GtkWidget *child) */
int gtkperl_notebook_page_num(SV* notebook, SV* child)
{
    return gtk_notebook_page_num(SvGtkNotebook(notebook), SvGtkWidget(child));
}

/*
GtkWidget*  gtk_notebook_get_menu_label     (GtkNotebook *notebook,
                                             GtkWidget *child);
GtkWidget*  gtk_notebook_get_tab_label      (GtkNotebook *notebook,
                                             GtkWidget *child);
void        gtk_notebook_query_tab_label_packing
                                            (GtkNotebook *notebook,
                                             GtkWidget *child,
                                             gboolean *expand,
                                             gboolean *fill,
                                             GtkPackType *pack_type);
void        gtk_notebook_set_homogeneous_tabs
                                            (GtkNotebook *notebook,
                                             gboolean homogeneous);
void        gtk_notebook_set_menu_label     (GtkNotebook *notebook,
                                             GtkWidget *child,
                                             GtkWidget *menu_label);
void        gtk_notebook_set_tab_label      (GtkNotebook *notebook,
                                             GtkWidget *child,
                                             GtkWidget *tab_label);
void        gtk_notebook_set_tab_label_packing
                                            (GtkNotebook *notebook,
                                             GtkWidget *child,
                                             gboolean expand,
                                             gboolean fill,
                                             GtkPackType pack_type);
void        gtk_notebook_set_tab_label_text (GtkNotebook *notebook,
                                             GtkWidget *child,
                                             const gchar *tab_text);
G_CONST_RETURN gchar* gtk_notebook_get_menu_label_text
                                            (GtkNotebook *notebook,
                                             GtkWidget *child);
gboolean    gtk_notebook_get_scrollable     (GtkNotebook *notebook);
*/

void gtkperl_notebook_set_tab_hborder(SV *notebook, int tab_hborder)
{
    gtk_notebook_set_tab_hborder(SvGtkNotebook(notebook), tab_hborder);
}

void gtkperl_notebook_set_tab_vborder(SV *notebook, int tab_vborder)
{
    gtk_notebook_set_tab_vborder(SvGtkNotebook(notebook), tab_vborder);
}

int gtkperl_notebook_get_show_border(SV *notebook)
{
    return gtk_notebook_get_show_border(SvGtkNotebook(notebook));
}

int gtkperl_notebook_get_show_tabs(SV *notebook)
{
    return gtk_notebook_get_show_tabs(SvGtkNotebook(notebook));
}

/*
G_CONST_RETURN gchar* gtk_notebook_get_tab_label_text
                                            (GtkNotebook *notebook,
                                             GtkWidget *child);
*/

SV* gtkperl_notebook_get_tab_pos(SV *notebook)
{
    return newSVGtkPositionType(gtk_notebook_get_tab_pos(SvGtkNotebook(notebook)));
}

void gtkperl_notebook_set_current_page(SV *notebook, int page_num)
{
    gtk_notebook_set_current_page(SvGtkNotebook(notebook), page_num);
}

