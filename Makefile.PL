
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
                       'BUILD_REQUIRES' => {
                                             'Try::Tiny' => '0',
                                             'Test::More' => '0.88',
                                             'Capture::Tiny' => '0',
                                             'Params::Util' => '0',
                                             'File::Find' => '0',
                                             'Sub::Exporter' => '0',
                                             'Dist::Zilla::Tester' => '0',
                                             'Dist::Zilla::App::Tester' => '0'
                                           },
                       'ABSTRACT' => 'check xt tests before release',
                       'EXE_FILES' => [],
                       'VERSION' => '0.003',
                       'PREREQ_PM' => {
                                        'Dist::Zilla::App' => '0',
                                        'namespace::autoclean' => '0.09',
                                        'File::pushd' => '0',
                                        'Moose::Autobox' => '0',
                                        'File::Temp' => '0',
                                        'Dist::Zilla' => '2.100950',
                                        'Dist::Zilla::Role::BeforeRelease' => '0',
                                        'Path::Class' => '0',
                                        'App::Prove' => '3.00',
                                        'Moose' => '0.99'
                                      },
                       'LICENSE' => 'apache'
                     );


delete $WriteMakefileArgs{BUILD_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.56) };

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



