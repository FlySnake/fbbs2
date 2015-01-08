#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from threading import Thread, Event
from os import path
from time import time, strftime, localtime
from traceback import format_exc
from logging import getLogger

log = getLogger(__name__)

import utils.shell
import utils.git
import utils.config
        
class BuildTerminateException(RuntimeError):
    pass

class Builder(Thread):
    def __init__(self, **kwargs):
        Thread.__init__(self)
        self.setDaemon(True)
        self.__params = kwargs
        self.__params["repository_path"] = utils.config.Config().repo_path
        self.__params["artefacts_path"] = utils.config.Config().artefacts_path
        self.__start_time = 0
        self.__end_time = 0
        self.__log = ""
        self.__last_commit_info = {}
        self.__build_executor = None
        self.__terminate_flag = Event()
        self.__terminated = False
        self.__error = True
        self.__import_custom_script()
        self.__error = False
        
    def __import_custom_script(self):
        try:
            import imp
            self.__custom_script = imp.load_source("custom_script", utils.config.Config().custom_script)
            self.__custom_script.log = log
        except:
            log.exception("cannot import custom script '{s}'".format(s=utils.config.Config().custom_script))
            raise
    
    def error(self):
        return self.__error
    
    def terminated(self):
        return self.__terminated
    
    def run_duration(self):
        return (time() if self.is_alive() else self.__end_time) - self.__start_time
    
    def last_commit_info(self):
        return self.__last_commit_info
    
    def build_log(self):
        return self.__log
    
    def params(self):
        return self.__params
    
    def run(self):
        try:
            self.__append_to_log("fbbs2 worker version XXX running on YYY")
            
            self.__start_time = time()
            self.__append_to_log("build started")
            git = utils.git.Git(self.__params["repository_path"])
            
            self.__append_to_log("fetching")
            self.__append_to_log(git.fetch())
            
            self.__append_to_log("resetting local changes")
            self.__append_to_log(git.reset_local_changes())
            
            self.__append_to_log("checking out " + self.__params["branch"])
            self.__append_to_log(git.checkout(self.__params["branch"]))
            
            self.__append_to_log("merging " + self.__params["branch"])
            self.__append_to_log(git.merge("origin/" + self.__params["branch"]))
            
            self.__last_commit_info = {"commit": git.last_commit_abbrev(),
                                       "datetime": git.last_commit_time(),
                                       "text": git.last_commit_text(),
                                       "author": git.last_commit_author()}
            self.__append_to_log("last commit info: " + str(self.__last_commit_info))
            self.__params["commit"] = self.__last_commit_info["commit"]
            
            self.__append_to_log("getting version info")
            self.__params["full_version"] = self.__custom_script.get_version(**self.__params)
            self.__append_to_log("full version: " + self.__params["full_version"])
            
            self.__params["artefact_name"] = self.__custom_script.get_artefact_name(**self.__params)
            self.__append_to_log("artefact name: '" + self.__params["artefact_name"] + "'")
            
            self.__params["build_cmd"] = self.__custom_script.get_build_cmd(**self.__params)
            self.__append_to_log("build command: '" + self.__params["build_cmd"] +"'")
            
            if self.__terminate_flag.is_set():
                raise BuildTerminateException("terminated befor build command exec")
            
            self.__append_to_log("exec '" + self.__params["build_cmd"] + "'")
            self.__build_executor = utils.shell.AsyncExecutor(True)
            self.__build_executor.execute(self.__params["build_cmd"], self.__params["repository_path"])
            self.__build_executor.join()
            
            if self.__terminate_flag.isSet():
                raise BuildTerminateException("build command terminated")
            
            (returncode, stdout, stderr) = self.__build_executor.get_result()
            self.__append_to_log("build command finished with return code " + str(returncode))
            self.__append_to_log(stdout, False)

            if returncode != 0:
                raise RuntimeError("build command return code: " + str(returncode))
            self.__append_to_log("build successfull")
            
        except BuildTerminateException as e:
            log.warning(str(e))
            self.__append_to_log(str(e))
            self.__terminated = True
        except Exception as e:
            log.exception("build error")
            self.__append_to_log("build error: " + str(e) + "\n" + format_exc(), False)
            self.__error = True
        finally:
            self.__end_time = time()
            print(self.__log)
    
    def terminate(self):
        if not self.is_alive():
            return False
        self.__terminate_flag.set()
        pids = self.__build_executor.kill()
        log.warn("terminated PIDs: " + str(pids))
        self.join(timeout=30)
        return not self.is_alive()
    
    def __append_to_log(self, msg, duplicate_to_systemlog=True):
        if duplicate_to_systemlog:
            log.info(msg)
        lines = msg.split("\n")
        if len(lines) > 1:
            s2 = "#" * min(max([len(i) for i in lines]), 100)
        else:
            s2 = "#" * min(len(msg), 100)
        s2 += "\n"
        self.__log += (s2 + msg + "\n" + s2)

builder = None

def status():
    global builder
    if not builder:
        return {"busy": False,
                "error": False,
                "terminated": False,
                "run_duration": 0,
                "last_commit_info": {},
                "build_log": "",
                "params": {}
               }
    else:
        return {"busy": builder.is_alive(),
                "error": builder.error(),
                "terminated": builder.terminated(),
                "run_duration": builder.run_duration(),
                "last_commit_info": builder.last_commit_info(),
                "build_log": builder.build_log(),
                "params": builder.params()
                }
    
def start(**kwargs):
    global builder
    try:
        if not builder or not builder.is_alive():
            builder = Builder(**kwargs)
            builder.start()
            builder.join(timeout=1) # should be enouth for starting
    except:
        log.exception("error starting builder")
    finally:
        return status()

def stop():
    global builder
    try:
        if builder and builder.is_alive():
            builder.terminate()
    except:
        log.exception("error stopping builder")
    finally:
        return status()
        