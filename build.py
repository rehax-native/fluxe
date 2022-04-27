
import os
import sys
import pathlib
from distutils.dir_util import copy_tree
import shutil
import glob

build_type = sys.argv[1]
if build_type != 'release' and build_type != 'debug':
  print('First argument must be "release" or "debug"')
  exit(1)

is_win = sys.platform == 'cygwin'
# is_mac = sys.platform == 'darwin'

build_shared = False
if is_win:
  build_shared = True

python = 'python' if is_win else 'python2'
lib_prefix = '' if is_win else 'lib'
lib_extension = 'lib' if is_win else 'a'
if is_win and build_shared:
  lib_extension = 'dll.lib'

pathlib.Path('build/out').mkdir(parents=True, exist_ok=True)

if not os.path.exists('third_party/skia/third_party/externals/jinja2'):
  print('Setting up Skia build tools')
  os.system('cd third_party/skia && {} tools/git-sync-deps'.format(python))

if not os.path.exists('third_party/skia/out/Static/' + lib_prefix + 'skia.' + lib_extension):
  print('Building Skia')
  depot_tools = os.path.abspath('third_party/depot_tools')
  flags = [
    'skia_use_system_expat=false',
    'skia_use_system_harfbuzz=false',
    'skia_use_system_icu=false',
    'skia_use_system_libjpeg_turbo=false',
    'skia_use_system_libpng=false',
    'skia_use_system_libwebp=false',
    'skia_use_system_zlib=false',
  ]
  if build_shared:
    flags.append('is_component_build=true')
  if build_type == 'debug':
    flags.append('is_debug=true')
  else:
    flags.append('is_official_build=true')
    flags.append('is_debug=false')
  if is_win:
    flags.append('clang_win=\\\\\\"C:\\\\Program Files\\\\LLVM\\\\\\"')
  if is_win and build_type == 'debug':
    if build_shared:
      flags.append('extra_cflags=[\\\\\\"/MDd\\\\\\"]')
    else:
      flags.append('extra_cflags=[\\\\\\"/MTd\\\\\\"]')

    # We're setting the PATH here manually, since it would try to use mingw's python if that's installed, but it only works with the windows python binary.
    depot_tools_env_path = '$(cygpath -w {})'.format(depot_tools)
    env_paths = ';'.join([
      depot_tools_env_path,
      'c:\\windows\\system32',
      'C:\\Program Files\\Git\\cmd',
      'c:\\windows',
    ])

    # os.system('cd third_party/depot_tools && echo "SET PATH={}%PATH%\ngclient" > prep_win.bat'.format(depot_tools_env_path))
    # os.system('cd third_party/depot_tools && chmod +x prep_win.bat')
    # os.system('cd third_party/depot_tools && cmd.exe /c prep_win.bat')

    os.system('cd third_party/skia && echo "SET PATH={}\ngn gen out/Static --args=\\"{}\\"" > gen_win.bat'.format(env_paths, ' '.join(flags)))
    os.system('cd third_party/skia && chmod +x gen_win.bat')
    os.system('cd third_party/skia && ./gen_win.bat')

    os.system('cd third_party/skia && echo "SET PATH={}\nninja -C out/Static" > build_win.bat'.format(env_paths))
    os.system('cd third_party/skia && chmod +x build_win.bat')
    os.system('cd third_party/skia && ./build_win.bat')
  else:
    os.system('cd third_party/skia && PATH=$PATH:{} gn gen out/Static --args=\'{}\' && PATH=$PATH:{} ninja -C out/Static'.format(depot_tools, ' '.join(flags), depot_tools))
  # os.system('cd third_party/skia && export PATH=$PATH:{} && gn args out/Static --list'.format(depot_tools))

copy_libs = [
  'skia',
  'skparagraph',
  'skshaper',
  'sktext',
  'icu',
  'skunicode',
]
for lib in copy_libs:
  if build_shared:
    lib_full_name = lib_prefix + lib + '.' + lib_extension
  else:
    lib_full_name = lib_prefix + lib + '.' + lib_extension
  os.system('cp third_party/skia/out/Static/{} build/{}'.format(lib_full_name, lib_full_name))

header_source_paths = [
  ('third_party/skia/include', 'build/out/include/third_party/skia/include'),
  ('third_party/skia/modules/skparagraph/include', 'build/out/include/third_party/skia/modules/skparagraph/include'),
  ('third_party/skia/modules/skshaper/include', 'build/out/include/third_party/skia/modules/skshaper/include'),
  ('third_party/skia/modules/skunicode/include', 'build/out/include/third_party/skia/modules/skunicode/include'),
]
header_files = [
  ('third_party/skia/modules/skparagraph/src/ParagraphBuilderImpl.h', 'build/out/include/third_party/skia/modules/skparagraph/src/ParagraphBuilderImpl.h'),
] + [[path, 'build/out/include/' + path] for path in glob.glob('third_party/skia/src/**/*.h')]

print('Building fluxe core')
fluxe_lib = lib_prefix + 'fluxe-' + build_type + '.' + lib_extension
if is_win:
  # TODO invoke VS to build
  # os.system('cd dev && make fluxe-cpp-core && cp fluxe-cpp-core/bin/Debug/' + lib_prefix + 'fluxe-cpp-core.' + lib_extension + ' ../build/' + fluxe_lib)
  os.system('cd dev && cp fluxe-cpp-core/bin/Debug/fluxe-cpp-core.lib ../build/' + fluxe_lib)
else:
  os.system('cd dev && make fluxe-cpp-core && cp fluxe-cpp-core/bin/Debug/' + lib_prefix + 'fluxe-cpp-core.' + lib_extension + ' ../build/' + fluxe_lib)

for source, target in header_source_paths:
  copy_tree(source, target)
for source, target in header_files:
  pathlib.Path(os.path.dirname(target)).mkdir(parents=True, exist_ok=True)
  shutil.copyfile(source, target)

if is_win:
  # lib_tool_path = '/c/Program\ Files\ \(x86\)/Microsoft\ Visual\ Studio/2019/Community/VC/Tools/MSVC/14.29.30133/bin/Hostx86/x86/lib.exe'
  # lib_tool_path = '/c/Program\ Files\ \(x86\)/Microsoft\ Visual\ Studio/2019/Community/VC/Tools/MSVC/14.29.30133/bin/Hostx64/x64/lib.exe'
  # os.system('{} /OUT:build/out/fluxe.lib build/{} {}'.format(lib_tool_path, fluxe_lib, fluxe_lib, ' '.join(['build/{}{}.{}'.format(lib_prefix, lib, lib_extension) for lib in copy_libs])))
  os.system('cp build/{} build/out/{}'.format(fluxe_lib, fluxe_lib))
else:
  os.system('libtool -static -o build/out/{} build/{} {}'.format(fluxe_lib, fluxe_lib, ' '.join(['build/{}{}.{}'.format(lib_prefix, lib, lib_extension) for lib in copy_libs])))