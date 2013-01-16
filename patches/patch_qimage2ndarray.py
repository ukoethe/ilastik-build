import sys, re

filename = sys.argv[1] + '/setup.py'
print "    patching ", filename

# Fix library names
s = open(filename).read()
s = re.sub(r'qt_libraries = \["QtCore", "QtGui"\]', 'qt_libraries = ["QtCore4", "QtGui4"]', s)
open(filename, "w").write(s)
