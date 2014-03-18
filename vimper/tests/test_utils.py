import unittest
import mock
import os
from vimper.utils import abspath
from vimper.utils import update_repo


class TestUtils(unittest.TestCase):

    @mock.patch('vimper.utils.subprocess')
    @mock.patch('vimper.utils.os')
    def test_update_repo(self, os, subprocess):
        popen = mock.Mock()
        subprocess.Popen.return_value = popen
        os.path.exists = mock.Mock(return_value=False)
        cmd = ['git', 'clone', 'bar', 'foo']
        proc, cloned = update_repo('foo', 'bar')
        self.assertTrue(cloned)
        self.assertEqual(proc, popen)
        popen.wait.assert_called_once_with()
        subprocess.Popen.assert_called_once_with(cmd, cwd=None, shell=False)

    @mock.patch('vimper.utils.subprocess')
    @mock.patch('vimper.utils.os')
    def test_update_repo_if_exists(self, os, subprocess):
        popen = mock.Mock()
        subprocess.Popen.return_value = popen
        os.path.exists = mock.Mock(return_value=True)
        cmd = ['git', 'pull']
        proc, cloned = update_repo('foo', 'bar')
        self.assertFalse(cloned)
        self.assertEqual(proc, popen)
        popen.wait.assert_called_once_with()
        subprocess.Popen.assert_called_once_with(cmd, cwd='foo', shell=False)

    @mock.patch('vimper.utils.subprocess')
    @mock.patch('vimper.utils.os')
    def test_update_repo_piped(self, os, subprocess):
        popen = mock.Mock()
        subprocess.Popen.return_value = popen
        os.path.exists = mock.Mock(return_value=False)
        cmd = ['git', 'clone', 'bar', 'foo']
        proc, cloned = update_repo('foo', 'bar', piped=True)
        self.assertTrue(cloned)
        self.assertEqual(proc, popen)
        popen.wait.assert_called_once_with()
        subprocess.Popen.assert_called_once_with(cmd, cwd=None, shell=False,
            stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    def test_abspath(self):
        self.assertEqual(abspath('/foo/', 'bar/'), '/foo/bar')
        self.assertEqual(abspath('/foo/', '/bar/'), '/bar')
        self.assertEqual(abspath('/foo/bar', '../baz/'), '/foo/baz')

