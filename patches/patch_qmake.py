import sys, mmap, re, glob

qtdir = sys.argv[1]
qtsrc = sys.argv[2]
qmake = qtdir + '/bin/qmake.exe'
qcore = qtdir + '/bin/QtCore4.dll'

if len(qtdir) > 400:
    print >> sys.stderr, "Path", qtdir, "too long. Aborting."
    exit(1)

  
class QProp(object):
    '''A property of one qmake aspect '''
    def __init__(self, name, token, folder):
        self._name = name
        self._token = token
        self._dir = folder
        self._pos = 0

_props = [
        QProp('QT_INSTALL_PREFIX','qt_prfxpath',''), 
        QProp('QT_INSTALL_DATA', 'qt_datapath', ''),
        QProp('QT_INSTALL_DOCS', 'qt_docspath','\\doc'),
        QProp('QT_INSTALL_HEADERS', 'qt_hdrspath', '\\include'),
        QProp('QT_INSTALL_LIBS', 'qt_libspath', '\\lib'),
        QProp('QT_INSTALL_BINS', 'qt_binspath', '\\bin'),
        QProp('QT_INSTALL_PLUGINS', 'qt_plugpath','\\plugins'),
        QProp('QT_INSTALL_IMPORTS', 'qt_impspath', '\\imports'),
        QProp('QT_INSTALL_TRANSLATIONS', 'qt_trnspath', '\\translations'),
        QProp('QT_INSTALL_EXAMPLES', 'qt_xmplpath', '\\examples'),
        QProp('QT_INSTALL_DEMOS', 'qt_demopath', '\\demos'), 
        QProp('QT_INSTALL_CONFIGURATION', '', ''),
        QProp('QMAKE_MKSPECS', '', '\\mkspecs')
        ]
        
def readToken(fmap, token, pos):
    '''
    Read null-terminated string from file map starts from pos.(token=)
    '''
    fmap.seek(pos + len(token)+1) #skip token=
    
    s = ''
    b = fmap.read_byte()
    
    zero = '\x00'
     
    while b != zero: 
        s += b
        b = fmap.read_byte()
    
    return s

for file in [qmake]:
    f = open(file, "r+b")
    fmap = mmap.mmap(f.fileno(),0, access= mmap.ACCESS_WRITE)
    try:
        zero = '\x00'
        for prop in _props:
            if prop._token:
                if prop._pos == 0:
                    i = fmap.find(prop._token, 0)
                    if i == -1: 
                        continue
                    prop._pos = i
                oldpath = readToken(fmap, prop._token, i)
                path = qtdir.replace('/', '\\') + prop._dir
                print file,": Setting", prop._name, "=", path, "(was", oldpath, ")"
                # FIXME: check that the old path is the expected one before replacing it
                fmap.seek(prop._pos)
                fmap.write(prop._token + '=' + path)
                fmap.write(zero) # Termniating zero
    finally:
        fmap.close()
        f.close()
            
        
# Update lib/*.prl hard-coded path
qtdirwin = qtdir.replace('/', r'\\\\')
qtsrcwin = qtsrc.replace('/', r'\\\\')
for filename in glob.glob(qtdir + '/lib/*.prl'):
    s = open(filename).read()
    s = re.sub(qtsrcwin, qtdirwin, s)
    open(filename, "w").write(s)
