/* $Id: Text.c,v 1.1 2002/11/20 20:42:57 gthyni Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

#include "gtk2-perl.h"
#define GTK_ENABLE_BROKEN
#include <gtk/gtktext.h>


SV* gtkperl_text__new(char* class, SV *hadj, SV *vadj)
{
    return gtk2_perl_new_object(gtk_text_new(hadj == &PL_sv_undef ? SvGtkAdjustment(hadj) : NULL,
					     vadj == &PL_sv_undef ? SvGtkAdjustment(vadj) : NULL));
}

/* NOT IMPLEMENTED
void        gtk_text_set_editable           (GtkText *text,
                                             gboolean editable);
void        gtk_text_set_word_wrap          (GtkText *text,
                                             gboolean word_wrap);
void        gtk_text_set_line_wrap          (GtkText *text,
                                             gboolean line_wrap);
void        gtk_text_set_adjustments        (GtkText *text,
                                             GtkAdjustment *hadj,
                                             GtkAdjustment *vadj);
void        gtk_text_set_point              (GtkText *text,
                                             guint index);
guint       gtk_text_get_point              (GtkText *text);
*/

int gtkperl_text_get_length(SV *text)
{
    return gtk_text_get_length(SvGtkText(text));
}

void gtkperl_text_freeze(SV *self)
{
    gtk_text_freeze(SvGtkText(self));
}

void gtkperl_text_thaw(SV *self)
{
    gtk_text_thaw(SvGtkText(self));
}

/*

void        gtk_text_insert                 (GtkText *text,
                                             GdkFont *font,
                                             GdkColor *fore,
                                             GdkColor *back,
                                             const char *chars,
                                             gint length);
gboolean    gtk_text_backward_delete        (GtkText *text,
                                             guint nchars);
gboolean    gtk_text_forward_delete         (GtkText *text,
                                             guint nchars);
#define     GTK_TEXT_INDEX                  (t, index)
*/

