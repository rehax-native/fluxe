
import os
import sys

# is_win = sys.platform
is_mac = sys.platform == 'darwin'

os.system('premake5 fetchDependencies')

if is_mac:
  os.system('premake5 xcode4')

os.system('premake5 gmake2')
