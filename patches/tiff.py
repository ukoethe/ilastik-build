import sys, re

filename = sys.argv[1] + '/nmake.opt'
prefix   = sys.argv[2]
print "    patching ", filename

s = open(filename).read()

# enable support for JPEG and ZIP compression
s = re.sub('#JPEG_SUPPORT', 'JPEG_SUPPORT', s)
s = re.sub(r'#JPEG_INCLUDE.*', 'JPEG_INCLUDE = -I%s/include' % prefix, s)
s = re.sub(r'#JPEG_LIB.*', 'JPEG_LIB = %s/lib/jpeg.lib' % prefix, s)

s = re.sub('#ZIP_SUPPORT', 'ZIP_SUPPORT', s)
s = re.sub(r'#ZLIB_INCLUDE.*', 'ZLIB_INCLUDE = -I%s/include' % prefix, s)
s = re.sub(r'#ZLIB_LIB.*', 'ZLIB_LIB = %s/lib/zlib.lib' % prefix, s)

open(filename, "w").write(s)

# create a CMake script for installation
s = '''
FILE(INSTALL DESTINATION "%(p)s/include" TYPE FILE FILES 
            "%(s)s/libtiff/tiff.h"
            "%(s)s/libtiff/tiffconf.h"
            "%(s)s/libtiff/tiffio.h"
            "%(s)s/libtiff/tiffiop.h"
            "%(s)s/libtiff/tiffvers.h"
    )

FILE(INSTALL DESTINATION "%(p)s/lib" TYPE STATIC_LIBRARY FILES 
             "%(s)s/libtiff/libtiff_i.lib"
             "%(s)s/libtiff/libtiff.lib"
    )

FILE(INSTALL DESTINATION "%(p)s/bin" TYPE SHARED_LIBRARY FILES 
             "%(s)s/libtiff/libtiff.dll"
    )
''' % {'p': prefix, 's': sys.argv[1]}

open(sys.argv[1] + '/cmake_install.cmake', "w").write(s)
