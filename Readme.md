ilastik-build
=============

ilastik-build downloads and compiles all dependencies needed by ilastik (and a few additional ones that are frequently needed for experimentation, such as ipython and matplotlib) and ilastik itself. It builds upon [BuildEM](https://github.com/janelia-flyem/buildem), Janelia Farm's build system for the FlyEM project (see there for a description of the underlying philosophy). 

It is currently able to do 32-bit and 64-bit builds on Windows 7 or 8 using Microsoft Visual Studio 2010 or 2012. 

Usage
-----

### Preliminaries:

* Install MS Visual Studio 2010 or 2012 (MSVC Express will *not* work),
  [git](http://msysgit.github.io/),
  [cmake](http://cmake.org/cmake/resources/software.html),
  and
  [ActiveState perl](http://www.activestate.com/activeperlActiveState perl).
  perl is not part of ilastik, but needed to compile Qt.
* If you want to build scipy and scikit-learn, MinGW and MSYS are needed to compile Fortran source.
  You must install the MinGW 64-bit (e.g. from http://sourceforge.net/projects/mingwbuilds/files/host-windows/releases/) or 32-bit (e.g. from http://sourceforge.net/projects/mingw/files/Installer/mingw-get-inst/) compiler suite and the MSYS tools (e.g. from http://sourceforge.net/projects/mingw-w64/files/External%20binary%20packages%20%28Win64%20hosted%29/MSYS%20%2832-bit%29/). When the MinGW download is compressed with 7-zip, you need this program as well. Make sure that `MINGW/bin` contains `gfortran.exe` and `gendef.exe` (64-bit build only), and `MSYS/bin` contains `make.exe`, `wget.exe`, `patch.exe`, and `grep.exe`.
* If you want to create an .exe installer, also install NSIS.
* Remove possibly interfering software from your `PATH` variable (e.g. an existing Python or Qt installation, the MinGW gcc compiler).

### Configuration:

* Open Visual Studio's 32-bit or 64-bit DOS command shell. It can usually be found in the Start menu under "Programs->Microsoft Visual Studio 2010->Visual Studio Tools->Visual Studio x64 Win64 Command Prompt" or similar. The choice of shell determines if you create a 32-bit or 64-bit installation.
  Simply adding `cl.exe` to your PATH does _NOT_  work because additional settings are required to ensure VisualStudio works properly
  (for the curious: the VS installation contains a script `vcvarsall.bat` that is executed at the start of the VisualStudio shell to 
   take care of this).
* Create a directory for the cmake-created build scripts (e.g. `ilastik-build/build`) and goto this directory:

```
    % mkdir <build-directory>
    % cd <build-directory>
```

* Configure the build system
  (use the generator `-G "Visual Studio 11 Win64"` if you have Visual Studio 2012,
   and drop `Win64` for a 32-bit build):

```
    % cmake -G "Visual Studio 10 Win64" -DILASTIK_DEPENDENCY_DIR=<prefix>  <path-to-build-system>
```

* You have to specify additional command line parameters if you want to include optional packages, see below.

This will create a file `ilastik.sln` in the `<build-directory>` that can be opened with Visual Studio. In the above cmake call, `<path-to-build-system>` is the directory where ilastik-build has been checked out (typically just `..` when we are in `ilastik-build/build`), and `<prefix>` is the desired path where the dependencies will be installed. The actual installations will be located in the subdirectories `<prefix>\bin`, `<prefix>\lib`, `<prefix>\include`, `<prefix>\python`, and `<prefix>\Qt4`. The sources (including cached `tar` archives and intermediate files) go into `<prefix>\src`. The ilastik Python modules will be installed into `<prefix>\ilastik`.
 
#### VTK
To include VTK into the build, use:

```
    % cmake -G "Visual Studio 10 Win64" -DILASTIK_DEPENDENCY_DIR=<prefix> -DWITH_VTK=1  <path-to-build-system>
```

#### SciPy
If you want to compile scipy as well, use :

```
    % cmake -G "Visual Studio 10 Win64" -DILASTIK_DEPENDENCY_DIR=<prefix> -DWITH_SCIPY=1 \
      -DMSYS_PATH=<path-to-msys-binaries> -DMINGW_PATH=<path-to-mingw-binaries>  <path-to-build-system>
```
The `MINGW_PATH` cmake variable must point to the MinGW *binary* directory
  (for example `-DMINGW_PATH=C:\mingw-builds\x64-4.8.1-posix-seh-rev5\mingw64\bin`)
  and the `MSYS_PATH` should point to the MSYS *binary* directory
  (for example `-DMSYS_PATH=C:\msys\1.0\bin`).

#### pgmLink
pgmLink depends on the proprietary software [IBM ILOG CPLEX](http://www-01.ibm.com/software/integration/optimization/cplex-optimization-studio/). If you are an academic you can obtain a free license from the [IBM Academic Initiative](http://www-03.ibm.com/ibm/university/academic/pub/page/academic_initiative). As of CPLEX version 12.5.1, pgmLink can be compiled with both Visual Studio 2010 and 2012. Only 64-bit builds of pgmlink are currently supported.

  Install cplex and use:

```
    % cmake -G "Visual Studio 10 Win64" -DILASTIK_DEPENDENCY_DIR=<prefix> -DWITH_PGMLINK=1 <path-to-build-system>
```

  Cplex will not be part of the ilastik installation bundle. You have to copy your cplex dll (for instance "cplex1251.dll") to the `bin\` directory manually or put the CPLEX binary directory in your `PATH` variable.

The different options can also be combined. The cmake generator should be changed as approriate.


### Compilation and Installation:

* Open `ilastik.sln`, switch to "Release" mode and build the project `ilastik`. In theory, this should build and install everything in one go. In practice, it sometimes stops with an error message like "Cannot extract sources". If this happens, just build `ilastik` again (this doesn't rebuild already installed dependencies). Due to unknown reasons, Visual Studio always believes that the compilation of numpy failed, although everything was actually ok. In this case, open "numpy-1.6.2->CMakeRules", right-click on `numpy-1.6.2-download.rule` and remove this rule. Do likewise with `numpy-1.6.2-patch.rule`. Then build `ilastik` again.
* Do not build the targets `ALL_BUILD` and `INSTALL`. 
* Add the following directories to your `PATH` variable:

```
    % <prefix>\bin
    % <prefix>\Qt4\bin
    % <prefix>\python
    % <prefix>\python\Scripts   # optional
```

### Create an .exe Installer:

* Open `ilastik.sln`, and build the project `PACKAGE`. The installer will be named something like `ilastik-1.0.0-win64.exe` in the directory where `ilastik.sln` resides.

### Using ilastik:

* To use the installed ilastik version, call `ilastik.bat` in the installation's root directory. It automatically sets `PATH` and `PYTHONPATH` appropriately.
* To use another ilastik version together with the installed dependencies, set the environment variable `ILASTIK_DIR` to the root of your ilastik installation before calling `ilastik.bat`. The specified directory must have subdirectories `lazyflow`, `volumina`, and `ilastik`, holding the respective sources or modules. Example:

```
    % set ILASTIK_DIR=c:\Users\ukoethe\ilastik
    % c:\ilastik\ilastik.bat
```
