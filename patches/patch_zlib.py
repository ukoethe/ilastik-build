import sys

filename = sys.argv[1] + '/CMakeLists.txt'
print "    patching ", filename

s = open(filename).read()

if s.find("workaround for cmake bug #0011240") == -1: # patch not yet applied
    s += '''
    # workaround for cmake bug #0011240 (see http://public.kitware.com/Bug/view.php?id=11240)
    if(WIN32 AND CMAKE_GENERATOR MATCHES Win64)
        set_target_properties(zlibstatic PROPERTIES STATIC_LIBRARY_FLAGS "/machine:x64")
    endif()
'''

open(filename, "w").write(s)
