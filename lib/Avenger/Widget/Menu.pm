package Avenger::Widget::Menu;
use Avenger;
use SDLx::Widget::Menu;

sub import {
    my $caller = caller;

    no strict 'refs';
    *{"${caller}::menu"} = sub (&;$) {
        my ($sub, $options) = @_;
        my %menu_items = $sub->(); use DDP; p %menu_items;

        my $menu = SDLx::Widget::Menu->new( $options || {} )->items( %menu_items );

        app->add_event_handler( sub { $menu->event_hook( shift ) } );

        show { $menu->render( app ) };
    };
}


'all your base are belong to us'

__END__
=head1 NAME

Avenger::Widget::Menu - add menus for your avenger games

=head1 SYNOPSIS

    package MyGame::MainScreen;
    use Avenger;
    use Avenger::Widget::Menu;

    menu {
        'New Game' => sub { start 'AnotherScreen' },
        'Quit'     => \&finish,
    };

    # or a more custom approach
    menu {
        'New Game' => sub { start 'AnotherScreen' },
        'Quit'     => \&finish,
    } => {
       topleft      => [100, 120],
       h_align      => 'right',
       spacing      => 10,
       mouse        => 1,
       font         => 'mygame/data/menu_font.ttf',
       font_size    => 20,
       font_color   => [255, 0, 0], # RGB (in this case, 'red')
       select_color => [0, 255, 0],
       active_color => [0, 0, 255],
       change_sound => 'game/data/menu_select.ogg',
    };


