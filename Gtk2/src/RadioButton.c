/* $Id: RadioButton.c,v 1.7 2002/11/11 19:09:22 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

#include "gtk2-perl.h"

SV* gtkperl_radio_button__new(char* class, SV* group)
{
    return gtk2_perl_new_object(gtk_radio_button_new(SvGSList_nullok(group)));
}

SV* gtkperl_radio_button_new_with_label(char* class, SV* group, gchar* label)
{
    return gtk2_perl_new_object(gtk_radio_button_new_with_label(SvGSList_nullok(group), label));
}

SV* gtkperl_radio_button_new_with_label_from_widget(char* class, SV *group, gchar *label)
{
    return gtk2_perl_new_object(gtk_radio_button_new_with_label_from_widget(SvGtkRadioButton(group), label));
}

SV* gtkperl_radio_button_get_group(SV* radio_button)
{
    return gtk2_perl_new_object_from_pointer(gtk_radio_button_get_group(SvGtkRadioButton(radio_button)),
					     "Gtk2::GSList");
}

