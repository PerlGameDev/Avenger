use lib 'lib';
use Avenger title => 'Platformer';

world->gravity( 0, -100 );

my $jumper = world->create_body(
        type => 'dynamic',
        x    => 50,
        y    => 100,
        w    => 30,
        h    => 30,
        friction => 0.0, # optional
        density  => 0.7, # optional
);

my $floor = world->create_body( x => app->w / 2, y => 50, w => app->w, h => 100 );

update { world->update };

event 'key_down' => sub {
    my ($x, $y);
    given (my $key = shift) {
        when ('up')    { $y = 200  };
        when ('left')  { $x = -200 };
        when ('right') { $x = 200  };
    };
    $jumper->velocity( $x, $y );
};

my @walls;
event 'mouse_left' => sub {
    my ($x, $y) = @_;
    push @walls, world->create_body( x => $x, y => app->h - $y );
};

my $app_rect = rect( 0, 0, app->w, app->h );
show {
    app->draw_rect( $app_rect, 0x7777ffff );
    app->draw_rect( $floor->rect, [0, 255, 0, 255] );
    foreach my $wall (@walls) {
        app->draw_rect( $wall->rect, [0, 255, 0, 255] );
    }
    app->draw_rect( $jumper->rect, [255, 50,0,255] );
    app->update;
};

start;
