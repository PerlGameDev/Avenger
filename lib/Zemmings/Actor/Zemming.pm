package Zemmings::Actor::Zemming;
use parent 'Avenger::Actor';

setup {
    my $self = shift;
    $self->body->velocity = 5;
    $self->body->y = 600;
    $self->body->x = 100;
};

event 'tick' => sub {
    my $self   = shift;
    my $event  = shift;
    my @actors = @_;
    $self->draw('right') if $self->body->velocity > 0;
    $self->draw('stop')  if $self->body->velocity == 0;
    $self->draw('left')  if $self->body->velocity < 0;
};

event 'hit' => sub {
    my $self   = shift;
    my $event  = shift;
    my @actors = @_;

    return unless @actors;

    if ( $actor->body->x > $self->body->x ) {
        $self->body->velocity(-5);
    }
    else {
        $self->body->velocity(5);

    }

};

draw {
    'right' => { [ [ 0, 0, 10, 10 ], [ 255, 0,   255, 255 ] ] },
    'stop'  => { [ [ 0, 0, 10, 10 ], [ 0,   255, 0,   255 ] ] },
    'left'  => { [ [ 0, 0, 10, 10 ], [ 0,   0,   255, 255 ] ] }
};

1;
