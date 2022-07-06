from distutils.core import setup
import py2exe

import sys; sys.argv.append('py2exe')

py2exe_options = dict(
                      ascii=True,  # Exclude encodings
                      excludes=['_ssl',  # Exclude _ssl
                                'pyreadline', 'difflib', 'doctest', 'locale', 
                                'optparse', 'pickle', 'calendar'],  # Exclude standard library
                      dll_excludes=['msvcr71.dll'],  # Exclude msvcr71
                      compressed=True,  # Compress library.zip
                      )

setup(name='<ejecutable>',
      version='1.0',
      description='<test>',
      author='Felix Prado',
	windows = [
        {
            "script": "main.py",
            "icon_resources": [(1, "iconlasalle.ico")]
        }
    ],

      options={'py2exe': py2exe_options},
      )