
#include "gtk2-perl.h"

SV* gtkperl_vruler_new(char* class)
{
    return gtk2_perl_new_object(gtk_vruler_new());
}

