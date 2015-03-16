#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from subprocess import Popen, PIPE, STDOUT
from os import getcwd, path
from threading import Thread
from sys import platform

def __is_shell_popen():
    if platform == "win32":
        return True
    return False

def make_cli(cli):
    return filter(lambda x : True if len(x) > 0 else False, cli.split(" "))

def make_process(popen_cli, cwd):
    return Popen(popen_cli, stdout=PIPE, stderr=PIPE, cwd=cwd, shell=__is_shell_popen())

def make_process_merged_stdout_stderr(popen_cli, cwd):
    return Popen(popen_cli, stdout=PIPE, stderr=STDOUT, cwd=cwd, shell=__is_shell_popen())

def exec_process(process):
    out, err = process.communicate()
    return (process.returncode, out.decode('utf-8') if out else "", err.decode('utf-8') if err else "")

def execute(cli, cwd=getcwd()):
    return exec_process(make_process(make_cli(cli), cwd))

def execute_merged_stdout_stderr(cli, cwd=getcwd()):
    return exec_process(make_process_merged_stdout_stderr(make_cli(cli), cwd))

class AsyncExecutor(Thread):
    def __init__(self, merged_stdout_stderr=False, onfinish_callback=None):
        Thread.__init__(self)
        self.setDaemon(True)
        self.__onfinish = onfinish_callback
        self.__merged_stdout_stderr = merged_stdout_stderr
        self.__result = None
        
    def execute(self, cli, cwd=getcwd()):
        if self.__merged_stdout_stderr:
            self.__process = make_process_merged_stdout_stderr(make_cli(cli), cwd)
        else:
            self.__process = make_process(make_cli(cli), cwd)
        self.start()
        return self.__process.pid
    
    def kill(self):
        if not self.__process:
            return None
        if platform == "win32":
            script_path = path.join(path.dirname(path.realpath(__file__)), "kill_all_children.bat")
            (r,o,e) = execute(script_path + " " + str(self.__process.pid))
            return [str(self.__process.pid)] + o.strip().split(" ")
        else:
            script_path = path.join(path.dirname(path.realpath(__file__)), "kill_all_children.sh")
            (r,o,e) = execute(script_path + " " + str(self.__process.pid))
            execute("kill -TERM {pid}".format(pid=self.__process.pid))
            return [str(self.__process.pid)] + o.strip().split(" ")
    
    def get_result(self):
        return self.__result
        
    def run(self):
        try:
            self.__result = exec_process(self.__process)
        except Exception as e:
            self.__result = (125, "", str(e))
        finally:
            if self.__onfinish is not None:
                (r, o, e) = self.__result
                self.__onfinish(r, o, e)
                
                
                