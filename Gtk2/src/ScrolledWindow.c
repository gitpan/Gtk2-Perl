/* $Id: ScrolledWindow.c,v 1.12 2003/02/13 11:51:00 ggc Exp $
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

/* void gtk_scrolled_window_set_hadjustment (GtkScrolledWindow *scrolled_window, GtkAdjustment *hadjustment) */
void gtkperl_scrolled_window_set_hadjustment(SV* scrolled_window, SV* hadjustment)
{
    gtk_scrolled_window_set_hadjustment(SvGtkScrolledWindow(scrolled_window), SvGtkAdjustment(hadjustment));
}

/* void gtk_scrolled_window_set_vadjustment (GtkScrolledWindow *scrolled_window, GtkAdjustment *hadjustment) */
void gtkperl_scrolled_window_set_vadjustment(SV* scrolled_window, SV* hadjustment)
{
    gtk_scrolled_window_set_vadjustment(SvGtkScrolledWindow(scrolled_window), SvGtkAdjustment(hadjustment));
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
					SV* hscrollbar_policy, SV* vscrollbar_policy)
{
    gtk_scrolled_window_set_policy(SvGtkScrolledWindow(scrolled_window),
				   SvGtkPolicyType(hscrollbar_policy), SvGtkPolicyType(vscrollbar_policy));
}

/* void gtk_scrolled_window_get_policy (GtkScrolledWindow *scrolled_window,
                                        GtkPolicyType *hscrollbar_policy, GtkPolicyType *vscrollbar_policy) */
SV* gtkperl_scrolled_window__get_policy(SV* scrolled_window)
{
    GtkPolicyType hscrollbar_policy, vscrollbar_policy;
    AV* values = newAV();
    gtk_scrolled_window_get_policy(SvGtkScrolledWindow(scrolled_window),
				   &hscrollbar_policy, &vscrollbar_policy);
    av_push(values, newSVGtkPolicyType(hscrollbar_policy));
    av_push(values, newSVGtkPolicyType(vscrollbar_policy));
    return newRV_noinc((SV*) values);
}

void gtkperl_scrolled_window_set_placement(SV *scrolled_window, SV *window_placement)
{
    gtk_scrolled_window_set_placement(SvGtkScrolledWindow(scrolled_window), SvGtkCornerType(window_placement));
}

/* GtkCornerType gtk_scrolled_window_get_placement (GtkScrolledWindow *scrolled_window) */
SV* gtkperl_scrolled_window_get_placement(SV* scrolled_window)
{
    return newSVGtkCornerType(gtk_scrolled_window_get_placement(SvGtkScrolledWindow(scrolled_window)));
}

void gtkperl_scrolled_window_set_shadow_type(SV *scrolled_window, SV *shadow_type)
{
    gtk_scrolled_window_set_shadow_type(SvGtkScrolledWindow(scrolled_window), SvGtkShadowType(shadow_type));
}

/* GtkShadowType gtk_scrolled_window_get_shadow_type (GtkScrolledWindow *scrolled_window) */
SV* gtkperl_scrolled_window_get_shadow_type(SV* scrolled_window)
{
    return newSVGtkShadowType(gtk_scrolled_window_get_shadow_type(SvGtkScrolledWindow(scrolled_window)));
}

void gtkperl_scrolled_window_add_with_viewport(SV *scrolled_window, SV *child)
{
    gtk_scrolled_window_add_with_viewport(SvGtkScrolledWindow(scrolled_window), SvGtkWidget(child));
}


/** methods to access internal stuff **/

SV* gtkperl_scrolled_window_hscrollbar(SV *scrolled_window)
{
    return gtk2_perl_new_object_nullok(SvGtkScrolledWindow(scrolled_window)->hscrollbar);
}

SV* gtkperl_scrolled_window_vscrollbar(SV *scrolled_window)
{
    return gtk2_perl_new_object_nullok(SvGtkScrolledWindow(scrolled_window)->vscrollbar);
}

int gtkperl_scrolled_window_hscrollbar_visible(SV *scrolled_window)
{
    return SvGtkScrolledWindow(scrolled_window)->hscrollbar_visible;
}

int gtkperl_scrolled_window_vscrollbar_visible(SV *scrolled_window)
{
    return SvGtkScrolledWindow(scrolled_window)->vscrollbar_visible;
}


/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
