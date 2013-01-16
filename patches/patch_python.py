import sys, re

filename = sys.argv[1]
print "    patching ", filename

s = open(filename).read()

# enable support for Visual Studio 2010
s = re.sub(r"(\s+)(ld_args\.append\('/MANIFESTFILE:'.*)", r"\1\2\1ld_args.append('/MANIFEST')", s)
open(filename, "w").write(s)
