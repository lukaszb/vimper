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
    if len(uri.split()) == 2:
        uri, tag = uri.split()
    else:
        tag = None

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

    # checkout to proper tag/sha
    if tag:
        cwd = ['git', 'checkout', tag]
        _ = subprocess.Popen(cmd, cwd=cwd, shell=False, **kwargs)
        _.wait()

    return Update(popen, cloned)
