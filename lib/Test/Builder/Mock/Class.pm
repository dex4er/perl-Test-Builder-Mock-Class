#!/usr/bin/perl -c

package Test::Builder::Mock::Class;

=head1 NAME

Test::Builder::Mock::Class - Simulating other classes with Test::Builder

=head1 SYNOPSIS

  use Test::Builder::Mock::Class ':all';
  mock_class 'Net::FTP' => 'Net::FTP::Mock';
  my $mock_object = Net::FTP::Mock->new;

  # anonymous mocked class
  my $metamock = mock_anon_class 'Net::FTP';
  my $mock_object = $metamock->new_object;

=head1 DESCRIPTION

This module adds support for standard L<Test::Builder> framework
(L<Test::Simple> or L<Test::More>) to L<Test::Mock::Class>.

Mock class can be used to create mock objects which can simulate the behavior
of complex, real (non-mock) objects and are therefore useful when a real
object is impractical or impossible to incorporate into a unit test.

=for readme stop

=cut

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Moose;



=head1 INHERITANCE

=over

=item extends L<Moose::Meta::Class>

=cut

extends 'Moose::Meta::Class';

=item with L<Test::Builder::Mock::Class::Role::Meta::Class>

=back

=cut

with 'Test::Builder::Mock::Class::Role::Meta::Class';


use namespace::clean -except => 'meta';


=head1 FUNCTIONS

=over

=cut

BEGIN {
    my %exports = ();

=item mock_class(I<class> : Str, I<mock_class> : Str = undef) : Moose::Meta::Class

Creates the concrete mock class based on original I<class>.  If the name of
I<mock_class> is undefined, its name is created based on name of original
I<class> with added C<::Mock> suffix.

The function returns the metaclass object of new I<mock_class>.

=cut

    $exports{mock_class} = sub {
        sub ($;$) {
            return __PACKAGE__->create_mock_class(
                defined $_[1] ? $_[1] : $_[0] . '::Mock',
                class => $_[0],
            );
        };
    };

=item mock_anon_class(I<class> : Str) : Moose::Meta::Class

Creates an anonymous mock class based on original I<class>.  The name of this
class is automatically generated.

The function returns the metaobject of new mock class.

=back

=cut

    $exports{mock_anon_class} = sub {
        sub ($) {
            return __PACKAGE__->create_mock_anon_class(
                class => $_[0],
            );
        };
    };

=head1 IMPORTS

=over

=cut

    my %groups = ();

=item Test::Builder::Mock::Class ':all';

Imports all functions into caller's namespace.

=back

=cut

    $groups{all} = [ keys %exports ];

    require Sub::Exporter;
    Sub::Exporter->import(
        -setup => {
            exports => [ %exports ],
            groups => \%groups,
        },
    );
};


1;


=begin umlwiki

= Class Diagram =

[                          <<utility>>
                    Test::Builder::Mock::Class
 -----------------------------------------------------------------------
 -----------------------------------------------------------------------
 mock_class(class : Str, mock_class : Str = undef) : Moose::Meta::Class
 mock_anon_class(class : Str) : Moose::Meta::Class
                                                                        ]

=end umlwiki

=head1 SEE ALSO

Mock metaclass API: L<Test::Builder::Mock::Class::Role::Meta::Class>,
L<Moose::Meta::Class>.

Mock object methods: L<Test::Builder::Mock::Class::Role::Object>.

Perl standard testing: L<Test::Builder>, L<Test::More>, L<Test::Simple>.

Mock classes for L<Test::Unit::Lite>: L<Test::Mock::Class>.

Other implementations: L<Test::MockObject>, L<Test::MockClass>.

=head1 BUGS

The API is not stable yet and can be changed in future.

=for readme continue

=head1 AUTHOR

Piotr Roszatycki <dexter@cpan.org>

=head1 LICENSE

Based on SimpleTest, an open source unit test framework for the PHP
programming language, created by Marcus Baker, Jason Sweat, Travis Swicegood,
Perrick Penet and Edward Z. Yang.

Copyright (c) 2009 Piotr Roszatycki <dexter@cpan.org>.

This program is free software; you can redistribute it and/or modify it
under GNU Lesser General Public License.
