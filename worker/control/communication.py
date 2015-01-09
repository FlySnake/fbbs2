#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from bottle import route, run, get, post, put, delete, request, response, static_file
from os import path, listdir, remove, stat, chdir
from logging import getLogger

log = getLogger(__name__)

import utils.config as config
import build.buildctl as buildctl

def request_logging(func):
    def wrap(*args, **kwargs):
        log.debug("{addr} -- {method} {qry}".format(addr=request.remote_addr, method=request.method, qry=request.path))
        return func(*args, **kwargs)
    return wrap

@get("/")
@request_logging
def index():
    return config.Config().get_raw_cfg()

@get("/download/<name>")
@request_logging
def download(name):
    try:
        return static_file(name, config.Config().artefacts_path)
    except:
        log.exception("error uploading file '{f}'".format(f=name))
        raise

@delete("/download/<name>")
@request_logging
def download_delete(name):
    try:
        filepath = path.join(config.Config().artefacts_path, name)
        remove(filepath)
    except:
        log.exception("error removing file '{f}'".format(f=filepath))
        raise
    
@get("/build")
@request_logging
def build_check():
    try:
        return buildctl.BuildCtl().status()
    except:
        log.exception("error checking build status")
        raise

@put("/build")
@request_logging
def build_start():
    try:
        params = {}
        d = request.query.decode().dict
        for k in d:
            params[k] = d[k][0] if d[k] else None
        return buildctl.BuildCtl().start(**params)
    except:
        log.exception("error starting build")
        raise

@delete("/build")
@request_logging
def build_stop():
    try:
        return buildctl.BuildCtl().stop()
    except:
        log.exception("error stopping build")
        raise

def start():
    run(host=config.Config().bind_addr, port=config.Config().bind_port)
    
