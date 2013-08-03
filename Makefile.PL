# -*- perl -*-

use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME           => 'Apache::HideFileExtension',
    VERSION_FROM   => 'lib/Apache/HideFileExtension.pm',
    ABSTRACT_FROM  => 'lib/Apache/HideFileExtension.pm',
    AUTHOR         => 'OGATA Tetsuji <tetsuji.ogata at cpan.org>',
    PREREQ_PM      => {
        'Apache'                  => 0,
        'Apache::Constants'       => 0,
        'Apache::Table'           => 0,
    },
    PMLIBDIRS      => ["lib"],
    META_MERGE     => {
        resources => {
            license    => 'http://dev.perl.org/licenses/',
            bugtracker => 'https://github.com/xtetsuji/p5-Apache-HideFileExtension/issues',
            repository => 'git://github.com/xtetsuji/p5-Apache-HideFileExtension.git',
        },
    },
    LICENSE        => "perl",
    PL_FILES       => {},
    EXE_FILES      => [],
    dist           => {
        SUFFIX => 'gz',
        COMPRESS => 'gzip -9f',
    },
);

# TODO: Better ModPerl::MM than EUMM?
