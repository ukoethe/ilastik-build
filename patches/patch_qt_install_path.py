import fnmatch, os, sys, re

def find_files(directory, pattern):
    for root, dirs, files in os.walk(directory):
        for basename in files:
            if fnmatch.fnmatch(basename, pattern):
                filename = os.path.join(root, basename)
                yield filename

basedir = sys.argv[1]
oldpath = re.sub("/", r"\\\\", sys.argv[2])
oldpath = oldpath[:2] + r"\$\(INSTALL_ROOT\)" + oldpath[2:]
newpath = os.path.normpath(sys.argv[3])

print "replacing", oldpath, "with", newpath

for filename in find_files(sys.argv[1], 'Makefile*'):
    s = open(filename).read()
    s = re.sub(oldpath, newpath, s)
    open(filename, "w").write(s)

filename=basedir+"/src/corelib/global/qconfig.cpp"
oldpath = re.sub("/", r"\\\\\\\\", sys.argv[2][2:])
newpath = re.sub("/", r"\\\\\\\\", sys.argv[3][2:])
print "replacing", oldpath, "with", newpath
s = open(filename).read()
s = re.sub(oldpath, newpath, s)
open(filename, "w").write(s)
