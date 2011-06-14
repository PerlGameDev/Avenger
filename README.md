Avenger
=======

Avenger is a simple and powerful framework for SDL games development.
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
