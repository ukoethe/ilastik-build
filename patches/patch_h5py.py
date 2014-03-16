import sys, re

filename = sys.argv[1] + '/setup.py'
print "    patching ", filename

s = open(filename).read()
s = re.sub(r'hdf5dll18', 'hdf5', s)
s = re.sub(r'hdf5_hldll', 'hdf5_hl', s)

# the following define is required for lzf compression on Win64
s = re.sub(r"\('_HDF5USEDLL_',\s*None\)", "('_HDF5USEDLL_', None), ('WIN32', 1)", s)

open(filename, "w").write(s)
