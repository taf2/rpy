# extconf.rb.in -> extconf.rb
# creates a Makefile to make python.so

require 'mkmf'

# Pass along Ruby's version number
VERSION_NUMBER = '0x'+RUBY_VERSION.tr('.','')

$CFLAGS = ""
$CPPFLAGS = "-DRUBY_VERSION=#{VERSION_NUMBER}  -I/usr/include/python2.5 -I/usr/include/python2.5 -fno-strict-aliasing -DNDEBUG -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m32 -march=i386 -mtune=generic -fasynchronous-unwind-tables -D_GNU_SOURCE -fPIC"

if RUBY_VERSION >= '1.8.0'
    $DLDFLAGS = " -lpthread -ldl -lutil -lm -lpython2.5"
    $CPPFLAGS = " -I/usr/include/python2.5 -I/usr/include/python2.5 -fno-strict-aliasing -DNDEBUG -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m32 -march=i386 -mtune=generic -fasynchronous-unwind-tables -D_GNU_SOURCE -fPIC"
else
    $LDFLAGS = " -lpthread -ldl -lutil -lm -lpython2.5"
    $CPPFLAGS = " -I/usr/include/python2.5 -I/usr/include/python2.5 -fno-strict-aliasing -DNDEBUG -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m32 -march=i386 -mtune=generic -fasynchronous-unwind-tables -D_GNU_SOURCE -fPIC"
end

$LOCAL_LIBS = "-lpthread -ldl -lutil -lm -lpython2.5"

# Force re-compilation if the generated Makefile or
# rpy_config.h changed.
$config_h = 'Makefile rpy_config.h'
dir_config("rpy")
have_library("c", "main")

create_makefile("rpy")
