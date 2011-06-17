package Avenger::Body;
use Box2D;
use SDL;
use SDL::Rect;
use strict;
use warnings;

sub new {
    my ($class, $world, %args) = @_;

    my $width    = $args{width}    || $args{w} || 20;
    my $height   = $args{height}   || $args{h} || 20;
    my $x        = $args{x}        || 0;
    my $y        = $args{y}        || 0;
    my $type     = $args{type}     || 'static';
    my $density;
    my $friction = $args{friction} || 0.3;
    my $half_w   = $width  / 2;
    my $half_h   = $height / 2;
    
    my $body_def = Box2D::b2BodyDef->new;
    $body_def->position->Set( $x, $y );
    if ($type ne 'static' ) {
        $body_def->type( Box2D::b2_dynamicBody );
        $density = $args{density} || 1.0;
    }

    my $body = $world->CreateBody( $body_def );

    my $box = Box2D::b2PolygonShape->new;
    $box->SetAsBox( $half_w, $half_h );

    my $fixture = Box2D::b2FixtureDef->new;
    $fixture->shape( $box );

    $fixture->density($density) if $density;
    $fixture->friction($friction);
    $body->CreateFixtureDef( $fixture );

    return bless {
        _body   => $body,
        _width  => $width,
        _height => $height,
        _half_w => $half_w,
        _half_h => $half_h,
        _app_h  => $args{app_h},
    }, $class;
}

sub w { return $_[0]->{_width}  }
sub h { return $_[0]->{_height} }


sub position {
    my ($self, @pos) = @_;
    my $body = $self->{_body};

    my $position = $body->GetPosition;
    my ($x, $y) = ( $position->x(), $position->y() );

    if (@pos) {
        $x ||= $pos[0];
        $y ||= $pos[1];
        my $angle = $body->GetAngle();
        my $vec = Box2D::b2Vec2->new($x,$y);
        $body->SetTransform( $vec, $angle );
    }
    return ($x, $y);
}

sub y {
    my $pos = $_[0]->{_body}->GetPosition;
    return $pos->y;
}

sub x {
    my $pos = $_[0]->{_body}->GetPosition;
    return $pos->x;
}

sub velocity {
    my ($self, @vel) = @_;
    if (@vel) {
        my $vel = Box2D::b2Vec2->new(@vel);
        $self->{_body}->SetLinearVelocity($vel);
    }
    my $velocity = $self->{_body}->GetLinearVelocity();
    return ($velocity->x, $velocity->y);
}

sub rect {
    my $self = shift;
    my $pos = $self->{_body}->GetPosition;
    my ($x, $y) = ($pos->x(), $pos->y() );
    return SDL::Rect->new( $x - $self->{_half_w},
                           $self->{_app_h} - $y - $self->{_half_h},
                           $self->{_width},
                           $self->{_height}
    );
}

'all your base are belong to us';
