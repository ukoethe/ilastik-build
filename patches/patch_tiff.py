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
