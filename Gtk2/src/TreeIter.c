/* $Id: TreeIter.c,v 1.5 2002/11/22 16:54:26 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV* gtkperl_tree_iter_new(char* class)
{
    return gtk2_perl_new_object_from_pointer(g_malloc0(sizeof(GtkTreeIter)), class);
}

/* GtkTreeIter * gtk_tree_iter_copy (GtkTreeIter *iter) */
SV* gtkperl_tree_iter_copy(SV* iter)
{
    return gtk2_perl_new_object_from_pointer(gtk_tree_iter_copy(SvGtkTreeIter(iter)),
					     "Gtk2::TreeIter");
}

void gtkperl_tree_iter_free(SV* iter)
{
    gtk_tree_iter_free(SvGtkTreeIter(iter));
}




