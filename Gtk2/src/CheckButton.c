/* $Id: CheckButton.c,v 1.5 2002/11/13 22:28:55 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV* gtkperl_check_button__new(char* class)
{
    return gtk2_perl_new_object(gtk_check_button_new());
}


SV* gtkperl_check_button_new_with_label(char* class, gchar* label)
{
    return gtk2_perl_new_object(gtk_check_button_new_with_label(label));
}

SV* gtkperl_check_button_new_with_mnemonic(char* class, gchar* label)
{
    return gtk2_perl_new_object(gtk_check_button_new_with_mnemonic(label));
}

