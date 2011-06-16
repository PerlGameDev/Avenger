use strict;
use warnings;

use Avenger title => 'Falling Platformer';

my @bodies;
event 'key_down' => sub {
    my ($x, $y) = mouse;
    my $body = world->create_body( x => $x, y => app->h - $y, type => 'dynamic' );
    push @bodies, $body;
};

my @walls;
event 'mouse_left' => sub {
    my ($x, $y) = @_;

    my $wall = world->create_body( x => $x, y => app->h - $y );
    push @walls, $wall;
};

my $app_rect = rect( 0, 0, app->w, app->h);
show {
    world->update;
    app->draw_rect( $app_rect, 0x0 );

    foreach my $wall (@walls) {
        app->draw_rect( $wall->rect, [0, 255, 0, 255] );
    }

    my @alive;
    foreach my $body (@bodies) {
        app->draw_rect( $body->rect, [255, 255, 0, 255] );

        if ($body->y > -200) {
            push @alive, $body;
        }
    }
    @bodies = @alive;

    app->update;
};

start;
