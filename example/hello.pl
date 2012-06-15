use lib '../lib';
use Avenger title => 'Hello, World!';

my $rect = rect( 10, 10, 100, 100 );
my $state = '';
my $speed = 10;

my $app_rect = rect( 0, 0, app->w, app->h);

event 'key_down' => sub {
    $state = shift;
};

event 'key_up' => sub {
    $state = '' if $state eq shift;
};

update {
    if ($state eq 'left') {
        $rect->x( $rect->x - $speed );
    }
    elsif ($state eq 'right') {
        $rect->x( $rect->x + $speed );
    }
    elsif ($state eq 'up') {
        $rect->y( $rect->y - $speed );
    }
    elsif ($state eq 'down') {
        $rect->y( $rect->y + $speed );
    }
};


show {
	app->draw_rect( $app_rect, 0x0 );
    app->draw_rect( $rect, 0x112244FF );
    app->update;
};

start;
