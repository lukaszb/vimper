import os
import subprocess
from collections import namedtuple


__all__ = [
    'abspath',
    'update_repo',
    'Update',
]


abspath = lambda *p: os.path.abspath(os.path.join(*p))


Update = namedtuple('Update', 'popen cloned')


def update_repo(repo_path, uri, piped=False):
    if os.path.exists(repo_path):
        cmd = ['git', 'pull']
        cwd = repo_path
        cloned = False
    else:
        cmd = ['git', 'clone', uri, repo_path]
        cwd = None
        cloned = True
    kwargs = {}
    if piped:
        kwargs.update({'stderr': subprocess.PIPE, 'stdout': subprocess.PIPE})
    popen = subprocess.Popen(cmd, cwd=cwd, shell=False, **kwargs)
    popen.wait()
    return Update(popen, cloned)

