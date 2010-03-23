#!perl
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

use Dist::Zilla     1.093250;
use Capture::Tiny qw/capture/;
use Path::Class;
use Test::More      tests => 1;
use Test::Exception;

# build fake repository
chdir( dir('t', 'check-pass') );
dir('xt')->mkpath;
my $t_fh = file("xt/pass.t")->openw;
print {$t_fh} << 'HERE';
use Test::More tests => 1;
pass("destined to pass");
HERE
close $t_fh;

my $zilla = Dist::Zilla->from_config;

# pass xt test
my ($out, $err) = capture { eval { $zilla->release} };
is( $@, q{}, "doesn't die" );

END { unlink 'Foo-1.23.tar.gz'; dir('Foo-1.23')->rmtree; dir("xt")->rmtree };
