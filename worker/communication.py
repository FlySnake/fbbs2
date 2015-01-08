#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from bottle import route, run, get, post, put, delete, request, response, static_file
from os import path, listdir, remove, stat, chdir
from logging import getLogger

log = getLogger(__name__)

import utils.config
import build

def __log_request_decorator(func):
    def wrap(*args):
        log.debug(str(request))
        return func(*args)
    return wrap

@get("/")
@__log_request_decorator
def index():
    return build_start()
    return utils.config.Config().get_raw_cfg()

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
    return build.status()

@put("/build")
@__log_request_decorator
def build_start():
    params = {}
    d = request.query.decode().dict
    for k in d:
        params[k] = d[k][0] if d[k] else None
    return build.start(**params)

@delete("/build")
@__log_request_decorator
def build_stop():
    return build.stop()

def start():
    run(host=utils.config.Config().bind_addr, port=utils.config.Config().bind_port)
    