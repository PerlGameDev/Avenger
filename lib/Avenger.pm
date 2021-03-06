package Avenger;
# ABSTRACT: Simple and powerful game framework
use SDL;
use SDLx::App;
use SDL::Rect;
use SDLx::Rect;
use SDLx::Text;
#use SDLx::Audio;
use Avenger::Event;
use Avenger::World;
use File::ShareDir;
use Class::Unload;
use strict;
use warnings;

use Avenger::ContactListener;

my $app;
my $world;

sub import {
    my $class = shift;
    my %properties = (ref $_[0] ? %{$_[0]} : @_);
    my $caller = caller;

    # Avenger modules are strict & modern!
    strict->import;
    warnings->import;
    if ($] >= 5.010) {
        require feature;
        feature->import(':5.10');
    }

    unless ($app) {
        $app = SDLx::App->new(
            eoq => 1,
            flags => SDL_DOUBLEBUF | SDL_HWSURFACE,
            delay => 100,
            dt    => 0.02,
            %properties
        );
        $app->stash->{_avenger}{BASE} = $caller;
    }

    unless ($world) {
        $world = Avenger::World->new( app_h => $app->h );
      }

    my $start = sub {
        if ( my $state = shift ) {
            my $base = $app->stash->{_avenger}{BASE};

            my $class = "$base\::$state";
            eval "require $class";
            if ($@) {
                require Carp;
                Carp::croak "error loading $class: $@";
            }
            else {
                $class->startup(@_) if $class->can('startup');
            }
        }

      my $listener = Avenger::ContactListener->new();
        $world->{world}->SetContactListener( $listener );
        $app->run;



    };

    my $load = sub {
        $app->remove_all_handlers;
        Class::Unload->unload($caller);
        $start->(@_);
    };

    no strict 'refs';
    *{"${caller}::app"}   = sub {$app};
    *{"${caller}::start"} = $start;
    *{"${caller}::load"}  = $load;
    *{"${caller}::show"}  = sub (&) { $app->add_show_handler(@_) };
    *{"${caller}::update"}= sub (&) { $app->add_move_handler(@_) };
    *{"${caller}::event"} = sub     { $app->add_event_handler( Avenger::Event::event(@_)) };
    *{"${caller}::rect"}  = sub { SDLx::Rect->new(@_) };
    *{"${caller}::mouse"} = \&Avenger::Event::mouse;
    *{"${caller}::world"} = sub {$world};
    *{"${caller}::text"}  = sub { SDLx::Text->new(@_) };
}

sub data {
}

sub config {
}


'all your base are belong to us';
__END__

=head1 SYNOPSIS

Simple one-file game:

  use Avenger title => 'My Awesome Game!';

  update {
  };

  show {
  };

  event 'key_up' => sub {
  };

  start;

Or a more structured approach:

  package MyGame::MainScreen;
  use Avenger;

  update { ... };
  update { ... };
  show   { ... };

  1;

  package MyGame;
  use Avenger;

  app->config(
          ...
  );

  start 'MainScreen';


=head1 DESCRIPTION

Avenger is a simple and powerful framework for SDL game development.
It is something of a redesign of SDLx::App with a simpler interface
and more features, such as level dispatching, integrated physics (Box2D),
data loading/storing, widget integration and much more!

Avenger borrows features from some of the most popular game frameworks
out there, including Microsoft's XNA and Flixel. It aims to be very
easy to learn and provide all the building blocks that will enable you
to quickly make your game ideas turn to life.

=head1 FUNCTIONS

=head2 app

  app->title( 'My Awesome Game' );

Your main application object (SDLx::App).

=head2 start

=head2 start 'FirstScreen'

Starts the application. If your application has more than one screen
(one or more classes in your application's namespace) you may optionally
pass a parameter telling Avenger which screen should be loaded first,
effectively starting your application flow.

This keyword should be called at the very end of your program, once all
setup was made. At this point, Avenger takes over for you.

=head2 load 'ScreenName'

Unloads your current screen and loads the next one. If your base game
package is called 'MyGame', it will try to load 'MyGame::ScreenName'.

=head2 update { ... };

Creates a new (SDLx::App) motion handler.

=head2 show { ... };

Creates a new (SDLx::App) show handler.

=head2 event 'label' => sub { ... };

Creates a new (SDLx::App) event handler for the labelled event. Currently
available events are:

=head3 'key_up'

=head3 'key_down'

  event 'key_down' => sub {
      my ($key, $event) = @_;

      if ($key eq 'left') {
          ...
      }
      elsif ($key eq 'a') {
          ...
      }
  };

For key pressing events, your function will receive two arguments:
the key name, and the event object itself (in case you want to do
something more specific)

=head3 'mouse_key_up'

=head3 'mouse_key_down'

  event 'mouse_key_up' => sub {
      my ($button_index, $x, $y, $event) = @_;

      ...
  };

For mouse button pressing events, you'll get the button id, the
x and y position of the mouse when the button was pressed (or
released), and the event object.

If you want to check for specific mouse buttons, you can treat them
separately:

=head3 'mouse_left'

=head3 'mouse_middle'

=head3 'mouse_right'

=head3 'mouse_wheel_up'

=head3 'mouse_wheel_down'

  event 'mouse_right' => sub {
      my ($x, $y, $event);
      ...
  };

Those specific button events will be triggered B<only> when the button
is released. Also note that, since you know which button was pressed,
the only arguments are the x and y positions.

=head3 'mouse_motion'

  event 'mouse_motion' => sub {
      my ($x, $y, $x_rel, $y_rel, $event);
      ...
  };

Mouse motion events are obviously triggered whenever the mouse is moved.
Your function will receive the current x and y position of the mouse,
and an x/y position relative to the previous mouse position. As usual,
the last element is the event object itself.

=head2 rect

  my $rect = rect( $x, $y, $w, $h );

Convenience function that returns an SDL::Rect object.

=head2 mouse

 my ($x, $y) = mouse;

Convenience function that returns the current x/y position of the mouse
on the screen.
