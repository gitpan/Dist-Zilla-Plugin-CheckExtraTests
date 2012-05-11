use strict;
use warnings;
package Dist::Zilla::Plugin::RunExtraTests;
# ABSTRACT: support running xt tests via dzil test
our $VERSION = '0.006'; # VERSION

# Dependencies
use Dist::Zilla 2.100950 (); # XXX really the next release after this date
use App::Prove 3.00 ();
use Moose 0.99;
use namespace::autoclean 0.09;

# extends, roles, attributes, etc.

with 'Dist::Zilla::Role::TestRunner';

# methods

sub test {
  my $self = shift;

  my @dirs;
  push @dirs, 'xt/release' if $ENV{RELEASE_TESTING};
  push @dirs, 'xt/author'  if $ENV{AUTHOR_TESTING};
  push @dirs, 'xt/smoke'   if $ENV{AUTOMATED_TESTING};
  @dirs = grep { -d } @dirs;
  return unless @dirs;

  my @builders = @{ $self->zilla->plugins_with(-BuildRunner) };
  die "no BuildRunner plugins specified" unless @builders;
  $builders[0]->build;

  my $app = App::Prove->new;
  $app->process_args(qw/-r -b/, @dirs);
  $app->run or $self->log_fatal("Fatal errors in xt tests");
  return;
}

__PACKAGE__->meta->make_immutable;

1;



=pod

=head1 NAME

Dist::Zilla::Plugin::RunExtraTests - support running xt tests via dzil test

=head1 VERSION

version 0.006

=head1 SYNOPSIS

In your dist.ini:

   [RunExtraTests]

=head1 DESCRIPTION

Runs xt tests when CE<lt>dzil testE<gt> is run. CE<lt>xtE<sol>releaseE<gt>, CE<lt>xtE<sol>authorE<gt>, and
CE<lt>xtE<sol>smokeE<gt> will be tested based on the values of the appropriate environment
variables (CE<lt>RELEASE_TESTINGE<gt>, CE<lt>AUTHOR_TESTINGE<gt>, and CE<lt>AUTOMATED_TESTINGE<gt>),
which are set by CE<lt>dzil testE<gt>.

=for Pod::Coverage::TrustPod test

=head1 SEE ALSO

=over

=item *

L<Dist::Zilla>

=back

=head1 AUTHORS

=over 4

=item *

David Golden <dagolden@cpan.org>

=item *

Jesse Luehrs <doy@cpan.org>

=back

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by David Golden.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut


__END__


