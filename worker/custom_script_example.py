#!/usr/bin/env python3
# -*- coding: utf-8 -*-

QT4_PATH = "/home/o.antonyan/android/qt/4.8.3/"
QT5_PATH = "/home/builder/android/qt/5.4.1/"
BUILD_CMD_PATTERN = "./build-android.sh -v {full_version} -f {artefact_name} -d {artefacts_path} -q {qt_path}"
BUILD_CMD_PATTERN_WITH_TESTS = BUILD_CMD_PATTERN + " -testsMask {tests_run_params} -testsResults {tests_artefact_name}"
ARTEFACT_NAME_PATTERN = "STMobile-android-{full_version}-{branch}-{date}-{commit}-{platform}"

from requests import post
from time import localtime, strftime
from os import path
from json import dumps, loads

log = None

class Version(object):
    def __init__(self, commercial="0"):
        self.commercial = commercial
        self.release = "0"
        self.buildnum = "0"
    
    def __str__(self):
        return "{cv}.{r}.{b}".format(cv=self.commercial, r=self.release, b=self.buildnum)
    
    def fetch_all(self, **kwargs):
        self.release = self.__fetch_release(kwargs["repository_path"])
        self.buildnum = self.__fetch_buildnum(kwargs["service_url"], kwargs["enviroment_id"], kwargs["branch"], kwargs["commit"])
        
    def __fetch_release(self, repository_path):
        try:
            with open(path.join(repository_path, "src", "release.version"), "r") as f:
                return f.read().rstrip("\n").rstrip("\r")
        except:
            if log:
                log.exception("error getting release number, 0 will be used")
            return "0"
        
    def __fetch_buildnum(self, service_url, enviroment_id, branch, commit):
        try:
            payload = {'enviroment_id': enviroment_id, 'branch': branch, 'vcscommit': commit}
            headers = {'Content-Type': 'application/json'}
            r = post(service_url, data=dumps(payload), headers=headers, timeout=5)
            if r.status_code != 200:
                raise RuntimeError("post request error to '{uri}': {s}".format(uri=uri, s=r.status_code))
            js = loads(r.text)
            return str(js['number'])
        except:
            if log:
                log.exception("error getting build number, 0 will be used")
            return "0"
        
def get_build_cmd(**kwargs):
    full_version = kwargs["full_version"]
    artefact_name = kwargs["artefacts_names"][0].replace(".apk", "")
    artefacts_path = kwargs["artefacts_path"]
    platform = kwargs["platform"]
    if 'params' in kwargs:
        tests_run_params = kwargs['params']['tests_run_params']
        tests_artefact_name =  kwargs['params']['tests_artefact_name']
        return BUILD_CMD_PATTERN_WITH_TESTS.format(full_version=full_version,
                     artefact_name=artefact_name,
                     artefacts_path=artefacts_path,
                     qt_path=(QT5_PATH if "qt5" in platform else QT4_PATH),
                     tests_run_params=tests_run_params,
                     tests_artefact_name=tests_artefact_name)
    else:
        return BUILD_CMD_PATTERN.format(full_version=full_version,
                     artefact_name=artefact_name,
                     artefacts_path=artefacts_path,
                     qt_path=(QT5_PATH if "qt5" in platform else QT4_PATH))

def get_artefacts_names(**kwargs):
    full_version = kwargs["full_version"]
    platform = kwargs["platform"]
    branch = kwargs["branch"]
    commit = kwargs["commit"]
    basename = ARTEFACT_NAME_PATTERN.format(platform=platform,
                 full_version=full_version,
                 branch=branch,
                 date=strftime("%Y.%m.%d_%H.%M.%S", localtime()),
                 commit=commit)
    if 'params' in kwargs:
        tests_artefact_name =  kwargs['params']['tests_artefact_name']
        return [basename + ".apk", basename + ".zip", tests_artefact_name]
    else:
        return [basename + ".apk", basename + ".zip"]

def get_version(**kwargs):
    commercial_version = kwargs["base_version"]
    repository_path = kwargs["repository_path"]
    branch = kwargs["branch"]
    commit = kwargs["commit"]
    service_url = kwargs["buildnum_service"]
    enviroment_id = kwargs["enviroment_id"]
    v = Version(commercial_version)
    v.fetch_all(service_url=service_url, enviroment_id=enviroment_id, repository_path=repository_path, branch=branch, commit=commit)
    return str(v)
