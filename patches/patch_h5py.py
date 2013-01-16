import sys, re

filename = sys.argv[1] + '/setup.py'
print "    patching ", filename

s = open(filename).read()
s = re.sub(r'hdf5dll18', 'hdf5dll', s)
s = re.sub(r"op\.join\(HDF5, 'dll'\)", "op.join(HDF5, 'lib')", s)
open(filename, "w").write(s)
