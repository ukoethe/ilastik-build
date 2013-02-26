import sys, re

filename = sys.argv[1] + '/setup.py'
print "    patching ", filename

s = open(filename).read()
s = re.sub(r'hdf5dll18', 'hdf5dll', s)  # RE won't match again
open(filename, "w").write(s)
