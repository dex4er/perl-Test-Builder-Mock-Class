#!/usr/bin/perl

use strict;
use warnings;

use Carp ();

$SIG{__WARN__} = sub { local $Carp::CarpLevel = 1; Carp::confess("Warning: ", @_) };

use Test::More tests => 12;

use constant::boolean;

BEGIN { use_ok 'Test::Builder::Mock::Class', ':all' };

eval {
    mock_class 'IO::File' => 'IO::File::Mock';
};
SKIP: {
    skip 'mock_class failed', 10
        unless is($@, '', 'mock_class');

    my $io = IO::File::Mock->new;
    $io->mock_return( open => TRUE, args => [qr//, 'r'] );
    $io->mock_return( open => undef, args => [qr//, 'w'] );
    $io->mock_return_at( 0, getline => 'root:x:0:0:root:/root:/bin/bash' );
    $io->mock_expect_never( 'close' );

    # ok
    ok( $io->open('/etc/passwd', 'r'), '$io->open' );

    # first line
    like( $io->getline, qr/^root:[^:]*:0:0:/, '$io->getline' );

    # eof
    is( $io->getline, undef, '$io->getline' );

    # access denied
    ok( ! $io->open('/etc/passwd', 'w'), '$io->open' );

    # close was not called
    $io->mock_tally;
};
