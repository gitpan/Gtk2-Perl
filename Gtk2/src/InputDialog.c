/* $Id: InputDialog.c,v 1.1 2002/11/04 23:40:50 glade-perl Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"


SV* gtkperl_input_dialog_new(char* class)
{
    return gtk2_perl_new_object(gtk_input_dialog_new());
}

