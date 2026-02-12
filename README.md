# NAME

Aion::Emitter - диспетчер событий

# SYNOPSIS

Файл lib/Event/BallEvent.pm:
```perl
package Event::BallEvent;

use Aion;

has radius => (is => 'ro', isa => Num, default => 0);
has weight => (is => 'ro', isa => Num, default => 0);

1;
```

Файл lib/Listener/RadiusListener.pm:
```perl
package Listener::RadiusListener;

use Aion;

#@listen Event::BallEvent
sub listen {
	my ($self, $event) = @_;
	
	$event->radius(10);
}

1;
```

Файл lib/Listener/WeightListener.pm:
```perl
package Listener::WeightListener;

use Aion;

#@listen Event::BallEvent
sub listen {
	my ($self, $event) = @_;
	
	$event->weight(12);
}

1;
```

```perl
use lib 'lib';

use Aion::Emitter;

my $emitter = Aion::Emitter->new;
my $ballEvent = BallEvent->new;

$emitter->emit($ballEvent);

$ballEvent->radius # 10
$ballEvent->weight # 12
```

# DESCRIPTION

Данный диспетчер событий реализует паттерн **Event Dispatcher** в котором событие определяется по классу объекта события (event).

Слушатель регистрируется как эон в плероме и будет всегда представлен одним объектом.

Метод обрабатывающий события отмечается аннотацией `#@listen`.

# SUBROUTINES

## emit ($event)

Излучает событие: вызывает все слушатели связанные с событием `$event`.

# AUTHOR

Yaroslav O. Kosmina <dart@cpan.org>

# LICENSE

⚖ **Perl5**

# COPYRIGHT

The Aion::Emitter module is copyright (c) 2026 Yaroslav O. Kosmina. Rusland. All rights reserved.
