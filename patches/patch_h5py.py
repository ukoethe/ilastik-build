import sys, re

filename = sys.argv[1] + '/setup.py'
print "    patching ", filename

s = open(filename).read()
s = re.sub(r'hdf5dll18', 'hdf5', s)
s = re.sub(r'hdf5_hldll', 'hdf5_hl', s)

# the following define apparently fixes a crash in lzf compression
s = re.sub(r"'define_macros'\s*:\s*\[", "'define_macros' : [('INIT_HTAB', 1), ", s)

open(filename, "w").write(s)
