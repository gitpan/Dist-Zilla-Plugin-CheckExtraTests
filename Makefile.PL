
use strict;
use warnings;



use ExtUtils::MakeMaker 6.11;



my %WriteMakefileArgs = (
                       'test' => {
                                   'TESTS' => 't/*.t'
                                 },
                       'NAME' => 'Dist::Zilla::Plugin::CheckExtraTests',
                       'DISTNAME' => 'Dist-Zilla-Plugin-CheckExtraTests',
                       'CONFIGURE_REQUIRES' => {
                                                 'ExtUtils::MakeMaker' => '6.11'
                                               },
                       'AUTHOR' => 'David Golden <dagolden@cpan.org>',
                       'BUILD_REQUIRES' => {},
                       'ABSTRACT' => 'check xt tests before release',
                       'EXE_FILES' => [],
                       'VERSION' => '0.002',
                       'PREREQ_PM' => {
                                        'namespace::autoclean' => '0.09',
                                        'Dist::Zilla::App' => '0',
                                        'Test::Exception' => '0',
                                        'Capture::Tiny' => '0',
                                        'File::chdir' => '0.1002',
                                        'Moose::Autobox' => '0',
                                        'Test::More' => '0',
                                        'File::Find' => '0',
                                        'Dist::Zilla' => '1.093250',
                                        'File::Temp' => '0',
                                        'Path::Class' => '0',
                                        'Dist::Zilla::Role::BeforeRelease' => '0',
                                        'App::Prove' => '3.00',
                                        'Moose' => '0.99'
                                      },
                       'LICENSE' => 'apache'
                     );


delete $WriteMakefileArgs{LICENSE}
  unless eval { ExtUtils::MakeMaker->VERSION(6.31) };

WriteMakefile(%WriteMakefileArgs);



