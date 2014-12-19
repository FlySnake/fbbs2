#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import subprocess
import sys
import traceback
import os
import shutil

def call(cli, cwd="/"):
    popen_cli = filter(lambda x : True if len(x) > 0 else False, cli.split(" "))
    process = subprocess.Popen(popen_cli, stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=cwd)
    out, err = process.communicate()
    if process.returncode != 0:
        raise RuntimeError("Process '{c}' failed with code '{r}' in working directory '{d}'\nstderr: '{e}'\nstdout: '{o}'".\
                           format(c=cli, r=process.returncode, d=cwd, e=err, o=out))
    return {"stdout": out, "stderr": err}

class Git:
    def __init__(self, repo):
        self.__repo__ = repo
        
    def fetch(self):
        return call("git fetch", self.__repo__)
    
    def merge(self, branch):
        return call("git merge {b}".format(b=branch), self.__repo__)
    
    def checkout(self, branch):
        return call("git checkout {b}".format(b=branch), self.__repo__)
    
    def ls_remote_heads(self, remote="origin"):
        return call("git ls-remote --heads {r}".format(r=remote), self.__repo__)
    
    def rev_list(self, src, dst):
        return call("git rev-list {s}..{d}".format(s=src, d=dst), self.__repo__)

def main():
    try:
        pass
    except Exception as e:
        sys.exit("Error: " + e.message + "\n\n" + traceback.format_exc())
    sys.exit(0)

if __name__ == "__main__":
    main()