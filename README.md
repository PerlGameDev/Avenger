Avenger
=======
![Logo](https://github.com/PerlGameDev/Avenger/raw/master/avenger_logo.png "Avenger Logo")

Avenger aims to be a simple and powerful framework for SDL game development.
It is something of a redesign of SDLx::App with a simpler interface
and more features, such as level dispatching, integrated physics (Box2D),
data loading/storing, widget integration and much more!

Basic Syntax:
-------------

    use Avenger title => 'My Awesome Game';

    my $rect = rect( 10, 10, 100, 100 );

    show {
        app->draw_rect( $rect );
        app->update;
    };

    start;


This is still pretty alpha, and the whole API is subject to change.

Have fun!
