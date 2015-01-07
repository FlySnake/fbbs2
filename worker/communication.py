#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from bottle import route, run, get, post, put, delete, request, response, static_file
from os import path, listdir, remove, stat, chdir
from logging import getLogger

log = getLogger(__name__)

import utils.config

def __log_request_decorator(func):
    def wrap(*args):
        log.debug(str(request))
        return func(*args)
    return wrap

@get("/")
@__log_request_decorator
def index():
    return "It works! Current config: " + str(utils.config.Config().get_raw_cfg())

@get("/download/<name>")
@__log_request_decorator
def download(name):
    return static_file(name, utils.config.Config().artefacts_path)

@delete("/download/<name>")
@__log_request_decorator
def download_delete(name):
    try:
        remove(path.join(config.Config().artefacts_path, name))
    except Exception as e:
        response.status = 500
        return str(e)
    
@get("/build")
@__log_request_decorator
def build_check():
    pass

@put("/build")
@__log_request_decorator
def build_start():
    try:
        branch = request.query.getall("branch")[0]
        platform = request.query.getall("platform")[0]
        dbid = request.query.getall("id")[0]
        commercial_version = request.query.getall("commercial_version")[0]
    except Eception as e:
        response.status = 500
        return str(e)

@delete("/build")
@__log_request_decorator
def build_stop():
    pass

def start():
    run(host=utils.config.Config().bind_addr, port=utils.config.Config().bind_port)
    