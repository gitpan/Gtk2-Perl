/* $Id: Toolbar.c,v 1.4 2002/11/21 15:35:15 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

#include "gtk2-perl.h"

SV* gtkperl_toolbar__new(char* class)
{
    return gtk2_perl_new_object_from_pointer(gtk_toolbar_new(), class);
}

SV* gtkperl_toolbar__append_item(SV* toolbar, gchar *text,
				 gchar *tooltip_text, gchar *tooltip_private_text,
				 SV* icon)
{
    return gtk2_perl_new_object(gtk_toolbar_append_item(SvGtkToolbar(toolbar),
							text, 
							tooltip_text,
							tooltip_private_text,
							SvGtkWidget(icon),
							NULL, NULL));
}

/* NOT IMPLEMENTED YET
GtkWidget*  gtk_toolbar_prepend_item        (GtkToolbar *toolbar,
                                             const char *text,
                                             const char *tooltip_text,
                                             const char *tooltip_private_text,
                                             GtkWidget *icon,
                                             GtkSignalFunc callback,
                                             gpointer user_data);
GtkWidget*  gtk_toolbar_insert_item         (GtkToolbar *toolbar,
                                             const char *text,
                                             const char *tooltip_text,
                                             const char *tooltip_private_text,
                                             GtkWidget *icon,
                                             GtkSignalFunc callback,
                                             gpointer user_data,
                                             gint position);
*/
void gtkperl_toolbar_append_space(SV *toolbar)
{
    gtk_toolbar_append_space(SvGtkToolbar(toolbar));
}
/*
void        gtk_toolbar_prepend_space       (GtkToolbar *toolbar);
void        gtk_toolbar_insert_space        (GtkToolbar *toolbar,
                                             gint position);
*/

SV* gtkperl_toolbar__append_element(SV* toolbar,
				    SV* type, SV* widget,
				    gchar *text, gchar *tooltip_text, gchar* tooltip_private_text,
				    SV* icon)
{
    return gtk2_perl_new_object(gtk_toolbar_append_element(SvGtkToolbar(toolbar), 
							   SvGtkToolbarChildType(type), SvGtkWidget_nullok(widget),
							   text, tooltip_text, tooltip_private_text,
							   SvGtkWidget(icon), NULL, NULL));
}


/*
GtkWidget*  gtk_toolbar_prepend_element     (GtkToolbar *toolbar,
                                             GtkToolbarChildType type,
                                             GtkWidget *widget,
                                             const char *text,
                                             const char *tooltip_text,
                                             const char *tooltip_private_text,
                                             GtkWidget *icon,
                                             GtkSignalFunc callback,
                                             gpointer user_data);
GtkWidget*  gtk_toolbar_insert_element      (GtkToolbar *toolbar,
                                             GtkToolbarChildType type,
                                             GtkWidget *widget,
                                             const char *text,
                                             const char *tooltip_text,
                                             const char *tooltip_private_text,
                                             GtkWidget *icon,
                                             GtkSignalFunc callback,
                                             gpointer user_data,
                                             gint position);
*/

void gtkperl_toolbar_append_widget(SV* toolbar, SV* widget, gchar* tooltip_text, gchar* tooltip_private_text)
{
    gtk_toolbar_append_widget(SvGtkToolbar(toolbar), SvGtkWidget(widget), tooltip_text, tooltip_private_text);
}

/*
void        gtk_toolbar_prepend_widget      (GtkToolbar *toolbar,
                                             GtkWidget *widget,
                                             const char *tooltip_text,
                                             const char *tooltip_private_text);
void        gtk_toolbar_insert_widget       (GtkToolbar *toolbar,
                                             GtkWidget *widget,
                                             const char *tooltip_text,
                                             const char *tooltip_private_text,
                                             gint position);
*/

/* void gtk_toolbar_set_orientation (GtkToolbar *toolbar, GtkOrientation orientation) */
void gtkperl_toolbar_set_orientation(SV* toolbar, SV* orientation)
{
    gtk_toolbar_set_orientation(SvGtkToolbar(toolbar), SvGtkOrientation(orientation));
}

/* void gtk_toolbar_set_style (GtkToolbar *toolbar, GtkToolbarStyle style) */
void gtkperl_toolbar_set_style(SV* toolbar, SV* style)
{
    gtk_toolbar_set_style(SvGtkToolbar(toolbar), SvGtkToolbarStyle(style));
}

/* void gtk_toolbar_set_icon_size (GtkToolbar *toolbar, GtkIconSize icon_size) */
void gtkperl_toolbar_set_icon_size(SV* toolbar, SV* icon_size)
{
    gtk_toolbar_set_icon_size(SvGtkToolbar(toolbar), SvGtkIconSize(icon_size));
}

/* void gtk_toolbar_set_tooltips (GtkToolbar *toolbar, gboolean enable) */
void gtkperl_toolbar_set_tooltips(SV* toolbar, int enable)
{
    gtk_toolbar_set_tooltips(SvGtkToolbar(toolbar), enable);
}

/* void gtk_toolbar_unset_style (GtkToolbar *toolbar) */
void gtkperl_toolbar_unset_style(SV* toolbar)
{
    gtk_toolbar_unset_style(SvGtkToolbar(toolbar));
}

/* void gtk_toolbar_unset_icon_size (GtkToolbar *toolbar) */
void gtkperl_toolbar_unset_icon_size(SV* toolbar)
{
    gtk_toolbar_unset_icon_size(SvGtkToolbar(toolbar));
}

/* GtkOrientation gtk_toolbar_get_orientation (GtkToolbar *toolbar) */
SV* gtkperl_toolbar_get_orientation(SV* toolbar)
{
    return newSVGtkOrientation(gtk_toolbar_get_orientation(SvGtkToolbar(toolbar)));
}

/* GtkToolbarStyle gtk_toolbar_get_style (GtkToolbar *toolbar) */
SV* gtkperl_toolbar_get_style(SV* toolbar)
{
    return newSVGtkToolbarStyle(gtk_toolbar_get_style(SvGtkToolbar(toolbar)));
}

/* GtkIconSize gtk_toolbar_get_icon_size (GtkToolbar *toolbar) */
SV* gtkperl_toolbar_get_icon_size(SV* toolbar)
{
    return newSVGtkIconSize(gtk_toolbar_get_icon_size(SvGtkToolbar(toolbar)));
}

/* gboolean gtk_toolbar_get_tooltips (GtkToolbar *toolbar) */
int gtkperl_toolbar_get_tooltips(SV* toolbar)
{
    return gtk_toolbar_get_tooltips(SvGtkToolbar(toolbar));
}

/*
GtkWidget*  gtk_toolbar_insert_stock        (GtkToolbar *toolbar,
                                             const gchar *stock_id,
                                             const char *tooltip_text,
                                             const char *tooltip_private_text,
                                             GtkSignalFunc callback,
                                             gpointer user_data,
                                             gint position);
void        gtk_toolbar_set_icon_size       (GtkToolbar *toolbar,
                                             GtkIconSize icon_size);
GtkIconSize gtk_toolbar_get_icon_size       (GtkToolbar *toolbar);
GtkOrientation gtk_toolbar_get_orientation  (GtkToolbar *toolbar);
GtkToolbarStyle gtk_toolbar_get_style       (GtkToolbar *toolbar);
gboolean    gtk_toolbar_get_tooltips        (GtkToolbar *toolbar);
void        gtk_toolbar_remove_space        (GtkToolbar *toolbar,
                                             gint position);
void        gtk_toolbar_unset_icon_size     (GtkToolbar *toolbar);
void        gtk_toolbar_unset_style         (GtkToolbar *toolbar);
*/
