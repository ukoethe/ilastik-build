import sys, re, os

from numpy.distutils.misc_util import get_numpy_include_dirs

filename = sys.argv[1]+'/setup.py'
prefix = sys.argv[2]
numpy_inc = get_numpy_include_dirs()[0].replace('\\', '/')

# set the right platform toolset
print "Patching", filename
s = open(filename).read()
s = re.sub(r'libraries\s*=\s*\[[^\]]*\]', 'library_dirs = ["%s/lib"], libraries = ["lemon"]' % prefix, s)
s = re.sub(r'extra_compile_args\s*=\s*\[[^\]]*\]', 'extra_compile_args=["-openmp", "-EHsc"]', s)
s = re.sub(r'include_dirs\s*=\s*\[[^\]]*\]', 'include_dirs = ["%s/include", "%s"]' % (prefix, numpy_inc), s)
open(filename, "w").write(s)
