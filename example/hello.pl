use lib '../lib';
use Avenger title => 'Hello, World!';

my $rect = rect( 10, 10, 100, 100 );
my $app_rect = rect( 0, 0, app->w, app->h);
move {
    $rect->x( $rect->x + 1 );
};

show {
	app->draw_rect( $app_rect, 0x0 );
    app->draw_rect( $rect, 0x112244FF );
    app->update;
};

start;
