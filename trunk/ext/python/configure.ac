# Copyright (c) 2007 Todd A. Fisher
# You can redistribute it and/or modify it under the same terms as Mozilla Public License 1.1.
#
# based on the rmagick configure script

AC_INIT(rpy, 0.1, todd.fisher@gmail.com, rpy.0.1.tar.gz)
echo "Configuring ${PACKAGE_STRING}"

AC_CONFIG_HEADER([rpy_config.h])

# Save caller's CFLAGS before configure changes it.
rm_saved_CFLAGS=${CFLAGS}

# Check for required programs
AC_PROG_CC
AC_PROG_CC_STDC
AC_PATH_PROG(RUBY, ruby,)
if test -z "$RUBY"; then
  AC_MSG_ERROR([Can't install rpython. Ruby must be installed first.])
fi
AC_PATH_PROG(PYTHON, python,)
if test -z "$PYTHON"; then
  AC_MSG_ERROR([Can't install rpython. Python must be installed first.])
fi
AC_PATH_PROG(PYTHON_CONFIG, python-config,)
if test -z "$PYTHON_CONFIG"; then
  AC_MSG_ERROR([Can't install rpython. python-config must be installed first. This usually comes with the development package of python.])
fi

# Append ***Magick's lists of flags to the user's lists (if any)
LDFLAGS="${LDFLAGS} `${PYTHON_CONFIG} --ldflags`"
CPPFLAGS="${CPPFLAGS} `${PYTHON_CONFIG} --cflags`"

AC_SUBST(LDFLAGS, ${LDFLAGS})
AC_SUBST(CFLAGS, ${rm_saved_CFLAGS})
AC_SUBST(CPPFLAGS, ${CPPFLAGS})
AC_SUBST(LOCAL_LIBS, `${PYTHON_CONFIG} --libs`)

PYTHONLIB=`${PYTHON_CONFIG} --libs`

AC_SUBST(PYTHONLIB)
AC_SUBST(PYTHON_CONFIG)

# What standard functions?
AC_CHECK_FUNCS([snprintf])
AC_CHECK_HEADERS(sys/types.h)

# Append ***Python's lists of libs to the user's list (if any)
LIBS="${LIBS} `${PYTHON_CONFIG} --libs`"

# What Python functions?
AC_CHECK_FUNCS([Py_SetProgramName Py_Initialize PySys_SetArgv PyRun_SimpleString Py_Exit])

AC_CACHE_CHECK(for Python Libraries, rm_cv_python,
  [AC_TRY_COMPILE(
[#include "Python.h"],
     [ Py_SetProgramName("test");  Py_Initialize();  Py_Exit(0); ],
     rm_cv_python='yes',
     rm_cv_python='no')])

if test "$rm_cv_python" = yes; then
  AC_DEFINE(HAVE_RUNNABLE_PYTHON)
fi

# Where is ****Python installed?
PYTHONPREFIX=`${PYTHON_CONFIG} --prefix`

# Options to pass to ruby config step

RUBY_CONFIG_OPTS=''

if test "x$prefix" != xNONE; then
  RUBY_CONFIG_OPTS="$RUBY_CONFIG_OPTS --prefix=$prefix"
fi
if test `eval echo $bindir` != NONE/bin; then
  RUBY_CONFIG_OPTS="$RUBY_CONFIG_OPTS --bin-dir=`eval echo $bindir`"
fi
if test `eval echo $datadir` != ${prefix}/share; then
  RUBY_CONFIG_OPTS="$RUBY_CONFIG_OPTS --data-dir=`eval echo $datadir`"
fi

AC_ARG_WITH(ruby-prog,
    AS_HELP_STRING([--with-ruby-prog=NAME], [the ruby program used for installation [[PREFIX/bin/ruby]]]),
    [RUBY_CONFIG_OPTS="$RUBY_CONFIG_OPTS --ruby-prog=$withval"
     RUBY=$withval], )

AC_ARG_WITH(rbconfig,
    AS_HELP_STRING([--with-rbconfig=PATH], [your rbconfig to load [[ruby's]]]),
    [RUBY_CONFIG_OPTS="$RUBY_CONFIG_OPTS --rbconfig=$withval"], )

AC_ARG_WITH(doc-dir,
    AS_HELP_STRING([--with-doc-dir=DIR], [RMagick documentation directory [[PREFIX/share/RMagick]]]),
    [RUBY_CONFIG_OPTS="$RUBY_CONFIG_OPTS --doc-dir=$withval"], )

AC_ARG_WITH(std-ruby,
    AS_HELP_STRING([--with-std-ruby=DIR], [the directory for standard ruby libraries [[PREFIX/lib/ruby/1.x]]]),
    [RUBY_CONFIG_OPTS="$RUBY_CONFIG_OPTS --std-ruby=$withval"], )

AC_ARG_WITH(site-ruby,
    AS_HELP_STRING([--with-site-ruby=DIR], [the directory for non-standard ruby libraries [[PREFIX/lib/ruby/site_ruby/1.x]]]),
    [RUBY_CONFIG_OPTS="$RUBY_CONFIG_OPTS --site-ruby=$withval"], )

AC_ARG_WITH(site-ruby-common,
    AS_HELP_STRING([--with-site-ruby-common=DIR], [the directory for version-independent non-standard ruby libraries [[PREFIX/lib/ruby/site_ruby]]]),
    [RUBY_CONFIG_OPTS="$RUBY_CONFIG_OPTS --site-ruby-common=$withval"], )

AC_ARG_WITH(rb-dir,
    AS_HELP_STRING([--with-rb-dir=DIR], [the directory for ruby scripts [[PREFIX/lib/ruby/site_ruby/1.x]]]),
    [RUBY_CONFIG_OPTS="$RUBY_CONFIG_OPTS --rb-dir=$withval"], )

AC_ARG_WITH(so-dir,
    AS_HELP_STRING([--with-so-dir=DIR], [the directory for ruby extensions]),
    [RUBY_CONFIG_OPTS="$RUBY_CONFIG_OPTS --so-dir=$withval"], )

AC_ARG_WITH(ruby-path,
    AS_HELP_STRING([--with-ruby-path=DIR], [path to set to #! line [PREFIX/bin/ruby]]),
    [RUBY_CONFIG_OPTS="$RUBY_CONFIG_OPTS --ruby-path=$withval"], )

AC_ARG_WITH(make-prog,
    AS_HELP_STRING([--with-make-prog=NAME], [the make program to compile ruby extensions [[make]]]),
    [RUBY_CONFIG_OPTS="$RUBY_CONFIG_OPTS --make-prog=$withval"], )

AC_ARG_ENABLE(without-ext,
    AS_HELP_STRING([--enable-without-ext], [does not compile/install ruby extensions [[--disable-without-ext]]]),
    [RUBY_CONFIG_OPTS="$RUBY_CONFIG_OPTS --without-ext"], )

AC_ARG_ENABLE(no-harm,
    AS_HELP_STRING([--enable-no-harm], [only display what to do if given [[--disable-no-harm]]]),
    [RUBY_CONFIG_OPTS="$RUBY_CONFIG_OPTS --no-harm"], )

AC_ARG_ENABLE(allow-example-errors,
    AS_HELP_STRING([--enable-allow-example-errors], [allow installation to proceed even if a lot of examples fail [[--disable-allow-example-errors]]]),
    [RUBY_CONFIG_OPTS="$RUBY_CONFIG_OPTS --allow-example-errors"], )

AC_ARG_ENABLE(htmldoc,
    AS_HELP_STRING([--disable-htmldoc], [skip creating the HTML documentation and examples [[--enable-htmldoc]]]),
    [if test "$enable_htmldoc" = no; then
        RUBY_CONFIG_OPTS="$RUBY_CONFIG_OPTS --disable-htmldoc"
     fi], )


PYTHON="`$PYTHON_CONFIG --exec-prefix`/bin/python"
$PYTHON --version 2>py.tmp
version=`cat py.tmp` 
rm py.tmp
PYTHON_VERSION_STRING=$version
RUBY_VERSION_STRING=`$RUBY --version`
AC_DEFINE_UNQUOTED(RUBY_VERSION_STRING, "$RUBY_VERSION_STRING")
AC_DEFINE_UNQUOTED(PYTHON_VERSION_STRING, "$PYTHON_VERSION_STRING")
AC_SUBST(PYTHON)
AC_SUBST(RUBY)
AC_SUBST(RUBY_CONFIG_OPTS)

AC_CONFIG_FILES(extconf.rb)
AC_OUTPUT

echo ""
echo ""
echo "This installation of $PACKAGE_STRING is configured for"
echo "$RUBY_VERSION_STRING and ${PYTHON_VERSION_STRING}."
