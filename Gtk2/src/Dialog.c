/* $Id: Dialog.c,v 1.9 2002/12/16 10:24:27 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"


SV* gtkperl_dialog_new(char* class)
{
    return gtk2_perl_new_object(gtk_dialog_new());
}

/* NOT IMPLEMENTED YET
GtkWidget*  gtk_dialog_new_with_buttons     (const gchar *title,
                                             GtkWindow *parent,
                                             GtkDialogFlags flags,
                                             const gchar *first_button_text,
                                             ...);
void        gtk_dialog_add_buttons          (GtkDialog *dialog,
                                             const gchar *first_button_text,
                                             ...);
*/

SV* gtkperl_dialog_run(SV* dialog)
{
    return newSVGtkResponseType(gtk_dialog_run(SvGtkDialog(dialog)));
}

SV* gtkperl_dialog_add_button(SV* dialog, gchar* button_text, int response_id)
{
    return gtk2_perl_new_object(gtk_dialog_add_button(
        SvGtkDialog(dialog), button_text, response_id));
}

void gtkperl_dialog_add_action_widget(SV* dialog, SV* child, int response_id)
{
    gtk_dialog_add_action_widget(
        SvGtkDialog(dialog), SvGtkWidget(child), response_id);
}

int gtkperl_dialog_get_has_separator(SV* dialog)
{
    return gtk_dialog_get_has_separator(SvGtkDialog(dialog));
}

void gtkperl_dialog_set_has_separator(SV* dialog, int setting)
{
    gtk_dialog_set_has_separator(SvGtkDialog(dialog), setting);
}

void gtkperl_dialog_response(SV* dialog, int response_id)
{
    gtk_dialog_response(SvGtkDialog(dialog), response_id);
}

void gtkperl_dialog_set_default_response(SV* dialog, int response_id)
{
    gtk_dialog_set_default_response(SvGtkDialog(dialog), response_id);
}

void gtkperl_dialog_set_response_sensitive(SV* dialog, int response_id, int setting)
{
    gtk_dialog_set_response_sensitive(SvGtkDialog(dialog), response_id, setting);
}

/* Access functions */

SV* gtkperl_dialog_vbox(SV* dialog)
{
    return gtk2_perl_new_object(SvGtkDialog(dialog)->vbox);
}

SV* gtkperl_dialog_action_area(SV* dialog)
{
    return gtk2_perl_new_object(SvGtkDialog(dialog)->action_area);
}

