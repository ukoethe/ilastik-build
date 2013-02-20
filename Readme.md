ilastik-build
=============

ilastik-build downloads and compiles all dependencies needed by ilastik (and a few additional ones that are frequently needed for experimentation, such as ipython and matplotlib) and ilastik itself. It builds upon [BuildEM](https://github.com/janelia-flyem/buildem), Janelia Farm's build system for the FlyEM project (see there for a description of the underlying philosophy). It is currently restricted to 64-bit builds on Windows using Microsoft Visual Studio 2010, but will be easy to generalize for 32-bit builds with that compiler, as there are only few places where specific settings are hard-wired. By merging with the corresponding scripts of the BuildEM project (and insertion of the appropriate `if` statements), it should also be easy to extend ilastik-build to Linux and Mac platforms.

Usage
-----

### Preliminaries:

* Install MS Visual Studio 2010, git, cmake, and ActiveState perl. perl is not part of ilastik, but needed for the compilation of Qt.
* Install the MingW 64-bit compiler suite from http://sourceforge.net/projects/mingwbuilds/files/host-windows/releases/ and the MSYS 64-bit tools from http://sourceforge.net/projects/mingw-w64/files/External%20binary%20packages%20%28Win64%20hosted%29/MSYS%20%2832-bit%29/. These packages are needed for scipy and other modules using Fortran.
* If you want to create an .exe installer, also install NSIS.
* Remove possibly interfering software from your `PATH` variable (e.g. an existing Python or Qt installation, the MinGW gcc compiler).

### Configuration:

* Open Visual Studio's 64-bit DOS command shell. It can usually be found in the Start menu under "Programs->Microsoft Visual Studio 2010->Visual Studio Tools->Visual Studio x64 Win64 Command Prompt".
* Create a directory for the cmake-created build scripts (e.g. `ilastik-build/build`) and goto this directory:

```
    % mkdir <build-directory>
    % cd <build-directory>
```

* Configure the build system:

```
    % cmake -G "Visual Studio 10 Win64" -DILASTIK_DEPENDENCY_DIR=<prefix> -DMSYS_PATH=<path-to-msys-binaries> -DMINGW_PATH=<path-to-mingw-binaries> <path-to-build-system>
```

  This will create a file `ilastik.sln` in the `<build-directory>` that can be opened with Visual Studio. In the above cmake call, `<path-to-build-system>` is the directory where ilastik-build has been checked out (typically just `..` when we are in `ilastik-build/build`), and `<prefix>` is the desired path where the dependencies will be installed. The actual installations will be located in the subdirectories `<prefix>\bin`, `<prefix>\lib`, `<prefix>\include`, `<prefix>\python`, and `<prefix>\Qt4`. The sources (including cached `tar` archieves and intermediate files) go into `<prefix>\src`. The ilastik Python modules will be installed into `<prefix>\ilastik`.

### Compilation and Installation:

* Open `ilastik.sln`, switch to "Release" mode and build the project `ilastik`. In theory, this should build and install everything in one go. In practice, it sometimes stops with an error message like "Cannot extract sources". If this happens, just build `ilastik` again (this doesn't rebuild already installed dependencies). Due to some unknown reasons, Visual Studio always believes that the compilation of numpy failed, although everything was actually ok. In this case, open "numpy-1.6.2->CMakeRules", right-click on `numpy-1.6.2-download.rule` and remove this rule. Do likewise with `numpy-1.6.2-patch.rule`. Then build `ilastik` again. 
* Add the following directories to your `PATH` variable:

```
    % <prefix>\bin
    % <prefix>\Qt4\bin
    % <prefix>\python
    % <prefix>\python\Scripts   # optional
```

### Create an .exe Installer:

* Open `ilastik.sln`, and build the project `PACKAGE`. The installer will be named something like `ilastik-0.6.a-win64.exe` in the same directory.

### Use the Pixel Classification Workflow:

* To use the installed ilastik version, call `pixelClassification.bat` in the installation's root directory. It automatically sets `PATH` and `PYTHONPATH` appropriately.
* To use another ilastik version together with the installed dependencies, set the environment variable `ILASTIK_DIR` to the root of your ilastik installation before calling `pixelClassification.bat`. The specified directory must have subdirectories `lazyflow`, `volumina`, and `ilastik`, holding the respective sources or modules. Example:

```
    % set ILASTIK_DIR=c:\Users\ukoethe\ilastik
    % c:\ilastik\pixelClassification.bat
```

* Other workflows will work similarly as soon as they are ported to Windows.
