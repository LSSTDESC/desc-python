#!/usr/bin/env python

from __future__ import print_function
import os
import sys
import subprocess
import json
import re

def abort(message, errorstatus=1):
    print('ERROR:', message)
    print('Abort!')
    sys.exit(errorstatus)

try:
    kernel_name = sys.argv[1]
except IndexError:
    abort('Must provide a kernel name as an argument: {} <kernel-name>'.format(sys.argv[0]))

kernel_path = os.path.join(
    os.getenv('HOME', os.getcwd()),
    '.local/share/jupyter/kernels',
    kernel_name,
    'kernel.json',
)

try:
    with open(kernel_path) as f:
        kernel_content = f.read()
except (IOError, OSError):
    abort('Cannot locate or access kernel {} at {}'.format(kernel_name, kernel_path))

try:
    argv = json.loads(kernel_content)['argv']
    arg_index = argv.index('-f')
except (KeyError, ValueError, IndexError):
    abort('{} kernel json file {} is not formatted correctly'.format(kernel_name, kernel_path))

if '-m' in argv and argv.index('-m') < arg_index:
    arg_index = argv.index('-m')

command = None
if arg_index == 1 and os.path.isfile(argv[0]):
    executable = argv[0]
    if re.match(r'.*/bin/python(?:[23](?:\.\d)?)?$', executable):
        os.environ['PATH'] = os.path.dirname(executable) + ':' + os.getenv('PATH', '')
        command = ['bash']
    else:
        command = ['bash', '--init-file', executable]

elif arg_index == 3 and argv[0] == 'shifter' and argv[1].startswith('--image='):
    command = [argv[0], argv[1], 'bash', '--init-file', argv[2]]

if not command:
    abort('Cannot transform the kernel spec into CLI environment')

print('Starting an environment for {} now...'.format(kernel_name))
if command[0] == 'shifter':
    print('This may take a while. Be patient...')

try:
    subprocess.call(command)
except KeyboardInterrupt:
    pass

