from __future__ import unicode_literals
from __future__ import print_function
from . import config
from .utils import abspath
from .utils import update_repo
from .compat import futures
from monolith.cli import BaseCommand
from monolith.cli import LabelCommand
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

def get_existing_plugins(config):
    """
    Returns list of plugins that are currently enabled locally. Those would be
    names of directories within bundle directory.
    """
    return os.listdir(config.bundle_path)


class Verbosity:
    INFO = 1
    DEBUG = 2


class BaseVimperCommandMixin(object):
    """
    Simple class for printing out messages to terminal. Not to be confused with
    logging.
    """
    INFO_COLOR = 'blue'
    SUB_INFO_COLOR = 'green'

    def __init__(self, *args, **kwargs):
        super(BaseVimperCommandMixin, self).__init__(*args, **kwargs)
        self.config = config.Config()
        self.verbosity = Verbosity.DEBUG # TODO: Add -v/-vv switches to parser

    def log(self, msg, **kwargs):
        if sys.platform != 'win32':
            msg = termcolor.colored(msg, **kwargs)
        print(msg, file=self.stdout)

    def raw_info(self, msg):
        if self.verbosity >= Verbosity.INFO:
            self.log(msg, color=self.INFO_COLOR)

    def info(self, msg):
        self.raw_info(' * %s' % msg)

    def sub_info(self, msg):
        if self.verbosity >= Verbosity.INFO:
            self.log('   ==> %s' % msg, color=self.SUB_INFO_COLOR)

    def raw_debug(self, msg):
        if self.verbosity >= Verbosity.DEBUG:
            self.log(msg, color='blue')

    def debug(self, msg):
        self.raw_debug(' * %s' % msg)

    def raw_warn(self, msg):
        self.log(msg, color='magenta')

    def warn(self, msg):
        self.raw_warn(' * %s' % msg)

    def get_plugins(self):
        return get_plugins(self.config)

    #def raw_error(self, msg):
        #self.log(msg, color='white', on_color='on_red')



class UpdateCommand(BaseVimperCommandMixin, BaseCommand):
    args = BaseCommand.args + [
        arg('-r', '--recreate-plugins', action='store_true', default=False,
            help="Forces to recreate local plugin repositories"),
        arg('-n', '--only-new', action='store_true', default=False,
            help='Updates only plugins that are not enabled yet'),
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
        self.debug('Pulling from %r' % self.config.lair_url)
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

    def get_plugins_to_update(self):
        plugins = sorted(get_plugins(self.config).items())
        if self.namespace.only_new:
            existing = get_existing_plugins(self.config)
            plugins = [(name, val) for name, val in plugins if name not in existing]
        return plugins

    def update_plugins(self):
        self.info('Updating plugins')
        plugins = self.get_plugins_to_update()
        with futures.ThreadPoolExecutor(20) as executor:
            for name, uri in executor.map(self.update_plugin_for_info, plugins):
                message = 'Updated "%s" at "%s"' % (name, uri)
                self.sub_info(message)



class LinkCommandMixin(object):

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

    def unlink_plugin(self, name):
        src = abspath(self.config.bundle_path, name)
        if os.path.islink(src):
            os.unlink(src)
            self.info('Removed link %s' % src)
        else:
            self.warn('Link at %s does not exist' % src)

    def get_plugin_link_path(self, name):
        return  abspath(self.config.bundle_path, name)

    def link_plugin(self, name):
        src = self.get_plugin_link_path(name)
        dst = get_plugin_repo_path(self.config, name)
        if not os.path.islink(dst):
            self.link(src, dst)

    def is_enabled(self, name):
        src = self.get_plugin_link_path(name)
        return os.path.exists(src)


class LinkCommand(BaseVimperCommandMixin, LinkCommandMixin, BaseCommand):

    def handle(self, namespace):
        self.link_vimper()
        self.link_plugins()

    def link_vimper(self):
        # Create links and backup if needed
        for src, dst in self.get_links():
            self.info('Re-linking %s -> %s' % (src, dst))
            self.link(src, dst)

    def link_plugins(self):
        plugins = self.get_plugins()
        for name in plugins:
            self.link_plugin(name)


class ListPluginsCommand(BaseVimperCommandMixin, LinkCommandMixin, BaseCommand):

    args = [
        arg('-p', '--plain', dest='plain', default=False, action='store_true',
            help="Doesn't show if plugin is enabled or disabled"),
    ]

    def handle(self, namespace):
        plugins = self.get_plugins()
        for name in sorted(plugins):
            msg = name
            if not namespace.plain:
                if self.is_enabled(name):
                    info = termcolor.colored('[Enabled]', 'green')
                else:
                    info = termcolor.colored('[Disabled]', 'red')
                msg += ' ' + info

            self.log(msg)


class EnablePluginCommand(BaseVimperCommandMixin, LinkCommandMixin, LabelCommand):

    def handle_label(self, label, namespace):
        self.link_plugin(label)


class DisablePluginCommand(BaseVimperCommandMixin, LinkCommandMixin, LabelCommand):

    def handle_label(self, label, namespace):
        self.unlink_plugin(label)

