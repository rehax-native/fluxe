
import os
import sys
import pathlib
from distutils.dir_util import copy_tree
import shutil
import glob

if len(sys.argv) < 2:
  print('First argument must be "release" or "debug"')
  exit(1)

build_type = sys.argv[1]
if build_type != 'release' and build_type != 'debug':
  print('First argument must be "release" or "debug"')
  exit(1)

is_win = sys.platform == 'cygwin' or sys.platform == 'win32'
is_mac = sys.platform == 'darwin'

build_shared_skia_library = False
# if is_win:
  # build_shared_skia_library = True

python = 'python' if is_win else 'python2'
depot_tools = os.path.abspath('third_party/depot_tools')
if is_win:
  # depot_tools_env_path = '$(cygpath -w {})'.format(depot_tools)
  depot_tools_env_path = depot_tools.replace('/', '\\')
  env_paths_win = ';'.join([
    depot_tools_env_path,
    'c:\\windows\\system32',
    'C:\\Program Files\\Git\\cmd',
    'c:\\windows',
  ])
  orig_env = os.environ["PATH"]
  os.environ["PATH"] = env_paths_win

lib_prefix = '' if is_win else 'lib'
lib_extension = 'lib' if is_win else 'a'
if is_win and build_shared_skia_library:
  lib_extension = 'dll.lib'

pathlib.Path('dist/out').mkdir(parents=True, exist_ok=True)

if not os.path.exists('third_party/skia/third_party/externals/jinja2'):
  print('Setting up Skia build tools')
  print('This takes a while')
  print('')
  if is_win:
    os.system('cd third_party/depot_tools && gclient sync')
    os.system('cd third_party/skia && {} tools/git-sync-deps'.format(python))
  else:
    os.system('cd third_party/skia && {} tools/git-sync-deps'.format(python))

# if not os.path.exists('third_party/skia/out/Static/' + lib_prefix + 'skia.' + lib_extension):
if True:
  print('Building Skia')
  print('This takes a little bit')

  flags = [
    'skia_use_system_expat=false',
    'skia_use_system_harfbuzz=false',
    'skia_use_system_icu=false',
    'skia_use_system_libjpeg_turbo=false',
    'skia_use_system_libpng=false',
    'skia_use_system_libwebp=false',
    'skia_use_system_zlib=false',
    'skia_use_sfntly=false',
    'skia_enable_skparagraph=true',
    'skia_use_freetype=true',
    'skia_use_harfbuzz=true',
    'skia_use_system_freetype2=false',
    'skia_enable_skshaper=true',
  ]
  # if build_shared_skia_library:
    # flags.append('is_component_build=true')
  
  if is_mac:
    flags.append('skia_use_metal=true')
    # flags.append('target_os="mac"')
    # flags.append('target_cpu="arm64"')
  if is_win:
    flags.append('skia_enable_gpu=true')

  if build_type == 'debug':
    flags.append('is_debug=true')
  else:
    flags.append('is_official_build=true')
    flags.append('is_debug=false')


  # if is_win and build_type == 'debug':
  #   if build_shared:
  #     flags.append('extra_cflags=[\\"/MDd\\"]')
  #   else:
  #     flags.append('extra_cflags=[\\"/MTd\\"]')
  if is_win:
    flags.append('clang_win=\\"C:\\Program Files\\LLVM\\"')
    if build_type == 'debug':
      flags.append('extra_cflags=[\\"/MDd\\"]')
    else:
      flags.append('extra_cflags=[\\"/MD\\"]')

  if is_win:
    # --with-data-packaging=library is the only one supported on windows
    os.system('cd third_party/skia && gn gen out/Static --args="{}" --with-data-packaging=static'.format(' '.join(flags)))
    os.system('cd third_party/skia && ninja -C out/Static')
  else:
    cmd = 'cd third_party/skia && PATH=$PATH:{} MACOSX_DEPLOYMENT_TARGET=10.9 gn gen out/Static --args=\'{}\' --with-data-packaging=static && PATH=$PATH:{} MACOSX_DEPLOYMENT_TARGET=10.9 ninja -C out/Static'.format(depot_tools, ' '.join(flags), depot_tools)
    os.system(cmd)
  # os.system('cd third_party/skia && PATH=$PATH:{} gn args out/Static --list'.format(depot_tools))

if is_win:
  copy_libs = [
    # 'skia.dll',
    # 'skia.dll.lib',
    # 'skparagraph.dll',
    # 'skparagraph.dll.lib',
    # 'skshaper.dll',
    # 'skshaper.dll.lib',
    # 'sktext.dll',
    # 'sktext.dll.lib',
    # 'icu.lib',
    # 'icudtl.dat',
    # 'skunicode.dll',
    # 'skunicode.dll.lib',
    'skia.lib',
    'skparagraph.lib',
    'skshaper.lib',
    'sktext.lib',
    'icu.lib',
    'skunicode.lib',
    # 'skottie.lib',
    'icudtl.dat', # This file must be copied next to the binary
  ]
  for lib in copy_libs:
    shutil.copyfile('third_party/skia/out/Static/{}'.format(lib), 'dist/{}'.format(lib))
else:
  copy_libs = [
    'skia',
    'skparagraph',
    'skshaper',
    'sktext',
    'icu',
    'skunicode',
    'skottie',
    'sksg',
  ]
  for lib in copy_libs:
    lib_full_name = lib_prefix + lib + '.' + lib_extension
    shutil.copyfile('third_party/skia/out/Static/{}'.format(lib_full_name), 'dist//out/{}'.format(lib_full_name))

header_source_paths = [
  ('third_party/skia/include', 'dist/out/include/third_party/skia/include'),
  ('third_party/skia/modules/skparagraph/include', 'dist/out/include/third_party/skia/modules/skparagraph/include'),
  ('third_party/skia/modules/skshaper/include', 'dist/out/include/third_party/skia/modules/skshaper/include'),
  ('third_party/skia/modules/skunicode/include', 'dist/out/include/third_party/skia/modules/skunicode/include'),
]
header_files = [
  ('third_party/skia/modules/skparagraph/src/ParagraphBuilderImpl.h', 'dist/out/include/third_party/skia/modules/skparagraph/src/ParagraphBuilderImpl.h'),
] + [[path, 'dist/out/include/' + path] for path in glob.glob('third_party/skia/src/**/*.h')]

print('Building fluxe core')
build_type_capital = 'Debug' if build_type == 'debug' else 'Release'
if is_win:
  os.environ["PATH"] = orig_env
fluxe_lib = lib_prefix + 'fluxe-' + build_type + '.' + lib_extension
if is_win:
  os.system('cd dev && make.exe fluxe-cpp-core && cp fluxe-cpp-core/bin/Debug/fluxe-cpp-core.lib ../dist/fluxe.lib')
elif is_mac:
  os.system('cd dev/fluxe-cpp-core && xcodebuild -configuration {} ONLY_ACTIVE_ARCH=NO -arch=universal && cp bin/{}/libfluxe-cpp-core.a ../../dist/out/libfluxe.a'.format(build_type_capital, build_type))
else:
  os.system('cd dev && make fluxe-cpp-core config={} && cp fluxe-cpp-core/bin/{}/libfluxe-cpp-core.a ../dist/libfluxe.a'.format(build_type, build_type_capital))

dist_headers = []
for source, target in header_source_paths:
  hdrs = copy_tree(source, target)
  dist_headers = dist_headers + hdrs
for header in dist_headers:
  if not header.endswith('.h'):
    os.remove(header)

for source, target in header_files:
  if target.endswith('.h'):
    pathlib.Path(os.path.dirname(target)).mkdir(parents=True, exist_ok=True)
    shutil.copyfile(source, target)

# for lib in copy_libs:
#   os.system('cp {}.a {}'.format(build_type, ' '.join(['dist/lib{}.a'.format(lib) for lib in copy_libs])))

# if not is_win:
  # os.system('libtool -static -o dist/out/libfluxe.a dist/libfluxe-{}.a {}'.format(build_type, ' '.join(['dist/lib{}.a'.format(lib) for lib in copy_libs])))
