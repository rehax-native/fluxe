
import os
import sys
import pathlib
from distutils.dir_util import copy_tree

# is_win = sys.platform
# is_mac = sys.platform == 'darwin'

pathlib.Path('build/out').mkdir(parents=True, exist_ok=True)

if not os.path.exists('third_party/skia/third_party/externals/jinja2'):
  print('Setting up Skia build tools')
  os.system('cd third_party/skia && python2 tools/git-sync-deps')

if not os.path.exists('third_party/skia/out/Static/libskia.a'):
  print('Building Skia')
  depot_tools = os.path.abspath('third_party/depot_tools')
  flags = [
    'is_official_build=true',
    'skia_use_system_expat=false',
    'skia_use_system_harfbuzz=false',
    'skia_use_system_icu=false',
    'skia_use_system_libjpeg_turbo=false',
    'skia_use_system_libpng=false',
    'skia_use_system_libwebp=false',
    'skia_use_system_zlib=false',
  ]
  os.system('cd third_party/skia && PATH=$PATH:{} gn gen out/Static --args=\'{}\' && PATH=$PATH:{} ninja -C out/Static'.format(depot_tools, ' '.join(flags), depot_tools))
  # os.system('cd third_party/skia && PATH=$PATH:{} gn args out/Static --list'.format(depot_tools))

copy_libs = [
  'skia',
  'skparagraph',
  'skshaper',
  'sktext',
  'icu',
  'skunicode',
]
for lib in copy_libs:
  os.system('cp third_party/skia/out/Static/lib{}.a build/lib{}.a'.format(lib, lib))

header_source_paths = [
  ('third_party/skia/include', 'build/out/include/third_party/skia/include')
]

print('Building fluxe core')
os.system('cd dev && make fluxe-cpp-core && cp fluxe-cpp-core/bin/Debug/libfluxe-cpp-core.a ../build/libfluxe.a')

for source, target in header_source_paths:
  copy_tree(source, target)

os.system('libtool -static -o build/out/libfluxe.a build/libfluxe.a {}'.format(' '.join(['build/lib{}.a'.format(lib) for lib in copy_libs])))