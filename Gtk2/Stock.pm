package Gtk2::Stock;

# $Id: Stock.pm,v 1.2 2002/11/09 16:23:15 gthyni Exp $
# Copyright 2002, Göran Thyni, kirra.net
# licensed with Lesser General Public License (LGPL)
# see http://www.fsf.org/licenses/lgpl.txt

our $rcsid = '$Id: Stock.pm,v 1.2 2002/11/09 16:23:15 gthyni Exp $';
our $VERSION = $1 if $rcsid =~ /(\d+\.[\d\.]+)/;


# Stock IDs (not all are stock items; some are images only)
sub DIALOG_INFO      { 'gtk-dialog-info' }
sub DIALOG_WARNING   { 'gtk-dialog-warning' }
sub DIALOG_ERROR     { 'gtk-dialog-error' }
sub DIALOG_QUESTION  { 'gtk-dialog-question' }
sub DND              { 'gtk-dnd' }
sub DND_MULTIPLE     { 'gtk-dnd-multiple' }
sub ADD              { 'gtk-add' }
sub APPLY            { 'gtk-apply' }
sub BOLD             { 'gtk-bold' }
sub CANCEL           { 'gtk-cancel' }
sub CDROM            { 'gtk-cdrom' }
sub CLEAR            { 'gtk-clear' }
sub CLOSE            { 'gtk-close' }
sub CONVERT          { 'gtk-convert' }
sub COPY             { 'gtk-copy' }
sub CUT              { 'gtk-cut' }
sub DELETE           { 'gtk-delete' }
sub EXECUTE          { 'gtk-execute' }
sub FIND             { 'gtk-find' }
sub FIND_AND_REPLACE { 'gtk-find-and-replace' }
sub FLOPPY           { 'gtk-floppy' }
sub GOTO_BOTTOM      { 'gtk-goto-bottom' }
sub GOTO_FIRST       { 'gtk-goto-first' }
sub GOTO_LAST        { 'gtk-goto-last' }
sub GOTO_TOP         { 'gtk-goto-top' }
sub GO_BACK          { 'gtk-go-back' }
sub GO_DOWN          { 'gtk-go-down' }
sub GO_FORWARD       { 'gtk-go-forward' }
sub GO_UP            { 'gtk-go-up' }
sub HELP             { 'gtk-help' }
sub HOME             { 'gtk-home' }
sub INDEX            { 'gtk-index' }
sub ITALIC           { 'gtk-italic' }
sub JUMP_TO          { 'gtk-jump-to' }
sub JUSTIFY_CENTER   { 'gtk-justify-center' }
sub JUSTIFY_FILL     { 'gtk-justify-fill' }
sub JUSTIFY_LEFT     { 'gtk-justify-left' }
sub JUSTIFY_RIGHT    { 'gtk-justify-right' }
sub MISSING_IMAGE    { 'gtk-missing-image' }
sub NEW              { 'gtk-new' }
sub NO               { 'gtk-no' }
sub OK               { 'gtk-ok' }
sub OPEN             { 'gtk-open' }
sub PASTE            { 'gtk-paste' }
sub PREFERENCES      { 'gtk-preferences' }
sub PRINT            { 'gtk-print' }
sub PRINT_PREVIEW    { 'gtk-print-preview' }
sub PROPERTIES       { 'gtk-properties' }
sub QUIT             { 'gtk-quit' }
sub REDO             { 'gtk-redo' }
sub REFRESH          { 'gtk-refresh' }
sub REMOVE           { 'gtk-remove' }
sub REVERT_TO_SAVED  { 'gtk-revert-to-saved' }
sub SAVE             { 'gtk-save' }
sub SAVE_AS          { 'gtk-save-as' }
sub SELECT_COLOR     { 'gtk-select-color' }
sub SELECT_FONT      { 'gtk-select-font' }
sub SORT_ASCENDING   { 'gtk-sort-ascending' }
sub SORT_DESCENDING  { 'gtk-sort-descending' }
sub SPELL_CHECK      { 'gtk-spell-check' }
sub STOP             { 'gtk-stop' }
sub STRIKETHROUGH    { 'gtk-strikethrough' }
sub UNDELETE         { 'gtk-undelete' }
sub UNDERLINE        { 'gtk-underline' }
sub UNDO             { 'gtk-undo' }
sub YES              { 'gtk-yes' }
sub ZOOM_100         { 'gtk-zoom-100' }
sub ZOOM_FIT         { 'gtk-zoom-fit' }
sub ZOOM_IN          { 'gtk-zoom-in' }
sub ZOOM_OUT         { 'gtk-zoom-out' }

1;

