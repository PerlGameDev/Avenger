use lib 'lib';    #Change later I iz lazy
use SDL::Events;
use Avenger title => 'Jumping Box';

world->gravity( 0, -100 );

#make the jumper body
my $jumper = world->create_body(
    x    => 50,
    y    => app->h - 100,
    w    => 25,
    h    => 25,
    type => 'dynamic'
);

my $floor =
  world->create_body( x => app->w / 2, y => 50, w => app->w, h => 10 );

my $app_rect = rect( 0, 0, app->w, app->h );

update { world->update; };

event 'key_down' => sub {
    my $key  = shift;
    my $keys = SDL::Events::get_key_state();

    my $x;
    my $y;
    if ( $keys->[SDLK_SPACE] ) {
        $y = 5000;
    }

    if ( $keys->[SDLK_LEFT] ) {
        $x = -2000;
    }
    elsif ( $keys->[SDLK_RIGHT] ) {
        $x = 2000;
    }

    $jumper->velocity( $x, $y );

};

show {

    app->draw_rect( $app_rect, 0x0 );

    app->draw_rect( $floor->rect,  [ 0,   255, 0, 255 ] );
    app->draw_rect( $jumper->rect, [ 255, 255, 0, 255 ] );

    app->update;

};

start;
