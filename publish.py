import os
import shutil
import json

print('Creating zip')
shutil.make_archive('dist/fluxe-static', 'zip', 'dist/out')

with open('haxelib.json') as file:
  lib_info = json.load(file)

version = lib_info['version']
release_note = lib_info['releasenote']

res = os.system('gh release view v{} --json url'.format(version))

if res == 256:
  print('Creating release')
  os.system('gh release create v{} -n "{}"'.format(version, release_note))

val = input('Upload release files now?')
if val.lower() == 'y':
  os.system('gh release upload v{} dist/fluxe-static.zip --clobber'.format(version))