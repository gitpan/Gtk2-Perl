use Gtk2;
use Encode qw(is_utf8 _utf8_on);

sub enter_callback {
	my ($widget, $entry) = @_;
	my $text= $entry->get_text;
	my $utf8= is_utf8($text) ? "on" : "off";
	printf "Entry contents: $text (utf8 flag: $utf8)\n";

	_utf8_on($text);
	$utf8= is_utf8($text) ? "on" : "off";
	printf "Entry contents: $text (utf8 flag: $utf8)\n";
}

Gtk2->init(\@ARGV);
my $window = Gtk2::Window->new('toplevel');
$window->set_size_request(200, 100);
$window->set_title("GTK Entry");
Gtk2::GSignal->connect($window, "destroy", sub { Gtk2->quit }, undef);
my $entry = Gtk2::Entry->new;
$entry->set_max_length(50);
Gtk2::GSignal->connect($entry, "activate", \&enter_callback, $entry);
$entry->set_text("hello");
$entry->show;
$window->add($entry);
$window->show;

Gtk2->main;
