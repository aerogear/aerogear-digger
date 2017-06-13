import os
import subprocess
import sys

import props


sdk_path = os.environ.get('ANDROID_HOME', props.sdk.path)
home_path = os.environ.get('HOME', '/root')


def keytool_path():
  return '%s/%s' % (sdk_path, props.keytool.name)


def gen(alias, name, unit, org, loc, state, country, storepass, keypass):
  ks_path = keytool_path()
  dname = 'CN=%s, OU=%s, O=%s, L=%s, S=%s, C=%s'
  dname_values = (name, unit, org, loc, state, country)
  cmd = [
    'keytool',
    '-genkey ', '-noprompt',
    '-alias',  alias,
    '-dname', dname % dname_values,
    '-keystore', ks_path,
    '-storepass', storepass,
    '-keypass', keypass,
    '-keysize', '2048',
    '-keyalg', 'RSA'
  ]
  return subprocess.call(cmd, stdout=sys.stdout, stderr=sys.stderr)
