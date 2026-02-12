package Emitter::ListenersRun;
# Список слушателей

use common::sense;
use List::Util qw/pairmap max/;
use Aion::Format qw/printcolor/;

use Aion;

with qw/Aion::Run/;

# Маска для фильтра по командам
has mask => (is => "ro", isa => Maybe[Str], arg => 1);

# Эмиттер
has emitter => (is => 'ro', isa => 'Aion::Emitter', eon => 1);

#@run emit:listeners „List of listeners”
sub list {
	my ($self) = @_;

	my @listeners = pairmap { +{ %$b, key => $a } } %{$self->emitter->event};
	my $len = max map length $_->{key}, @listeners;
	my $len2 = max map length($_->{pkg})+length($_->{sub})+1, @listeners;
	for my $listener_bag (@listeners) {
		printcolor "#green%-${len}s #{bold red}%-${len2}s #{bold black}%s#r\n", $_->{key}, "$_->{pkg}#$_->{sub}";
	}
}
