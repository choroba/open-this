#!/usr/bin/env perl

use strict;
use warnings;

use Open::This qw( to_editor_args );
use Test::Differences qw( eq_or_diff );
use Test::More;
use Test::Warnings ();

# This gets really noisy on CI if $ENV{EDITOR} is not set
local $ENV{EDITOR} = 'vim';

local $ENV{PATH} = 't/lib:t/bin';

is( Open::This::_which('foo'),      undef, 'binary not found' );
is( Open::This::_which('bin/date'), undef, 'binary with dir not found' );

eq_or_diff(
    [ to_editor_args('datex') ], [],
    'to_editor_args binary not found'
);

SKIP: {
    skip 'Fails on Windows', 2, if $^O eq 'MSWin32';

    is( Open::This::_which('date'), 't/bin/date', 'binary found' );

    eq_or_diff(
        [ to_editor_args('date') ],
        ['t/bin/date'],
        'to_editor_args'
    );
}

done_testing();
