import sys, re

filename = sys.argv[1]
print "    patching ", filename
s = open(filename).read()
# enable support for Visual Studio 2010
s = re.sub(r"(\s+)(ld_args\.append\('/MANIFESTFILE:'.*)", r"\1\2\1ld_args.append('/MANIFEST')", s)
open(filename, "w").write(s)

filename = sys.argv[2]
print "    patching ", filename
s = open(filename).read()
# enable support for Visual Studio 2010
s = re.sub(r"return \['msvcr90'\]", 
            "return ['msvcr90']\n        elif msc_ver == '1600':\n            # VS2010 / MSVC 10.0\n            return ['msvcr100']", s)
open(filename, "w").write(s)
