/* $Id: TreeView.c,v 1.15 2003/01/08 17:03:39 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV* gtkperl_tree_view_new(char* class)
{
    return gtk2_perl_new_object(gtk_tree_view_new());
}

SV* gtkperl_tree_view_new_with_model(char* class, SV* model)
{
    return gtk2_perl_new_object(gtk_tree_view_new_with_model(SvGtkTreeModel(model)));
}

SV* gtkperl_tree_view_get_model(SV* tree_view)
{
    return gtk2_perl_new_object(gtk_tree_view_get_model(SvGtkTreeView(tree_view)));
}

void gtkperl_tree_view_set_model(SV* tree_view, SV* model)
{
    gtk_tree_view_set_model(SvGtkTreeView(tree_view), SvGtkTreeModel(model));
}

void gtkperl_tree_view_set_rules_hint(SV* tree_view, int setting)
{
    gtk_tree_view_set_rules_hint(SvGtkTreeView(tree_view), setting);
}

int gtkperl_tree_view_get_rules_hint(SV* tree_view)
{
   return gtk_tree_view_get_rules_hint(SvGtkTreeView(tree_view));
}

void gtkperl_tree_view_set_headers_visible(SV* tree_view, int setting)
{
    gtk_tree_view_set_headers_visible(SvGtkTreeView(tree_view), setting);
}

int gtkperl_tree_view_get_headers_visible(SV* tree_view)
{
   return gtk_tree_view_get_headers_visible(SvGtkTreeView(tree_view));
}

int gtkperl_tree_view_append_column(SV* tree_view, SV* column)
{
    return gtk_tree_view_append_column(SvGtkTreeView(tree_view),
				       SvGtkTreeViewColumn(column));
}

void gtkperl_tree_view_set_search_column(SV* tree_view, int column)
{
    gtk_tree_view_set_search_column(SvGtkTreeView(tree_view), column);
}

SV* gtkperl_tree_view_get_selection(SV *tree_view)
{
    return gtk2_perl_new_object(gtk_tree_view_get_selection(SvGtkTreeView(tree_view)));
}

void gtkperl_tree_view_set_reorderable(SV* tree_view, int setting)
{
    gtk_tree_view_set_reorderable(SvGtkTreeView(tree_view), setting);
}

int gtkperl_tree_view_get_reorderable(SV* tree_view)
{
   return gtk_tree_view_get_reorderable(SvGtkTreeView(tree_view));
}

void gtkperl_tree_view_set_enable_search(SV* tree_view, int setting)
{
    gtk_tree_view_set_enable_search(SvGtkTreeView(tree_view), setting);
}

int gtkperl_tree_view_get_enable_search(SV* tree_view)
{
   return gtk_tree_view_get_enable_search(SvGtkTreeView(tree_view));
}

/* gboolean gtk_tree_view_expand_row (GtkTreeView *tree_view, GtkTreePath *path, gboolean open_all) */
int gtkperl_tree_view_expand_row(SV* tree_view, SV* path, int open_all)
{
    return gtk_tree_view_expand_row(SvGtkTreeView(tree_view), SvGtkTreePath(path), open_all);
}

/* gboolean gtk_tree_view_collapse_row (GtkTreeView *tree_view, GtkTreePath *path) */
int gtkperl_tree_view_collapse_row(SV* tree_view, SV* path)
{
    return gtk_tree_view_collapse_row(SvGtkTreeView(tree_view), SvGtkTreePath(path));
}

/* void gtk_tree_view_expand_all (GtkTreeView *tree_view) */
void gtkperl_tree_view_expand_all(SV* tree_view)
{
    gtk_tree_view_expand_all(SvGtkTreeView(tree_view));
}

/* void gtk_tree_view_collapse_all (GtkTreeView *tree_view) */
void gtkperl_tree_view_collapse_all(SV* tree_view)
{
    gtk_tree_view_collapse_all(SvGtkTreeView(tree_view));
}

/* void gtk_tree_view_expand_to_path (GtkTreeView *tree_view, GtkTreePath *path) */
void gtkperl_tree_view__expand_to_path(SV* tree_view, SV* path)
{
    gtk_tree_view_expand_to_path(SvGtkTreeView(tree_view), SvGtkTreePath(path));
}

/* gboolean gtk_tree_view_row_expanded (GtkTreeView *tree_view, GtkTreePath *path) */
int gtkperl_tree_view_row_expanded(SV* tree_view, SV* path)
{
    return gtk_tree_view_row_expanded(SvGtkTreeView(tree_view), SvGtkTreePath(path));
}

/* void gtk_tree_view_columns_autosize (GtkTreeView *tree_view) */
void gtkperl_tree_view_columns_autosize(SV* tree_view)
{
    gtk_tree_view_columns_autosize(SvGtkTreeView(tree_view));
}

/* void gtk_tree_view_set_headers_clickable (GtkTreeView *tree_view, gboolean setting) */
void gtkperl_tree_view_set_headers_clickable(SV* tree_view, int setting)
{
    gtk_tree_view_set_headers_clickable(SvGtkTreeView(tree_view), setting);
}

/* gint gtk_tree_view_remove_column (GtkTreeView *tree_view, GtkTreeViewColumn *column) */
int gtkperl_tree_view_remove_column(SV* tree_view, SV* column)
{
    return gtk_tree_view_remove_column(SvGtkTreeView(tree_view), SvGtkTreeViewColumn(column));
}

/* gint gtk_tree_view_insert_column (GtkTreeView *tree_view, GtkTreeViewColumn *column, gint position) */
int gtkperl_tree_view_insert_column(SV* tree_view, SV* column, int position)
{
    return gtk_tree_view_insert_column(SvGtkTreeView(tree_view), SvGtkTreeViewColumn(column), position);
}

/* GtkTreeViewColumn *gtk_tree_view_get_column (GtkTreeView *tree_view, gint n) */
SV* gtkperl_tree_view_get_column(SV* tree_view, int n)
{
    return gtk2_perl_new_object(gtk_tree_view_get_column(SvGtkTreeView(tree_view), n));
}

/* NOT IMPLEMENTED YET 
// Accessors 

GtkAdjustment         *gtk_tree_view_get_hadjustment               (GtkTreeView               *tree_view);
void                   gtk_tree_view_set_hadjustment               (GtkTreeView               *tree_view,
								    GtkAdjustment             *adjustment);
GtkAdjustment         *gtk_tree_view_get_vadjustment               (GtkTreeView               *tree_view);
void                   gtk_tree_view_set_vadjustment               (GtkTreeView               *tree_view,
								    GtkAdjustment             *adjustment);
gint                   gtk_tree_view_insert_column_with_attributes (GtkTreeView               *tree_view,
								    gint                       position,
								    const gchar               *title,
								    GtkCellRenderer           *cell,
								    ...);
gint                   gtk_tree_view_insert_column_with_data_func  (GtkTreeView               *tree_view,
								    gint                       position,
								    const gchar               *title,
								    GtkCellRenderer           *cell,
                                                                    GtkTreeCellDataFunc        func,
                                                                    gpointer                   data,
                                                                    GDestroyNotify             dnotify);
GList                 *gtk_tree_view_get_columns                   (GtkTreeView               *tree_view);
void                   gtk_tree_view_move_column_after             (GtkTreeView               *tree_view,
								    GtkTreeViewColumn         *column,
								    GtkTreeViewColumn         *base_column);
void                   gtk_tree_view_set_expander_column           (GtkTreeView               *tree_view,
								    GtkTreeViewColumn         *column);
GtkTreeViewColumn     *gtk_tree_view_get_expander_column           (GtkTreeView               *tree_view);
void                   gtk_tree_view_set_column_drag_function      (GtkTreeView               *tree_view,
								    GtkTreeViewColumnDropFunc  func,
								    gpointer                   user_data,
								    GtkDestroyNotify           destroy);

void        gtk_tree_view_map_expanded_rows (GtkTreeView *tree_view,
                                             GtkTreeViewMappingFunc func,
                                             gpointer data);
*/

/* void gtk_tree_view_scroll_to_point (GtkTreeView *tree_view, gint tree_x, gint tree_y) */
void gtkperl_tree_view_scroll_to_point(SV* tree_view, int tree_x, int tree_y)
{
    gtk_tree_view_scroll_to_point(SvGtkTreeView(tree_view), tree_x, tree_y);
}

/* void gtk_tree_view_scroll_to_cell (GtkTreeView *tree_view, GtkTreePath *path, GtkTreeViewColumn *column,
                                      gboolean use_align, gfloat row_align, gfloat col_align) */
void gtkperl_tree_view_scroll_to_cell(SV* tree_view, SV* path, SV* column,
				      int use_align, float row_align, float col_align)
{
    gtk_tree_view_scroll_to_cell(SvGtkTreeView(tree_view), SvGtkTreePath_nullok(path), SvGtkTreeViewColumn_nullok(column),
				 use_align, row_align, col_align);
}

/* void gtk_tree_view_row_activated (GtkTreeView *tree_view, GtkTreePath *path, GtkTreeViewColumn *column) */
void gtkperl_tree_view_row_activated(SV* tree_view, SV* path, SV* column)
{
    gtk_tree_view_row_activated(SvGtkTreeView(tree_view), SvGtkTreePath(path), SvGtkTreeViewColumn(column));
}

/* void gtk_tree_view_set_cursor (GtkTreeView *tree_view, GtkTreePath *path, GtkTreeViewColumn *focus_column, gboolean start_editing) */
void gtkperl_tree_view_set_cursor(SV* tree_view, SV* path, SV* focus_column, int start_editing)
{
    gtk_tree_view_set_cursor(SvGtkTreeView(tree_view), SvGtkTreePath(path), SvGtkTreeViewColumn_nullok(focus_column), start_editing);
}

/* void gtk_tree_view_get_cursor (GtkTreeView *tree_view, GtkTreePath **path, GtkTreeViewColumn **focus_column) */
SV* gtkperl_tree_view__get_cursor(SV* tree_view)
{
    AV* values = newAV();
    GtkTreePath* path;
    GtkTreeViewColumn* col;
    gtk_tree_view_get_cursor(SvGtkTreeView(tree_view), &path, &col);
    av_push(values, gtk2_perl_new_object_from_pointer_nullok(path, "Gtk2::TreePath"));
    av_push(values, gtk2_perl_new_object_nullok(col));
    return newRV_noinc((SV*) values);
}

/* gboolean gtk_tree_view_get_path_at_pos (GtkTreeView *tree_view,
                                           gint x, gint y,
                                           GtkTreePath **path, GtkTreeViewColumn **column,
                                           gint *cell_x, gint *cell_y) */
SV* gtkperl_tree_view__get_path_at_pos(SV* tree_view, int x, int y)
{
    int returns;
    GtkTreePath* path = gtk_tree_path_new();
    GtkTreeViewColumn* column = gtk_tree_view_column_new();
    gint cell_x;
    gint cell_y;
    AV* values = newAV();
    returns = gtk_tree_view_get_path_at_pos(SvGtkTreeView(tree_view), x, y, &path, &column, &cell_x, &cell_y);
    av_push(values, newSViv(returns));
    av_push(values, gtk2_perl_new_object_from_pointer_nullok(path,   "Gtk2::TreePath"));
    av_push(values, gtk2_perl_new_object_from_pointer_nullok(column, "Gtk2::TreeViewColumn"));
    av_push(values, newSViv(cell_x));
    av_push(values, newSViv(cell_y));
    return newRV_noinc((SV*) values);
}


/*
// Layout information
GdkWindow             *gtk_tree_view_get_bin_window                (GtkTreeView               *tree_view);
gboolean               gtk_tree_view_get_path_at_pos               (GtkTreeView               *tree_view,
								    gint                       x,
								    gint                       y,
								    GtkTreePath              **path,
								    GtkTreeViewColumn        **column,
								    gint                      *cell_x,
								    gint                      *cell_y);
void                   gtk_tree_view_get_cell_area                 (GtkTreeView               *tree_view,
								    GtkTreePath               *path,
								    GtkTreeViewColumn         *column,
								    GdkRectangle              *rect);
void                   gtk_tree_view_get_background_area           (GtkTreeView               *tree_view,
								    GtkTreePath               *path,
								    GtkTreeViewColumn         *column,
								    GdkRectangle              *rect);
void                   gtk_tree_view_get_visible_rect              (GtkTreeView               *tree_view,
								    GdkRectangle              *visible_rect);
void                   gtk_tree_view_widget_to_tree_coords         (GtkTreeView               *tree_view,
								    gint                       wx,
								    gint                       wy,
								    gint                      *tx,
								    gint                      *ty);
void                   gtk_tree_view_tree_to_widget_coords         (GtkTreeView               *tree_view,
								    gint                       tx,
								    gint                       ty,
								    gint                      *wx,
								    gint                      *wy);

// Drag-and-Drop support 
void                   gtk_tree_view_enable_model_drag_source      (GtkTreeView               *tree_view,
								    GdkModifierType            start_button_mask,
								    const GtkTargetEntry      *targets,
								    gint                       n_targets,
								    GdkDragAction              actions);
void                   gtk_tree_view_enable_model_drag_dest        (GtkTreeView               *tree_view,
								    const GtkTargetEntry      *targets,
								    gint                       n_targets,
								    GdkDragAction              actions);
void                   gtk_tree_view_unset_rows_drag_source        (GtkTreeView               *tree_view);
void                   gtk_tree_view_unset_rows_drag_dest          (GtkTreeView               *tree_view);


// These are useful to implement your own custom stuff.
void                   gtk_tree_view_set_drag_dest_row             (GtkTreeView               *tree_view,
								    GtkTreePath               *path,
								    GtkTreeViewDropPosition    pos);
void                   gtk_tree_view_get_drag_dest_row             (GtkTreeView               *tree_view,
								    GtkTreePath              **path,
								    GtkTreeViewDropPosition   *pos);
gboolean               gtk_tree_view_get_dest_row_at_pos           (GtkTreeView               *tree_view,
								    gint                       drag_x,
								    gint                       drag_y,
								    GtkTreePath              **path,
								    GtkTreeViewDropPosition   *pos);
GdkPixmap             *gtk_tree_view_create_row_drag_icon          (GtkTreeView               *tree_view,
								    GtkTreePath               *path);

// Interactive search 
gint                       gtk_tree_view_get_search_column     (GtkTreeView                *tree_view);

GtkTreeViewSearchEqualFunc gtk_tree_view_get_search_equal_func (GtkTreeView                *tree_view);
void                       gtk_tree_view_set_search_equal_func (GtkTreeView                *tree_view,
								GtkTreeViewSearchEqualFunc  search_equal_func,
								gpointer                    search_user_data,
								GtkDestroyNotify            search_destroy);
*/


/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
