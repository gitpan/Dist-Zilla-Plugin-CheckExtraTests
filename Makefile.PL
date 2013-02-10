
use strict;
use warnings;

use 5.006;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "check xt tests before release",
  "AUTHOR" => "David Golden <dagolden\@cpan.org>, Jesse Luehrs <doy\@cpan.org>",
  "BUILD_REQUIRES" => {
    "Capture::Tiny" => 0,
    "Dist::Zilla::App::Tester" => 0,
    "Dist::Zilla::Tester" => 0,
    "File::Find" => 0,
    "Params::Util" => 0,
    "Sub::Exporter" => 0,
    "Test::More" => "0.88",
    "Test::Requires" => 0,
    "Try::Tiny" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Dist-Zilla-Plugin-CheckExtraTests",
  "EXE_FILES" => [],
  "LICENSE" => "apache",
  "NAME" => "Dist::Zilla::Plugin::CheckExtraTests",
  "PREREQ_PM" => {
    "App::Prove" => "3.00",
    "Dist::Zilla" => "4.3",
    "Dist::Zilla::App" => 0,
    "Dist::Zilla::Role::BeforeRelease" => 0,
    "Dist::Zilla::Role::TestRunner" => 0,
    "File::Temp" => 0,
    "File::pushd" => 0,
    "Moose" => "0.99",
    "Moose::Autobox" => 0,
    "Path::Iterator::Rule" => 0,
    "Path::Tiny" => 0,
    "namespace::autoclean" => "0.09",
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "0.011",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



