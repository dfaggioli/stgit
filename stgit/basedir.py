"""Access to the GIT base directory
"""

__copyright__ = """
Copyright (C) 2006, Catalin Marinas <catalin.marinas@gmail.com>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License version 2 as
published by the Free Software Foundation.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
"""

import os

class BaseDirException(Exception):
    pass

def __output(cmd):
    f = os.popen(cmd, 'r')
    string = f.readline().rstrip()
    if f.close():
        raise BaseDirException, 'Error: failed to execute "%s"' % cmd
    return string

# GIT_DIR value cached
__base_dir = None

def get():
    """Return the .git directory location
    """
    global __base_dir

    if not __base_dir:
        if 'GIT_DIR' in os.environ:
            __base_dir = os.environ['GIT_DIR']
        else:
            __base_dir = __output('git-rev-parse --git-dir')

    return __base_dir