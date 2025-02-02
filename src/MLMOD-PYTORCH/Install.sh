# Install/unInstall package files in LAMMPS

if (test $1 = 1) then

  echo "================================================================================"
  echo "MLMOD-PYTORCH Package: Machine Learning (ML) for Data-Driven Modeling (MOD)        "
  echo "--------------------------------------------------------------------------------"
  #echo " "

  #echo "Symbolic link copying files for MLMOD-PYTORCH package."  
  #basePath=$(pwd -P)
  #echo "Base Path = $basePath"
  #ln -sf $basePath/*.h ../
  #ln -sf $basePath/*.cpp ../

  echo "Copying files for the package into the source directory."
  #cp -p $PWD/*.h ../
  #cp -p $PWD/*.cpp ../
  find $PWD -name '*.h' -exec cp "{}" ../ >& mlmod_cp_h.log \;
  find $PWD -name '*.cpp' -exec cp "{}" ../ >& mlmod_cp_cpp.log \;

  echo " "
  echo "Note MLMOD-PYTORCH current version uses serial head node for handling" 
  echo "the couplings"
  echo " "
  echo "For more information and examples see "
  echo "http://atzberger.org"
  echo " "
  echo "================================================================================"

elif (test $1 = 0) then

  rm ../fix_mlmod.cpp
  rm ../fix_mlmod.h

  echo "  "

fi

# test is MOLECULE package installed already
if (test $1 = 1) then
  if (test ! -e ../angle_harmonic.cpp) then
    echo "Must install MOLECULE package with MLMOD-PYTORCH, for example by command 'make yes-molecule'."
    exit 1
  fi

fi

# setup library settings
if (test $1 = 1) then

  if (test -e ../Makefile.package) then
    sed -i -e 's/[^ \t]*mlmod[^ \t]* //' ../Makefile.package
    sed -i -e 's|^PKG_INC =[ \t]*|&-I../../lib/mlmod |' ../Makefile.package
    sed -i -e 's|^PKG_PATH =[ \t]*|&-L../../lib/mlmod |' ../Makefile.package

#   sed -i -e 's|^PKG_INC =[ \t]*|&-I../../lib/mlmod |' ../Makefile.package
#   sed -i -e 's|^PKG_PATH =[ \t]*|&-L../../lib/mlmod$(LIBSOBJDIR) |' ../Makefile.package
    sed -i -e 's|^PKG_LIB =[ \t]*|&-lmlmod |' ../Makefile.package
    sed -i -e 's|^PKG_SYSINC =[ \t]*|&$(user-mlmod_SYSINC) |' ../Makefile.package
    sed -i -e 's|^PKG_SYSLIB =[ \t]*|&$(user-mlmod_SYSLIB) |' ../Makefile.package
    sed -i -e 's|^PKG_SYSPATH =[ \t]*|&$(user-mlmod_SYSPATH) |' ../Makefile.package
  fi

  if (test -e ../Makefile.package.settings) then
    sed -i -e '/^include.*mlmod.*$/d' ../Makefile.package.settings
    # multiline form needed for BSD sed on Macs
    sed -i -e '4 i \
include ..\/..\/lib\/mlmod\/Makefile.lammps
' ../Makefile.package.settings
  fi

elif (test $1 = 0) then

  if (test -e ../Makefile.package) then
    sed -i -e 's/[^ \t]*mlmod[^ \t]* //' ../Makefile.package
  fi

  if (test -e ../Makefile.package.settings) then
    sed -i -e '/^include.*mlmod.*$/d' ../Makefile.package.settings
  fi

fi

