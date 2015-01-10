#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from sys import exit, stdout
from optparse import OptionParser
from signal import signal, SIGTERM
from logging import basicConfig, getLogger, StreamHandler, Formatter, info, DEBUG, INFO, ERROR, WARNING, warning, debug, critical, exception
from os import chdir, getcwd, path, getpid

import utils.config as config
import utils.daemon as daemon
import control.communication as comm
import build.buildctl as build

def signal_handler(signum, frame):
    build.BuildCtl().stop()
    warning("terminated")
    exit(0)

def bootstrap(configfile, console_app):
    conf = config.Config(configfile)
    
    loglevels = {"debug": DEBUG, "info": INFO, "error": ERROR, "warning": WARNING }
    
    basicConfig(filename=conf.logfile, 
                        format = "[%(asctime)s] %(name)s |%(levelname)s| %(message)s", 
                        datefmt="%Y-%m-%d %H:%M:%S", 
                        level=loglevels[conf.loglevel])
    
    if console_app:
        root_logger = getLogger()
        child_logger = StreamHandler(stdout)
        child_logger.setLevel(DEBUG)
        formatter = Formatter("[%(asctime)s] %(name)s |%(levelname)s| %(message)s", "%Y-%m-%d %H:%M:%S")
        child_logger.setFormatter(formatter)
        root_logger.addHandler(child_logger)
        info("started as console application")
    else:
        info("started as daemon")
    
    info("using config file: '{c}'".format(c=configfile))
    debug("working directory: '{w}', pid: '{pid}'".format(w=getcwd(), pid=getpid()))
    debug("config:\n" + str(conf.get_raw_cfg()))
    signal(SIGTERM, signal_handler)
    
def app():
    comm.start()
    
class DaemonApp(daemon.Daemon): 
    def run(self):
        try:
            debug("daemon working directory: '{w}'".format(w=getcwd()))
            app()
        except Exception as e:
            critical("fatal: unhandled exception\n{e}\n{t}".format(e=str(e), t=format_exc()))

def main():
    parser = OptionParser()
    parser.add_option("-c", "--config-file", dest="configfile", help="path to configration file")
    parser.add_option("-p", "--pid-file", dest="pidfile", help="path to pid file (only for daemon mode with -d option)")
    parser.add_option("-t", "--console-app", action="store_true", dest="console_app", help="run program as a console app instead of daemon")
    parser.add_option("-d", "--daemon-contol", dest="daemon_control", help="run program as a console app instead of daemon")
    
    (opts, args) = parser.parse_args()
    
    if not opts.configfile:
        parser.error("no config file specified")
        exit(2)
    
    if opts.console_app:
        bootstrap(opts.configfile, True)
        exit(app())
    else:
        if not opts.pidfile:
            parser.error("no pid file specified for daemon mode")
            exit(2)
        daemon = DaemonApp(opts.pidfile)
        if 'start' == opts.daemon_control:
            bootstrap(opts.configfile, False)
            daemon.start()
        elif 'stop' == opts.daemon_control:
            daemon.stop()
        elif 'status' == opts.daemon_control:
            daemon.status()
        elif not opts.daemon_control:
            parser.error("no daemon control options specified, try start or stop".format(opts.daemon_control))
            exit(2)
        else:
            parser.error("unknown daemon control command '{}'".format(opts.daemon_control))
            exit(2)
        exit(0)

if __name__ == "__main__":
    main()