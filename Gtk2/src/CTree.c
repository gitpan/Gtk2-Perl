/* $Id: CTree.c,v 1.1 2002/11/12 23:13:56 glade-perl Exp $
 * Copyright 2002, Dermot Musgrove <dermot.musgrove@virgin.net>
 * licensed under Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"


/* Helpers */
SV* newSVGList(GList* list)
{
    GList * start = list;
    AV* items = newAV();
    while (list) {
        av_push(items, gtk2_perl_new_object(list->data));
        list = list->next;
    }
    if (start)
        g_list_free(start);
        
    return newRV_noinc((SV*) items);
}

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

/* CTREE */
SV* gtkperl_ctree_new(char* class, int columns, int tree_column)
{
    return gtk2_perl_new_object(gtk_ctree_new(columns, tree_column));
}

/*
GtkWidget*  gtk_ctree_new_with_titles       (gint columns,
                                               gint tree_column,
                                               gchar *titles[]);
  GtkCTreeNode* gtk_ctree_insert_node         (GtkCTree *ctree,
                                               GtkCTreeNode *parent,
                                               GtkCTreeNode *sibling,
                                               gchar *text[],
                                               guint8 spacing,
                                               GdkPixmap *pixmap_closed,
                                               GdkBitmap *mask_closed,
                                               GdkPixmap *pixmap_opened,
                                               GdkBitmap *mask_opened,
                                               gboolean is_leaf,
                                               gboolean expanded);
  void        gtk_ctree_remove_node           (GtkCTree *ctree,
                                               GtkCTreeNode *node);
  GtkCTreeNode* gtk_ctree_insert_gnode        (GtkCTree *ctree,
                                               GtkCTreeNode *parent,
                                               GtkCTreeNode *sibling,
                                               GNode *gnode,
                                               GtkCTreeGNodeFunc func,
                                               gpointer data);
  GNode*      gtk_ctree_export_to_gnode       (GtkCTree *ctree,
                                               GNode *parent,
                                               GNode *sibling,
                                               GtkCTreeNode *node,
                                               GtkCTreeGNodeFunc func,
                                               gpointer data);
  void        gtk_ctree_post_recursive        (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               GtkCTreeFunc func,
                                               gpointer data);
  void        gtk_ctree_post_recursive_to_depth
                                              (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               gint depth,
                                               GtkCTreeFunc func,
                                               gpointer data);
  void        gtk_ctree_pre_recursive         (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               GtkCTreeFunc func,
                                               gpointer data);
  void        gtk_ctree_pre_recursive_to_depth
                                              (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               gint depth,
                                               GtkCTreeFunc func,
                                               gpointer data);
  gboolean    gtk_ctree_is_viewable           (GtkCTree *ctree,
                                               GtkCTreeNode *node);
  GtkCTreeNode* gtk_ctree_last                (GtkCTree *ctree,
                                               GtkCTreeNode *node);
  GtkCTreeNode* gtk_ctree_find_node_ptr       (GtkCTree *ctree,
                                               GtkCTreeRow *ctree_row);
  gboolean    gtk_ctree_find                  (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               GtkCTreeNode *child);
  gboolean    gtk_ctree_is_ancestor           (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               GtkCTreeNode *child);
  GtkCTreeNode* gtk_ctree_find_by_row_data    (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               gpointer data);
  GList*      gtk_ctree_find_all_by_row_data  (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               gpointer data);
  GtkCTreeNode* gtk_ctree_find_by_row_data_custom
                                              (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               gpointer data,
                                               GCompareFunc func);
  GList*      gtk_ctree_find_all_by_row_data_custom
                                              (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               gpointer data,
                                               GCompareFunc func);
  gboolean    gtk_ctree_is_hot_spot           (GtkCTree *ctree,
                                               gint x,
                                               gint y);
  void        gtk_ctree_move                  (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               GtkCTreeNode *new_parent,
                                               GtkCTreeNode *new_sibling);
  void        gtk_ctree_expand                (GtkCTree *ctree,
                                               GtkCTreeNode *node);
  void        gtk_ctree_expand_recursive      (GtkCTree *ctree,
                                               GtkCTreeNode *node);
  void        gtk_ctree_expand_to_depth       (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               gint depth);
  void        gtk_ctree_collapse              (GtkCTree *ctree,
                                               GtkCTreeNode *node);
  void        gtk_ctree_collapse_recursive    (GtkCTree *ctree,
                                               GtkCTreeNode *node);
  void        gtk_ctree_collapse_to_depth     (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               gint depth);
  void        gtk_ctree_toggle_expansion      (GtkCTree *ctree,
                                               GtkCTreeNode *node);
  void        gtk_ctree_toggle_expansion_recursive
                                              (GtkCTree *ctree,
                                               GtkCTreeNode *node);
  void        gtk_ctree_select                (GtkCTree *ctree,
                                               GtkCTreeNode *node);
  void        gtk_ctree_select_recursive      (GtkCTree *ctree,
                                               GtkCTreeNode *node);
  void        gtk_ctree_unselect              (GtkCTree *ctree,
                                               GtkCTreeNode *node);
  void        gtk_ctree_unselect_recursive    (GtkCTree *ctree,
                                               GtkCTreeNode *node);
  void        gtk_ctree_real_select_recursive (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               gint state);
  void        gtk_ctree_node_set_text         (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               gint column,
                                               const gchar *text);
  void        gtk_ctree_node_set_pixmap       (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               gint column,
                                               GdkPixmap *pixmap,
                                               GdkBitmap *mask);
  void        gtk_ctree_node_set_pixtext      (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               gint column,
                                               const gchar *text,
                                               guint8 spacing,
                                               GdkPixmap *pixmap,
                                               GdkBitmap *mask);
  void        gtk_ctree_set_node_info         (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               const gchar *text,
                                               guint8 spacing,
                                               GdkPixmap *pixmap_closed,
                                               GdkBitmap *mask_closed,
                                               GdkPixmap *pixmap_opened,
                                               GdkBitmap *mask_opened,
                                               gboolean is_leaf,
                                               gboolean expanded);
  void        gtk_ctree_node_set_shift        (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               gint column,
                                               gint vertical,
                                               gint horizontal);
  void        gtk_ctree_node_set_selectable   (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               gboolean selectable);
  gboolean    gtk_ctree_node_get_selectable   (GtkCTree *ctree,
                                               GtkCTreeNode *node);
  GtkCellType gtk_ctree_node_get_cell_type    (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               gint column);
  gboolean    gtk_ctree_node_get_text         (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               gint column,
                                               gchar **text);
  gboolean    gtk_ctree_node_get_pixmap       (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               gint column,
                                               GdkPixmap **pixmap,
                                               GdkBitmap **mask);
  gboolean    gtk_ctree_node_get_pixtext      (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               gint column,
                                               gchar **text,
                                               guint8 *spacing,
                                               GdkPixmap **pixmap,
                                               GdkBitmap **mask);
  gboolean    gtk_ctree_get_node_info         (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               gchar **text,
                                               guint8 *spacing,
                                               GdkPixmap **pixmap_closed,
                                               GdkBitmap **mask_closed,
                                               GdkPixmap **pixmap_opened,
                                               GdkBitmap **mask_opened,
                                               gboolean *is_leaf,
                                               gboolean *expanded);
  void        gtk_ctree_node_set_row_style    (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               GtkStyle *style);
  GtkStyle*   gtk_ctree_node_get_row_style    (GtkCTree *ctree,
                                               GtkCTreeNode *node);
  void        gtk_ctree_node_set_cell_style   (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               gint column,
                                               GtkStyle *style);
  GtkStyle*   gtk_ctree_node_get_cell_style   (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               gint column);
  void        gtk_ctree_node_set_foreground   (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               GdkColor *color);
  void        gtk_ctree_node_set_background   (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               GdkColor *color);
  void        gtk_ctree_node_set_row_data     (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               gpointer data);
  void        gtk_ctree_node_set_row_data_full
                                              (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               gpointer data,
                                               GtkDestroyNotify destroy);
  gpointer    gtk_ctree_node_get_row_data     (GtkCTree *ctree,
                                               GtkCTreeNode *node);
  void        gtk_ctree_node_moveto           (GtkCTree *ctree,
                                               GtkCTreeNode *node,
                                               gint column,
                                               gfloat row_align,
                                               gfloat col_align);
  GtkVisibility gtk_ctree_node_is_visible     (GtkCTree *ctree,
                                               GtkCTreeNode *node);
  void        gtk_ctree_set_indent            (GtkCTree *ctree,
                                               gint indent);
  void        gtk_ctree_set_spacing           (GtkCTree *ctree,
                                               gint spacing);
  #define     gtk_ctree_set_reorderable       (t,r)
  void        gtk_ctree_set_line_style        (GtkCTree *ctree,
                                               GtkCTreeLineStyle line_style);
  void        gtk_ctree_set_expander_style    (GtkCTree *ctree,
                                               GtkCTreeExpanderStyle expander_style);
  void        gtk_ctree_set_drag_compare_func (GtkCTree *ctree,
                                               GtkCTreeCompareDragFunc cmp_func);
  void        gtk_ctree_sort_node             (GtkCTree *ctree,
                                               GtkCTreeNode *node);
  void        gtk_ctree_sort_recursive        (GtkCTree *ctree,
                                               GtkCTreeNode *node);
  GtkCTreeNode* gtk_ctree_node_nth            (GtkCTree *ctree,
                                               guint row);
  void        gtk_ctree_set_show_stub         (GtkCTree *ctree,
                                               gboolean show_stub);
*/
