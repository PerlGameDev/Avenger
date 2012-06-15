package Avenger::ContactListener;
use Box2D;

use base qw(Box2D::b2ContactListener);

sub BeginContact {
    my ( $self, $contact ) = @_;

    my $body_a = $contact->GetFixtureA()->GetUserData()->{parent};
    my $body_b = $contact->GetFixtureB()->GetUserData()->{parent};

    #callback to each bodies collide
    $body_a->collided->{begin}->( $body_b, $contact, $c_impulse );
    $body_b->collided->{begin}->( $body_a, $contact, $c_impulse );

    # Do something
}

sub EndContact {
    my ( $self, $contact ) = @_;

    my $body_a = $contact->GetFixtureA()->GetUserData()->{parent};
    my $body_b = $contact->GetFixtureB()->GetUserData()->{parent};

    #callback to each bodies collide
    $body_a->collided->{end}->( $body_b, $contact, $c_impulse );
    $body_b->collided->{end}->( $body_a, $contact, $c_impulse );

    # Do something
}

sub PreSolve {
    my ( $self, $contact, $manifold ) = @_;
    my $body_a = $contact->GetFixtureA()->GetUserData()->{parent};
    my $body_b = $contact->GetFixtureB()->GetUserData()->{parent};

    #callback to each bodies collide
    $body_a->collided->{postsolve}->( $body_b, $contact, $c_impulse );
    $body_b->collided->{postsolve}->( $body_a, $contact, $c_impulse );

    # Do something
}

sub PostSolve {
    my ( $self, $contact, $impulse ) = @_;
    my $body_a = $contact->GetFixtureA()->GetUserData()->{parent};
    my $body_b = $contact->GetFixtureB()->GetUserData()->{parent};

    #callback to each bodies collide
    $body_a->collided->{postsolve}->( $body_b, $contact, $c_impulse );
    $body_b->collided->{postsolve}->( $body_a, $contact, $c_impulse );

    # Do something
}

1;
