import sys, re
anndir = sys.argv[1]
builddir = anndir + "/MS_Win32"
print "   patching ", builddir

with open(builddir+"/Ann.sln", 'r') as f:
    s = f.read()
s = re.sub(r'Win32', 'x64', s)
with open(builddir+"/Ann.sln", 'w') as f:
    f.write(s)

with open(builddir+"/dll/dll.vcxproj", 'r') as f:
    s = f.read()
s = re.sub(r'Win32', 'x64', s)
s = re.sub(r'<TargetMachine>MachineX86</TargetMachine>', '', s)
with open(builddir+"/dll/dll.vcxproj", 'w') as f:
    f.write(s)

