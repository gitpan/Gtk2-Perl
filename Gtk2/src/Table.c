/* $Id: Table.c,v 1.7 2002/11/09 15:55:27 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

#include "gtk2-perl.h"

SV* gtkperl_table_new(char* class, int rows, int columns, int homogeneous)
{
    return gtk2_perl_new_object(gtk_table_new(rows, columns, homogeneous));
}

/* void gtk_table_resize (GtkTable *table, guint rows, guint columns) */
void gtkperl_table_resize(SV* table, int rows, int columns)
{
    gtk_table_resize(SvGtkTable(table), rows, columns);
}

void gtkperl_table_attach(SV* table, SV* child,
			  int left_attach, int right_attach, int top_attach, int bottom_attach,
			  SV* xoptions, SV* yoptions, int xpadding, int ypadding)
{
    gtk_table_attach(SvGtkTable(table), SvGtkWidget(child),
		     left_attach, right_attach, top_attach, bottom_attach,
		     SvGtkAttachOptions(xoptions), SvGtkAttachOptions(yoptions),
		     xpadding, ypadding);
}

void gtkperl_table_attach_defaults(SV *table, SV *widget, int left, int right, int top, int bottom)
{
    gtk_table_attach_defaults(SvGtkTable(table), SvGtkWidget(widget), left, right, top, bottom);
}

/* void gtk_table_set_row_spacing (GtkTable *table, guint row, guint spacing) */
void gtkperl_table_set_row_spacing(SV* table, int row, int spacing)
{
    gtk_table_set_row_spacing(SvGtkTable(table), row, spacing);
}

/* void gtk_table_set_col_spacing (GtkTable *table, guint column, guint spacing) */
void gtkperl_table_set_col_spacing(SV* table, int column, int spacing)
{
    gtk_table_set_col_spacing(SvGtkTable(table), column, spacing);
}

void gtkperl_table_set_row_spacings(SV *table, int spacing)
{
    gtk_table_set_row_spacings(SvGtkTable(table), spacing);
}

void gtkperl_table_set_col_spacings(SV *table, int spacing)
{
    gtk_table_set_col_spacings(SvGtkTable(table), spacing);
}

/* void gtk_table_set_homogeneous (GtkTable *table, gboolean homogeneous) */
void gtkperl_table_set_homogeneous(SV* table, int homogeneous)
{
    gtk_table_set_homogeneous(SvGtkTable(table), homogeneous);
}

/* guint gtk_table_get_default_row_spacing (GtkTable *table) */
int gtkperl_table_get_default_row_spacing(SV* table)
{
    return gtk_table_get_default_row_spacing(SvGtkTable(table));
}

/* gboolean gtk_table_get_homogeneous (GtkTable *table) */
int gtkperl_table_get_homogeneous(SV* table)
{
    return gtk_table_get_homogeneous(SvGtkTable(table));
}

/* guint gtk_table_get_row_spacing (GtkTable *table, guint row) */
int gtkperl_table_get_row_spacing(SV* table, int row)
{
    return gtk_table_get_row_spacing(SvGtkTable(table), row);
}

/* guint gtk_table_get_col_spacing (GtkTable *table, guint column) */
int gtkperl_table_get_col_spacing(SV* table, int column)
{
    return gtk_table_get_col_spacing(SvGtkTable(table), column);
}

/* guint gtk_table_get_default_col_spacing(GtkTable *table) */
int gtkperl_table_get_default_col_spacing(SV* table)
{
    return gtk_table_get_default_col_spacing(SvGtkTable(table));
}
