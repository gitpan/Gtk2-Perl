/* $Id: Entry.c,v 1.7 2002/11/04 01:13:03 glade-perl Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV* gtkperl_entry__new(char* class)
{
    return gtk2_perl_new_object(gtk_entry_new());
}

SV* gtkperl_entry_new_with_max_length(char* class, int max)
{
    return gtk2_perl_new_object(gtk_entry_new_with_max_length(max));
}

int gtkperl_entry_get_visibility(SV *entry)
{
    return gtk_entry_get_visibility(SvGtkEntry(entry));
}

void gtkperl_entry_set_visibility(SV *entry, int visibility)
{
    gtk_entry_set_visibility(SvGtkEntry(entry), visibility);
}

gchar* gtkperl_entry_get_text(SV *entry)
{
    return gtk_entry_get_text(SvGtkEntry(entry));
}

void gtkperl_entry_set_text(SV *entry, gchar* text)
{
    gtk_entry_set_text(SvGtkEntry(entry), text);
}


void gtkperl_entry_set_max_length(SV *entry, int max)
{
    gtk_entry_set_max_length(SvGtkEntry(entry), max);
}


void gtkperl_entry_set_invisible_char(SV *entry, char ch)
{
    gtk_entry_set_invisible_char(SvGtkEntry(entry), ch);
}

void gtkperl_entry_set_has_frame(SV *entry, int setting)
{
    gtk_entry_set_has_frame(SvGtkEntry(entry), setting);
}

void gtkperl_entry_set_activates_default(SV *entry, int setting)
{
    gtk_entry_set_activates_default(SvGtkEntry(entry), setting);
}

/** access function **/

int gtkperl_entry_text_length(SV* entry)
{
    return SvGtkEntry(entry)->text_length;
}


/*

void        gtk_entry_append_text           (GtkEntry *entry,
                                           const gchar *text);
void        gtk_entry_prepend_text          (GtkEntry *entry,
                                           const gchar *text);
void        gtk_entry_set_position          (GtkEntry *entry,
                                           gint position);
G_CONST_RETURN gchar* gtk_entry_get_text    (GtkEntry *entry);
void        gtk_entry_select_region         (GtkEntry *entry,
                                           gint start,
                                           gint end);
void        gtk_entry_set_editable          (GtkEntry *entry,
                                           gboolean editable);
void        gtk_entry_set_max_length        (GtkEntry *entry,
                                           gint max);
gboolean    gtk_entry_get_activates_default (GtkEntry *entry);
gboolean    gtk_entry_get_has_frame         (GtkEntry *entry);
gint        gtk_entry_get_width_chars       (GtkEntry *entry);
void        gtk_entry_set_width_chars       (GtkEntry *entry,
                                           gint n_chars);
gunichar    gtk_entry_get_invisible_char    (GtkEntry *entry);
PangoLayout* gtk_entry_get_layout           (GtkEntry *entry);
void        gtk_entry_get_layout_offsets    (GtkEntry *entry,
                                           gint *x,
                                           gint *y);
gint        gtk_entry_get_max_length        (GtkEntry *entry);
*/
