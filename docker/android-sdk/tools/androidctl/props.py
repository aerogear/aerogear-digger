import ConfigParser
import os
from collections import namedtuple


_cwd = os.path.dirname(os.path.realpath(__file__))
config = None
SDK = namedtuple('Properties', ['path', 'url', 'shell'])
KeyTool = namedtuple('KeyTool', ['name', 'params'])
sdk = None
keytool = None


def bootstrap(path='%s/props.cfg' % _cwd):
  global config
  config = ConfigParser.ConfigParser(allow_no_value=True)
  config.read(path)


def values(item):
  return [v for (k, v) in config.items(item)]


def refresh():
  global sdk
  global keytool
  sdk = SDK(*values('sdk'))
  keytool = KeyTool(*values('keytool'))
  keytool = keytool._replace(params=keytool.params.split(','))
