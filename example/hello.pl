use lib '../lib';
use Avenger title => 'Hello, World!';

my $rect = rect( 10, 10, 100, 100 );

move {
    $rect->x( $rect->x + 1 );
};

show {
    app->draw_rect( $rect, 0x112244FF );
    app->update;
};

start;
