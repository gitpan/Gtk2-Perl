/* $Id: FontSelectionDialog.c,v 1.8 2002/11/12 23:13:56 glade-perl Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"


SV* gtkperl_font_selection_dialog_new(char* class, gchar* title)
{
    return gtk2_perl_new_object(gtk_font_selection_dialog_new(title));
}

SV* gtkperl_font_selection_dialog_get_font_name(SV* fsd)
{
    return newSVgchar(gtk_font_selection_dialog_get_font_name(
        SvGtkFontSelectionDialog(fsd)));
}

int gtkperl_font_selection_dialog_set_font_name(SV* fontsel, gchar *fontname)
{
    return gtk_font_selection_dialog_set_font_name(
        SvGtkFontSelectionDialog(fontsel), fontname);
}

gchar* gtkperl_font_selection_dialog_get_preview_text(SV* fontsel)
{
    return gtk_font_selection_dialog_get_preview_text(
        SvGtkFontSelectionDialog(fontsel));
}

void gtkperl_font_selection_dialog_set_preview_text(SV* fontsel, gchar *text)
{
    gtk_font_selection_dialog_set_preview_text(
        SvGtkFontSelectionDialog(fontsel), text);
}

/** access methods **/

SV* gtkperl_font_selection_dialog_ok_button(SV* dialog)
{
    return gtk2_perl_new_object(SvGtkFontSelectionDialog(dialog)->ok_button);
}

SV* gtkperl_font_selection_dialog_cancel_button(SV* dialog)
{
    return gtk2_perl_new_object(SvGtkFontSelectionDialog(dialog)->cancel_button);
}

SV* gtkperl_font_selection_dialog_apply_button(SV* dialog)
{
    return gtk2_perl_new_object(SvGtkFontSelectionDialog(dialog)->apply_button);
}

SV* gtkperl_font_selection_dialog_fontsel(SV* dialog)
{
    return gtk2_perl_new_object(SvGtkFontSelectionDialog(dialog)->fontsel);
}

/* Deprecated
GdkFont*    gtk_font_selection_dialog_get_font
                                            (GtkFontSelectionDialog *fsd);

*/
