"""
vimper is a tool for managing vim configuration and plugins.
"""
from __future__ import unicode_literals
import os
import sys


VERSION = (0, 8, 0)

__version__ = '.'.join((str(each) for each in VERSION[:4]))


def get_version():
    """
    Returns shorter version (digit parts only) as string.
    """
    return '.'.join((str(each) for each in VERSION[:4]))

def update_sys_path():
    dirpath = os.path.abspath(os.path.dirname(__file__))
    sys.path.insert(0, dirpath)

def main():
    update_sys_path()
    from monolith.cli import SimpleExecutionManager
    manager = SimpleExecutionManager('vimper', commands={
        'link': 'vimper.commands.LinkCommand',
        'update': 'vimper.commands.UpdateCommand',
    })
    manager.execute()

