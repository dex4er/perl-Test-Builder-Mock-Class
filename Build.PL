#!/usr/bin/perl

use 5.006;

use strict;
use warnings;

use Module::Build;

my $module = 'Test::Builder::Mock::Class';

(my $dist = $module) =~ s/::/-/g;

my $build = Module::Build->new(
    module_name => $module,
    license => 'lgpl',
    requires => {
        'perl'               => 5.006,
        'namespace::clean'   => 0,
        'Test::Mock::Class'  => 0.02,
        'Test::Builder'      => 0,
    },
    optional => {
    },
    build_requires => {
    },
    create_makefile_pl => 'traditional',
    create_readme => 1,
    create_license => 1,
    sign => 1,
    recursive_test_files => 1,
    add_to_cleanup => [
        '*.bak', '*.gz', '*.tgz', '*.ppd', '*.ppmx', '*.deb', '*.bat',
        'Makefile', 'pm_to_blib', 'cover_db', 'Debian_CPANTS.txt',
        "$dist-*",
    ],
    meta_merge => {
        resources => {
            bugtracker => "http://rt.cpan.org/NoAuth/Bugs.html?Dist=$dist",
            repository => "https://dexter-cpan.googlecode.com/svn/$dist",
        },
    },
);

$build->create_build_script;
