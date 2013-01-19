ilastik-build
=============

ilastik-build downloads and compiles all dependencies needed by ilastik (and a few additional ones that are frequently needed for experimentation, such as ipython). It builds upon [buildem](https://github.com/janelia-flyem/buildem), Janelia Farm's build system for the FlyEM project (see there for a description of the underlying philosophy). It is currently restricted to 64-bit builds on Windows using Microsoft Visual Studio 2010, but it will be easy to generalize for 32-bit builds with the same compiler, as there are only few places where specific settings are hard-wired. By merging with the corresponding scripts of the buildem project (and insertion of the appropriate `if` statements), it should also be easy to extend ilastik-build to Linux and Mac platforms.

## Usage

Preliminaries:

* Install MS Visual Studio 2010, cmake, git, and ActiveState perl. perl is not part of ilastik, but needed for the compilation of Qt.
* Remove possibly interfering software from your `PATH` variable (e.g. an existing Python or Qt installation, the MinGW gcc compiler).

Configuration:

* Open Visual Studio's 64-bit DOS command shell. It can usually be found in the Start menu under "Programs->Microsoft Visual Studio 2010->Visual Studio Tools->Visual Studio x64 Win64 Command Prompt")
* Create a directory for the cmake-created build scripts (e.g. `ilastik-build/build`) and goto this directory:
```
    % mkdir <build-directory\>
    % cd <build-directory>
```
* Configure the build system:
```
    % cmake -G "Visual Studio 10 Win64" -DILASTIK_DEPENDENCY_DIR=<prefix>  <path-to-build-system>
```
  This will create a file `ilastik.sln` in the `<build-directory>` that can be opened with Visual Studio. In the above cmake call, `<path-to-build-system>` is the directory where ilastik-build has been checked out (typically just `..` when we are in `ilastik-build/build`), and `<prefix>` is the desired path where the dependencies will be installed. The actual installations will be located in the subdirectories `<prefix>\bin`, `<prefix>\lib`, `<prefix>\include`, `<prefix>\python`, and `<prefix>\Qt4`. The sources (including cached `tar` archives and intermediate files) go into `<prefix>\src`.

Compilation and Installation:

* Open `ilastik.sln`, switch to "Release" mode and build the project `ilastik`. In theory, this should build and install everything in one go. In practice, it sometimes stops with an error message like "Cannot extract sources". If this happens, just build `ilastik` again (this doesn't rebuild already installed dependencies). Due to some unknown reasons, Visual Studio always believes that the compilation of numpy failed, although everything was actually ok. In this case, open "numpy-1.6.2->CMakeRules", right-click on `numpy-1.6.2-download.rule` and remove this rule. Then build `ilastik` again. 
* Add the following directories to your `PATH` variable:
```
    % <prefix>\bin
    % <prefix>\Qt4\bin
    % <prefix>\python
    % <prefix>\python\Scripts   # optional
```
* Open a new command shell (to activate your chages to the `PATH`) and invoke python with the approriate ilastik start-up script.
