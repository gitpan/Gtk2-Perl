/* $Id: Frame.c,v 1.12 2002/11/12 20:29:23 gthyni Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV* gtkperl_frame__new(char* class, SV* label)
{
    const gchar * g_label = NULL;
    if (label != &PL_sv_undef) {
        sv_utf8_upgrade(label);
        g_label = g_strdup(SvPV_nolen(label));
    }
    return gtk2_perl_new_object(gtk_frame_new(g_label));
}

void gtkperl_frame_set_label(SV *frame, gchar *label)
{
    gtk_frame_set_label(SvGtkFrame(frame), label);
}

void gtkperl_frame_set_label_widget(SV *frame, SV *label_widget)
{
    gtk_frame_set_label_widget(SvGtkFrame(frame), SvGtkWidget(label_widget));
}

void gtkperl_frame_set_label_align(SV *frame, double xalign, double yalign)
{
    gtk_frame_set_label_align(SvGtkFrame(frame), xalign, yalign);
}

void gtkperl_frame_set_shadow_type(SV* frame, SV* type)
{
    gtk_frame_set_shadow_type(SvGtkFrame(frame), SvGtkShadowType(type));
}

/* G_CONST_RETURN gchar* gtk_frame_get_label (GtkFrame *frame) */
gchar* gtkperl_frame_get_label(SV* frame)
{
    return gtk_frame_get_label(SvGtkFrame(frame));
}

/* void gtk_frame_get_label_align (GtkFrame *frame, gfloat *xalign, gfloat *yalign) */
SV* gtkperl_frame__get_label_align(SV* frame)
{
    gfloat xalign;
    gfloat yalign;
    AV* values = newAV();
    gtk_frame_get_label_align(SvGtkFrame(frame), &xalign, &yalign);
    av_push(values, newSVnv(xalign));
    av_push(values, newSVnv(yalign));
    return newRV_noinc((SV*) values);
}

/* GtkWidget* gtk_frame_get_label_widget (GtkFrame *frame) */
SV* gtkperl_frame_get_label_widget(SV* frame)
{
    return gtk2_perl_new_object(gtk_frame_get_label_widget(SvGtkFrame(frame)));
}

/* GtkShadowType gtk_frame_get_shadow_type (GtkFrame *frame) */
SV* gtkperl_frame_get_shadow_type(SV* frame)
{
    return newSVGtkShadowType(gtk_frame_get_shadow_type(SvGtkFrame(frame)));
}

