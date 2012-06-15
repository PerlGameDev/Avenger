package Avenger::ContactListener;
use Box2D;

use base qw(Box2D::b2ContactListener);

sub BeginContact {
    my ( $self, $contact ) = @_;

# Do something
}

sub EndContact {
    my ( $self, $contact ) = @_;

# Do something
}

sub PreSolve {
    my ( $self, $contact, $manifold ) = @_;

# Do something
}

sub PostSolve {
    my ( $self, $contact, $impulse ) = @_;
                                       my $body_a = $contact->GetFixtureA()->GetUserData()->{parent};       
                                       my $body_b = $contact->GetFixtureB()->GetUserData()->{parent};       
                                        #callback to each bodies collide 
                                        $body_a->collided( $body_b, $contact, $c_impulse);
                                        $body_b->collided( $body_a, $contact, $c_impulse);
# Do something
}



1;
