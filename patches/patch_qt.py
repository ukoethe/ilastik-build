import sys, re

filename = sys.argv[1] + '/src/gui/image/qjpeghandler.pri'
print "    patching ", filename
s = open(filename).read()
s = re.sub(r'win32:\s*LIBS \+= libjpeg.lib', 'win32:          LIBS += jpeg.lib', s)
open(filename, "w").write(s)

filename = sys.argv[1] + '/src/gui/image/qpnghandler.pri'
print "    patching ", filename
s = open(filename).read()
s = re.sub(r'win32:\s*LIBS \+= libpng.lib', 'win32:          LIBS += libpng15.lib', s)
open(filename, "w").write(s)

filename = sys.argv[1] + '/src/gui/image/qtiffhandler.pri'
print "    patching ", filename
s = open(filename).read()
s = re.sub(r'win32:\s*LIBS \+= libtiff.lib', 'win32:          LIBS += libtiff_i.lib', s)
open(filename, "w").write(s)

filename = sys.argv[1] + '/src/3rdparty/zlib_dependency.pri'
print "    patching ", filename
s = open(filename).read()
s = re.sub(r'else:\s*LIBS \+= zdll.lib', 'else:                    LIBS += zlib.lib', s)
open(filename, "w").write(s)

filename = sys.argv[1] + '/src/tools/bootstrap/bootstrap.pri'
print "    patching ", filename
s = open(filename).read()
s = re.sub(r'else:LIBS \+= zdll.lib', 'else:LIBS += zlib.lib', s)
open(filename, "w").write(s)
