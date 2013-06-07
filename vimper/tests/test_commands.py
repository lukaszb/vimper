from argparse import Namespace
from mock import Mock
from mock import call
from mock import patch
from vimper.config import Config
from vimper.commands import get_plugins
from vimper.commands import UpdateCommand
from vimper.utils import abspath
import os
import shutil
import tempfile
import unittest

UNIT_TEST_DATA_DIR = abspath(os.path.dirname(__file__), 'unittestdata')
DUMMY_PLUGINS_CONF = abspath(UNIT_TEST_DATA_DIR, 'plugins.example.yml')


class TestUtilities(unittest.TestCase):

    def setUp(self):
        self.config = Config()
        self.config.config_filename = ''
        self.config.setup()

    def test_get_plugins(self):
        self.config.plugins_config = DUMMY_PLUGINS_CONF
        self.assertEqual(get_plugins(self.config), {
            'ctrlp': 'git://github.com/kien/ctrlp.vim.git',
            'nerdtree': 'git://github.com/lukaszb/nerdtree.git',
        })


class TestUpdateCommand(unittest.TestCase):

    def setUp(self):
        self.command = UpdateCommand()
        self.command.stdout = open(os.devnull, 'w')

    def test_handle(self):
        self.command.update_vimper_repo = Mock()
        self.command.makedirs = Mock()
        self.command.update_plugins = Mock()

        self.command.handle(Namespace())
        self.command.update_vimper_repo.assert_called_once_with()
        self.command.makedirs.assert_called_once_with()

    @patch('vimper.commands.update_repo')
    def test_update_vimper_repo(self, update_repo):
        self.command.config.lair_path = 'foo'
        self.command.config.lair_url = 'bar'
        self.command.update_vimper_repo()
        update_repo.assert_called_once_with('foo', 'bar')

    @patch('vimper.commands.os')
    def test_makedirs(self, os):
        self.command.config.bundle_path = '/foo'
        self.command.config.plugins_path = '/bar'
        self.command.makedirs()
        calls = [call(dirname, 0o755) for dirname in ['/foo', '/bar']]
        self.assertEqual(os.makedirs.call_args_list, calls)

    def test_makedirs_if_they_exist(self):
        tempdir = tempfile.mkdtemp()
        shutil.rmtree(tempdir)
        self.command.get_dirnames_to_create = Mock(return_value=[tempdir])
        self.command.makedirs() # should not raise OSError here
        self.assertTrue(os.path.isdir(tempdir))

    @patch('vimper.commands.update_repo')
    def test_update_plugin(self, update_repo):
        self.command.update_plugin('foo', 'bar')
        repo_path = abspath(self.command.config.plugins_path, 'foo')
        update_repo.assert_called_once_with(repo_path, 'bar', piped=True)

    @patch('vimper.commands.update_repo')
    @patch('vimper.commands.shutil')
    @patch('vimper.commands.os')
    def test_update_plugin_recreate_plugins(self, os, shutil, update_repo):
        self.command.namespace = Mock()
        self.command.namespace.recreate_plugins = True
        repo_path = abspath(self.command.config.plugins_path, 'foo')
        os.path.exists.return_value = True
        self.command.update_plugin('foo', 'bar')
        os.path.exists.assert_called_once_with(repo_path)
        shutil.rmtree.assert_called_once_with(repo_path)
        update_repo.assert_called_once_with(repo_path, 'bar', piped=True)

    def test_update_plugin_for_info(self):
        self.command.update_plugin = Mock(return_value=123)
        value = self.command.update_plugin_for_info(('foo', 'bar'))
        self.command.update_plugin.assert_called_once_with('foo', 'bar')
        self.assertEqual(value, 123)

    @patch('vimper.commands.update_repo')
    @patch('vimper.commands.get_plugins')
    def test_update_plugins(self, get_plugins, update_repo):
        plugins = {'adamantium': 'foo', 'eternium': 'bar'}
        get_plugins.return_value = plugins
        self.command.update_plugin_for_info = Mock(return_value=('foo', 'bar'))
        self.command.update_plugins()
        self.assertEqual(self.command.update_plugin_for_info.call_args_list, [
        call(('adamantium', 'foo')), call(('eternium', 'bar'))])

