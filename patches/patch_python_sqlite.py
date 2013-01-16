import sys, re

filename = sys.argv[1] + '/pyproject.props'
print "    patching ", filename

s = open(filename).read()
s = re.sub(r'sqlite-3\.6\.21', 'sqlite-3.7.15', s)
open(filename, "w").write(s)
