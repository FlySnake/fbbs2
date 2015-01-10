#!/usr/bin/env python3
# -*- coding: utf-8 -*-

QT4_PATH = "/home/builder/android/qt/4.8.3/"
QT5_PATH = "/home/builder/android/qt/5.4.1/"
BUILDNUM_SRV = "http://localhost:12345/development/buildnum"
BUILD_CMD_PATTERN = "./build-android.sh -v {full_version} -f {artefact_name} -d {artefacts_path} -q {qt_path}"
ARTEFACT_NAME_PATTERN = "STMobile-android-{full_version}-{branch}-{date}-{commit}-{platform}"

from requests import get
from time import localtime, strftime
from os import path

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
        self.buildnum = self.__fetch_buildnum(kwargs["branch"], kwargs["commit"])
        
    def __fetch_release(self, repository_path):
        try:
            with open(path.join(repository_path, "src", "release.version"), "r") as f:
                return f.read().rstrip("\n").rstrip("\r")
        except:
            if log:
                log.exception("error getting release number, 0 will be used")
            return "0"
        
    def __fetch_buildnum(self, branch, commit):
        try:
            uri = BUILDNUM_SRV + "?branch={v}&commit={c}".format(v=branch, c=commit)
            r = get(uri, timeout=8)
            if r.status_code != 200:
                raise RuntimeError("get request error to '{uri}': {s}".format(uri=uri, s=r.status_code))
            return str(int(r.text.strip()))
        except:
            if log:
                log.exception("error getting build number, 0 will be used")
            return "0"
        
def get_build_cmd(**kwargs):
    full_version = kwargs["full_version"]
    artefact_name = kwargs["artefact_name"]
    artefacts_path = kwargs["artefacts_path"]
    platform = kwargs["platform"]
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
    return [basename + ".apk", basename + ".zip"]

def get_version(**kwargs):
    commercial_version = kwargs["commercial_version"]
    repository_path = kwargs["repository_path"]
    branch = kwargs["branch"]
    commit = kwargs["commit"]
    v = Version(commercial_version)
    v.fetch_all(repository_path=repository_path, branch=branch, commit=commit)
    return str(v)
