/* $Id: ToggleButton.c,v 1.8 2002/11/28 13:40:15 gthyni Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 * Local variables:
 *  c-basic-offset: 4
 * End:
 */

#include "gtk2-perl.h"

SV* gtkperl_toggle_button__new(char* class)
{
    return gtk2_perl_new_object(gtk_toggle_button_new());
}

SV* gtkperl_toggle_button_new_with_label(char* class, gchar* label)
{
    return gtk2_perl_new_object(gtk_toggle_button_new_with_label(label));
}

SV* gtkperl_toggle_button_new_with_mnemonic(char* class, gchar* label)
{
    return gtk2_perl_new_object(gtk_toggle_button_new_with_mnemonic(label));
}

int gtkperl_toggle_button_get_active(SV* toggle_button)
{
    return gtk_toggle_button_get_active(SvGtkToggleButton(toggle_button));
}

void gtkperl_toggle_button__set_active(SV* toggle_button, int is_active)
{
    gtk_toggle_button_set_active(SvGtkToggleButton(toggle_button), is_active);
}

int gtkperl_toggle_button_get_mode(SV* toggle_button)
{
    return gtk_toggle_button_get_mode(SvGtkToggleButton(toggle_button));
}

void gtkperl_toggle_button_set_mode(SV* toggle_button, int draw_indicator)
{
    gtk_toggle_button_set_mode(SvGtkToggleButton(toggle_button), draw_indicator);
}

int gtkperl_toggle_button_get_inconsistent(SV* toggle_button)
{
    return gtk_toggle_button_get_inconsistent(SvGtkToggleButton(toggle_button));
}

void gtkperl_toggle_button_set_inconsistent(SV* toggle_button, int val)
{
    gtk_toggle_button_set_inconsistent(SvGtkToggleButton(toggle_button), val);
}

void gtkperl_toggle_button_toggled(SV* toggle_button)
{
    gtk_toggle_button_toggled(SvGtkToggleButton(toggle_button));
}


/*
Deprecated
#define     gtk_toggle_button_set_state
*/
