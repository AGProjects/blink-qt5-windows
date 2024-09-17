# -*- mode: python ; coding: utf-8 -*-

from PyInstaller.utils.hooks import collect_submodules
all_libraries = [
    "application.version",
    'PyQt5.QtPrintSupport',
    'PyQt5.QtSvg'
]

hidden_imports = []
for l in all_libraries:
    hidden_imports += collect_submodules(l)

datas = []
from sipsimple.payloads import XMLDocument
orig_path = XMLDocument.schema_path
dst_path = os.path.join('resources', 'xml-schemas')
datas = datas + [(os.path.join(orig_path), os.path.join(dst_path))]
datas = datas + [('resources', './resources'), ('blink', 'blink')]

a = Analysis(
    ['bin/blink'],
    pathex=['.'],
    binaries=[],
    datas=datas,
    hiddenimports=hidden_imports,
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
#    runtime_hooks=['split_hook.py'],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name='blink',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon="resources/icons/blink.ico",
    contents_directory='lib'
)
coll = COLLECT(
    exe,
    a.binaries,
    a.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name='blink',
)
