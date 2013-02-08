use strict;
use warnings;
package Dist::Zilla::Plugin::CheckExtraTests;
# ABSTRACT: check xt tests before release
our $VERSION = '0.010'; # VERSION

# Dependencies
use Dist::Zilla 2.100950 (); # XXX really the next release after this date
use Moose 0.99;
use namespace::autoclean 0.09;

# extends, roles, attributes, etc.

with 'Dist::Zilla::Role::BeforeRelease';

# methods

sub before_release {
  my $self = shift;

  $self->zilla->ensure_built_in;

  # chdir in
  require File::pushd;
  my $wd = File::pushd::pushd($self->zilla->built_in);

  # make
  my @builders = @{ $self->zilla->plugins_with(-BuildRunner) };
  die "no BuildRunner plugins specified" unless @builders;
  $builders[0]->build;

  require App::Prove;
  App::Prove->VERSION('3.00');

  # prove xt
  local $ENV{RELEASE_TESTING} = 1;
  my $app = App::Prove->new;
  $app->process_args(qw/-r -b xt/);
  $app->run or $self->log_fatal("Fatal errors in xt tests");
  return;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 NAME

Dist::Zilla::Plugin::CheckExtraTests - check xt tests before release

=head1 VERSION

version 0.010

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

=for :stopwords cpan testmatrix url annocpan anno bugtracker rt cpants kwalitee diff irc mailto metadata placeholders metacpan

=head1 SUPPORT

=head2 Bugs / Feature Requests

Please report any bugs or feature requests through the issue tracker
at L<https://github.com/dagolden/dist-zilla-plugin-checkextratests/issues>.
You will be notified automatically of any progress on your issue.

=head2 Source Code

This is open source software.  The code repository is available for
public review and contribution under the terms of the license.

L<https://github.com/dagolden/dist-zilla-plugin-checkextratests>

  git clone git://github.com/dagolden/dist-zilla-plugin-checkextratests.git

=head1 AUTHORS

=over 4

=item *

David Golden <dagolden@cpan.org>

=item *

Jesse Luehrs <doy@cpan.org>

=back

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2013 by David Golden.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut
