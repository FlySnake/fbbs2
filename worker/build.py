#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from threading import Thread
from os import path
from requests import get
from time import time, strftime, localtime
from logging import getLogger

log = getLogger(__name__)

import utils.shell
import utils.git
import utils.config

class Version(object):
    def __init__(self, commercial="0"):
        self.commercial = commercial
        self.release = "0"
        self.buildnum = "0"
    
    def __str__(self):
        return "{cv}.{r}.{b}".format(cv=self.commercial, r=self.release, b=self.buildnum)
        
    @staticmethod
    def get_release():
        with open(path.join(utils.config.Config().repo_path(), "src", "release.version"), "r") as f:
            return f.read().rstrip("\n").rstrip("\r")
        
    @staticmethod
    def get_buildnum(branch, commit):
        try:
            uri = utils.config.Config().buildnum_service + "/buildnum?branch={v}&commit={c}".format(v=branch, c=commit)
            r = get(uri, timeout=8)
            if r.status_code != 200:
                raise RuntimeError("get request error to '{uri}': {s}".format(uri=uri, s=r.status_code))
            return str(int(r.text.strip()))
        except Exception as e:
            log.exception("error getting build number, 0 will be used")
            return "0"
        
class BuildTerminateException(RuntimeError):
    pass

class Builder(Thread):
    def __init__(self, **kwargs):
        Thread.__init__(self)
        self.setDaemon(True)
        self.__branch = kwargs["branch"]
        self.__platform = kwargs["platform"]
        self.__dbid = kwargs["dbid"]
        self.__start_time = None
        self.__end_time = None
        self.__artefact = None
        self.__log = ""
        self.__returncode = 1
        self.__last_commit_info = {}
        self.__version = Version(commercial=kwargs["commercial_version"])
        self.__build_executor = None
        self.__terminate_flag = False
        
    def run(self):
        self.__append_to_log("fbbs2 worker version XXX running on YYY")
        try:
            self.__start_time = time()
            self.__append_to_log("build started")
            git = utils.git.Git(utils.config.Config().repo_path)
            self.__append_to_log("fetching")
            self.__append_to_log(git.fetch())
            self.__append_to_log("resetting local changes")
            self.__append_to_log(git.reset_local_changes())
            self.__append_to_log("checking out " + self.__branch)
            self.__append_to_log(git.checkout(self.__branch))
            self.__append_to_log("merging " + self.__branch)
            self.__append_to_log(git.merge("origin/" + self.__branch))
            self.__last_commit_info = {"commit": git.last_commit_abbrev(),
                                       "datetime": git.last_commit_time(),
                                       "text": git.last_commit_text(),
                                       "author": git.last_commit_author()}
            self.__append_to_log("last commit info: " + str(self.__last_commit_info))
            self.__append_to_log("getting version info")
            self.__version.release = Version.get_release()
            self.__version.buildnum = Version.get_buildnum(branch=self.__branch, commit=self.__last_commit_info["commit"])
            self.__append_to_log("version: " + str(self.__version))
            
            if self.__terminate_flag:
                raise BuildTerminateException("terminated")
        
        except BuildTerminateException as e:
            log.warning("build terminated")
            self.__append_to_log("build terminated")
        except Exception as e:
            log.exception("build error")
            self.__append_to_log("build error")
        finally:
            self.__end_time = time()
    
    def terminate(self):
        pass 
    
    def __append_to_log(self, msg):
        log.info(msg)
        lines = msg.split("\n")
        if len(lines) > 1:
            s2 = "#" * max([len(i) for i in lines])
        else:
            s2 = "#" * len(msg)
        self.__log += (s2 + "\n" + msg + "\n" + s2)

builder = None

def start(branch, platform, dbid, commercial_version):
    if builder is not None:
        raise RuntimeError("error starting builder: already started")

def status():
    pass

def stop():
    pass