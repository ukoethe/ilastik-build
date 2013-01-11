import os, sys, re, urllib, zipfile

# retrieve the MSVC build files
archive  = 'fftw-3.3-libs-visual-studio-2010.zip'
url      = "ftp://ftp.fftw.org/pub/fftw/"
fftwdir  = sys.argv[1]
builddir = fftwdir + "/fftw-3.3-libs"
filename = builddir + "/fftw-3.3-libs.sln"
print "    patching ", filename

os.chdir(fftwdir)
urllib.urlretrieve(url + archive, archive)
zipfile.ZipFile(archive).extractall()

# set the right platform toolset
for proj in [builddir + "/libfftw-3.3/libfftw-3.3.vcxproj", builddir + "/libfftwf-3.3/libfftwf-3.3.vcxproj"]:
    s = open(proj).read()
    s = re.sub(r'\<PlatformToolset\>.+\</PlatformToolset\>', '<PlatformToolset>v100</PlatformToolset>', s)
    open(proj, "w").write(s)

# create a CMake script for installation
s = '''
FILE(INSTALL DESTINATION "%(p)s/include" TYPE FILE FILES 
            "%(s)s/api/fftw3.h"
    )

FILE(INSTALL DESTINATION "%(p)s/lib" TYPE STATIC_LIBRARY FILES 
             "%(b)s/libfftw-3.3.lib"
             "%(b)s/libfftwf-3.3.lib"
    )

FILE(INSTALL DESTINATION "%(p)s/bin" TYPE SHARED_LIBRARY FILES 
             "%(b)s/libfftw-3.3.dll"
             "%(b)s/libfftwf-3.3.dll"
    )
''' % {'p': sys.argv[2], 's': fftwdir, 'b': builddir + "/x64/Release"}

open(sys.argv[1] + '/cmake_install.cmake', "w").write(s)
