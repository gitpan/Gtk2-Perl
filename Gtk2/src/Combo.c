/* $Id: Combo.c,v 1.6 2002/11/21 16:12:20 ggc Exp $
 * Copyright 2002, Dermot Musgrove <dermot.musgrove@virgin.net>
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV* gtkperl_combo_new(char* class)
{
    return gtk2_perl_new_object(gtk_combo_new());
}

void gtkperl_combo_set_use_arrows(SV* combo, int val)
{
    gtk_combo_set_use_arrows(SvGtkCombo(combo), val);
}

void gtkperl_combo_set_use_arrows_always(SV* combo, int val)
{
    gtk_combo_set_use_arrows_always(SvGtkCombo(combo), val);
}

void gtkperl_combo_set_case_sensitive(SV* combo, int val)
{
    gtk_combo_set_case_sensitive(SvGtkCombo(combo), val);
}

void gtkperl_combo_set_value_in_list(SV* combo, int val, int ok_if_empty)
{
    gtk_combo_set_value_in_list(SvGtkCombo(combo), val, ok_if_empty);
}

void gtkperl_combo_disable_activate(SV* combo)
{
    gtk_combo_disable_activate(SvGtkCombo(combo));
}
 
void gtkperl_combo__set_popdown_strings(SV* combo, SV* strings)
{
    GList* list = SvGList_of_strings(strings);
    gtk_combo_set_popdown_strings(SvGtkCombo(combo), list);
    g_list_free(list);
}

void gtkperl_combo_set_item_string(SV* combo, SV* item, gchar* item_value)
{
    gtk_combo_set_item_string(SvGtkCombo(combo), SvGtkItem(item), item_value);
}

/* Access functions */

SV* gtkperl_combo_entry(SV* combo)
{
    return gtk2_perl_new_object(SvGtkCombo(combo)->entry);
}

SV* gtkperl_combo_list(SV* combo)
{
    return gtk2_perl_new_object(SvGtkCombo(combo)->list);
}

SV* gtkperl_combo_popwin(SV* combo)
{
    return gtk2_perl_new_object(SvGtkCombo(combo)->popwin);
}

/*
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */
