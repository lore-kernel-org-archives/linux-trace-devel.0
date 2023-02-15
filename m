Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 808DBC05027
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Feb 2023 01:48:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjBOBsN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Feb 2023 20:48:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjBOBsM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Feb 2023 20:48:12 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0822749F
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Feb 2023 17:48:10 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id v3so11508352pgh.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Feb 2023 17:48:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=QEQeqjxKYjCpukABJfY+8njc02+31fc7uyYh6VWlxRI=;
        b=KrzcC9uhSY2lzjwHxyGXyvEFKYL2xvNfcixWoUKY11H1UfFMS0+/l19vt17+XkLA8H
         thGfrGEdM80t2zytA96miiOuDe2iJXcae0gU3X83gQeE0vDKtpZNc6kAXmSs1885zema
         m03b9eWDvrpVCfFVMoP7jl6kAsEQbuqiDVnr7UCsucGcOeEhOAKMZT9c59d35vvwMPnj
         87nRcdRG4JfgqCdB7m1T2Qetkf7PiLSOWPtGGSiKO/zscRig7Ir6zhRcvJfdO/rwq4i+
         EOmhUw20twgHqPIF83ZMbqt8jWqpulQQ4sblLLVE3a/XFQmP10pPK8kiIAHhMy+AAvrK
         SSrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QEQeqjxKYjCpukABJfY+8njc02+31fc7uyYh6VWlxRI=;
        b=l2f3LtHm/dY+pDcvtMLUQs6pz+vHvKboyn/+uEfQBDwrrXJP6ArsGWMxLCTpFnJ2fc
         mHZusDvwSVVd9v5LiuTfY37y1IrIvg9U3PNwGAFKmsPy3U3lh/QMD14tcDGNlI1AnPIX
         D60kdnMvb6FSexIOcUrb/GDMns9MWBkIOq8xNmmDGYl6XXDxPyccmYWBA2vs9BWLjTIo
         /5z8+Hz6I9arbqB0h0ABaXwm4ylbOkBSEwbW51keC/qHqheQnV6lH6xmPM1zPAgDrQst
         U1uJZPeyxkQP1xwuM7MGwEu+Tz6Ow71iCVssFb0IfZVNu7H2/Bpe3scvcxZlfE9tYFNY
         z4UQ==
X-Gm-Message-State: AO0yUKX9LnDAjanvoPMGVLbYueunqoW94tv2/pLHuyHV9zANZwuOb1vx
        dblee3nzv635t2Vy2OKXm0rQWLXFrjw=
X-Google-Smtp-Source: AK7set9XEC5fU5eX10d6URi7lIBEVXYnwjv3Er/E7QCmTNvq7dpCmh0ysVY5ObAkr8sCvLheXvbZVQ==
X-Received: by 2002:aa7:900e:0:b0:5a8:cc39:fc58 with SMTP id m14-20020aa7900e000000b005a8cc39fc58mr1266251pfo.6.1676425689154;
        Tue, 14 Feb 2023 17:48:09 -0800 (PST)
Received: from localhost ([2620:10d:c090:400::5:497a])
        by smtp.gmail.com with ESMTPSA id y8-20020a62b508000000b00592de256f2csm10681892pfe.145.2023.02.14.17.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 17:48:08 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Tue, 14 Feb 2023 15:48:06 -1000
From:   Tejun Heo <tj@kernel.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] trace-cmd: python: Update python module
Message-ID: <Y+w51nOhNd+PGo/k@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

It looks like python support has been left behind for quite a while. While
the current code builds, there are multiple problems:

- Linker library flags haven't been updated, so the produced ctracecmd.so is
  missing dependency on zlib and libzstd which makes the python fail to
  load.

- tep_plugin_kvm_get/put_func() cause load failures.

- Some of the tracecmd library functions are made private and swig no longer
  generates wrappers for them.

- Some library functions and conventions are changed.

- Recent python3 isn't happy with some older constructs (e.g. DictMixin).

This patch fixes up the python support by:

- Add missing library flags.

- Add %ignore swig directives for tep_plugin_kvm_get/put_func(). They aren't
  used by python module anyway.

- Move the prototypes of the following functions from
  trace-cmd/include/private/trace-cmd-private.h to
  trace-cmd-private-python.h and include it from ctracecmd.i so that the
  wrappers are generated for them.

  tracecmd_long_size()
  tracecmd_cpus()
  tracecmd_peek_data()
  tracecmd_peek_data_ref()
  tracecmd_read_next_data()

- Update the library calls as needed.

- Update to python3

  - s/PyEval_CallObject/PyObject_Call/

  - Use functools.cached_property instead of the custom one.

  - Replace DictMixin with collections.abc.Mapping which requires
    implementation of __iter__() and __len__(). Implement them so that all
    keys can be iterated and counted.

- Beef up the test code a bit.

This makes it incompatible with python2 but given how long the module has
been broken and how long python3 has been widespread, concentrating on
python3 support seems reasonable.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Hello,

The trace-cmd-private-python.h part is kinda ugly. Please let me know if
anyone has better ideas.

Thanks.

 Makefile                                      |  2 +-
 .../private/trace-cmd-private-python.h        | 27 +++++++
 .../include/private/trace-cmd-private.h       | 18 +----
 python/Makefile                               |  7 +-
 python/ctracecmd.i                            | 10 ++-
 python/tracecmd.py                            | 71 +++++++++----------
 6 files changed, 76 insertions(+), 59 deletions(-)
 create mode 100644 lib/trace-cmd/include/private/trace-cmd-private-python.h

diff --git a/Makefile b/Makefile
index ea83f60..c2c819e 100644
--- a/Makefile
+++ b/Makefile
@@ -144,7 +144,7 @@ endif
 ifndef NO_PYTHON
 PYTHON		:= ctracecmd.so
 
-PYTHON_VERS ?= python
+PYTHON_VERS ?= python3
 PYTHON_PKGCONFIG_VERS ?= $(PYTHON_VERS)
 
 # Can build python?
diff --git a/lib/trace-cmd/include/private/trace-cmd-private-python.h b/lib/trace-cmd/include/private/trace-cmd-private-python.h
new file mode 100644
index 0000000..ddc52f1
--- /dev/null
+++ b/lib/trace-cmd/include/private/trace-cmd-private-python.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+/*
+ * Private interface exposed to the python module. See python/ctracecmd.i and
+ * python/tracecmd.py.
+ */
+#ifndef _TRACE_CMD_PRIVATE_PYTHON_H
+#define _TRACE_CMD_PRIVATE_PYTHON_H
+
+int tracecmd_long_size(struct tracecmd_input *handle);
+int tracecmd_cpus(struct tracecmd_input *handle);
+
+struct tep_record *
+tracecmd_read_next_data(struct tracecmd_input *handle, int *rec_cpu);
+
+struct tep_record *
+tracecmd_peek_data(struct tracecmd_input *handle, int cpu);
+
+static inline struct tep_record *
+tracecmd_peek_data_ref(struct tracecmd_input *handle, int cpu)
+{
+	struct tep_record *rec = tracecmd_peek_data(handle, cpu);
+	if (rec)
+		rec->ref_count++;
+	return rec;
+}
+
+#endif /* _TRACE_CMD_PRIVATE_PYTHON_H */
diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index f2cf8dc..6173001 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -10,6 +10,7 @@
 #include <sys/types.h>
 #include "event-parse.h"
 #include "trace-cmd/trace-cmd.h"
+#include "trace-cmd-private-python.h"
 
 #define __packed __attribute__((packed))
 #define __hidden __attribute__((visibility ("hidden")))
@@ -194,9 +195,7 @@ void tracecmd_ref(struct tracecmd_input *handle);
 int tracecmd_read_headers(struct tracecmd_input *handle,
 			  enum tracecmd_file_states state);
 int tracecmd_get_parsing_failures(struct tracecmd_input *handle);
-int tracecmd_long_size(struct tracecmd_input *handle);
 int tracecmd_page_size(struct tracecmd_input *handle);
-int tracecmd_cpus(struct tracecmd_input *handle);
 int tracecmd_copy_headers(struct tracecmd_input *in_handle,
 			  struct tracecmd_output *out_handle,
 			  enum tracecmd_file_states start_state,
@@ -230,26 +229,11 @@ void tracecmd_print_stats(struct tracecmd_input *handle);
 void tracecmd_print_uname(struct tracecmd_input *handle);
 void tracecmd_print_version(struct tracecmd_input *handle);
 
-struct tep_record *
-tracecmd_peek_data(struct tracecmd_input *handle, int cpu);
-
-static inline struct tep_record *
-tracecmd_peek_data_ref(struct tracecmd_input *handle, int cpu)
-{
-	struct tep_record *rec = tracecmd_peek_data(handle, cpu);
-	if (rec)
-		rec->ref_count++;
-	return rec;
-}
-
 int tracecmd_latency_data_read(struct tracecmd_input *handle, char **buf, size_t *size);
 
 struct tep_record *
 tracecmd_read_prev(struct tracecmd_input *handle, struct tep_record *record);
 
-struct tep_record *
-tracecmd_read_next_data(struct tracecmd_input *handle, int *rec_cpu);
-
 struct tep_record *
 tracecmd_peek_next_data(struct tracecmd_input *handle, int *rec_cpu);
 
diff --git a/python/Makefile b/python/Makefile
index 63f5736..926e64c 100644
--- a/python/Makefile
+++ b/python/Makefile
@@ -9,9 +9,12 @@ PYTHON_PY_LIBS := tracecmd.install
 endif
 
 ctracecmd.so: ctracecmd.i $(LIBTRACECMD_STATIC)
-	swig -Wall -python -noproxy -I$(src)/include/trace-cmd $(LIBTRACEEVENT_CFLAGS) ctracecmd.i
+	swig -Wall -python -noproxy \
+		-I$(src)/include/trace-cmd -I$(src)/lib/trace-cmd/include/private \
+		$(LIBTRACEEVENT_CFLAGS) ctracecmd.i
 	$(CC) -fpic -c $(CPPFLAGS) $(CFLAGS) $(PYTHON_INCLUDES)  ctracecmd_wrap.c
-	$(CC) --shared $(LIBTRACECMD_STATIC) $(LDFLAGS) ctracecmd_wrap.o -o ctracecmd.so $(TRACE_LIBS)
+	$(CC) --shared $(LIBTRACECMD_STATIC) $(LDFLAGS) $(LIBZSTD_LDLAGS) $(ZLIB_LDLAGS) \
+		ctracecmd_wrap.o -o ctracecmd.so $(TRACE_LIBS)
 
 $(PYTHON_SO_INSTALL): %.install : %.so force
 	$(Q)$(call do_install_data,$<,$(python_dir_SQ))
diff --git a/python/ctracecmd.i b/python/ctracecmd.i
index 6d0179e..3856460 100644
--- a/python/ctracecmd.i
+++ b/python/ctracecmd.i
@@ -15,6 +15,7 @@
 
 %{
 #include "trace-cmd.h"
+#include "trace-cmd-private-python.h"
 #include "event-parse.h"
 #include "event-utils.h"
 #include <Python.h>
@@ -176,14 +177,14 @@ static PyObject *py_field_get_str(struct tep_format_field *f, struct tep_record
 				strnlen((char *)r->data + f->offset, f->size));
 }
 
-static PyObject *py_format_get_keys(struct tep_event *ef)
+static PyObject *py_format_get_keys(struct tep_event *ef, bool common_keys)
 {
 	PyObject *list;
 	struct tep_format_field *f;
 
 	list = PyList_New(0);
 
-	for (f = ef->format.fields; f; f = f->next) {
+	for (f = common_keys ? ef->format.common_fields : ef->format.fields; f; f = f->next) {
 		if (PyList_Append(list, PyUnicode_FromString(f->name))) {
 			Py_DECREF(list);
 			return NULL;
@@ -214,7 +215,7 @@ static int python_callback(struct trace_seq *s,
 		SWIG_NewPointerObj(SWIG_as_voidptr(event),
 				   SWIGTYPE_p_tep_event, 0));
 
-	result = PyEval_CallObject(context, arglist);
+	result = PyObject_Call(context, arglist, NULL);
 	Py_XDECREF(arglist);
 	if (result && result != Py_None) {
 		if (!PyInt_Check(result)) {
@@ -239,6 +240,8 @@ static int python_callback(struct trace_seq *s,
 
 %ignore trace_seq_vprintf;
 %ignore vpr_stat;
+%ignore tep_plugin_kvm_get_func;
+%ignore tep_plugin_kvm_put_func;
 
 /* SWIG can't grok these, define them to nothing */
 #define __trace
@@ -246,5 +249,6 @@ static int python_callback(struct trace_seq *s,
 #define __thread
 
 %include "trace-cmd.h"
+%include "trace-cmd-private-python.h"
 %include <trace-seq.h>
 %include <event-parse.h>
diff --git a/python/tracecmd.py b/python/tracecmd.py
index 4d48157..6761f8a 100644
--- a/python/tracecmd.py
+++ b/python/tracecmd.py
@@ -18,9 +18,10 @@
 # 2009-Dec-17:	Initial version by Darren Hart <dvhltc@us.ibm.com>
 #
 
-from functools import update_wrapper
+from functools import cached_property
+from collections.abc import Mapping
+from itertools import chain
 from ctracecmd import *
-from UserDict import DictMixin
 
 """
 Python interface to the tracecmd library for parsing ftrace traces
@@ -33,25 +34,7 @@ and it is recommended applications not use it directly.
 TODO: consider a complete class hierarchy of ftrace events...
 """
 
-def cached_property(func, name=None):
-    if name is None:
-        name = func.__name__
-    def _get(self):
-        try:
-            return self.__cached_properties[name]
-        except AttributeError:
-            self.__cached_properties = {}
-        except KeyError:
-            pass
-        value = func(self)
-        self.__cached_properties[name] = value
-        return value
-    update_wrapper(_get, func)
-    def _del(self):
-        self.__cached_properties.pop(name, None)
-    return property(_get, None, _del)
-
-class Event(object, DictMixin):
+class Event(Mapping):
     """
     This class can be used to access event data
     according to an event's record and format.
@@ -67,16 +50,30 @@ TODO: consider a complete class hierarchy of ftrace events...
                 self.num_field("common_pid"), self.comm, self.type)
 
     def __del__(self):
-        free_record(self._record)
+        tracecmd_free_record(self._record)
 
     def __getitem__(self, n):
-        f = tep_find_field(self._format, n)
+        if n.startswith('common_'):
+            f = tep_find_common_field(self._format, n)
+        else:
+            f = tep_find_field(self._format, n)
         if f is None:
             raise KeyError("no field '%s'" % n)
         return Field(self._record, f)
 
+    def __iter__(self):
+        yield from chain(self.common_keys, self.keys)
+
+    def __len__(self):
+        return len(self.common_keys) + len(self.keys)
+
+    @cached_property
+    def common_keys(self):
+        return py_format_get_keys(self._format, True)
+
+    @cached_property
     def keys(self):
-        return py_format_get_keys(self._format)
+        return py_format_get_keys(self._format, False)
 
     @cached_property
     def comm(self):
@@ -88,7 +85,7 @@ TODO: consider a complete class hierarchy of ftrace events...
 
     @cached_property
     def name(self):
-        return event_format_name_get(self._format)
+        return tep_event_name_get(self._format)
 
     @cached_property
     def pid(self):
@@ -182,15 +179,8 @@ TODO: consider a complete class hierarchy of ftrace events...
     used to manage the trace and extract events from it.
     """
     def __init__(self, filename):
-        self._handle = tracecmd_alloc(filename)
-
-        if tracecmd_read_headers(self._handle):
-            raise FileFormatError("Invalid headers")
-
-        if tracecmd_init_data(self._handle):
-            raise FileFormatError("Failed to init data")
-
-        self._pevent = tracecmd_get_pevent(self._handle)
+        self._handle = tracecmd_open(filename, 0)
+        self._pevent = tracecmd_get_tep(self._handle)
 
     @cached_property
     def cpus(self):
@@ -242,8 +232,12 @@ TODO: consider a complete class hierarchy of ftrace events...
 # Basic builtin test, execute module directly
 if __name__ == "__main__":
     t = Trace("trace.dat")
-    print("Trace contains data for %d cpus" % (t.cpus))
+    print(f"Trace contains data for {t.cpus} cpus, long has {t.long_size} bytes")
+
+    print("Peek the first event on CPU0")
+    print("\t%s" % (t.peek_event(0)))
 
+    print("Events by CPUs")
     for cpu in range(0, t.cpus):
         print("CPU %d" % (cpu))
         ev = t.read_event(cpu)
@@ -251,5 +245,10 @@ TODO: consider a complete class hierarchy of ftrace events...
             print("\t%s" % (ev))
             ev = t.read_event(cpu)
 
+    t = Trace("trace.dat")
 
-
+    print("Events by time")
+    ev = t.read_next_event()
+    while ev:
+        print("\t%s" % (ev))
+        ev = t.read_next_event()
-- 
2.39.1

