/* $Id: ItemFactoryEntry.c,v 1.4 2002/11/13 19:21:22 glade-perl Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

SV*  gtkperl_item_factory_entry_new(char* class, gchar* path, gchar* accelerator, gpointer callback, int action, gchar* type)
{
    GtkItemFactoryEntry* e = g_malloc0(sizeof(GtkItemFactoryEntry));
    e->path = path;
    e->accelerator = accelerator;
    e->callback = callback;
    e->callback_action = action;
    e->item_type = g_strdup(type);
    return gtk2_perl_new_object_from_pointer(e, class);
}




