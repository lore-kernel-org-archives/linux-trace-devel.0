Return-Path: <SRS0=8Y6V=R6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA2B6C43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 16:03:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8BE220700
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Mar 2019 16:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbfC0QDy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 12:03:54 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:43441 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727469AbfC0QDy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 12:03:54 -0400
Received: by mail-pl1-f169.google.com with SMTP id m10so3527415plt.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 27 Mar 2019 09:03:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kDkNZESp4lQbZ512JZjn7zRF1O4+2aKvr3Mkvj2Pd9k=;
        b=gcDwlx+5RjWtAt0ThECcRYIxH/+swOg1aTjFEEfpAMIu/eq3ubGUW1DRzOb1Ssae+A
         OUeryWwhXyk5Jc8w1QAraUj1qfXO1YK3WBvz2t2YUb6tQTJhQ8WiMuWqhKAGod7/yv9G
         3cPZazFX04a1GPGeKv1wp6qODfVUUn1snO3am9MczkZjH615INd7yA/L7S26o7/dDxkM
         p9otZAsWvLwEhQQgqCh6AadGurrdPzO5hOYKlZ6WjtGNts8mJuFmwgv3Y0xr3mMPh1fP
         61I7v34RvCPP+DM/uifejOVGkte32v18aTewBpICl8j30C/HFqZ6cfv3pM7ByK7eFFUF
         ANVQ==
X-Gm-Message-State: APjAAAWFaiC2vfC+LjCTJr/KUyCHOy7QNcYpmZfXU+1rlxEh95gXL0KP
        Vdnb7WOindGhqbFMzlU1khTO7NYgut8=
X-Google-Smtp-Source: APXvYqx10DgnsgcsQs5TTzB7zmz1PT4ii1i/7InoQnTpxCR1GkTetRoMWr0pcF7DuDoqmjtjSt6g0Q==
X-Received: by 2002:a17:902:380c:: with SMTP id l12mr37993439plc.238.1553702633355;
        Wed, 27 Mar 2019 09:03:53 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id p88sm36150806pfa.80.2019.03.27.09.03.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Mar 2019 09:03:52 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com
Subject: [RFC 5/7] kernel-shark: Add Numpy Interface for processing of tracing data
Date:   Wed, 27 Mar 2019 18:03:21 +0200
Message-Id: <20190327160323.31654-6-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190327160323.31654-1-ykaradzhov@vmware.com>
References: <20190327160323.31654-1-ykaradzhov@vmware.com>
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
 kernel-shark/build/py/libkshark_wrapper.pyx | 264 ++++++++++++++++++++
 kernel-shark/build/py/np_setup.py           |  87 +++++++
 2 files changed, 351 insertions(+)
 create mode 100644 kernel-shark/build/py/libkshark_wrapper.pyx
 create mode 100644 kernel-shark/build/py/np_setup.py

diff --git a/kernel-shark/build/py/libkshark_wrapper.pyx b/kernel-shark/build/py/libkshark_wrapper.pyx
new file mode 100644
index 0000000..825850f
--- /dev/null
+++ b/kernel-shark/build/py/libkshark_wrapper.pyx
@@ -0,0 +1,264 @@
+"""
+SPDX-License-Identifier: LGPL-2.1
+
+Copyright (C) 2017 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+"""
+
+# Import the Python-level symbols of numpy
+import numpy as np
+
+# Import the C-level symbols of numpy
+cimport numpy as np
+
+import ctypes
+import json
+
+cdef extern from "stdint.h":
+  ctypedef unsigned short uint8_t
+  ctypedef unsigned short uint16_t
+  ctypedef unsigned long long uint64_t
+
+from libcpp cimport bool
+
+cdef extern from "numpy/ndarraytypes.h":
+  int NPY_ARRAY_CARRAY
+
+# Declare the prototype of the C function we are interested in calling
+cdef extern from "../../src/libkshark-py.c":
+  bool kspy_open(const char *fname);
+
+cdef extern from "../../src/libkshark-py.c":
+  bool kspy_close()
+
+cdef extern from "../../src/libkshark-py.c":
+  size_t kspy_trace2matrix(uint64_t **offset_array,
+                           uint8_t **cpu_array,
+                           uint64_t **ts_array,
+                           uint16_t **pid_array,
+                           int **event_array);
+
+cdef extern from "../../src/libkshark-py.c":
+  int kspy_get_event_id(const char *sys, const char *evt)
+
+cdef extern from "../../src/libkshark-py.c":
+  uint64_t kspy_read_event_field(uint64_t offset, const char *sys,
+                                                    const char *evt,
+                                                    const char *field)
+
+cdef extern from "../../src/libkshark-py.c":
+  ssize_t kspy_get_tasks(int **pids, char ***names)
+
+cdef extern from "../../src/libkshark.h":
+  int KS_EVENT_OVERFLOW
+
+cdef extern from "../../src/libkshark-py.c":
+  void kspy_new_session_file(const char *data_file, const char *session_file)
+
+EVENT_OVERFLOW = KS_EVENT_OVERFLOW
+
+from libc.stdlib cimport free
+
+#from libcpp.string cimport string
+
+from cpython cimport PyObject, Py_INCREF
+
+# Numpy must be initialized!!!
+np.import_array()
+
+cdef class KsDataWrapper:
+  cdef int item_size
+  cdef int data_size
+  cdef int data_type
+  cdef void* data_ptr
+
+  cdef init(self, int data_type,
+                  int data_size,
+                  int item_size,
+                  void* data_ptr):
+    """ This initialization cannot be done in the constructor because we use
+        C-level arguments.
+    """
+    self.item_size = item_size
+    self.data_size = data_size
+    self.data_type = data_type
+    self.data_ptr = data_ptr
+
+  def __array__(self):
+    """ Here we use the __array__ method, that is called when numpy
+        tries to get an array from the object.
+    """
+    cdef np.npy_intp shape[1]
+    shape[0] = <np.npy_intp> self.data_size
+
+    ndarray = np.PyArray_New(np.ndarray,
+                             1, shape,
+                             self.data_type,
+                             NULL,
+                             self.data_ptr,
+                             self.item_size,
+                             NPY_ARRAY_CARRAY,
+                             <object> NULL)
+
+    return ndarray
+
+  def __dealloc__(self):
+    """ Frees the data. This is called by Python when all the
+        references to the object are gone.
+    """
+    free(<void*>self.data_ptr)
+
+def open_file(fname):
+  """ Open a tracing data file.
+  """
+  return kspy_open(fname)
+
+def close():
+  """ Open the session file.
+  """
+  kspy_close()
+
+def read_event_field(offset, sys, event, field):
+  """ Read the value of a specific field of the trace event.
+  """
+  cdef uint64_t v
+
+  v = kspy_read_event_field(offset, sys, event, field)
+  return v
+
+def event_id(system, event):
+  """ Get the unique Id of the event
+  """
+  return kspy_get_event_id(system, event)
+
+def c_str_cast(char *c_str):
+  """ String convertion C -> Python
+  """
+  return ctypes.c_char_p(c_str).value
+
+def get_tasks():
+  """ get a dictionary of all task's PIDs
+  """
+  cdef int *pids
+  cdef char **names
+  cdef int size = kspy_get_tasks(&pids, &names)
+
+  task_dict = {}
+
+  for i in range(0, size):
+    task_dict.update({c_str_cast(names[i]) : pids[i]})
+
+  return task_dict
+
+def load_data():
+  """ Python binding of the 'kshark_load_data_matrix' function that does not
+      copy the data.
+  """
+  cdef uint64_t *ofst
+  cdef uint8_t *cpu
+  cdef uint64_t *ts
+  cdef uint16_t *pid
+  cdef int *evt
+
+  cdef np.ndarray ndarray_ofst
+  cdef np.ndarray ndarray_cpu
+  cdef np.ndarray ndarray_ts
+  cdef np.ndarray ndarray_pid
+  cdef np.ndarray ndarray_evt
+
+  # Call the C function
+  cdef int size = kspy_trace2matrix(&ofst, &cpu, &ts, &pid, &evt)
+
+  array_wrapper_ofst = KsDataWrapper()
+  array_wrapper_cpu = KsDataWrapper()
+  array_wrapper_ts = KsDataWrapper()
+  array_wrapper_pid = KsDataWrapper()
+  array_wrapper_evt = KsDataWrapper()
+
+  array_wrapper_ofst.init(data_type=np.NPY_UINT64,
+                          item_size=0,
+                          data_size=size,
+                          data_ptr=<void*> ofst)
+
+  array_wrapper_cpu.init(data_type=np.NPY_UINT8,
+                         data_size=size,
+                         item_size=0,
+                         data_ptr=<void*> cpu)
+
+  array_wrapper_ts.init(data_type=np.NPY_UINT64,
+                        data_size=size,
+                        item_size=0,
+                        data_ptr=<void*> ts)
+
+  array_wrapper_pid.init(data_type=np.NPY_UINT16,
+                         data_size=size,
+                         item_size=0,
+                         data_ptr=<void*> pid)
+
+  array_wrapper_evt.init(data_type=np.NPY_INT,
+                         data_size=size,
+                         item_size=0,
+                         data_ptr=<void*> evt)
+
+  ndarray_ofst = np.array(array_wrapper_ofst, copy=False)
+  ndarray_cpu = np.array(array_wrapper_cpu, copy=False)
+  ndarray_ts = np.array(array_wrapper_ts, copy=False)
+  ndarray_pid = np.array(array_wrapper_pid, copy=False)
+  ndarray_evt = np.array(array_wrapper_evt, copy=False)
+
+  # Assign our object to the 'base' of the ndarray object
+  ndarray_ofst.base = <PyObject*> array_wrapper_ofst
+  ndarray_cpu.base = <PyObject*> array_wrapper_cpu
+  ndarray_ts.base = <PyObject*> array_wrapper_ts
+  ndarray_pid.base = <PyObject*> array_wrapper_pid
+  ndarray_evt.base = <PyObject*> array_wrapper_evt
+
+  # Increment the reference count, as the above assignement was done in
+  # C, and Python does not know that there is this additional reference
+  Py_INCREF(array_wrapper_ofst)
+  Py_INCREF(array_wrapper_cpu)
+  Py_INCREF(array_wrapper_ts)
+  Py_INCREF(array_wrapper_pid)
+  Py_INCREF(array_wrapper_evt)
+
+  return ndarray_ofst, ndarray_cpu, ndarray_evt, ndarray_pid, ndarray_ts
+
+def save_session(session, s):
+  """ Save a KernelShark session description of a JSON file.
+  """
+  s.seek(0)
+  json.dump(session, s, indent=4)
+  s.truncate()
+
+def new_session(fname, sname):
+  """ Generate and save a default KernelShark session description file (JSON).
+  """
+  kspy_new_session_file(fname, sname)
+
+  with open(sname, "r+") as s:
+    session = json.load(s)
+
+    session['Filters']['filter mask'] = 7
+
+    session['CPUPlots'] = []
+
+    session['TaskPlots'] = []
+
+    session['Splitter'] = [1, 1]
+
+    session['MainWindow'] = [1200, 800]
+
+    session['ViewTop'] = 0
+
+    session['ColorScheme'] = 0.75
+
+    session['Model']['bins'] = 1000
+
+    session['Markers']['markA'] = {}
+    session['Markers']['markA']['isSet'] = False
+
+    session['Markers']['markB'] = {}
+    session['Markers']['markB']['isSet'] = False
+
+    session['Markers']['Active'] = 'A'
+
+    save_session(session, s)
diff --git a/kernel-shark/build/py/np_setup.py b/kernel-shark/build/py/np_setup.py
new file mode 100644
index 0000000..602a99c
--- /dev/null
+++ b/kernel-shark/build/py/np_setup.py
@@ -0,0 +1,87 @@
+#!/usr/bin/python
+
+import sys, getopt
+import numpy
+from Cython.Distutils import build_ext
+
+def libs(argv):
+   pykslibdir = ''
+   evlibdir = ''
+   evincdir = ''
+   trlibdir = ''
+   trincdir = ''
+   jsnincdir = ''
+
+   try:
+      opts, args = getopt.getopt(argv,"l:t:i:e:n:j:", \
+				      ["pykslibdir=", \
+                                       "trlibdir=", \
+                                       "trincdir=", \
+                                       "evlibdir=", \
+                                       "evincdir=", \
+                                       "jsnincdir="])
+   except getopt.GetoptError:
+      sys.exit(2)
+   for opt, arg in opts:
+      if opt in ("-l", "--pykslibdir"):
+         pykslibdir = arg
+      elif opt in ("-t", "--trlibdir"):
+         trlibdir = arg
+      elif opt in ("-i", "--trincdir"):
+         trincdir = arg
+      elif opt in ("-e", "--evlibdir"):
+         evlibdir = arg
+      elif opt in ("-n", "--evincdir"):
+         evincdir = arg
+      elif opt in ("-j", "--jsnincdir"):
+         jsnincdir = arg
+
+   cmd1 = 1
+   for i in xrange(len(sys.argv)):
+      if sys.argv[i] == "build_ext":
+         cmd1 = i
+
+   sys.argv = sys.argv[:1] + sys.argv[cmd1:]
+   print "jsnincdir:", jsnincdir
+
+   return pykslibdir, evlibdir, evincdir, trlibdir, trincdir, jsnincdir
+
+def configuration(parent_package='', top_path=None, \
+                  libs=["pykshark", "tracecmd", "traceevent", "json-c"], \
+                  libdirs=['.'], \
+                  incdirs=['.']):
+   """ Function used to build our configuration.
+   """
+   from numpy.distutils.misc_util import Configuration
+
+   # The configuration object that hold information on all the files
+   # to be built.
+   config = Configuration('', parent_package, top_path)
+   config.add_extension("libkshark_wrapper",
+                        sources=["libkshark_wrapper.pyx"],
+                        libraries=libs,
+                        library_dirs=libdirs,
+                        depends=["../../src/libkshark.c"],
+                        include_dirs=incdirs)
+
+   return config
+
+def main(argv):
+   # Retrieve third-party libraries
+   pykslibdir, evlibdir, evincdir, trlibdir, trincdir, jsnincdir = libs(sys.argv[1:])
+
+   # Retrieve the parameters of our local configuration
+   params = configuration(top_path='', \
+                          libdirs=[pykslibdir, trlibdir, evlibdir], \
+                          incdirs=[trincdir, evincdir, jsnincdir]).todict()
+
+   #Override the C-extension building so that it knows about '.pyx'
+   #Cython files
+   params['cmdclass'] = dict(build_ext=build_ext)
+
+   # Call the actual building/packaging function (see distutils docs)
+   from numpy.distutils.core import setup
+   setup(**params)
+
+if __name__ == "__main__":
+   main(sys.argv[1:])
-- 
2.19.1

