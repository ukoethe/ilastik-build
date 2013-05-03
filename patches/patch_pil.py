import sys, re

filename = sys.argv[1] + '/setup.py'
print "    patching ", filename

replacement = '"%s/lib", "%s/include"' % (sys.argv[2], sys.argv[2])
s = open(filename).read()
s = re.sub(r'JPEG_ROOT = None', 'JPEG_ROOT = %s' % replacement, s)
s = re.sub(r'ZLIB_ROOT = None', 'ZLIB_ROOT = %s' % replacement, s)
s = re.sub(r'TIFF_ROOT = None', 'TIFF_ROOT = %s' % replacement, s)
s = re.sub(r'FREETYPE_ROOT = None', 'FREETYPE_ROOT = %s' % replacement, s)
open(filename, "w").write(s)
