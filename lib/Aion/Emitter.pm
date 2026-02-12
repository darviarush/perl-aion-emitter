package Aion::Emitter;
# Диспетчер 

use common::sense;

our $VERSION = "0.0.0-prealpha";

use Aion::Pleroma;

use Aion;

use config INI => 'etc/annotation/listen.ann';

# Путь к собранным из аннотаций методам
has ini => (is => 'ro', isa => Str, default => INI);

# Список слушателей
has event => (is => 'ro', isa => HashRef[ArrayRef[Dict[pkg => ClassName, sub => Str, remark => Str]]], default => sub {
	my ($self) = @_;
	my %event;
	open my $f, "<:utf8", $self->ini or die "Not open ${\$self->ini}"; defer { close $f };
	while(<$f>) {
		die "${\$self->ini}:$. corrupt!" unless /^([\w:]+)#(\w*),\d+=(\w:+)\s+(.*?)\s*$/;
		my ($pkg, $sub, $evt, $remark) = ($1, $2, $3, $4);
		push @{$event{$evt}}, {
			pkg => $pkg,
			sub => $sub,
			remark => $remark,
		};
	}

	\%event
});

# Плерома
has pleroma => (is => 'ro', isa => 'Aion::Pleroma', eon => 1);

# Излучить
sub emit {
	my ($self, $event) = @_;
	
	my $listeners = $self->event->{ref $event};
	return $self unless $listeners;
	
	for my $listener_bag (@$listeners) {
		my ($pkg, $sub) = @$listener_bag{qw/pkg sub/};
		my $listener = $self->pleroma->get($pkg) // $self->pleroma->autoware($pkg)->resolve($pkg);
		$listener->$sub($event);
	}
	
	$self
}

1;

__END__

=encoding utf-8

=head1 NAME

Aion::Emitter - event dispatcher

=head1 SYNOPSIS

File lib/Event/BallEvent.pm:

	package Event::BallEvent;
	
	use Aion;
	
	has radius => (is => 'ro', isa => Num, default => 0);
	has weight => (is => 'ro', isa => Num, default => 0);
	
	1;

File lib/Listener/RadiusListener.pm:

	package Listener::RadiusListener;
	
	use Aion;
	
	#@listen Event::BallEvent
	sub listen {
		my ($self, $event) = @_;
		
		$event->radius(10);
	}
	
	1;

File lib/Listener/WeightListener.pm:

	package Listener::WeightListener;
	
	use Aion;
	
	#@listen Event::BallEvent
	sub listen {
		my ($self, $event) = @_;
		
		$event->weight(12);
	}
	
	1;



	use lib 'lib';
	
	use Aion::Emitter;
	
	my $emitter = Aion::Emitter->new;
	my $ballEvent = BallEvent->new;
	
	$emitter->emit($ballEvent);
	
	$ballEvent->radius # 10
	$ballEvent->weight # 12

=head1 DESCRIPTION

This event dispatcher implements the B<Event Dispatcher> pattern in which an event is defined by the class of the event object (event).

The listener is registered as an aeon in the pleroma and will always be represented by one object.

The event processing method is marked with the C<#@listen> annotation.

=head1 SUBROUTINES

=head2 emit ($event)

Emits an event: calls all listeners associated with the C<$event> event.

=head1 AUTHOR

Yaroslav O. Kosmina L<mailto:dart@cpan.org>

=head1 LICENSE

⚖ B<Perl5>

=head1 COPYRIGHT

The Aion::Emitter module is copyright (c) 2026 Yaroslav O. Kosmina. Rusland. All rights reserved.

