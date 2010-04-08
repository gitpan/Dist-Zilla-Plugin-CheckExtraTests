
use strict;
use warnings;



use ExtUtils::MakeMaker 6.31;



my %WriteMakefileArgs = (
                       'test' => {
                                   'TESTS' => 't/*.t'
                                 },
                       'NAME' => 'Dist::Zilla::Plugin::CheckExtraTests',
                       'DISTNAME' => 'Dist-Zilla-Plugin-CheckExtraTests',
                       'CONFIGURE_REQUIRES' => {
                                                 'ExtUtils::MakeMaker' => '6.31'
                                               },
                       'AUTHOR' => 'David Golden <dagolden@cpan.org>',
                       'BUILD_REQUIRES' => {},
                       'ABSTRACT' => 'check xt tests before release',
                       'EXE_FILES' => [],
                       'VERSION' => '0.004',
                       'PREREQ_PM' => {
                                        'Capture::Tiny' => '0',
                                        'Sub::Exporter' => '0',
                                        'Dist::Zilla::Tester' => '2',
                                        'Params::Util' => '1',
                                        'Moose' => '0',
                                        'Try::Tiny' => '0',
                                        'namespace::autoclean' => '0',
                                        'Dist::Zilla::App' => '2',
                                        'File::pushd' => '1',
                                        'Dist::Zilla::App::Tester' => '2',
                                        'Moose::Autobox' => '0',
                                        'Test::More' => '0.88',
                                        'Dist::Zilla' => '2',
                                        'File::Temp' => '0.20',
                                        'Dist::Zilla::Role::BeforeRelease' => '2',
                                        'Path::Class' => '0',
                                        'App::Prove' => '3'
                                      },
                       'LICENSE' => 'apache'
                     );


delete $WriteMakefileArgs{BUILD_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.56) };

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



