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
package Dist::Zilla::App::Command::xtest;
our $VERSION = '0.002';
# ABSTRACT: run xt tests for your dist
use Dist::Zilla::App -command;

use Moose::Autobox;


sub abstract { 'test your dist' }

sub execute {
  my ($self, $opt, $arg) = @_;

  require App::Prove;
  require File::chdir;
  require File::Temp;
  require Path::Class;

  my $build_root = Path::Class::dir('.build');
  $build_root->mkpath unless -d $build_root;

  my $target = Path::Class::dir( File::Temp::tempdir(DIR => $build_root) );
  $self->log("building test distribution under $target");

  local $ENV{AUTHOR_TESTING} = 1;
  local $ENV{RELEASE_TESTING} = 1;

  $self->zilla->ensure_built_in($target);

  local $File::chdir::CWD = $target;

  my $error;

  my $app = App::Prove->new;
  $app->process_args(qw/-r -l xt/);
  $error = "Failed xt tests" unless  $app->run;

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

version 0.002

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

=head1 AUTHOR

  David Golden <dagolden@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2010 by David Golden.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut

