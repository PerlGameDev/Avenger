package Avenger::Event;
use strict;
use warnings;

use SDL;
use SDL::Event;
use SDL::Events;

my %key_events = (
    key_up    => SDL_KEYUP,
    key_down  => SDL_KEYDOWN,
);

my %mouse_keypress = (
    mouse_key_down => SDL_MOUSEBUTTONDOWN,
    mouse_key_up   => SDL_MOUSEBUTTONUP,
);

my %mouse_buttons = (
    mouse_left       => SDL_BUTTON_LEFT,
    mouse_middle     => SDL_BUTTON_MIDDLE,
    mouse_right      => SDL_BUTTON_RIGHT,
    mouse_wheel_up   => SDL_BUTTON_WHEELUP,
    mouse_wheel_down => SDL_BUTTON_WHEELDOWN,
);

my %mouse_motion = (
    mouse_motion => SDL_MOUSEMOTION,
);

sub event {
    my ($name, $sub) = @_;


    # in key events we pass the key
    # name: 'left', 'up', 'a', '4', etc.
    if ($key_events{$name}) {
        return sub {
            my $event = shift;
            if ($event->type == $key_events{$name}) {
                $sub->( SDL::Events::get_key_name($event->key_sym, $event) );
            }
        };
    }
    # in general mouse key press events
    # we pass the button index and x/y positions
    elsif ($mouse_keypress{$name}) {
        return sub {
            my $event = shift;
            if ($event->type == $mouse_keypress{$name}) {
                $sub->( $event->button_button, $event->button_x, $event->button_y,  $event );
            }
        };
    }
    elsif ($mouse_buttons{$name}) {
        return sub {
            my $event = shift;
            if ($event->type == SDL_MOUSEBUTTONUP) {
                if ($event->button_button == $mouse_buttons{$name}) {
                    $sub->( $event->button_x, $event->button_y, $event );
                }
            }
        };
    }
    elsif ($mouse_motion{$name}) {
        return sub {
            my $event = shift;
            if ($event->type == $mouse_motion{$name}) {
                $sub->( $event->motion_x, $event->motion_y, $event->motion_xrel, $event->motion_yrel, $event );
            }
        };
    }
    else {
        require Carp;
        Carp::croak "unknown event: '$name'";
    }
}

'all your base are belong to us';
