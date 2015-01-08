#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from yaml import load
from os import path

import utils.singleton

class Config(object, metaclass=utils.singleton.Singleton):
    def __init__(self, filepath):
        if not path.isfile(filepath):
            raise OSError("config file {c} does not exists".format(c=filepath))
        with open(filepath, 'r') as ymlfile:
            self.__cfg = load(ymlfile)
            
    def get_raw_cfg(self):
        return self.__cfg
    
    @property        
    def logfile(self):
        return self.__cfg["logging"]["file"]
    
    @property
    def loglevel(self):
        return self.__cfg["logging"]["level"]
    
    @property
    def bind_addr(self):
        return self.__cfg["communication"]["bind_to"].split(":")[0]
    
    @property
    def bind_port(self):
        return self.__cfg["communication"]["bind_to"].split(":")[1]
    
    @property
    def artefacts_path(self):
        return self.__cfg["artefact"]["path"]
    
    @property
    def repo_path(self):
        return self.__cfg["repository"]["path"]
    
    @property
    def custom_script(self):
        return self.__cfg["build"]["custom_script"]