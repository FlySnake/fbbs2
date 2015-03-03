#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from logging import getLogger

log = getLogger(__name__)

import utils.shell as shell

class Git:
    def __init__(self, repo):
        cli = "git --version"
        try:
            (r,o,e) = shell.execute(cli, repo)
            self.__raise_if_error(cli, r, e, o)
            log.info("using git: {v}".format(v=o.strip()))   
        except OSError as e:
            log.exception("error communicating with git")
            raise RuntimeError("error communicating with git: " + srt(e))
        self.__repo__ = repo
        
    def fetch(self):
        (r,o,e) = self.__exec("git fetch")
        return o
    
    def merge(self, dst_branch):
        (r,o,e) = self.__exec("git merge {b}".format(b=dst_branch))
        return o
    
    def checkout(self, branch):
        (r,o,e) = self.__exec("git checkout {b}".format(b=branch))
        return o
    
    def ls_remote_heads(self, remote="origin"):
        (r,o,e) = self.__exec("git ls-remote --heads {r}".format(r=remote))
        return o
    
    def rev_list(self, src, dst):
        (r,o,e) = self.__exec("git rev-list {s}..{d}".format(s=src, d=dst))
        
    def last_commit_abbrev(self):
        (r,o,e) = self.__exec("git --no-pager log --pretty=format:%h --abbrev-commit -n1")
        return o
    
    def last_commit_time(self):
        (r,o,e) = self.__exec("git --no-pager log --pretty=format:%ci --abbrev-commit -n1")
        return o
    
    def last_commit_text(self):
        (r,o,e) = self.__exec("git --no-pager log --pretty=format:%s --abbrev-commit -n1")
        return o
    
    def last_commit_author(self):
        (r,o,e) = self.__exec("git --no-pager log --pretty=format:%an --abbrev-commit -n1")
        return o
        
    def reset_local_changes(self):
        (r,o,e) = self.__exec("git checkout -- .")
        return o
    
    def __raise_if_error(self, cli, returncode, stderr, stdout):
        if returncode != 0:
            raise RuntimeError("error executing '{cli}': {err};{out}, code {c}".format(cli=cli, err=stderr, out=stdout, c=returncode))
        
    def __exec(self, cli):
        (r, o, e) = shell.execute(cli, self.__repo__)
        self.__raise_if_error(cli, r, e, o)
        return (r, o, e)