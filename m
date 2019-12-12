Return-Path: <SRS0=wXUw=2C=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60624C2D0C8
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 09:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B18C24654
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 09:03:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hEgkwbLq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbfLLJDG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Dec 2019 04:03:06 -0500
Received: from mail-lf1-f42.google.com ([209.85.167.42]:46174 "EHLO
        mail-lf1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728256AbfLLJDF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Dec 2019 04:03:05 -0500
Received: by mail-lf1-f42.google.com with SMTP id f15so1057148lfl.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Dec 2019 01:03:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a+BXVPMKBy+1VO/77mfq//mwpBhl95JVPpWHC+3ZHXw=;
        b=hEgkwbLqruqEqj+qK+BFcjQs1ABWDRFR06lA6WLsRrF01gWUDJt8c3WlIDOigtO5Pi
         6Spb8KBNw57hZUOYfIJdYsM/9bRpxrPCrw8ZLJInFkotqh6nVms5L1iK0atKO8A4WDdN
         DaG0ktXyTLfl6LkjT8rY69iiATzxl0TATq21cv3puGVYmcTDPk2l/5JEpR5vjzRDoNnc
         vwkyRkbiVuL9JG/T5W/EAS6naBdd2iL1KawDMOXprQV0Nay2bfQfyTIfcdzSqwN1hA9W
         +BSyfPXnh8uKbR9Gfs7FjJhQ/TN2fCJGmraGNkyseQIwk1gF1ZlliSuIYeWyPohdjNVn
         d3Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a+BXVPMKBy+1VO/77mfq//mwpBhl95JVPpWHC+3ZHXw=;
        b=QvoKvMCv3vxmEYooW7RNZ5LLLmbZP/Ki+3f0NnmmVEgIYt3govzqsssQ0/BzruL/jb
         VoDrc8ZIfMgmtKq0FoVMd0Z9/mkxApe6EgnT+jiF//akeOp0AJWEdQnztm5SrlUaGgUU
         ZBbUU+FlqNNwyVTdQCYmcO4dq1F2aD7qOipnt9y7+ehMmp/R68iCjvqD2v7vUwOxc68Y
         4198/p2yEWweeDZF02xwniTuYq5T7I+8fBSRcgTFUIbx64aQJwivZm7wW5jMpC8+SX1d
         wb9Q9QPFXYCAJ+gy/tbjTemtFn6P4Xb/JSpD6YGNEtE0BmTJN21htKe2zw0NjD3ccOnJ
         Z3UQ==
X-Gm-Message-State: APjAAAXkUlKxCuXOWEUTt6rM8h1quzRXVsyTZNN895ZY9VNjblYu4UGb
        13lvrGgLrJaXZWS0ChT6xWqk5Tw9
X-Google-Smtp-Source: APXvYqw2/KGKHcqjq7gSukWNktx38T2brmarVgUtmlr4U4Mgv4cU0dqKMcMEHypyPMyU5NYOy36Sdw==
X-Received: by 2002:a19:5212:: with SMTP id m18mr4905676lfb.7.1576141383171;
        Thu, 12 Dec 2019 01:03:03 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u16sm2849908lfi.36.2019.12.12.01.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 01:03:02 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, Valentin.Schneider@arm.com,
        douglas.raillard@arm.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/5] Refactor NumPy based data wrapper
Date:   Thu, 12 Dec 2019 11:02:30 +0200
Message-Id: <20191212090232.24236-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191212090232.24236-1-y.karadz@gmail.com>
References: <20191212090232.24236-1-y.karadz@gmail.com>
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
 setup.py            |  10 ++-
 src/datawrapper.pyx | 201 ++++++++++++++++++++++++++++++++++++++++++++
 src/trace2matrix.c  |  29 +++++++
 3 files changed, 239 insertions(+), 1 deletion(-)
 create mode 100644 src/datawrapper.pyx
 create mode 100644 src/trace2matrix.c

diff --git a/setup.py b/setup.py
index dfe1d00..5a07710 100644
--- a/setup.py
+++ b/setup.py
@@ -16,6 +16,14 @@ def main():
     traceevent_path = '/usr/local/lib/traceevent/'
     tracecmd_path = '/usr/local/lib/trace-cmd/'
 
+    cythonize('src/datawrapper.pyx')
+    module_data = Extension('tracecruncher.datawrapper',
+                            sources=['src/datawrapper.c'],
+                            library_dirs=[kshark_path, traceevent_path, tracecmd_path],
+                            runtime_library_dirs=[kshark_path, traceevent_path, tracecmd_path],
+                            libraries=['kshark', 'traceevent', 'tracecmd']
+                            )
+
     module_ks = Extension('tracecruncher.ksharkpy',
                           sources=['src/ksharkpy.c'],
                           library_dirs=[kshark_path],
@@ -42,7 +50,7 @@ def main():
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

