/* $Id: ListItem.c,v 1.5 2002/11/20 20:42:57 gthyni Exp $
 * Copyright 2002, Marin Purgar
 * licensed under Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

/* LISTITEM */

SV* gtkperl_list_item__new(char* class)
{
    return gtk2_perl_new_object(gtk_list_item_new());
}

SV* gtkperl_list_item_new_with_label(char* class, gchar* label)
{
    return gtk2_perl_new_object(gtk_list_item_new_with_label(label));
}
