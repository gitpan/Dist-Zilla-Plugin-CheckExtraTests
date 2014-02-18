use strict;
use warnings;
use Test::More;

# generated by Dist::Zilla::Plugin::Test::PodSpelling 2.006002
use Test::Spelling 0.12;
use Pod::Wordlist;


add_stopwords(<DATA>);
all_pod_files_spelling_ok( qw( bin lib  ) );
__DATA__
xt
David
Golden
dagolden
Jesse
Luehrs
doy
Christopher
Madsen
cjm
Karen
Etheridge
ether
Olivier
Mengue
dolmen
Ricardo
Signes
rjbs
lib
Dist
Zilla
Plugin
CheckExtraTests
RunExtraTests
App
Command
xtest
