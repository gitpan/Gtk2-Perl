
#include "gtk2-perl.h"

SV* gtkperl_hruler_new(char* class)
{
    return gtk2_perl_new_object(gtk_hruler_new());
}

