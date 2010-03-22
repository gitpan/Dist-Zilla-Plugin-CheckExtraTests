# 
# This file is part of Dist-Zilla-Plugin-CheckExtraTests
# 
# This software is Copyright (c) 2010 by David Golden.
# 
# This is free software, licensed under:
# 
#   The Apache License, Version 2.0, January 2004
# 
use strict;
use warnings;
package Dist::Zilla::Plugin::CheckExtraTests;
our $VERSION = '0.001';
# ABSTRACT: check xt tests before release

# Dependencies
use App::Prove 3.00 ();
use File::chdir 0.1002 ();
use Moose 0.99;
use namespace::autoclean 0.09;

# extends, roles, attributes, etc.

with 'Dist::Zilla::Role::BeforeRelease';

# methods

sub before_release {
  my $self = shift;

  # chdir in
  local $File::chdir::CWD = $self->zilla->ensure_built_in;
 
  # prove xt
  local $ENV{RELEASE_TESTING} = 1;
  my $app = App::Prove->new;
  $app->process_args(qw/-r -l -q xt/);
  $app->run or $self->log_fatal("Fatal errors in xt tests");
  return;
}

__PACKAGE__->meta->make_immutable;

1;



=pod

=head1 NAME

Dist::Zilla::Plugin::CheckExtraTests - check xt tests before release

=head1 VERSION

version 0.001

=head1 SYNOPSIS

In your dist.ini:

   [CheckExtraTests]

=head1 DESCRIPTION

Runs all xt tests before release.  Dies if any fail.  Sets RELEASE_TESTING,
but not AUTHOR_TESTING.

=for Pod::Coverage::TrustPod before_release

=head1 SEE ALSO

=over

=item *

L<Dist::Zilla>

=back

=head1 AUTHOR

  David Golden <dagolden@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2010 by David Golden.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut


__END__


