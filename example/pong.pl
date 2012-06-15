use Avenger title => 'Pong!', dt => 0.1;

my $background = rect( 0, 0, app->w, app->h );
my $score = text();

my $paddle_speed = 5.5;

my $player1 = {
    paddle => rect( 10, app->h / 2, 10, 40 ),
    v_y    => 0,
    score  => 0,
};

my $player2 = {
    paddle => rect( app->w - 20, app->h / 2, 10, 40 ),
    v_y    => 0,
    score  => 0,
};

my $ball = {
    rect => rect( 0, 0, 10, 10 ),
    v_x  => -6,
    v_y  => 5,
};

# initialize positions
reset_game();

sub check_collision {
    my ($A, $B) = @_;

    return if $A->bottom < $B->top;
    return if $A->top    > $B->bottom;
    return if $A->right  < $B->left;
    return if $A->left   > $B->right;

    # if we got here, we have a collision!
    return 1;
}

sub reset_game {
    $ball->{rect}->x( app->w / 2 );
    $ball->{rect}->y( app->h / 2 );
}

event 'key_down' => sub {
    my $key = shift;

    if ($key eq 'down') {
        $player1->{v_y} = $paddle_speed;
    }
    elsif ($key eq 'up') {
        $player1->{v_y} = -$paddle_speed;
    }
};

event 'key_up' => sub {
    my $key = shift;
    if ($key eq 'up' or $key eq 'down') {
        $player1->{v_y} = 0;
    }
};

# player paddle movement
update {
    my ( $step, $app ) = @_;
    my $paddle = $player1->{paddle};

    $paddle->y( int($paddle->y + ( $player1->{v_y} * $step )) );
};

# AI paddle movement
update {
    my ( $step, $app ) = @_;
    my $paddle = $player2->{paddle};
    my $v_y = $player2->{v_y};

    if ( $ball->{rect}->y > $paddle->y ) {
        $player2->{v_y} = 2;
    }
    elsif ( $ball->{rect}->y < $paddle->y ) {
        $player2->{v_y} = -2;
    }
    else {
        $player2->{v_y} = 0;
    }

    $paddle->y( $paddle->y + ( $v_y * $step ) );
};

# ball movement
update {
    my $step = shift;
    my $ball_rect = $ball->{rect};

    $ball_rect->x( $ball_rect->x + ($ball->{v_x} * $step) );
    $ball_rect->y( $ball_rect->y + ($ball->{v_y} * $step) );

    # collision to the bottom of the screen
    if ( $ball_rect->bottom >= app->h ) {
        $ball_rect->bottom( app->h );
        $ball->{v_y} *= -1;
    }

    # collision to the top of the screen
    elsif ( $ball_rect->top <= 0 ) {
        $ball_rect->top( 0 );
        $ball->{v_y} *= -1;
    }

    # collision to the right: player 1 score!
    elsif ( $ball_rect->right >= app->w ) {
        $player1->{score}++;
        reset_game();
        return;
    }

    # collision to the left: player 2 score!
    elsif ( $ball_rect->left <= 0 ) {
        $player2->{score}++;
        reset_game();
        return;
    }

    # collision with player1's paddle
    elsif ( check_collision( $ball_rect, $player1->{paddle} )) {
        $ball_rect->left( $player1->{paddle}->right );
        $ball->{v_x} *= -1;
    }

    # collision with player2's paddle
    elsif ( check_collision( $ball_rect, $player2->{paddle} )) {
        $ball->{v_x} *= -1;
        $ball_rect->right( $player2->{paddle}->left );
    }
};

show {
    # first, we clear the screen
    app->draw_rect( [ 0, 0, app->w, app->h ], 0x000000 );

    # then we render the ball
    app->draw_rect( $ball->{rect}, 0xFF0000FF );

    # then we render each paddle
    app->draw_rect( $player1->{paddle}, 0xFF0000FF );
    app->draw_rect( $player2->{paddle}, 0xFF0000FF );

    # ... and each player's score!
    $score->write_to( app,
       $player1->{score} . ' x ' . $player2->{score}
    );

    # finally, we update the screen
    app->update;
};

start;
