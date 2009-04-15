#!/usr/bin/perl -c

package Test::Builder::Mock::Class::Role::Object;

=head1 NAME

Test::Builder::Mock::Class::Role::Object - Role for base object of mock class

=head1 DESCRIPTION

This role provides an API for changing behavior of mock class.

=cut

use 5.006;

use strict;
use warnings;

our $VERSION = '0.01';

use Moose::Role;

with 'Test::Mock::Class::Role::Object';


use Test::Builder;


use Exception::Base (
    '+ignore_package' => [__PACKAGE__],
);


=head1 ATTRIBUTES

=over

=item B<_mock_test_builder> : Test::Builder

The L<Test::Builder> singleton object.

=back

=cut

has '_mock_test_builder' => (
    is      => 'rw',
    default => sub { Test::Builder->new },
);


use namespace::clean -except => 'meta';


## no critic RequireCheckingReturnValueOfEval

=head1 METHODS

=over

=item <<around>> B<mock_tally>(I<>) : Self

Check the expectations at the end.  See L<Test::Mock::Class::Role::Object> for
more description.

The test passes if original C<mock_tally> method doesn't throw an exception.

=cut

around 'mock_tally' => sub {
    my ($next, $self) = @_;

    my $return = eval {
        $self->$next();
    };
    $self->_mock_test_builder->is_eq($@, '', 'mock_tally()');

    return $return;
};


=item <<around>> B<mock_invoke>( I<method> : Str, I<args> : Array ) : Any

Returns the expected value for the method name and checks expectations.  See
L<Test::Mock::Class::Role::Object> for more description.

The test passes if original C<mock_tally> method doesn't throw an exception.

=cut

around 'mock_invoke' => sub {
    my ($next, $self, $method, @args) = @_;

    my ($return, @return);
    eval {
        if (wantarray) {
            @return = $self->$next($method, @args);
        }
        else {
            $return = $self->$next($method, @args);
        };
    };
    $self->_mock_test_builder->is_eq($@, '', "mock_invoke($method)");

    return wantarray ? @return : $return;
};


1;


=back

=begin umlwiki

= Class Diagram =

[                                <<role>>
                    Test::Builder::Mock::Class::Role::Object
 -----------------------------------------------------------------------------
 #_mock_test_builder : Test::Builder
 -----------------------------------------------------------------------------
 +<<around>> mock_tally() : Self
 +<<around>> mock_invoke( method : Str, args : Array ) : Any
                                                                              ]

[Test::Builder::Mock::Class::Role::Object] ---|> [<<role>> Test::Mock::Class::Role::Object]

=end umlwiki

=head1 SEE ALSO

L<Test::Mock::Class>.

=head1 BUGS

The API is not stable yet and can be changed in future.

=head1 AUTHOR

Piotr Roszatycki <dexter@cpan.org>

=head1 LICENSE

Based on SimpleTest, an open source unit test framework for the PHP
programming language, created by Marcus Baker, Jason Sweat, Travis Swicegood,
Perrick Penet and Edward Z. Yang.

Copyright (c) 2009 Piotr Roszatycki <dexter@cpan.org>.

This program is free software; you can redistribute it and/or modify it
under GNU Lesser General Public License.
