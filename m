Return-Path: <SRS0=g3Xf=24=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38BCDC33C8C
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 17:04:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05946214D8
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 17:04:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TYoHHiub"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbgAGRD7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jan 2020 12:03:59 -0500
Received: from mail-lj1-f181.google.com ([209.85.208.181]:45710 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728389AbgAGRD7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jan 2020 12:03:59 -0500
Received: by mail-lj1-f181.google.com with SMTP id j26so280118ljc.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 07 Jan 2020 09:03:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KiI/Yo4jIxvroBj8sxt2BxDVZ0QCGynq68aHS6+CQdg=;
        b=TYoHHiubFT4la7g+w9tsUNDzcy0bHLWqqx7bLYZpXPgpAf4PiqUaLjUxlg44OtJj8s
         2NEOrs5n2bztgWzmPvI7/lSG6UMHVkUxinmKgaah4sveNHTCHL6QFrEtyZsdFmNCTOxk
         bz29q432Xa/dfhkWcOqCCDI8vAUmSqm6iVncbFt+Q+cTtGK9SDKEap/DF85stj3GQe9X
         PlxNBWT7G9+P0RbSF2sj2ryvxf6EyFDCBhEPEtQQxPyg0KrYlUOUU2XKFwtpEaCYIb0F
         RxK9tOyyRCDyxriuAiA94XOG08VsMp4RoJC0081st+qDL0ooKbVRwhvvGw57SrW3a78H
         Eomw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KiI/Yo4jIxvroBj8sxt2BxDVZ0QCGynq68aHS6+CQdg=;
        b=JTEi8CYwMJgxwkErPl4wdGpTv8POc6Ccsotz2eRg0AYfEMm32mBOdTFRm9tkr8TpeH
         V8dNripIrD4rDzdecZ54DqaOhgYxr9snxtQYsGBxw1QcdtiF8cve9IHQZQxE3TE0UM/q
         AhaKr+lG25mVXPAlZ+zd9bYKtypA4RjiTF/xy7MFc6oWA3aOv6Klmax6rL36GaezVf/0
         oB2fZ+QuNixHLV+a4aXdHO5+buZQWL0b52HQC9ypJegs3UyFZhC3B4skj/RyUBqyjZdZ
         m21IR9HMOMkCCrOPkPD9RfSsgLKeip9f229CWMRiDdsRSXIhLnbJk58x1GmY3Cqtxo1+
         KOKw==
X-Gm-Message-State: APjAAAWaO7D81lO4LUut1Uy0pOSYVEAu6tfx7bmzNtq+/S5e6V5LrMUy
        RdboJRCxfexMrsPFX/rsafvvb3Ch
X-Google-Smtp-Source: APXvYqy9razyQs81ZzxtVDd+20/zQJOiVsDMzdkNpMYrwJKEs8yGpbwicGD0MJMWseMP/dWu0WaRLg==
X-Received: by 2002:a2e:2c16:: with SMTP id s22mr276857ljs.248.1578416634876;
        Tue, 07 Jan 2020 09:03:54 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d16sm140605lfa.16.2020.01.07.09.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 09:03:54 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, Douglas.Raillard@arm.com,
        Valentin.Schneider@arm.com, nd@arm.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 03/12] trace-cruncher: Refactor NumPy based data wrapper
Date:   Tue,  7 Jan 2020 19:03:03 +0200
Message-Id: <20200107170312.27116-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200107170312.27116-1-y.karadz@gmail.com>
References: <20200107170312.27116-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The data wrapper is the only thing that remains being built with Cython.
It is now a subpackage called "tracecruncher.datawrapper".

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 setup.py            |  12 ++-
 src/datawrapper.pyx | 201 ++++++++++++++++++++++++++++++++++++++++++++
 src/trace2matrix.c  |  29 +++++++
 3 files changed, 241 insertions(+), 1 deletion(-)
 create mode 100644 src/datawrapper.pyx
 create mode 100644 src/trace2matrix.c

diff --git a/setup.py b/setup.py
index 62912e2..526e1e7 100644
--- a/setup.py
+++ b/setup.py
@@ -9,12 +9,22 @@ Copyright 2019 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
 from setuptools import setup, find_packages
 from distutils.core import Extension
 from Cython.Build import cythonize
+import numpy as np
 
 def main():
     kshark_path = '/usr/local/lib/kernelshark'
     traceevent_path = '/usr/local/lib/traceevent/'
     tracecmd_path = '/usr/local/lib/trace-cmd/'
 
+    cythonize('src/datawrapper.pyx')
+    module_data = Extension('tracecruncher.datawrapper',
+                            sources=['src/datawrapper.c'],
+                            include_dirs=[np.get_include()],
+                            library_dirs=[kshark_path, traceevent_path, tracecmd_path],
+                            runtime_library_dirs=[kshark_path, traceevent_path, tracecmd_path],
+                            libraries=['kshark', 'traceevent', 'tracecmd']
+                            )
+
     module_ks = Extension('tracecruncher.ksharkpy',
                           sources=['src/ksharkpy.c'],
                           library_dirs=[kshark_path],
@@ -41,7 +51,7 @@ def main():
           url='https://github.com/vmware/trace-cruncher',
           license='LGPL-2.1',
           packages=find_packages(),
-          ext_modules=[module_ks, module_ft],
+          ext_modules=[module_data, module_ks, module_ft],
           classifiers=[
               'Development Status :: 3 - Alpha',
               'Programming Language :: Python :: 3',
diff --git a/src/datawrapper.pyx b/src/datawrapper.pyx
new file mode 100644
index 0000000..070d4e4
--- /dev/null
+++ b/src/datawrapper.pyx
@@ -0,0 +1,201 @@
+"""
+SPDX-License-Identifier: LGPL-2.1
+
+Copyright 2019 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
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
+from libc cimport stdint
+ctypedef stdint.int16_t int16_t
+ctypedef stdint.uint16_t uint16_t
+ctypedef stdint.int32_t int32_t
+ctypedef stdint.uint32_t uint32_t
+ctypedef stdint.int64_t int64_t
+ctypedef stdint.uint64_t uint64_t
+
+cdef extern from 'numpy/ndarraytypes.h':
+    int NPY_ARRAY_CARRAY
+    
+# Numpy must be initialized!!!
+np.import_array()
+
+cdef extern from 'trace2matrix.c':
+    ssize_t trace2matrix(uint64_t **offset_array,
+			 uint16_t **cpu_array,
+			 uint64_t **ts_array,
+			 uint16_t **pid_array,
+			 int **event_array)
+
+data_column_types = {
+    'cpu': np.NPY_UINT16,
+    'pid': np.NPY_UINT16,
+    'event': np.NPY_INT,
+    'offset': np.NPY_UINT64,
+    'time': np.NPY_UINT64
+    }
+
+cdef class KsDataWrapper:
+    cdef int item_size
+    cdef int data_size
+    cdef int data_type
+    cdef void* data_ptr
+
+    cdef init(self, int data_type,
+                    int data_size,
+                    int item_size,
+                    void* data_ptr):
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
+def load(ofst_data=True, cpu_data=True, ts_data=True,
+         pid_data=True, evt_data=True):
+    """ Python binding of the 'kshark_load_data_matrix' function that does not
+        copy the data. The input parameters can be used to avoid loading the
+        data from the unnecessary fields.
+    """
+    cdef uint64_t *ofst_c
+    cdef uint16_t *cpu_c
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
+    cdef ssize_t size
+
+    size = trace2matrix(&ofst_c, &cpu_c, &ts_c, &pid_c, &evt_c)
+    if size <= 0:
+        raise Exception('No data has been loaded.')
+
+    if cpu_data:
+        column = 'cpu'
+        array_wrapper_cpu = KsDataWrapper()
+        array_wrapper_cpu.init(data_type=data_column_types[column],
+                               data_size=size,
+                               item_size=0,
+                               data_ptr=<void *> cpu_c)
+
+        cpu = np.array(array_wrapper_cpu, copy=False)
+        cpu.base = <PyObject *> array_wrapper_cpu
+        data_dict.update({column: cpu})
+        Py_INCREF(array_wrapper_cpu)
+
+    if pid_data:
+        column = 'pid'
+        array_wrapper_pid = KsDataWrapper()
+        array_wrapper_pid.init(data_type=data_column_types[column],
+                               data_size=size,
+                               item_size=0,
+                               data_ptr=<void *>pid_c)
+
+        pid = np.array(array_wrapper_pid, copy=False)
+        pid.base = <PyObject *> array_wrapper_pid
+        data_dict.update({column: pid})
+        Py_INCREF(array_wrapper_pid)
+
+    if evt_data:
+        column = 'event'
+        array_wrapper_evt = KsDataWrapper()
+        array_wrapper_evt.init(data_type=data_column_types[column],
+                               data_size=size,
+                               item_size=0,
+                               data_ptr=<void *>evt_c)
+
+        evt = np.array(array_wrapper_evt, copy=False)
+        evt.base = <PyObject *> array_wrapper_evt
+        data_dict.update({column: evt})
+        Py_INCREF(array_wrapper_evt)
+
+    if ofst_data:
+        column = 'offset'
+        array_wrapper_ofst = KsDataWrapper()
+        array_wrapper_ofst.init(data_type=data_column_types[column],
+                                data_size=size,
+                                item_size=0,
+                                data_ptr=<void *> ofst_c)
+
+
+        ofst = np.array(array_wrapper_ofst, copy=False)
+        ofst.base = <PyObject *> array_wrapper_ofst
+        data_dict.update({column: ofst})
+        Py_INCREF(array_wrapper_ofst)
+        
+    if ts_data:
+        column = 'time'
+        array_wrapper_ts = KsDataWrapper()
+        array_wrapper_ts.init(data_type=data_column_types[column],
+                              data_size=size,
+                              item_size=0,
+                              data_ptr=<void *> ts_c)
+
+        ts = np.array(array_wrapper_ts, copy=False)
+        ts.base = <PyObject *> array_wrapper_ts
+        data_dict.update({column: ts})
+        Py_INCREF(array_wrapper_ts)
+
+    return data_dict
diff --git a/src/trace2matrix.c b/src/trace2matrix.c
new file mode 100644
index 0000000..aaf8322
--- /dev/null
+++ b/src/trace2matrix.c
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: LGPL-2.1
+
+/*
+ * Copyright 2019 VMware Inc, Yordan Karadzhov <ykaradzhov@vmware.com>
+ */
+
+// KernelShark
+#include "kernelshark/libkshark.h"
+
+ssize_t trace2matrix(uint64_t **offset_array,
+		     uint16_t **cpu_array,
+		     uint64_t **ts_array,
+		     uint16_t **pid_array,
+		     int **event_array)
+{
+	struct kshark_context *kshark_ctx = NULL;
+	ssize_t total = 0;
+
+	if (!kshark_instance(&kshark_ctx))
+		return -1;
+
+	total = kshark_load_data_matrix(kshark_ctx, offset_array,
+						    cpu_array,
+						    ts_array,
+						    pid_array,
+						    event_array);
+
+	return total;
+}
-- 
2.20.1

