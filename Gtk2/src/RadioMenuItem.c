/* $Id: RadioMenuItem.c,v 1.4 2002/11/15 06:26:20 glade-perl Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV* gtkperl_radio_menu_item__new(char* class, SV* group)
{
    return gtk2_perl_new_object(gtk_radio_menu_item_new(SvGSList_nullok(group)));
}

SV* gtkperl_radio_menu_item_new_with_label(char* class, SV* group, gchar* label)
{
    return gtk2_perl_new_object(gtk_radio_menu_item_new_with_label(SvGSList_nullok(group), label));
}

SV* gtkperl_radio_menu_item_new_with_mnemonic(char* class, SV* group, gchar* label)
{
    return gtk2_perl_new_object(gtk_radio_menu_item_new_with_mnemonic(SvGSList_nullok(group), label));
}

SV* gtkperl_radio_menu_item_get_group(SV* radio_menu_item)
{
    return gtk2_perl_new_object_from_pointer(gtk_radio_menu_item_get_group(
        SvGtkRadioMenuItem(radio_menu_item)), "Gtk2::GSList");
}

void gtkperl_radio_menu_item_set_group(SV* radio_menu_item, SV* group)
{
    gtk_radio_menu_item_set_group(SvGtkRadioMenuItem(radio_menu_item), SvGSList_nullok(group));
}

/* Deprecated
#define     gtk_radio_menu_item_group
*/

