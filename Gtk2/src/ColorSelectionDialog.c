/* $Id: ColorSelectionDialog.c,v 1.5 2002/11/05 20:13:26 glade-perl Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV* gtkperl_color_selection_dialog_new(char* class, gchar* title)
{
    return gtk2_perl_new_object(gtk_color_selection_dialog_new(title));
}

/** access methods **/

SV* gtkperl_color_selection_dialog_colorsel(SV* dialog)
{
    return gtk2_perl_new_object(SvGtkColorSelectionDialog(dialog)->colorsel);
}

SV* gtkperl_color_selection_dialog_ok_button(SV* dialog)
{
    return gtk2_perl_new_object(SvGtkColorSelectionDialog(dialog)->ok_button);
}

SV* gtkperl_color_selection_dialog_cancel_button(SV* dialog)
{
    return gtk2_perl_new_object(SvGtkColorSelectionDialog(dialog)->cancel_button);
}

SV* gtkperl_color_selection_dialog_help_button(SV* dialog)
{
    return gtk2_perl_new_object(SvGtkColorSelectionDialog(dialog)->help_button);
}

