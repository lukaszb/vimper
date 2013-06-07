import sys

PY2 = sys.version_info[0] == 2


if PY2:
    import futures
    from ConfigParser import ConfigParser
else:
    from concurrent import futures
    from configparser import ConfigParser

