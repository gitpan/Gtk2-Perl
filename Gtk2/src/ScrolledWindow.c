/* $Id: ScrolledWindow.c,v 1.10 2002/11/04 01:13:03 glade-perl Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV*  gtkperl_scrolled_window__new(char* class, SV* hadj, SV* vadj)
{
    return gtk2_perl_new_object(gtk_scrolled_window_new(SvGtkAdjustment_nullok(hadj),
							SvGtkAdjustment_nullok(vadj)));
}

SV* gtkperl_scrolled_window_get_hadjustment(SV* scrolled_window)
{
    return gtk2_perl_new_object(gtk_scrolled_window_get_hadjustment(SvGtkScrolledWindow(scrolled_window)));
}

SV* gtkperl_scrolled_window_get_vadjustment(SV* scrolled_window)
{
    return gtk2_perl_new_object(gtk_scrolled_window_get_vadjustment(SvGtkScrolledWindow(scrolled_window)));
}

void gtkperl_scrolled_window_set_policy(SV *scrolled_window,
					SV* hscrollbar_policy,
					SV* vscrollbar_policy)
{
    gtk_scrolled_window_set_policy(SvGtkScrolledWindow(scrolled_window),
				   SvGtkPolicyType(hscrollbar_policy), SvGtkPolicyType(vscrollbar_policy));
}

void gtkperl_scrolled_window_add_with_viewport(SV *scrolled_window, SV *child)
{
    gtk_scrolled_window_add_with_viewport(SvGtkScrolledWindow(scrolled_window), 
					  SvGtkWidget(child));
}

void gtkperl_scrolled_window_set_shadow_type(SV *scrolled_window, SV *shadow_type)
{
    gtk_scrolled_window_set_shadow_type(SvGtkScrolledWindow(scrolled_window), SvGtkShadowType(shadow_type));
}

void gtkperl_scrolled_window_set_placement(SV *scrolled_window, SV *window_placement)
{
    gtk_scrolled_window_set_placement(SvGtkScrolledWindow(scrolled_window), SvGtkCornerType(window_placement));
}

/* NOT IMPLEMENTED YET
void        gtk_scrolled_window_set_hadjustment(GtkScrolledWindow *scrolled_window,
 GtkAdjustment *hadjustment);
void        gtk_scrolled_window_set_vadjustment(GtkScrolledWindow *scrolled_window, GtkAdjustment *hadjustment);
GtkCornerType gtk_scrolled_window_get_placement(GtkScrolledWindow *scrolled_window);
void        gtk_scrolled_window_get_policy  (GtkScrolledWindow *scrolled_window,
                                             GtkPolicyType *hscrollbar_policy,
                                             GtkPolicyType *vscrollbar_policy);
GtkShadowType gtk_scrolled_window_get_shadow_type(GtkScrolledWindow *scrolled_window);
*/
