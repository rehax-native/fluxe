
import os
import sys

is_win = sys.platform == 'cygwin' or sys.platform == 'win32'
is_mac = sys.platform == 'darwin'

os.system('premake5 fetchDependencies')

if is_mac:
  # os.system('premake5 xcode4')
  os.system('cmake -G "Xcode" -S . -B build')
elif is_win:
  # os.system('premake5 vs2022')
  os.system('cmake -G "Visual Studio 17 2022" -S . -B build')
else:
  # os.system('premake5 gmake2')
  os.system('cmake -S . -B build')

