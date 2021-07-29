Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71D77C43216
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 13:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BB2A60EBC
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 13:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237771AbhG2NXj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 09:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237857AbhG2NXS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 09:23:18 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028C9C0613D5
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Jul 2021 06:23:15 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id h24-20020a1ccc180000b029022e0571d1a0so4033063wmb.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Jul 2021 06:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3D173v3WYLdxxYsUY34eDjqGVAjbg6uFWfRgfZf6DKA=;
        b=jbWZ4d9il9YRXaXA7B23GvQ2MdcyaYrgtbgrhHuOLqvh/RnGbMy/9+WoqynB6bTGTh
         WZV0NxwU+xWWhDJDgTu+egPi4VVcIt8s9rSpW0PY89Y/SuzA/1v+Q/eGQPYrtxuhpi+Y
         zCIi/NMZxWNSe36X9mihBYMrheHcjKSVFEYUM2IJG83ub+a6hvET9GGBXA3mwe1KIero
         S2uH8+FHyvmLGl67RuPzWDOCVVe03ibPto1Oqqt9wxSllrJfDHo8ycctRI4D2QY3ahlh
         UgIE7bZFdUJ1/wqQ7sEr+VnHs7qTgNPafHB7A1epMyFC50a2mEAQue+/2dYQQE73rsM2
         Qpag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3D173v3WYLdxxYsUY34eDjqGVAjbg6uFWfRgfZf6DKA=;
        b=XLM/2f6EP/GFnO/iGXD+wsenkAdbrhqZyCQNSRsK1euQxk6fKb0a4JwAPkvKHAtplW
         tFZ8RDnKV2XVt7Q5KimH2aSRC6iRcSjmxKUYbxFfUo7dOfhHC14iwKaxJ8iqpS/E7TrA
         6qUSemUx1IxHzCS+XwiYV/x5rrzxNJH3eDEnkwCFeFMXsDocrsRNYI4oXjvdFHGLUGzt
         o5sV4fKqL5RueCGA61ctShCskmn5iX6DSDck2vmwzttZPLBiBFchmPu44+FRs8ZlCN0B
         bAQEK7rtGT0LSsWEOX048kWFVMUw2DKa03aQcy3yqsVs1CLt5haTzoAueYBdDSCHprIY
         xevQ==
X-Gm-Message-State: AOAM532YoaGrFjXjf+4jAHpUv5cyj89jfRjJRZM2eyb0CMxMHKzEGpu9
        uA5gptkqz807wbpO6Uj8ZKQzVD/JLXE=
X-Google-Smtp-Source: ABdhPJzp/EnaxE5qAFqi642miocIPwrlEyAah1FmKvNVLCfHRInfHj3zcMV8W4BKFGcBtNrpf7iczg==
X-Received: by 2002:a1c:35c2:: with SMTP id c185mr14574370wma.73.1627564993370;
        Thu, 29 Jul 2021 06:23:13 -0700 (PDT)
Received: from crow.. ([146.247.46.131])
        by smtp.gmail.com with ESMTPSA id c12sm1501503wrm.29.2021.07.29.06.23.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 06:23:12 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/2] trace-cruncher: Add generic methods for printing
Date:   Thu, 29 Jul 2021 16:22:55 +0300
Message-Id: <20210729132256.86569-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new methods makes it easy to print:
 - the name and PID of the process that generated the trace record,
 - the unique fields of the record (called also 'info') or
 - all information for the event all together.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 examples/kprobe_open.py |   8 +-
 src/ftracepy-utils.c    | 159 ++++++++++++++++++++++++++++++++++++++++
 src/ftracepy-utils.h    |   9 +++
 src/ftracepy.c          |  15 ++++
 4 files changed, 186 insertions(+), 5 deletions(-)

diff --git a/examples/kprobe_open.py b/examples/kprobe_open.py
index f8d4d8b..5b217d3 100755
--- a/examples/kprobe_open.py
+++ b/examples/kprobe_open.py
@@ -26,12 +26,10 @@ open_probe.add_ptr_arg(name='mode',
 
 open_probe.register()
 
+tep = tc.local_tep()
+
 def callback(event, record):
-    if event.id() == open_probe.id():
-        file_name = event.parse_record_field(record=record, field='file')
-        flags = event.parse_record_field(record, 'flags')
-        mode = event.parse_record_field(record, 'mode')
-        print('file: {0}  (flags: {1}; mode: {2})'.format(file_name, hex(flags), hex(mode)))
+    print(tep.info(event, record))
 
 
 if __name__ == "__main__":
diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 6739db7..3c000a7 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -298,6 +298,162 @@ PyObject *PyTep_get_event(PyTep *self, PyObject *args,
 	return PyTepEvent_New(event);
 }
 
+static struct trace_seq seq;
+
+static bool init_print_seq(void)
+{
+	if (!seq.buffer)
+		trace_seq_init(&seq);
+
+	if (!seq.buffer) {
+		PyErr_SetString(TFS_ERROR, "Unable to initialize 'trace_seq'.");
+		return false;
+	}
+
+	trace_seq_reset(&seq);
+
+	return true;
+}
+
+static char *get_comm_from_pid(int pid)
+{
+	char *comm_file, *comm = NULL;
+	char buff[PATH_MAX];
+	int fd, r;
+
+	if (asprintf(&comm_file, "/proc/%i/comm", pid) <= 0) {
+		MEM_ERROR;
+		return NULL;
+	}
+
+	/*
+	 * This file is not guaranteed to exist. Return NULL if the process
+	 * is no longer active.
+	 */
+	fd = open(comm_file, O_RDONLY);
+	free(comm_file);
+	if (fd < 0)
+		return NULL;
+
+	r = read(fd, buff, PATH_MAX);
+	close(fd);
+	if (r <= 0)
+		return NULL;
+
+	comm = strdup(buff);
+	if (!comm)
+		MEM_ERROR;
+
+	return comm;
+}
+
+static void print_comm_pid(struct tep_handle *tep,
+			   struct trace_seq *seq,
+			   struct tep_record *record,
+			   struct tep_event *event)
+{
+	int pid = get_pid(event, record);
+	if (!tep_is_pid_registered(tep, pid)) {
+		char *comm = get_comm_from_pid(pid);
+		if (comm) {
+			tep_register_comm(tep, comm, pid);
+			free(comm);
+		}
+	}
+
+	tep_print_event(tep, seq, record, "%s-%i",
+			TEP_PRINT_COMM,
+			TEP_PRINT_PID);
+}
+
+static void print_name_info(struct tep_handle *tep,
+			    struct trace_seq *seq,
+			    struct tep_record *record,
+			    struct tep_event *event)
+{
+	trace_seq_printf(seq, " %s: ", event->name);
+	tep_print_event(tep, seq, record, "%s", TEP_PRINT_INFO);
+}
+
+static void print_event(struct tep_handle *tep,
+			struct trace_seq *seq,
+			struct tep_record *record,
+			struct tep_event *event)
+{
+	tep_print_event(tep, seq, record, "%6.1000d ", TEP_PRINT_TIME);
+	print_comm_pid(tep, seq, record, event);
+	tep_print_event(tep, seq, record, " cpu=%i ", TEP_PRINT_CPU);
+	print_name_info(tep, seq, record, event);
+}
+
+static bool print_init(PyObject *args, PyObject *kwargs,
+		       struct tep_event **event,
+		       struct tep_record **record)
+{
+	static char *kwlist[] = { "event", "record", NULL};
+	PyTepRecord *py_record;
+	PyTepEvent *py_event;
+
+	if (!init_print_seq())
+		return false;
+
+	if(!PyArg_ParseTupleAndKeywords(args,
+					kwargs,
+					"OO",
+					kwlist,
+					&py_event,
+					&py_record)) {
+		return false;
+	}
+
+	*event = py_event->ptrObj;
+	*record = py_record->ptrObj;
+
+	return true;
+}
+
+PyObject *PyTep_event_record(PyTep *self, PyObject *args,
+					  PyObject *kwargs)
+{
+	struct tep_record *record;
+	struct tep_event *event;
+
+	if (!print_init(args, kwargs, &event, &record))
+		return NULL;
+
+	print_event(self->ptrObj, &seq, record, event);
+
+	return PyUnicode_FromString(seq.buffer);
+}
+
+PyObject *PyTep_info(PyTep *self, PyObject *args,
+				  PyObject *kwargs)
+{
+	struct tep_record *record;
+	struct tep_event *event;
+
+	if (!print_init(args, kwargs, &event, &record))
+		return NULL;
+
+	print_name_info(self->ptrObj, &seq, record, event);
+
+	return PyUnicode_FromString(seq.buffer);
+}
+
+PyObject *PyTep_process(PyTep *self, PyObject *args,
+				     PyObject *kwargs)
+{
+	struct tep_record *record;
+	struct tep_event *event;
+
+	if (!print_init(args, kwargs, &event, &record))
+		return NULL;
+
+	print_comm_pid(self->ptrObj, &seq, record, event);
+
+	return PyUnicode_FromString(seq.buffer);
+}
+
 static bool check_file(struct tracefs_instance *instance, const char *file)
 {
 	if (!tracefs_file_exists(instance, file)) {
@@ -2222,4 +2378,7 @@ void PyFtrace_at_exit(void)
 {
 	destroy_all_kprobes();
 	destroy_all_instances();
+
+	if (seq.buffer)
+		trace_seq_destroy(&seq);
 }
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index 5d7c19c..aca1ccc 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -44,6 +44,15 @@ PyObject *PyTep_init_local(PyTep *self, PyObject *args,
 PyObject *PyTep_get_event(PyTep *self, PyObject *args,
 				       PyObject *kwargs);
 
+PyObject *PyTep_event_record(PyTep *self, PyObject *args,
+					  PyObject *kwargs);
+
+PyObject *PyTep_info(PyTep *self, PyObject *args,
+				  PyObject *kwargs);
+
+PyObject *PyTep_process(PyTep *self, PyObject *args,
+				     PyObject *kwargs);
+
 PyObject *PyFtrace_dir(PyObject *self);
 
 PyObject *PyFtrace_create_instance(PyObject *self, PyObject *args,
diff --git a/src/ftracepy.c b/src/ftracepy.c
index e3fec7b..e948b15 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -68,6 +68,21 @@ static PyMethodDef PyTep_methods[] = {
 	 METH_VARARGS | METH_KEYWORDS,
 	 "Get a PyTepEvent object."
 	},
+	{"event_record",
+	 (PyCFunction) PyTep_event_record,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Generic print of a trace event."
+	},
+	{"process",
+	 (PyCFunction) PyTep_process,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Generic print of the process that generated the trace event."
+	},
+	{"info",
+	 (PyCFunction) PyTep_info,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Generic print of a trace event info."
+	},
 	{NULL}
 };
 
-- 
2.30.2

