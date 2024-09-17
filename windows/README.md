
Building Blink Qt in Windows
============================

This document contains information on how to build a Windows EXE with Blink Qt and how to package it for
distribution using Inno Setup.

## 1. Install SIP SIMPLE Client SDK and build Blink

Follow the instructions on how to build SIP SIMPLE Client SDK and Blink by
following the instructions contained in the "Install.windows" for SIP SIMPLE
Client SDK and the Windows section in INSTALL for Blink.

## 2. Copy the necessary files

Copy the required files to the root of this repository:

`windows/copy_dependencies`

## 3. Build Blink executable

Blink should be build and able to run before you continue.

* Install pyinstaller
`pip install pyinstaller`

* Run the build process
`./build_exe`

* Test if Blink runs OK by executing blink.exe in the dist/ folder

`./dist/blink/blink.exe`

## 4. Build Installer

* Open setup.iss with InnoSetup, adjust the version number and click on Build -> Compile
* The resulting Blink-Installer.exe installer will be on the Output/ directory in the Blink root directory

