use strict;
use warnings;
package Dist::Zilla::App::Command::xtest;
# ABSTRACT: run xt tests for your dist
our $VERSION = '0.009'; # VERSION
use Dist::Zilla::App -command;

use Moose::Autobox;


sub abstract { 'run xt tests for your dist' }

sub command_names {
  my ($self) = @_;
  return ( $self->SUPER::command_names, 'xt' );
}

sub execute {
  my ($self, $opt, $arg) = @_;

  require App::Prove;
  require File::pushd;
  require File::Temp;
  require Path::Tiny;

  my $build_root = Path::Tiny::path('.build');
  $build_root->mkpath unless -d $build_root;

  my $target = Path::Tiny::path( File::Temp::tempdir(DIR => $build_root) );
  $self->log("building test distribution under $target");

  local $ENV{AUTHOR_TESTING} = 1;
  local $ENV{RELEASE_TESTING} = 1;

  $self->zilla->ensure_built_in($target);

  my $wd = File::pushd::pushd( $target );

  my @builders = @{ $self->zilla->plugins_with(-BuildRunner) };
  die "no BuildRunner plugins specified" unless @builders;
  $builders[0]->build;

  my $error;

  my $app = App::Prove->new;
  if ( ref $arg eq 'ARRAY' && @$arg ) {
    require Path::Iterator::Rule;
    my $pcr = Path::Iterator::Rule->new->file->name(@$arg);
    my @t = map { "$_" } $pcr->all( 'xt' );
    if ( @t ) {
      $app->process_args(qw/-r -b/, @t) if @t;
      $error = "Failed xt tests" unless  $app->run;
    }
    else {
      $self->log("no xt files found matching: @$arg");
    }
  }
  else {
    $app->process_args(qw/-r -b xt/);
    $error = "Failed xt tests" unless  $app->run;
  }

  if ($error) {
    $self->log($error);
    $self->log("left failed dist in place at $target");
    exit 1;
  } else {
    $self->log("all's well; removing $target");
    $target->rmtree;
  }

}

1;

__END__

=pod

=head1 NAME

Dist::Zilla::App::Command::xtest - run xt tests for your dist

=head1 VERSION

version 0.009

=head1 SYNOPSIS

Run xt tests for your distribution:

  dzil xtest

This runs with AUTHOR_TESTING and RELEASE_TESTING environment variables turned
on, so it's like doing this:

  export AUTHOR_TESTING=1
  export RELEASE_TESTING=1
  dzil build
  rsync -avp My-Project-Version/ .build/
  cd .build;
  prove -l -r xt

Except for the fact it's built directly in a subdir of .build (like
F<.build/ASDF123>).

A build that fails tests will be left behind for analysis, and F<dzil> will
exit a non-zero value.  If the tests are successful, the build directory will
be removed and F<dzil> will exit with status 0.

You can also use 'xt' as an alias for 'xtest':

  dzil xt

If you provide one or more filenames on the command line, only
those tests will be run (however deeply they are nested).  Glob
patterns may also work, if you protect it from your shell.

  dzil xtest pod-spell.t
  dzil xtest 'dist*'          # don't expand to dist.ini

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
