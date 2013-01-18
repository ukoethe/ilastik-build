import sys, re

filename = sys.argv[1] + '/setupext.py'
print "    patching ", filename

# Fix library names
s = open(filename).read()
s = re.sub(r'win32_static', sys.argv[2], s)
s = re.sub(r"'z'", "'zlib'", s)
s = re.sub(r"'png'", "'libpng15'", s)
open(filename, "w").write(s)
