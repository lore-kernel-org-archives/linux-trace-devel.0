Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49808C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Oct 2022 10:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiJLKPg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 Oct 2022 06:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiJLKPG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Oct 2022 06:15:06 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059DCC1496
        for <linux-trace-devel@vger.kernel.org>; Wed, 12 Oct 2022 03:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=Xm2jFdh6ZaZS4vLe6VYr6Fv6fVou9ez5xtbREHR0igs=;
        t=1665569608; x=1666779208; b=xvnXZXpw+9VPthcv7vaHJEoIBVNyBA+1VjJq7Nrn51bSS5Q
        90p4d9YlXuay24hWd3KPKtr73hFJ766hFHJDvPBKlPqEUSEP/X+ryuDiHHop06tN0Q6S2rHZZGCXP
        5hn8JpduOZA6O9Ly3bs2r7qG/G/k11oqPodXhBF8Z5Ioz++1t0o0QCtqMLN0wT1xrI4lXVit59eUV
        hYq2S7O1SPaFZT5keAjDyLsx7hdNQa5/yBUpQStUVKIeI5j0lfrLav+6mmSwT1Ye0YvjeI0Tr/ZXY
        6KpJtwdUMX5aPBJj7KFlXhu/xjSph7mpj4Gt6POjQjq0E+Av4gmYls4OUuG3+x9Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <benjamin@sipsolutions.net>)
        id 1oiYjk-004lcr-0G;
        Wed, 12 Oct 2022 12:13:16 +0200
From:   Benjamin Berg <benjamin@sipsolutions.net>
To:     linux-trace-devel@vger.kernel.org
Cc:     johannes@sipsolutions.net,
        Benjamin Berg <benjamin@sipsolutions.net>
Subject: [RFC PATCH 2/2] trace-cmd: Add back python support without wrapping trace-cmd API
Date:   Wed, 12 Oct 2022 12:13:07 +0200
Message-Id: <20221012101307.784747-2-benjamin@sipsolutions.net>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221012101307.784747-1-benjamin@sipsolutions.net>
References: <20221012101307.784747-1-benjamin@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This code appears to be working at this point. Note that it is a pure
libtraceevent plugin at this point (the trace-cmd API is not wrapped
anymore). As such, the code should live in libtraceevent rather than
here.

Also, the Makefile changes are incomplete.

Coming from the GNOME side, I was considering that a good approach might
be to create a GLib based wrapper library for libtraceevent and a
separate (python) plugin loader using it. I suppose, if people are happy
with the current SWIG bindings, then it is not worth to do that though.
---
 Makefile                      |   5 +-
 python/Makefile               |  11 +++-
 python/ctracecmd.i            |  12 ++--
 python/plugin_python_loader.c | 115 ++++++++++++++++++++++++++++++++++
 python/tracecmd.py            |  91 +++------------------------
 5 files changed, 143 insertions(+), 91 deletions(-)
 create mode 100644 python/plugin_python_loader.c

diff --git a/Makefile b/Makefile
index 7178d7a9..19649f4a 100644
--- a/Makefile
+++ b/Makefile
@@ -142,7 +142,7 @@ NO_PYTHON = 1
 endif
 
 ifndef NO_PYTHON
-PYTHON		:= ctracecmd.so
+PYTHON		:= ctracecmd.so plugin_python_loader.so
 
 PYTHON_VERS ?= python
 PYTHON_PKGCONFIG_VERS ?= $(PYTHON_VERS)
@@ -585,6 +585,9 @@ export PYGTK_CFLAGS
 ctracecmd.so: force $(LIBTRACECMD_STATIC)
 	$(Q)$(MAKE) -C $(src)/python $@
 
+plugin_python_loader.so: force $(LIBTRACECMD_STATIC)
+	$(Q)$(MAKE) -C $(src)/python $@
+
 PHONY += python
 python: $(PYTHON)
 
diff --git a/python/Makefile b/python/Makefile
index 63f5736d..d0bab375 100644
--- a/python/Makefile
+++ b/python/Makefile
@@ -6,10 +6,11 @@ ifdef BUILD_PYTHON_WORKS
 PYTHON_SO_INSTALL := ctracecmd.install
 PYTHON_PY_PROGS := event-viewer.install
 PYTHON_PY_LIBS := tracecmd.install
+PYTHON_PLUGIN := plugin_python_loader.so
 endif
 
 ctracecmd.so: ctracecmd.i $(LIBTRACECMD_STATIC)
-	swig -Wall -python -noproxy -I$(src)/include/trace-cmd $(LIBTRACEEVENT_CFLAGS) ctracecmd.i
+	swig -Wall -python -noproxy $(LIBTRACEEVENT_CFLAGS) ctracecmd.i
 	$(CC) -fpic -c $(CPPFLAGS) $(CFLAGS) $(PYTHON_INCLUDES)  ctracecmd_wrap.c
 	$(CC) --shared $(LIBTRACECMD_STATIC) $(LDFLAGS) ctracecmd_wrap.o -o ctracecmd.so $(TRACE_LIBS)
 
@@ -22,7 +23,13 @@ $(PYTHON_PY_PROGS): %.install : %.py force
 $(PYTHON_PY_LIBS): %.install : %.py force
 	$(Q)$(call do_install_data,$<,$(python_dir_SQ))
 
-install_python: $(PYTHON_SO_INSTALL) $(PYTHON_PY_PROGS) $(PYTHON_PY_LIBS)
+plugin_python_loader.so: %.so: %.o
+	$(Q)$(do_python_plugin_build)
+
+plugin_python_loader.o: %.o : %.c
+	$(Q)$(do_compile_python_plugin_obj)
+
+install_python: $(PYTHON_SO_INSTALL) $(PYTHON_PY_PROGS) $(PYTHON_PY_LIBS) $(PYTHON_PLUGIN)
 
 
 clean:
diff --git a/python/ctracecmd.i b/python/ctracecmd.i
index 6d0179e3..c0c0097c 100644
--- a/python/ctracecmd.i
+++ b/python/ctracecmd.i
@@ -12,9 +12,16 @@
 %apply unsigned long long *OUTPUT {unsigned long long *}
 %apply int *OUTPUT {int *}
 
+%ignore ref_count;
+%ignore locked;
+%ignore tep_print_field;
+%rename(tep_print_field) tep_print_field_content;
+
+//%feature("ref")   record "tep_record_ref($this));"
+//%feature("unref") record "tep_record_unref($this);"
+
 
 %{
-#include "trace-cmd.h"
 #include "event-parse.h"
 #include "event-utils.h"
 #include <Python.h>
@@ -204,8 +211,6 @@ static int python_callback(struct trace_seq *s,
 	PyObject *arglist, *result;
 	int r = 0;
 
-	record->ref_count++;
-
 	arglist = Py_BuildValue("(OOO)",
 		SWIG_NewPointerObj(SWIG_as_voidptr(s),
 				   SWIGTYPE_p_trace_seq, 0),
@@ -245,6 +250,5 @@ static int python_callback(struct trace_seq *s,
 #define __attribute__(x)
 #define __thread
 
-%include "trace-cmd.h"
 %include <trace-seq.h>
 %include <event-parse.h>
diff --git a/python/plugin_python_loader.c b/python/plugin_python_loader.c
new file mode 100644
index 00000000..58482795
--- /dev/null
+++ b/python/plugin_python_loader.c
@@ -0,0 +1,115 @@
+// SPDX-License-Identifier: LGPL-2.1
+#include <Python.h>
+#include <stdio.h>
+#include "event-parse.h"
+#include "trace-cmd-private.h"
+
+#ifndef PYTHON_DIR
+#define PYTHON_DIR "."
+#endif
+
+static const char pypath[] =
+"import sys\n"
+"sys.path.append(\"" PYTHON_DIR "\")\n";
+
+static const char pyload[] =
+"import imp, tracecmd, ctracecmd\n"
+"fn = r'%s'\n"
+"file = open(fn, 'r')\n"
+"try:\n"
+"   module = imp.load_source('%s', fn, file)\n"
+"   module.register(tracecmd.PEvent(ctracecmd.convert_pevent(pevent)))\n"
+"finally:\n"
+"   file.close()\n";
+
+static void load_plugin(struct tep_handle *pevent, const char *path,
+		       const char *name, void *data)
+{
+	PyObject *globals = data;
+	int err;
+	int len = strlen(path) + strlen(name) + 2;
+	int nlen = strlen(name) + 1;
+	char *full = malloc(len);
+	char *n = malloc(nlen);
+	char *load;
+	PyObject *res;
+
+	if (!full || !n)
+		return;
+
+	strcpy(full, path);
+	strcat(full, "/");
+	strcat(full, name);
+
+	strcpy(n, name);
+	n[nlen - 4] = '\0';
+
+	err = asprintf(&load, pyload, full, n);
+	if (err < 0)
+		return;
+
+	res = PyRun_String(load, Py_file_input, globals, globals);
+	if (!res) {
+		fprintf(stderr, "failed loading %s\n", full);
+		PyErr_Print();
+	} else
+		Py_DECREF(res);
+
+	free(load);
+
+}
+
+void set_has_plugin(struct tep_handle *tep,
+		    const char *path,
+		    const char *name,
+		    void *data)
+{
+	*(bool*) data = true;
+}
+
+int TEP_PLUGIN_LOADER(struct tep_handle *pevent)
+{
+	PyObject *globals, *m, *py_pevent, *str, *res;
+	bool has_plugin = false;
+
+	/* Only load plugins if they exist */
+	tep_load_plugins_hook(pevent, ".py", set_has_plugin, &has_plugin);
+	if (!has_plugin)
+		return 0;
+
+	Py_Initialize();
+
+	m = PyImport_AddModule("__main__");
+	globals = PyModule_GetDict(m);
+
+	res = PyRun_String(pypath, Py_file_input, globals, globals);
+	if (!res) {
+		PyErr_Print();
+		return -1;
+	} else
+		Py_DECREF(res);
+
+	str = PyUnicode_FromString("pevent");
+	if (!str)
+		return -ENOMEM;
+
+	py_pevent = PyLong_FromUnsignedLong((unsigned long)pevent);
+	if (!py_pevent)
+		return -ENOMEM;
+
+	if (PyDict_SetItem(globals, str, py_pevent))
+		fprintf(stderr, "failed to insert pevent\n");
+
+	Py_DECREF(py_pevent);
+	Py_DECREF(str);
+
+	tep_load_plugins_hook(pevent, ".py", load_plugin, globals);
+
+	return 0;
+}
+
+int TEP_PLUGIN_UNLOADER(struct tep_handle *pevent)
+{
+	Py_Finalize();
+	return 0;
+}
diff --git a/python/tracecmd.py b/python/tracecmd.py
index 4d481576..e435712c 100644
--- a/python/tracecmd.py
+++ b/python/tracecmd.py
@@ -22,6 +22,8 @@ from functools import update_wrapper
 from ctracecmd import *
 from UserDict import DictMixin
 
+__all__ = ["Event", "TraceSeq", "FieldError", "Field", "PEvent"]
+
 """
 Python interface to the tracecmd library for parsing ftrace traces
 
@@ -61,13 +63,15 @@ class Event(object, DictMixin):
         self._record = record
         self._format = format
 
+        tep_record_ref(self._record)
+
     def __str__(self):
         return "%d.%09d CPU%d %s: pid=%d comm=%s type=%d" % \
                (self.ts/1000000000, self.ts%1000000000, self.cpu, self.name,
                 self.num_field("common_pid"), self.comm, self.type)
 
     def __del__(self):
-        free_record(self._record)
+        tep_record_unref(self._record)
 
     def __getitem__(self, n):
         f = tep_find_field(self._format, n)
@@ -126,6 +130,8 @@ class TraceSeq(object):
         self._trace_seq = trace_seq
 
     def puts(self, s):
+        if type(s) != str:
+            s = s.encode('ascii')
         return trace_seq_puts(self._trace_seq, s)
 
 class FieldError(Exception):
@@ -170,86 +176,3 @@ class PEvent(object):
             return '>'
         return '<'
 
-
-class FileFormatError(Exception):
-    pass
-
-class Trace(object):
-    """
-    Trace object represents the trace file it is created with.
-
-    The Trace object aggregates the tracecmd structures and functions that are
-    used to manage the trace and extract events from it.
-    """
-    def __init__(self, filename):
-        self._handle = tracecmd_alloc(filename)
-
-        if tracecmd_read_headers(self._handle):
-            raise FileFormatError("Invalid headers")
-
-        if tracecmd_init_data(self._handle):
-            raise FileFormatError("Failed to init data")
-
-        self._pevent = tracecmd_get_pevent(self._handle)
-
-    @cached_property
-    def cpus(self):
-        return tracecmd_cpus(self._handle)
-
-    @cached_property
-    def long_size(self):
-        return tracecmd_long_size(self._handle)
-
-    def read_event(self, cpu):
-        rec = tracecmd_read_data(self._handle, cpu)
-        if rec:
-            type = tep_data_type(self._pevent, rec)
-            format = tep_find_event(self._pevent, type)
-            # rec ownership goes over to Event instance
-            return Event(self._pevent, rec, format)
-        return None
-
-    def read_event_at(self, offset):
-        res = tracecmd_read_at(self._handle, offset)
-        # SWIG only returns the CPU if the record is None for some reason
-        if isinstance(res, int):
-            return None
-        rec, cpu = res
-        type = tep_data_type(self._pevent, rec)
-        format = tep_find_event(self._pevent, type)
-        # rec ownership goes over to Event instance
-        return Event(self._pevent, rec, format)
-
-    def read_next_event(self):
-        res = tracecmd_read_next_data(self._handle)
-        if isinstance(res, int):
-            return None
-        rec, cpu = res
-        type = tep_data_type(self._pevent, rec)
-        format = tep_find_event(self._pevent, type)
-        return Event(self._pevent, rec, format)
-
-    def peek_event(self, cpu):
-        rec = tracecmd_peek_data_ref(self._handle, cpu)
-        if rec is None:
-            return None
-        type = tep_data_type(self._pevent, rec)
-        format = tep_find_event(self._pevent, type)
-        # rec ownership goes over to Event instance
-        return Event(self._pevent, rec, format)
-
-
-# Basic builtin test, execute module directly
-if __name__ == "__main__":
-    t = Trace("trace.dat")
-    print("Trace contains data for %d cpus" % (t.cpus))
-
-    for cpu in range(0, t.cpus):
-        print("CPU %d" % (cpu))
-        ev = t.read_event(cpu)
-        while ev:
-            print("\t%s" % (ev))
-            ev = t.read_event(cpu)
-
-
-
-- 
2.37.3

