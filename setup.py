"""
This is a setup.py script generated by py2applet

Usage:
    python setup.py py2app
"""
import os

from setuptools import setup

MINECRAFT_SRC = os.path.join(os.getcwd(), "_internal", ".minecraft")
SCRIPTS_SRC = os.path.join(os.getcwd(), "_internal", "scripts")
JAVA_SRC = os.path.join(os.getcwd(), "_internal", "java", "mac")


APP = ['main.py']
DATA_FILES = [
    ('_internal', [MINECRAFT_SRC]),
    ('_internal', [SCRIPTS_SRC]),
    ('_internal/java', [JAVA_SRC]),
    'options.json'
]
    # '_internal', 'venv_java_mac',  'options.json']

OPTIONS = {
    'iconfile':'_internal/icon.icns'
}

setup(
    app=APP,
    name="CNetMinecraftLauncher",
    version="1.0.0",
    data_files=DATA_FILES,
    options={'py2app': OPTIONS},
    setup_requires=['py2app'],
)
