from __future__ import unicode_literals
from __future__ import print_function
from . import config
from .utils import abspath
from .utils import update_repo
from .compat import futures
from monolith.cli import BaseCommand
from monolith.cli import arg
import datetime
import os
import shutil
import sys
import termcolor
import yaml


def get_plugin_repo_path(config, name):
    return abspath(config.plugins_path, name)

def get_plugins(config):
    data = yaml.load(open(config.plugins_config))
    return data.get('plugins', {})


class BaseVimperCommandMixin(object):
    """
    Simple class for printing out messages to terminal. Not to be confused with
    logging.
    """
    INFO_COLOR = 'blue'
    SUB_INFO_COLOR = 'green'
    debug = False

    def __init__(self, *args, **kwargs):
        super(BaseVimperCommandMixin, self).__init__(*args, **kwargs)
        self.config = config.Config()

    def log(self, msg, **kwargs):
        if sys.platform != 'win32':
            msg = termcolor.colored(msg, **kwargs)
        print(msg, file=self.stdout)

    def raw_info(self, msg):
        self.log(msg, color=self.INFO_COLOR)

    def info(self, msg):
        self.raw_info(' * %s' % msg)

    def sub_info(self, msg):
        self.log('   ==> %s' % msg, color=self.SUB_INFO_COLOR)

    def raw_debug(self, msg):
        if self.debug:
            self.log(msg, color='blue')

    def debug(self, msg):
        self.raw_debug(' * %s' % msg)

    def raw_warn(self, msg):
        self.log(msg, color='magenta')

    def warn(self, msg):
        self.raw_warn(' * %s' % msg)

    #def raw_error(self, msg):
        #self.log(msg, color='white', on_color='on_red')



class UpdateCommand(BaseVimperCommandMixin, BaseCommand):
    args = BaseCommand.args + [
        arg('-r', '--recreate-plugins', action='store_true', default=False),
    ]

    def handle(self, namespace):
        self.namespace = namespace
        self.info('Performing update')
        self.update_vimper_repo()
        self.makedirs()
        self.update_plugins()

        LinkCommand().handle(namespace)

    def update_vimper_repo(self):
        self.info('Updating vimper repository at %r' % self.config.lair_path)
        update_repo(self.config.lair_path, self.config.lair_url)
        self.info('Done')

    def get_dirnames_to_create(self):
        return [self.config.bundle_path, self.config.plugins_path]

    def makedirs(self):
        mode = 0o755
        self.info('Making sure proper directories exist')
        for dirname in self.get_dirnames_to_create():
            self.sub_info(dirname)
            try:
                os.makedirs(dirname, mode)
            except OSError as err:
                if err.errno != 17:
                    raise

    def update_plugin(self, name, uri):
        repo_path = get_plugin_repo_path(self.config, name)
        if os.path.exists(repo_path):
            shutil.rmtree(repo_path)
        update_repo(repo_path, uri, piped=True)
        return name, uri

    def update_plugin_for_info(self, info):
        name, uri = info
        return self.update_plugin(name, uri)

    def update_plugins(self):
        self.info('Updating plugins')
        plugins = sorted(get_plugins(self.config).items())
        with futures.ThreadPoolExecutor(20) as executor:
            for name, uri in executor.map(self.update_plugin_for_info, plugins):
                message = 'Updated "%s" at "%s"' % (name, uri)
                self.sub_info(message)



class LinkCommand(BaseVimperCommandMixin, BaseCommand):

    def handle(self, namespace):
        self.link_vimper()
        self.link_plugins()

    def link(self, dst, src):
        now = datetime.datetime.now()
        if os.path.islink(dst):
            orgpath = os.readlink(dst)
            self.debug("Found link: %s => %s" % (dst, orgpath))
            os.remove(dst)
            self.warn("Removed link %s " % dst)
        elif os.path.exists(dst):
            newpath = '%s-%s' % (dst, now.strftime(self.config.datetime_format))
            shutil.move(dst, newpath)
            self.debug("Moved %s to %s" % (dst, newpath))
        else:
            self.debug("No entry at %s" % dst)
        os.symlink(src, dst)
        self.info("Created link %s ==> %s" % (dst, src))

    def get_links(self):
        return (
            (self.config.user_vim_path, self.config.vim_path),
            (self.config.user_vimrc_path, self.config.vimrc_path),
            (self.config.user_gvimrc_path, self.config.gvimrc_path),
        )

    def link_vimper(self):
        # Create links and backup if needed
        for src, dst in self.get_links():
            self.info('Re-linking %s -> %s' % (src, dst))
            self.link(src, dst)

    def link_plugins(self):
        plugins = get_plugins(self.config)
        for name in plugins:
            src = abspath(self.config.bundle_path, name)
            dst = get_plugin_repo_path(self.config, name)
            self.link(src, dst)

