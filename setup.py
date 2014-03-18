import os
import sys
from setuptools import setup, find_packages
from setuptools.command.test import test as TestCommand


class PyTest(TestCommand):
    def finalize_options(self):
        TestCommand.finalize_options(self)
        self.test_args = []
        self.test_suite = True
    def run_tests(self):
        #import here, cause outside the eggs aren't loaded
        import pytest
        errno = pytest.main(self.test_args)
        sys.exit(errno)


readme_file = os.path.abspath(os.path.join(os.path.dirname(__file__),
    'README.rst'))

try:
    long_description = open(readme_file).read()
except IOError as err:
    sys.stderr.write("[ERROR] Cannot find file specified as "
        "long_description (%s)\n" % readme_file)
    sys.exit(1)

extra_kwargs = {'install_requires': ['termcolor', 'pyyaml']}
if sys.version_info < (3,):
    extra_kwargs['install_requires'].append('futures')


vimper = __import__('vimper')

setup(
    name='vimper',
    version=vimper.get_version(),
    url='https://github.com/lukaszb/vimper',
    author='Lukasz Balcerzak',
    author_email='lukaszbalcerzak@gmail.com',
    description=vimper.__doc__,
    long_description=long_description,
    zip_safe=False,
    packages=find_packages(),
    license='MIT',
    scripts=[],
    tests_require=['pytest', 'mock'],
    cmdclass={'test': PyTest},
    include_package_data=True,
    entry_points={
        'console_scripts': [
            'vimper = vimper:main',
        ],
    },
    classifiers=[
        'Development Status :: 4 - Beta',
        'License :: OSI Approved :: MIT License',
        'Intended Audience :: Developers',
        'Operating System :: OS Independent',
        'Programming Language :: Python',
        'Programming Language :: Python :: 3',
    ],
    **extra_kwargs
)

