/* $Id: CList.c,v 1.2 2002/11/15 04:13:58 glade-perl Exp $
 * Copyright 2002, Dermot Musgrove <dermot.musgrove@virgin.net>
 * licensed under Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

/* CLIST */

SV* gtkperl_clist_new(char* class, int columns)
{
    return gtk2_perl_new_object(gtk_clist_new(columns));
}

/*
  GtkWidget*  gtk_clist_new_with_titles       (gint columns,
                                               gchar *titles[]);
*/
void gtkperl_clist_set_shadow_type(SV* clist, SV* type)
{
    gtk_clist_set_shadow_type(SvGtkCList(clist), SvGtkShadowType(type));
} 

void gtkperl_clist_set_selection_mode(SV* clist, SV* mode)
{
    gtk_clist_set_selection_mode(SvGtkCList(clist), SvGtkSelectionMode(mode));
} 

void gtkperl_clist_column_titles_show(SV* clist)
{
    gtk_clist_column_titles_show(SvGtkCList(clist));
} 

void gtkperl_clist_column_titles_hide(SV* clist)
{
    gtk_clist_column_titles_hide(SvGtkCList(clist));
} 

void gtkperl_clist_freeze(SV* clist)
{
    gtk_clist_freeze(SvGtkCList(clist));
} 

void gtkperl_clist_thaw(SV* clist)
{
    gtk_clist_thaw(SvGtkCList(clist));
} 

void gtkperl_clist_set_column_title(SV* clist, int column, gchar* title)
{
    gtk_clist_set_column_title(SvGtkCList(clist), column, title);
} 

void gtkperl_clist_set_column_widget(SV* clist, int column, SV* widget)
{
    gtk_clist_set_column_widget(SvGtkCList(clist), column, SvGtkWidget(widget));
} 

void gtkperl_clist_column_title_active(SV* clist, int column)
{
    gtk_clist_column_title_active(SvGtkCList(clist), column);
} 

void gtkperl_clist_column_title_passive(SV* clist, int column)
{
    gtk_clist_column_title_passive(SvGtkCList(clist), column);
} 

void gtkperl_clist_column_titles_active(SV* clist)
{
    gtk_clist_column_titles_active(SvGtkCList(clist));
} 

void gtkperl_clist_column_titles_passive(SV* clist)
{
    gtk_clist_column_titles_passive(SvGtkCList(clist));
} 

void gtkperl_clist_set_column_justification(SV* clist, int column, SV* justification)
{
    gtk_clist_set_column_justification(SvGtkCList(clist), 
        column, SvGtkJustification(justification));
} 

void gtkperl_clist_set_column_visibility(SV* clist, int column, int visibility)
{
    gtk_clist_set_column_visibility(SvGtkCList(clist), column, visibility);
} 

void gtkperl_clist_set_column_resizeable(SV* clist, int column, int resizeable)
{
    gtk_clist_set_column_resizeable(SvGtkCList(clist), column, resizeable);
} 

void gtkperl_clist_set_column_auto_resize(SV* clist, int column, int auto_resize)
{
    gtk_clist_set_column_auto_resize(SvGtkCList(clist), column, auto_resize);
} 

void gtkperl_clist_optimal_column_width(SV* clist, int column)
{
    gtk_clist_optimal_column_width(SvGtkCList(clist), column);
} 

void gtkperl_clist_set_column_width(SV* clist, int column, int width)
{
    gtk_clist_set_column_width(SvGtkCList(clist), column, width);
} 

void gtkperl_clist_set_column_min_width(SV* clist, int column, int min_width)
{
    gtk_clist_set_column_min_width(SvGtkCList(clist), column, min_width);
} 

void gtkperl_clist_set_column_max_width(SV* clist, int column, int max_width)
{
    gtk_clist_set_column_max_width(SvGtkCList(clist), column, max_width);
} 

void gtkperl_clist_set_row_height(SV* clist, int height)
{
    gtk_clist_set_row_height(SvGtkCList(clist), height);
} 

/*
  void        gtk_clist_moveto                (GtkCList *clist,
                                               gint row,
                                               gint column,
                                               gfloat row_align,
                                               gfloat col_align);
  GtkVisibility gtk_clist_row_is_visible      (GtkCList *clist,
                                               gint row);
*/

/*
  GtkCellType gtk_clist_get_cell_type         (GtkCList *clist,
                                               gint row,
                                               gint column);
*/
SV* gtkperl_clist_get_cell_type(SV* clist, int row, int column)
{
    return newSVGtkCellType(gtk_clist_get_cell_type(SvGtkCList(clist), row, column));
} 

void gtkperl_clist_set_text(SV* clist, int row, int column, gchar* text)
{
    gtk_clist_set_text(SvGtkCList(clist), row, column, text);
} 

/*
  gint        gtk_clist_get_text              (GtkCList *clist,
                                               gint row,
                                               gint column,
                                               gchar **text);
  void        gtk_clist_set_pixmap            (GtkCList *clist,
                                               gint row,
                                               gint column,
                                               GdkPixmap *pixmap,
                                               GdkBitmap *mask);
  gint        gtk_clist_get_pixmap            (GtkCList *clist,
                                               gint row,
                                               gint column,
                                               GdkPixmap **pixmap,
                                               GdkBitmap **mask);
  void        gtk_clist_set_pixtext           (GtkCList *clist,
                                               gint row,
                                               gint column,
                                               const gchar *text,
                                               guint8 spacing,
                                               GdkPixmap *pixmap,
                                               GdkBitmap *mask);
  gint        gtk_clist_get_pixtext           (GtkCList *clist,
                                               gint row,
                                               gint column,
                                               gchar **text,
                                               guint8 *spacing,
                                               GdkPixmap **pixmap,
                                               GdkBitmap **mask);
*/
void gtkperl_clist_set_foreground(SV* clist, int row, SV* color)
{
    gtk_clist_set_foreground(SvGtkCList(clist), row, SvGdkColor(color));
} 

void gtkperl_clist_set_background(SV* clist, int row, SV* color)
{
    gtk_clist_set_background(SvGtkCList(clist), row, SvGdkColor(color));
} 

/*
  void        gtk_clist_set_cell_style        (GtkCList *clist,
                                               gint row,
                                               gint column,
                                               GtkStyle *style);
  GtkStyle*   gtk_clist_get_cell_style        (GtkCList *clist,
                                               gint row,
                                               gint column);
  void        gtk_clist_set_row_style         (GtkCList *clist,
                                               gint row,
                                               GtkStyle *style);
  GtkStyle*   gtk_clist_get_row_style         (GtkCList *clist,
                                               gint row);
  void        gtk_clist_set_shift             (GtkCList *clist,
                                               gint row,
                                               gint column,
                                               gint vertical,
                                               gint horizontal);
*/

void gtkperl_clist_set_selectable(SV* clist, int row, int selectable)
{
    gtk_clist_set_selectable(SvGtkCList(clist), row, selectable);
} 

int gtkperl_clist_get_selectable(SV* clist, int row)
{
    return gtk_clist_get_selectable(SvGtkCList(clist), row);
} 
/*
  gint        gtk_clist_prepend               (GtkCList *clist,
                                               gchar *text[]);
  gint        gtk_clist_append                (GtkCList *clist,
                                               gchar *text[]);
  gint        gtk_clist_insert                (GtkCList *clist,
                                               gint row,
                                               gchar *text[]);
  void        gtk_clist_remove                (GtkCList *clist,
                                               gint row);
  void        gtk_clist_set_row_data          (GtkCList *clist,
                                               gint row,
                                               gpointer data);
  void        gtk_clist_set_row_data_full     (GtkCList *clist,
                                               gint row,
                                               gpointer data,
                                               GtkDestroyNotify destroy);
  gpointer    gtk_clist_get_row_data          (GtkCList *clist,
                                               gint row);
  gint        gtk_clist_find_row_from_data    (GtkCList *clist,
                                               gpointer data);
*/

void gtkperl_clist_select_row(SV* clist, int row, int column)
{
    gtk_clist_select_row(SvGtkCList(clist), row, column);
} 

void gtkperl_clist_unselect_row(SV* clist, int row, int column)
{
    gtk_clist_unselect_row(SvGtkCList(clist), row, column);
} 

void gtkperl_clist_undo_selection(SV* clist)
{
    gtk_clist_undo_selection(SvGtkCList(clist));
} 

void gtkperl_clist_clear(SV* clist)
{
    gtk_clist_clear(SvGtkCList(clist));
} 

void gtkperl_clist_select_all(SV* clist)
{
    gtk_clist_select_all(SvGtkCList(clist));
} 

void gtkperl_clist_unselect_all(SV* clist)
{
    gtk_clist_unselect_all(SvGtkCList(clist));
} 

/*
  gint        gtk_clist_get_selection_info    (GtkCList *clist,
                                               gint x,
                                               gint y,
                                               gint *row,
                                               gint *column);
  void        gtk_clist_swap_rows             (GtkCList *clist,
                                               gint row1,
                                               gint row2);
  void        gtk_clist_set_compare_func      (GtkCList *clist,
                                               GtkCListCompareFunc cmp_func);
  void        gtk_clist_set_sort_column       (GtkCList *clist,
                                               gint column);
  void        gtk_clist_set_sort_type         (GtkCList *clist,
                                               GtkSortType sort_type);
*/
void gtkperl_clist_sort(SV* clist)
{
    gtk_clist_sort(SvGtkCList(clist));
} 

void gtkperl_clist_set_auto_sort(SV* clist, int auto_sort)
{
    gtk_clist_set_auto_sort(SvGtkCList(clist), auto_sort);
} 

void gtkperl_columns_autosize(SV* clist)
{
    gtk_clist_columns_autosize(SvGtkCList(clist));
} 
/*
  gchar*      gtk_clist_get_column_title      (GtkCList *clist,
                                               gint column);
  GtkWidget*  gtk_clist_get_column_widget     (GtkCList *clist,
                                               gint column);
  GtkAdjustment* gtk_clist_get_hadjustment    (GtkCList *clist);
  GtkAdjustment* gtk_clist_get_vadjustment    (GtkCList *clist);
  void        gtk_clist_row_move              (GtkCList *clist,
                                               gint source_row,
                                               gint dest_row);
  void        gtk_clist_set_button_actions    (GtkCList *clist,
                                               guint button,
                                               guint8 button_actions);
  void        gtk_clist_set_hadjustment       (GtkCList *clist,
                                               GtkAdjustment *adjustment);
  void        gtk_clist_set_reorderable       (GtkCList *clist,
                                               gboolean reorderable);
  void        gtk_clist_set_use_drag_icons    (GtkCList *clist,
                                               gboolean use_icons);
  void        gtk_clist_set_vadjustment       (GtkCList *clist,
                                               GtkAdjustment *adjustment);
*/
