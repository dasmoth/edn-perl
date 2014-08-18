use 5.014002;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'edn',
    VERSION_FROM      => 'lib/edn.pm', # finds $VERSION
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/edn.pm', # retrieve abstract from module
       AUTHOR         => '@dasmoth <thomas@biodalliance.org>') : ()),
#    LIBS              => ['-L/usr/local/lib/ -lorient'], # e.g., '-lm'
    DEFINE            => '', # e.g., '-DHAVE_SOMETHING'
#    INC               => '-I. -I/usr/local/include', # e.g., '-I. -I/usr/include/other'
    CCFLAGS           => '-Wall',   #Really want -std=c++11, but incompatible with current Perl headers.
    CC                => 'c++',
    LD                => 'c++',
    XSOPT             => '-C++',
#    'MYEXTLIB' => 'lib/c/libplorient$(LIB_EXT)',
	# Un-comment this if you add C files to link with later:
    # OBJECT            => '$(O_FILES)', # link all the C files too
);


# sub MY::postamble {
# '
# $(MYEXTLIB): lib/c/Makefile
#	cd lib/c && $(MAKE) $(PASSTHRU)
#';
# }
