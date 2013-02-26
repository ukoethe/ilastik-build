import sys, re

filename = sys.argv[1] + '/setupext.py'
print "    patching ", filename

# Fix library names, add required compiler flag
s = open(filename).read()
if s.find("'libpng15'") == -1:  # patch was not previously applied
    s = re.sub(r"'z'", "'zlib'", s)
    s = re.sub(r"'png'", "'libpng15'", s)
    s = re.sub(r"def\s+add_base_flags\(module\):", "def add_base_flags(module):\n    module.extra_compile_args.append('/EHsc')", s)
open(filename, "w").write(s)

filename = sys.argv[1] + '/setup.cfg'
print "    patching ", filename

# Fix base path
s = open(filename+'.template').read()
s = re.sub(r"#basedirlist.*", "basedirlist = "+sys.argv[2], s)
open(filename, "w").write(s)
