/* $Id: FontSelection.c,v 1.2 2002/11/05 23:25:56 glade-perl Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

#include "gtk2-perl.h"

SV* gtkperl_font_selection_new(char* class)
{
    return gtk2_perl_new_object(gtk_font_selection_new());
}
/* Deprecated 
SV* gtkperl_font_selection_get_font(SV* fontsel)
{
    return newSVGdkFont(gtk_font_selection_get_font(
        SvGtkFontSelection(fontsel)));
}
*/
SV* gtkperl_font_selection_get_font_name(SV* fontsel)
{
    return newSVgchar(gtk_font_selection_get_font_name(
        SvGtkFontSelection(fontsel)));
}

int gtkperl_font_selection_set_font_name(SV* fontsel, gchar *fontname)
{
    return gtk_font_selection_set_font_name(
        SvGtkFontSelection(fontsel), fontname);
}

gchar* gtkperl_font_selection_get_preview_text(SV* fontsel)
{
    return gtk_font_selection_get_preview_text(
        SvGtkFontSelection(fontsel));
}

void gtkperl_font_selection_set_preview_text(SV* fontsel, gchar *text)
{
    gtk_font_selection_set_preview_text(
        SvGtkFontSelection(fontsel), text);
}

