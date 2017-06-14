import os
import argparse
import subprocess
import sys
import zipfile
import shutil
import ConfigParser
import distutils.util

import requests

import props
props.bootstrap()
props.refresh()
import sdk
import keytool
import pkg


sdk_path = os.environ.get('ANDROID_HOME', props.sdk.path)
sdk_url = props.sdk.url
keystore_params = props.keytool.params


def sdk_cmd(action, url, path):
  if action == 'install':
    sdk.install(url, path)
  else:
    sdk.uninstall(path)


def pkg_cmd(action, name, version):
  if action == 'uninstall':
    pkg.uninstall(name, version)
  else:
    pkg.install(name, version)


def sync_cmd(path, purge=False, purge_key=True):
  config = ConfigParser.ConfigParser(allow_no_value=True)
  config.read(path)
  sections = config.sections()
  if 'keystore' in sections:
    ks_path = keytool.keytool_path()
    if os.path.exists(ks_path) and purge_key:
      os.remove(ks_path)
    keytool.gen(*[v for k,v in config.items('keystore')])
  pkgs = {}
  for section in [name for name in sections if not name in ['keystore']]:
    pkgs[section] = [k for k,v in config.items(section)]
  pkg.sync(pkgs)


def keystore_cmd(*args):
  keytool.gen(*args)


parser = argparse.ArgumentParser(description='manage Android SDK')
subparsers = parser.add_subparsers(help='Android SDK manager subcommands')
#install subcommand
parser_sdk = subparsers.add_parser('sdk', help='install/remove Android SDK')
parser_sdk.set_defaults(fn=sdk_cmd, params=['action', 'url', 'path'])
parser_sdk.add_argument('action', type=str, choices=['install', 'uninstall'])
parser_sdk.add_argument('-u', '--url', type=str, default=sdk_url, help='url do download Android SDK from')
parser_sdk.add_argument('-p', '--path', type=str, default=sdk_path, help='path to install Android sdk')
#package subcommand
parser_pkg = subparsers.add_parser('pkg', help='install, remove or update Android SDK packages')
parser_pkg.set_defaults(fn=pkg_cmd, params=['action', 'name', 'version'])
parser_pkg.add_argument('action', type=str, choices=['install', 'uninstall'])
parser_pkg.add_argument('name', type=str, help='package name', choices=['build-tools', 'platforms', 'extras', 'addons'])
parser_pkg.add_argument('version', type=str, help='package version')
#sync subcommand
parser_sync = subparsers.add_parser('sync', help='syncs installed packages based on config file')
parser_sync.set_defaults(fn=sync_cmd, params=['path', 'purge', 'purge_key'])
parser_sync.add_argument('path', type=str, help='config file path to be loaded')
parser_sync.add_argument('--purge', type=distutils.util.strtobool, default=True, help='removes packages that are not listed in file')
parser_sync.add_argument('--purge-key', type=distutils.util.strtobool, default=True, help='removes keytool if it already exists')
#keystore subcommand
parser_keystore = subparsers.add_parser('keystore', help='generates keystore debug file')
parser_keystore.set_defaults(fn=keystore_cmd, params=keystore_params)
for param in keystore_params:
  parser_keystore.add_argument(param, type=str, help='keytool %s argument' % param)


def parse_cli(*args, **kwargs):
  return parser.parse_args(*args, **kwargs)


if __name__ == '__main__':
  args = parse_cli()
  params = [getattr(args, param) for param in args.params if hasattr(args, param)]
  args.fn(*params)
