
import os
import sys

is_win = sys.platform == 'cygwin' or sys.platform == 'win32'
is_mac = sys.platform == 'darwin'

os.system('premake5 fetchDependencies')

if is_mac:
  os.system('premake5 xcode4')
if is_win:
  os.system('premake5 vs2022')

os.system('premake5 gmake2')
