#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from bottle import route, run, get, post, put, delete, request, response, static_file
from os import path, listdir, remove, stat, chdir
from logging import getLogger

log = getLogger(__name__)

import utils.config
import build

def __log_request_decorator(func):
    def wrap(*args, **kwargs):
        log.debug("{addr} ==> {method} {qry}".format(addr=request.remote_addr, method=request.method, qry=request.path))
        r = func(*args, **kwargs)
        log.debug("{addr} <== {result} {size}".format(addr=request.remote_addr, result=r.status_line, size=r.get_header('Content-Length')))
        return r
    return wrap

@get("/")
@__log_request_decorator
def index():
    return utils.config.Config().get_raw_cfg()

@get("/download/<name>")
@__log_request_decorator
def download(name):
    try:
        return static_file(name, utils.config.Config().artefacts_path)
    except:
        log.exception("error uploading file '{f}'".format(f=name))
        raise

@delete("/download/<name>")
@__log_request_decorator
def download_delete(name):
    try:
        filepath = path.join(config.Config().artefacts_path, name)
        remove(filepath)
    except:
        log.exception("error removing file '{f}'".format(f=filepath))
        raise
    
@get("/build")
@__log_request_decorator
def build_check():
    try:
        return build.status()
    except:
        log.exception("error checking build status")
        raise

@put("/build")
@__log_request_decorator
def build_start():
    try:
        params = {}
        d = request.query.decode().dict
        for k in d:
            params[k] = d[k][0] if d[k] else None
        return build.start(**params)
    except:
        log.exception("error starting build")
        raise

@delete("/build")
@__log_request_decorator
def build_stop():
    try:
        return build.stop()
    except:
        log.exception("error stopping build")
        raise

def start():
    run(host=utils.config.Config().bind_addr, port=utils.config.Config().bind_port)
    