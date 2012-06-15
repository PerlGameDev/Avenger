package Avenger::World;
use Box2D;
use Avenger::Body;
use strict;
use warnings;

sub new {
    my ($class, %args) = @_;
    my $self = bless {}, $class;

    my $gravity = Box2D::b2Vec2->new( @{ $args{gravity} || [0, 0] } );
    $self->{world} = Box2D::b2World->new( $gravity, 1 );
    $self->{app_h} = $args{app_h};

    return $self;
}

sub update {
    my ($self, $time_step, $velocity_i, $position_i) = @_;
    $time_step  ||= 0.02; #1.0/60.0;
    $velocity_i ||= 6;
    $position_i ||= 3;

    my $world = $_[0]->{world};
    $world->Step( $time_step, $velocity_i, $position_i );
    $world->ClearForces();
}

sub gravity {
    my ($self, @gravity) = @_;

    my $gravity = Box2D::b2Vec2->new( @gravity );
    $self->{world}->SetGravity( $gravity );
}

sub create_body {
    my ($self, %args) = @_;

    my $body = Avenger::Body->new($self->{world}, app_h => $self->{app_h}, %args);
    return $body;
}

sub create_dynamic {
    my ($self, %args) = @_;

    my $body = Avenger::Body->new(
         $self->{world},
         app_h => $self->{app_h},
         %args,
         type  => 'dynamic',
    );
    return $body;
}

sub create_static {
    my ($self, %args) = @_;

    my $body = Avenger::Body->new(
         $self->{world},
         app_h => $self->{app_h},
         %args,
         type  => 'static',
    );
    return $body;
}

'all your base are belong to us';
