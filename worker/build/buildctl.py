#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from logging import getLogger

log = getLogger(__name__)

import utils.singleton as singleton
import build.buildjob as buildjob

class BuildCtl(object, metaclass=singleton.Singleton):
    def __init__(self):
        self.__job = None
        
    def start(self, **kwargs):
        log.info("starting build job with params: " + str(kwargs))
        try:
            if not self.__job or not self.__job.is_alive():
                self.__job = buildjob.BuildJob(**kwargs)
                self.__job.start()
                self.__job.join(timeout=1) # should be enouth for starting
        except:
            log.exception("error starting builder")
        finally:
            return self.status()
        
    def stop(self):
        log.info("stopping build job")
        try:
            if self.__job and self.__job.is_alive():
                self.__job.terminate()
        except:
            log.exception("error stopping builder")
        finally:
            return self.status()
        
    def status(self):
        st =   {"busy": self.__busy,
                "error": self.__error,
                "terminated": self.__terminated,
                "run_duration": self.__run_duration,
                "last_commit_info": self.__last_commit_info,
                "build_log": self.__build_log,
                "params": self.__params
                }
        st_log = st
        if len(st_log['build_log']) > 100:
            st_log['build_log'] = "** truncated **"
        log.debug("status: \n" + str(st_log))
        return st
    
    @property        
    def __busy(self):
        return self.__job.is_alive() if self.__job else False
    
    @property
    def __error(self):
        return self.__job.error() if self.__job else False
    
    @property
    def __terminated(self):
        return self.__job.terminated() if self.__job else False
    
    @property
    def __run_duration(self):
        return self.__job.run_duration() if self.__job else 0
    
    @property
    def __last_commit_info(self):
        return self.__job.last_commit_info() if self.__job else {}
    
    @property
    def __build_log(self):
        return self.__job.build_log() if self.__job else ""
    
    @property
    def __params(self):
        return self.__job.params() if self.__job else {}
     
