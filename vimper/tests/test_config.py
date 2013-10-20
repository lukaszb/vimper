from __future__ import unicode_literals
import os
import tempfile
import unittest
from vimper.config import Config
from vimper.utils import abspath


class TestConfig(unittest.TestCase):

    def test_defaults(self):
        config = Config()
        config.config_filename = ''
        config.setup()

        self.assertEqual(config.lair_url, 'git@github.com:lukaszb/vimper-lair.git')

        lair_path = os.path.expanduser('~/.vimper')
        self.assertEqual(config.lair_path, lair_path)
        self.assertEqual(config.bundle_path, abspath(lair_path, 'vim', 'bundle'))
        self.assertEqual(config.plugins_path, abspath(lair_path, 'vim', 'plugins-repos'))
        self.assertEqual(config.plugins_config, abspath(config.lair_path, 'plugins.yml'))
        self.assertEqual(config.links_backup_path, abspath(lair_path, 'links-backup'))
        self.assertEqual(config.user_vim_path, os.path.expanduser('~/.vim'))
        self.assertEqual(config.user_vimrc_path, os.path.expanduser('~/.vimrc'))
        self.assertEqual(config.user_gvimrc_path, os.path.expanduser('~/.gvimrc'))
        self.assertEqual(config.vim_path, abspath(lair_path, 'vim'))
        self.assertEqual(config.vimrc_path, abspath(lair_path, 'vimrc'))
        self.assertEqual(config.gvimrc_path, abspath(lair_path, 'gvimrc'))

    def test_config_interpolation(self):
        config = Config()
        config.default_config = '\n'.join([
            '[lair]',
            'url = foo-bar',
        ])
        with tempfile.NamedTemporaryFile() as tmp:
            tmp.write('\n'.join([
                '[lair]',
                'path = ~/.foo',
            ]).encode('utf-8'))
            tmp.flush()
            config.config_filename = tmp.name
            config.setup()

        self.assertEqual(config.lair_url, 'foo-bar')
        self.assertEqual(config.lair_path, os.path.expanduser('~/.foo'))

