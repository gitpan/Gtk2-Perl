/* $Id: MenuShell.c,v 1.4 2002/10/20 15:53:32 ggc Exp $
 * Copyright 2002, Göran Thyni, kirra.net
 * licensed with Lesser General Public License (LGPL)
 * see http://www.fsf.org/licenses/lgpl.txt
 */

#include "gtk2-perl.h"

void gtkperl_menu_shell_append(SV* menu_shell, SV* child)
{
    gtk_menu_shell_append(SvGtkMenuShell(menu_shell), SvGtkWidget(child));
}


