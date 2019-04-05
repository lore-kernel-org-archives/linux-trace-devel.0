Return-Path: <SRS0=Gl8V=SH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8169C10F13
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 10:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA622217D4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 10:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730610AbfDEKO0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Apr 2019 06:14:26 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:43231 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730532AbfDEKO0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Apr 2019 06:14:26 -0400
Received: by mail-wr1-f43.google.com with SMTP id k17so7258609wrx.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Apr 2019 03:14:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rkLsNwijaMBBDsVj9HNv6GFGTQT1HiGdcwbTl0G1pIo=;
        b=WnhMT2FLVSO+i+HpSJSco74XTLlNoMDTofsYV2NxwJrXGDVQnh0nPJ9tEZTZB4rz5M
         WWqVTzypJXwy+kKzeAmOHw51P+3st6gh8PkvECcFW35FxUhTND86QSZKxKagLHTFJVBa
         3DHgfHROXti3W6omqlFVOGAMPv1vdfh+5Td5Q0MWT/Tr8upOHRjlaI3PkVIiEWBmkL9K
         T+TOUzcc9C3M2NfhBbvQ1zJHwlazCuIpBjX3pmgZVmaRQl5BXeEbfbRvAgvkXee/OTgU
         FvUFGyuA8+icgyYGYfRykBwZ2ENgvSmtvzVtLxoFaN+n5Ab4TxLh2eyG4TBUchmxFKU6
         bDsA==
X-Gm-Message-State: APjAAAWDLMQJy7HseogooDxYnlQTTF6tGLaE0W8hqg1jv28CQCLH1yEn
        Yc5rWy2aCilxFjL3BJ3VzepMtYlebSY=
X-Google-Smtp-Source: APXvYqwBn7EuNJtlVkJ+KUdv3pyMV/v+CHy46Ff6DKBPP0Z1vxJBWDvxPjeML+ZCt3mvBu6EIW9Zlw==
X-Received: by 2002:a5d:6706:: with SMTP id o6mr8286095wru.36.1554459263873;
        Fri, 05 Apr 2019 03:14:23 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a187sm1851124wma.32.2019.04.05.03.14.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Apr 2019 03:14:23 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [RFC v2 4/6] kernel-shark: Add Numpy Interface for processing of tracing data
Date:   Fri,  5 Apr 2019 13:14:09 +0300
Message-Id: <20190405101411.25466-5-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190405101411.25466-1-ykaradzhov@vmware.com>
References: <20190405101411.25466-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch contains the Cython implementation of the Interface
together with a Python script used to build the corresponding
library (libkshark_wrapper.so)

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/build/py/libkshark_wrapper.pyx | 302 ++++++++++++++++++++
 kernel-shark/build/py/np_setup.py           | 101 +++++++
 2 files changed, 403 insertions(+)
 create mode 100644 kernel-shark/build/py/libkshark_wrapper.pyx
 create mode 100644 kernel-shark/build/py/np_setup.py

diff --git a/kernel-shark/build/py/libkshark_wrapper.pyx b/kernel-shark/build/py/libkshark_wrapper.pyx
new file mode 100644
index 0000000..71d4bd7
--- /dev/null
+++ b/kernel-shark/build/py/libkshark_wrapper.pyx
@@ -0,0 +1,302 @@
+"""
+SPDX-License-Identifier: GPL-2.0
+
+Copyright (C) 2017 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+"""
+
+import ctypes
+
+# Import the Python-level symbols of numpy
+import numpy as np
+# Import the C-level symbols of numpy
+cimport numpy as np
+
+import json
+
+from libcpp cimport bool
+
+from libc.stdlib cimport free
+
+from cpython cimport PyObject, Py_INCREF
+
+
+cdef extern from 'stdint.h':
+    ctypedef unsigned short uint8_t
+    ctypedef unsigned short uint16_t
+    ctypedef unsigned long long uint64_t
+
+cdef extern from 'numpy/ndarraytypes.h':
+    int NPY_ARRAY_CARRAY
+
+# Declare all C functions we are going to call
+cdef extern from '../../src/libkshark-py.c':
+    bool kspy_open(const char *fname)
+
+cdef extern from '../../src/libkshark-py.c':
+    bool kspy_close()
+
+cdef extern from '../../src/libkshark-py.c':
+    size_t kspy_trace2matrix(uint64_t **offset_array,
+                             uint8_t **cpu_array,
+                             uint64_t **ts_array,
+                             uint16_t **pid_array,
+                             int **event_array)
+
+cdef extern from '../../src/libkshark-py.c':
+    int kspy_get_event_id(const char *sys, const char *evt)
+
+cdef extern from '../../src/libkshark-py.c':
+    uint64_t kspy_read_event_field(uint64_t offset,
+                                   int event_id,
+                                   const char *field)
+
+cdef extern from '../../src/libkshark-py.c':
+    ssize_t kspy_get_tasks(int **pids, char ***names)
+
+cdef extern from '../../src/libkshark.h':
+    int KS_EVENT_OVERFLOW
+
+cdef extern from '../../src/libkshark-py.c':
+    void kspy_new_session_file(const char *data_file,
+                               const char *session_file)
+
+EVENT_OVERFLOW = KS_EVENT_OVERFLOW
+
+# Numpy must be initialized!!!
+np.import_array()
+
+
+cdef class KsDataWrapper:
+    cdef int item_size
+    cdef int data_size
+    cdef int data_type
+    cdef void* data_ptr
+
+    cdef init(self,
+              int data_type,
+              int data_size,
+              int item_size,
+              void* data_ptr):
+        """ This initialization cannot be done in the constructor because
+            we use C-level arguments.
+        """
+        self.item_size = item_size
+        self.data_size = data_size
+        self.data_type = data_type
+        self.data_ptr = data_ptr
+
+    def __array__(self):
+        """ Here we use the __array__ method, that is called when numpy
+            tries to get an array from the object.
+        """
+        cdef np.npy_intp shape[1]
+        shape[0] = <np.npy_intp> self.data_size
+
+        ndarray = np.PyArray_New(np.ndarray,
+                                 1, shape,
+                                 self.data_type,
+                                 NULL,
+                                 self.data_ptr,
+                                 self.item_size,
+                                 NPY_ARRAY_CARRAY,
+                                 <object>NULL)
+
+        return ndarray
+
+    def __dealloc__(self):
+        """ Free the data. This is called by Python when all the references to
+            the object are gone.
+        """
+        free(<void*>self.data_ptr)
+
+
+def c_str2py(char *c_str):
+    """ String convertion C -> Python
+    """
+    return ctypes.c_char_p(c_str).value.decode('utf-8')
+
+
+def py_str2c(py_str):
+    """ String convertion Python -> C
+    """
+    return py_str.encode('utf-8')
+
+
+def open_file(fname):
+    """ Open a tracing data file.
+    """
+    return kspy_open(py_str2c(fname))
+
+
+def close():
+    """ Open the session file.
+    """
+    kspy_close()
+
+
+def read_event_field(offset, event_id, field):
+    """ Read the value of a specific field of the trace event.
+    """
+    cdef uint64_t v
+
+    v = kspy_read_event_field(offset, event_id, py_str2c(field))
+    return v
+
+
+def event_id(system, event):
+    """ Get the unique Id of the event
+    """
+    return kspy_get_event_id(py_str2c(system), py_str2c(event))
+
+
+def get_tasks():
+    """ Get a dictionary of all task's PIDs
+    """
+    cdef int *pids
+    cdef char **names
+    cdef int size = kspy_get_tasks(&pids, &names)
+
+    task_dict = {}
+
+    for i in range(0, size):
+        task_dict.update({c_str2py(names[i]): pids[i]})
+
+    return task_dict
+
+
+def load_data(ofst_data=True, cpu_data=True,
+	      ts_data=True, pid_data=True,
+	      evt_data=True):
+    """ Python binding of the 'kshark_load_data_matrix' function that does not
+        copy the data. The input parameters can be used to avoid loading the
+        data from the unnecessary fields.
+    """
+    cdef uint64_t *ofst_c
+    cdef uint8_t *cpu_c
+    cdef uint64_t *ts_c
+    cdef uint16_t *pid_c
+    cdef int *evt_c
+
+    cdef np.ndarray ofst
+    cdef np.ndarray cpu
+    cdef np.ndarray ts
+    cdef np.ndarray pid
+    cdef np.ndarray evt
+
+    if not ofst_data:
+        ofst_c = NULL
+
+    if not cpu_data:
+        cpu_c = NULL
+
+    if not ts_data:
+        ts_c = NULL
+
+    if not pid_data:
+        pid_c = NULL
+
+    if not evt_data:
+        evt_c = NULL
+
+    data_dict = {}
+
+    # Call the C function
+    size = kspy_trace2matrix(&ofst_c, &cpu_c, &ts_c, &pid_c, &evt_c)
+
+    if ofst_data:
+        array_wrapper_ofst = KsDataWrapper()
+        array_wrapper_ofst.init(data_type=np.NPY_UINT64,
+                                item_size=0,
+                                data_size=size,
+                                data_ptr=<void *> ofst_c)
+
+
+        ofst = np.array(array_wrapper_ofst, copy=False)
+        ofst.base = <PyObject *> array_wrapper_ofst
+        data_dict.update({'offset': ofst})
+        Py_INCREF(array_wrapper_ofst)
+
+    if cpu_data:
+        array_wrapper_cpu = KsDataWrapper()
+        array_wrapper_cpu.init(data_type=np.NPY_UINT8,
+                               data_size=size,
+                               item_size=0,
+                               data_ptr=<void *> cpu_c)
+
+        cpu = np.array(array_wrapper_cpu, copy=False)
+        cpu.base = <PyObject *> array_wrapper_cpu
+        data_dict.update({'cpu': cpu})
+        Py_INCREF(array_wrapper_cpu)
+
+    if ts_data:
+        array_wrapper_ts = KsDataWrapper()
+        array_wrapper_ts.init(data_type=np.NPY_UINT64,
+                              data_size=size,
+                              item_size=0,
+                              data_ptr=<void *> ts_c)
+
+        ts = np.array(array_wrapper_ts, copy=False)
+        ts.base = <PyObject *> array_wrapper_ts
+        data_dict.update({'time': ts})
+        Py_INCREF(array_wrapper_ts)
+
+    if pid_data:
+        array_wrapper_pid = KsDataWrapper()
+        array_wrapper_pid.init(data_type=np.NPY_UINT16,
+                               data_size=size,
+                               item_size=0,
+                               data_ptr=<void *>pid_c)
+
+        pid = np.array(array_wrapper_pid, copy=False)
+        pid.base = <PyObject *> array_wrapper_pid
+        data_dict.update({'pid': pid})
+        Py_INCREF(array_wrapper_pid)
+
+    if evt_data:
+        array_wrapper_evt = KsDataWrapper()
+        array_wrapper_evt.init(data_type=np.NPY_INT,
+                               data_size=size,
+                               item_size=0,
+                               data_ptr=<void *>evt_c)
+
+        evt = np.array(array_wrapper_evt, copy=False)
+        evt.base = <PyObject *> array_wrapper_evt
+        data_dict.update({'event': evt})
+        Py_INCREF(array_wrapper_evt)
+
+    return data_dict
+
+
+def save_session(session, s):
+    """ Save a KernelShark session description of a JSON file.
+    """
+    s.seek(0)
+    json.dump(session, s, indent=4)
+    s.truncate()
+
+
+def new_session(fname, sname):
+    """ Generate and save a default KernelShark session description
+        file (JSON).
+    """
+    kspy_new_session_file(py_str2c(fname), py_str2c(sname))
+
+    with open(sname, 'r+') as s:
+        session = json.load(s)
+
+        session['Filters']['filter mask'] = 7
+        session['CPUPlots'] = []
+        session['TaskPlots'] = []
+        session['Splitter'] = [1, 1]
+        session['MainWindow'] = [1200, 800]
+        session['ViewTop'] = 0
+        session['ColorScheme'] = 0.75
+        session['Model']['bins'] = 1000
+
+        session['Markers']['markA'] = {}
+        session['Markers']['markA']['isSet'] = False
+        session['Markers']['markB'] = {}
+        session['Markers']['markB']['isSet'] = False
+        session['Markers']['Active'] = 'A'
+
+        save_session(session, s)
diff --git a/kernel-shark/build/py/np_setup.py b/kernel-shark/build/py/np_setup.py
new file mode 100644
index 0000000..0f0a26c
--- /dev/null
+++ b/kernel-shark/build/py/np_setup.py
@@ -0,0 +1,101 @@
+#!/usr/bin/env python3
+
+"""
+SPDX-License-Identifier: LGPL-2.1
+
+Copyright (C) 2017 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+"""
+
+import sys
+import getopt
+import numpy
+from Cython.Distutils import build_ext
+
+
+def libs(argv):
+    kslibdir = ''
+    evlibdir = ''
+    evincdir = ''
+    trlibdir = ''
+    trincdir = ''
+    jsnincdir = ''
+
+    try:
+        opts, args = getopt.getopt(
+            argv, 'l:t:i:e:n:j:', ['kslibdir=',
+                                   'trlibdir=',
+                                   'trincdir=',
+                                   'evlibdir=',
+                                   'evincdir=',
+                                   'jsnincdir=']
+        )
+
+    except getopt.GetoptError:
+        sys.exit(2)
+
+    for opt, arg in opts:
+        if opt in ('-l', '--kslibdir'):
+            kslibdir = arg
+        elif opt in ('-t', '--trlibdir'):
+            trlibdir = arg
+        elif opt in ('-i', '--trincdir'):
+            trincdir = arg
+        elif opt in ('-e', '--evlibdir'):
+            evlibdir = arg
+        elif opt in ('-n', '--evincdir'):
+            evincdir = arg
+        elif opt in ('-j', '--jsnincdir'):
+            jsnincdir = arg
+
+    cmd1 = 1
+    for i in range(len(sys.argv)):
+        if sys.argv[i] == 'build_ext':
+            cmd1 = i
+
+    sys.argv = sys.argv[:1] + sys.argv[cmd1:]
+
+    return kslibdir, evlibdir, evincdir, trlibdir, trincdir, jsnincdir
+
+
+def configuration(parent_package='',
+                  top_path=None,
+                  libs=['kshark', 'tracecmd', 'traceevent', 'json-c'],
+                  libdirs=['.'],
+                  incdirs=['.']):
+    """ Function used to build our configuration.
+    """
+    from numpy.distutils.misc_util import Configuration
+
+    # The configuration object that hold information on all the files
+    # to be built.
+    config = Configuration('', parent_package, top_path)
+    config.add_extension('ksharkpy',
+                         sources=['libkshark_wrapper.pyx'],
+                         libraries=libs,
+                         library_dirs=libdirs,
+                         depends=['../../src/libkshark.c', '../../src/libkshark-py.c'],
+                         include_dirs=incdirs)
+
+    return config
+
+
+def main(argv):
+    # Retrieve third-party libraries
+    kslibdir, evlibdir, evincdir, trlibdir, trincdir, jsnincdir = libs(sys.argv[1:])
+
+    # Retrieve the parameters of our local configuration
+    params = configuration(top_path='',
+                           libdirs=[kslibdir, trlibdir, evlibdir],
+                           incdirs=[trincdir, evincdir, jsnincdir]).todict()
+
+    # Override the C-extension building so that it knows about '.pyx'
+    # Cython files.
+    params['cmdclass'] = dict(build_ext=build_ext)
+
+    # Call the actual building/packaging function (see distutils docs)
+    from numpy.distutils.core import setup
+    setup(**params)
+
+
+if __name__ == '__main__':
+    main(sys.argv[1:])
-- 
2.19.1

