/* $Id: TreeViewColumn.c,v 1.10 2003/02/03 22:39:19 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV* gtkperl_tree_view_column_new(char* class)
{
    return gtk2_perl_new_object(gtk_tree_view_column_new());
}

//GtkTreeViewColumn* gtk_tree_view_column_new_with_attributes(const gchar *title,GtkCellRenderer *cell,...);
SV* gtkperl_tree_view_column__new_with_attributes(char* class, gchar* title, SV* cell, SV* argv_ref)
{
    int i;
    AV* argv = (AV*) SvRV(argv_ref);
    int len = av_len(argv) + 1;
    GtkTreeViewColumn* retval;

    retval = gtk_tree_view_column_new();

    gtk_tree_view_column_set_title (retval, title);
    gtk_tree_view_column_pack_start (retval, SvGtkCellRenderer(cell), TRUE);

    gtk_tree_view_column_clear_attributes(retval, SvGtkCellRenderer(cell));

    for (i=0; i < len; i += 2) {
        gchar* attribute;
        int column;
        attribute = SvPV_nolen(av_shift(argv));
        column = SvIV(av_shift(argv));
        gtk_tree_view_column_add_attribute(retval, SvGtkCellRenderer(cell), attribute, column);
    }

    return gtk2_perl_new_object(retval);
}


void gtkperl_tree_view_column_pack_start(SV* tree_column, SV* cell, int expand)
{
    gtk_tree_view_column_pack_start(SvGtkTreeViewColumn(tree_column), SvGtkCellRenderer(cell), expand);
}

/* void gtk_tree_view_column_pack_end (GtkTreeViewColumn *tree_column, GtkCellRenderer *cell, gboolean expand) */
void gtkperl_tree_view_column_pack_end(SV* tree_column, SV* cell, int expand)
{
    gtk_tree_view_column_pack_end(SvGtkTreeViewColumn(tree_column), SvGtkCellRenderer(cell), expand);
}

/* void gtk_tree_view_column_clear (GtkTreeViewColumn *tree_column) */
void gtkperl_tree_view_column_clear(SV* tree_column)
{
    gtk_tree_view_column_clear(SvGtkTreeViewColumn(tree_column));
}

/* NOT IMPLEMENTED YET
GList*      gtk_tree_view_column_get_cell_renderers(GtkTreeViewColumn *tree_column);
*/

void gtkperl_tree_view_column_add_attribute(SV* tree_column, SV* cell_renderer, gchar* attribute, int column)
{
     gtk_tree_view_column_add_attribute(SvGtkTreeViewColumn(tree_column), SvGtkCellRenderer(cell_renderer),
					attribute, column);
}

void gtkperl_tree_view_column_set_sort_column_id(SV* tree_column, int sort_column_id)
{
    gtk_tree_view_column_set_sort_column_id(SvGtkTreeViewColumn(tree_column), sort_column_id);
}

/*
void        gtk_tree_view_column_set_attributes
                                            (GtkTreeViewColumn *tree_column,
                                             GtkCellRenderer *cell_renderer,
                                             ...);
void        gtk_tree_view_column_set_cell_data_func
                                            (GtkTreeViewColumn *tree_column,
                                             GtkCellRenderer *cell_renderer,
                                             GtkTreeCellDataFunc func,
                                             gpointer func_data,
                                             GtkDestroyNotify destroy);
*/

/* void gtk_tree_view_column_clear_attributes (GtkTreeViewColumn *tree_column, GtkCellRenderer *cell_renderer) */
void gtkperl_tree_view_column_clear_attributes(SV* tree_column, SV* cell_renderer)
{
    gtk_tree_view_column_clear_attributes(SvGtkTreeViewColumn(tree_column), SvGtkCellRenderer(cell_renderer));
}

/* void gtk_tree_view_column_set_spacing (GtkTreeViewColumn *tree_column, gint spacing) */
void gtkperl_tree_view_column_set_spacing(SV* tree_column, int spacing)
{
    gtk_tree_view_column_set_spacing(SvGtkTreeViewColumn(tree_column), spacing);
}

/* gint gtk_tree_view_column_get_spacing (GtkTreeViewColumn *tree_column) */
int gtkperl_tree_view_column_get_spacing(SV* tree_column)
{
    return gtk_tree_view_column_get_spacing(SvGtkTreeViewColumn(tree_column));
}

/* void gtk_tree_view_column_set_visible (GtkTreeViewColumn *tree_column, gboolean visible) */
void gtkperl_tree_view_column_set_visible(SV* tree_column, int visible)
{
    gtk_tree_view_column_set_visible(SvGtkTreeViewColumn(tree_column), visible);
}

/* gboolean gtk_tree_view_column_get_visible (GtkTreeViewColumn *tree_column) */
int gtkperl_tree_view_column_get_visible(SV* tree_column)
{
    return gtk_tree_view_column_get_visible(SvGtkTreeViewColumn(tree_column));
}

/* void gtk_tree_view_column_set_resizable (GtkTreeViewColumn *tree_column, gboolean resizable) */
void gtkperl_tree_view_column_set_resizable(SV* tree_column, int resizable)
{
    gtk_tree_view_column_set_resizable(SvGtkTreeViewColumn(tree_column), resizable);
}

/* gboolean gtk_tree_view_column_get_resizable (GtkTreeViewColumn *tree_column) */
int gtkperl_tree_view_column_get_resizable(SV* tree_column)
{
    return gtk_tree_view_column_get_resizable(SvGtkTreeViewColumn(tree_column));
}

/* void gtk_tree_view_column_set_sizing (GtkTreeViewColumn *tree_column, GtkTreeViewColumnSizing type) */
void gtkperl_tree_view_column_set_sizing(SV* tree_column, SV* type)
{
    gtk_tree_view_column_set_sizing(SvGtkTreeViewColumn(tree_column), SvGtkTreeViewColumnSizing(type));
}

/* GtkTreeViewColumnSizing gtk_tree_view_column_get_sizing (GtkTreeViewColumn *tree_column) */
SV* gtkperl_tree_view_column_get_sizing(SV* tree_column)
{
    return newSVGtkTreeViewColumnSizing(gtk_tree_view_column_get_sizing(SvGtkTreeViewColumn(tree_column)));
}

/* gint gtk_tree_view_column_get_width (GtkTreeViewColumn *tree_column) */
int gtkperl_tree_view_column_get_width(SV* tree_column)
{
    return gtk_tree_view_column_get_width(SvGtkTreeViewColumn(tree_column));
}

/* gint gtk_tree_view_column_get_fixed_width (GtkTreeViewColumn *tree_column) */
int gtkperl_tree_view_column_get_fixed_width(SV* tree_column)
{
    return gtk_tree_view_column_get_fixed_width(SvGtkTreeViewColumn(tree_column));
}

/* void gtk_tree_view_column_set_fixed_width (GtkTreeViewColumn *tree_column, gint fixed_width) */
void gtkperl_tree_view_column_set_fixed_width(SV* tree_column, int fixed_width)
{
    gtk_tree_view_column_set_fixed_width(SvGtkTreeViewColumn(tree_column), fixed_width);
}

/* void gtk_tree_view_column_set_min_width (GtkTreeViewColumn *tree_column, gint min_width) */
void gtkperl_tree_view_column_set_min_width(SV* tree_column, int min_width)
{
    gtk_tree_view_column_set_min_width(SvGtkTreeViewColumn(tree_column), min_width);
}

/* gint gtk_tree_view_column_get_min_width (GtkTreeViewColumn *tree_column) */
int gtkperl_tree_view_column_get_min_width(SV* tree_column)
{
    return gtk_tree_view_column_get_min_width(SvGtkTreeViewColumn(tree_column));
}

/* void gtk_tree_view_column_set_max_width (GtkTreeViewColumn *tree_column, gint max_width) */
void gtkperl_tree_view_column_set_max_width(SV* tree_column, int max_width)
{
    gtk_tree_view_column_set_max_width(SvGtkTreeViewColumn(tree_column), max_width);
}

/* gint gtk_tree_view_column_get_max_width (GtkTreeViewColumn *tree_column) */
int gtkperl_tree_view_column_get_max_width(SV* tree_column)
{
    return gtk_tree_view_column_get_max_width(SvGtkTreeViewColumn(tree_column));
}

/* void gtk_tree_view_column_clicked (GtkTreeViewColumn *tree_column) */
void gtkperl_tree_view_column_clicked(SV* tree_column)
{
    gtk_tree_view_column_clicked(SvGtkTreeViewColumn(tree_column));
}

void gtkperl_tree_view_column_set_title(SV* tree_column, gchar* title)
{
    gtk_tree_view_column_set_title(SvGtkTreeViewColumn(tree_column), title);
}

/* G_CONST_RETURN gchar *gtk_tree_view_column_get_title (GtkTreeViewColumn *tree_column) */
char* gtkperl_tree_view_column_get_title(SV* tree_column)
{
    return gtk_tree_view_column_get_title(SvGtkTreeViewColumn(tree_column));
}

/* void gtk_tree_view_column_set_clickable (GtkTreeViewColumn *tree_column, gboolean clickable) */
void gtkperl_tree_view_column_set_clickable(SV* tree_column, int clickable)
{
    gtk_tree_view_column_set_clickable(SvGtkTreeViewColumn(tree_column), clickable);
}

/* gboolean gtk_tree_view_column_get_clickable (GtkTreeViewColumn *tree_column) */
int gtkperl_tree_view_column_get_clickable(SV* tree_column)
{
    return gtk_tree_view_column_get_clickable(SvGtkTreeViewColumn(tree_column));
}

/* void gtk_tree_view_column_set_widget (GtkTreeViewColumn *tree_column, GtkWidget *widget) */
void gtkperl_tree_view_column_set_widget(SV* tree_column, SV* widget)
{
    gtk_tree_view_column_set_widget(SvGtkTreeViewColumn(tree_column), SvGtkWidget(widget));
}

/* GtkWidget *gtk_tree_view_column_get_widget (GtkTreeViewColumn *tree_column) */
SV* gtkperl_tree_view_column_get_widget(SV* tree_column)
{
    return gtk2_perl_new_object(gtk_tree_view_column_get_widget(SvGtkTreeViewColumn(tree_column)));
}

/* void gtk_tree_view_column_set_alignment (GtkTreeViewColumn *tree_column, gfloat xalign) */
void gtkperl_tree_view_column_set_alignment(SV* tree_column, double xalign)
{
    gtk_tree_view_column_set_alignment(SvGtkTreeViewColumn(tree_column), xalign);
}

/* gfloat gtk_tree_view_column_get_alignment (GtkTreeViewColumn *tree_column) */
double gtkperl_tree_view_column_get_alignment(SV* tree_column)
{
    return gtk_tree_view_column_get_alignment(SvGtkTreeViewColumn(tree_column));
}

/* void gtk_tree_view_column_set_reorderable (GtkTreeViewColumn *tree_column, gboolean reorderable) */
void gtkperl_tree_view_column_set_reorderable(SV* tree_column, int reorderable)
{
    gtk_tree_view_column_set_reorderable(SvGtkTreeViewColumn(tree_column), reorderable);
}

/* gboolean gtk_tree_view_column_get_reorderable (GtkTreeViewColumn *tree_column) */
int gtkperl_tree_view_column_get_reorderable(SV* tree_column)
{
    return gtk_tree_view_column_get_reorderable(SvGtkTreeViewColumn(tree_column));
}

/* gint gtk_tree_view_column_get_sort_column_id (GtkTreeViewColumn *tree_column) */
int gtkperl_tree_view_column_get_sort_column_id(SV* tree_column)
{
    return gtk_tree_view_column_get_sort_column_id(SvGtkTreeViewColumn(tree_column));
}

/* void gtk_tree_view_column_set_sort_indicator (GtkTreeViewColumn *tree_column, gboolean setting) */
void gtkperl_tree_view_column_set_sort_indicator(SV* tree_column, int setting)
{
    gtk_tree_view_column_set_sort_indicator(SvGtkTreeViewColumn(tree_column), setting);
}

/* gboolean gtk_tree_view_column_get_sort_indicator (GtkTreeViewColumn *tree_column) */
int gtkperl_tree_view_column_get_sort_indicator(SV* tree_column)
{
    return gtk_tree_view_column_get_sort_indicator(SvGtkTreeViewColumn(tree_column));
}

/* void gtk_tree_view_column_set_sort_order (GtkTreeViewColumn *tree_column, GtkSortType order) */
void gtkperl_tree_view_column_set_sort_order(SV* tree_column, SV* order)
{
    gtk_tree_view_column_set_sort_order(SvGtkTreeViewColumn(tree_column), SvGtkSortType(order));
}

/* GtkSortType gtk_tree_view_column_get_sort_order (GtkTreeViewColumn *tree_column) */
SV* gtkperl_tree_view_column_get_sort_order(SV* tree_column)
{
    return newSVGtkSortType(gtk_tree_view_column_get_sort_order(SvGtkTreeViewColumn(tree_column)));
}

/*
void        gtk_tree_view_column_cell_set_cell_data
                                            (GtkTreeViewColumn *tree_column,
                                             GtkTreeModel *tree_model,
                                             GtkTreeIter *iter,
                                             gboolean is_expander,
                                             gboolean is_expanded);
void        gtk_tree_view_column_cell_get_size
                                            (GtkTreeViewColumn *tree_column,
                                             GdkRectangle *cell_area,
                                             gint *x_offset,
                                             gint *y_offset,
                                             gint *width,
                                             gint *height);
*/

/* gboolean gtk_tree_view_column_cell_is_visible (GtkTreeViewColumn *tree_column) */
int gtkperl_tree_view_column_cell_is_visible(SV* tree_column)
{
    return gtk_tree_view_column_cell_is_visible(SvGtkTreeViewColumn(tree_column));
}

