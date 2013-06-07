from __future__ import unicode_literals
from .utils import abspath
from .compat import ConfigParser
import io
import os


VIMPER_CONFIG = os.path.expanduser('~/.vimperconfig')

DEFAULT_CONFIG = b'''
[lair]
url = git@github.com:lukaszb/vimper-lair.git
path = ~/.vimper
'''


class Config(object):
    default_config = DEFAULT_CONFIG
    config_filename = VIMPER_CONFIG

    def __init__(self):
        self.setup()

    def setup(self):
        self.parser = ConfigParser()
        self.parser.readfp(io.BytesIO(self.default_config))
        self.parser.read(self.config_filename)
        
        self.lair_url = self.parser.get('lair', 'url')
        self.lair_path = os.path.expanduser(self.parser.get('lair', 'path'))
        self.bundle_path = abspath(self.lair_path, 'vim', 'bundle')
        self.plugins_path = abspath(self.lair_path, 'vim', 'plugins-repos')
        self.plugins_config = abspath(self.lair_path, 'plugins.yml')
        self.links_backup_path = abspath(self.lair_path, 'links-backup')
        self.user_vim_path = os.path.expanduser('~/.vim')
        self.user_vimrc_path = os.path.expanduser('~/.vimrc')
        self.user_gvimrc_path = os.path.expanduser('~/.gvimrc')
        self.vim_path = abspath(self.lair_path, 'vim')
        self.vimrc_path = abspath(self.lair_path, 'vimrc')
        self.gvimrc_path = abspath(self.lair_path, 'gvimrc')
        self.datetime_format = '%Y%m%dT%H%M%S'

