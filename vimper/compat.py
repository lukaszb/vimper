import sys

PY2 = sys.version_info[0] == 2


from concurrent import futures
if PY2:
    from ConfigParser import ConfigParser
else:
    from configparser import ConfigParser

