Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E99C6C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 15:10:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7A5B61029
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 15:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237544AbhIMPMO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 11:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344983AbhIMPMH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 11:12:07 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C45DC0ABEF4
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 06:56:55 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id e21so21211462ejz.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 06:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9H2+nj8sZMydcmtHI0Mu8f1mB5gSXI9bgvro2XwyrsI=;
        b=p+0NoSjTUpN2Ka6RhXed0YyalO3mdanAmQpmBYG2m6R1LpyAjz2p1zxSfppstaCtvI
         uT0GmMrsIpyPrwDkrHYTj7wjckwwhn4TexNBloY4KR9M5zpXOrPduwxlzQl71ty9OEFr
         yYua4xBARBLPw4Xzhcf1ztZ3iCPNgB8QSvVWlgplpr/G7YVc0Xx70hyIA3j8RB5REdIl
         ESBamg8AO3jwMcEgVdKV/F2hltL/W/6faaUmxyzDqgutnxskLxp/1lwLVLxHA8vPAUsT
         fIg872Va4nXEpIlWbE2ZIaCrFFOwQxlAaVf3pPTYU7Ky99rTPodThjnlOCP1mOn/Qs0/
         x/SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9H2+nj8sZMydcmtHI0Mu8f1mB5gSXI9bgvro2XwyrsI=;
        b=3uO3AU4OPj/3lF9lsFRYys5bOEAxuogQPx37U4dBfqwivjkbhQrbI2LCirkT1a4Izi
         0w/W5J38BMBVXSHCvG3w/oI/4UtIjh5wlQENkhDzwc9M6vNgMQslfXZu5inUAhD7xeOY
         ceGsX3cBQIJQ9UrAJXFPVPJSKK4pm0tUAwCIeJolqOe0LwCIjwkwNlcg2soXFGDX0Ahy
         WwENF6RKkGV6EysRZTktP5IznYK5jEDbyRBuLd8tol9JKSYKKtmAhjBPnxLh4JPepoAa
         e37u0CO/B6ruuN9mmSBckkxARdWs8OO30+t4udiaN32doB6e2IDOKagmeXXpEmmD1MoT
         eeXA==
X-Gm-Message-State: AOAM5311CACVr++AhCrTFNKNjZ44m2wDWQtBbiM0n4180uSDSwvj+5Uo
        MXiKCpGwRz3gIz6pxRPVYP33mH9q8mU=
X-Google-Smtp-Source: ABdhPJy0ijabI5RBxill0aik0OceK8U1vBM+xolKxNi5+HODyyACpA/Fpek5oNXpvhM/Mkem5HbXbQ==
X-Received: by 2002:a17:906:bfe7:: with SMTP id vr7mr12594455ejb.32.1631541413420;
        Mon, 13 Sep 2021 06:56:53 -0700 (PDT)
Received: from crow.. ([95.87.199.108])
        by smtp.gmail.com with ESMTPSA id e28sm3934160edc.93.2021.09.13.06.56.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 06:56:52 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/2] trace-cruncher: Add generic methods for printing
Date:   Mon, 13 Sep 2021 16:56:37 +0300
Message-Id: <20210913135638.395855-1-y.karadz@gmail.com>
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
 src/ftracepy-utils.c    | 168 ++++++++++++++++++++++++++++++++++++++++
 src/ftracepy-utils.h    |   9 +++
 src/ftracepy.c          |  15 ++++
 4 files changed, 195 insertions(+), 5 deletions(-)

diff --git a/examples/kprobe_open.py b/examples/kprobe_open.py
index 43b4212..99f6c8c 100755
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
index d4fa59e..c076d3b 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -367,6 +367,172 @@ PyObject *PyTep_get_event(PyTep *self, PyObject *args,
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
+	PyObject *obj_rec, *obj_evt;
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
+					&obj_evt,
+					&obj_rec)) {
+		return false;
+	}
+
+	if (PyTepEvent_Check(obj_evt) && PyTepRecord_Check(obj_rec)) {
+		py_event = (PyTepEvent *)obj_evt;
+		*event = py_event->ptrObj;
+		py_record = (PyTepRecord *)obj_rec;
+		*record = py_record->ptrObj;
+
+		return true;
+	}
+
+	PyErr_SetString(TRACECRUNCHER_ERROR,
+			"Inconsistent arguments.");
+
+	return false;
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
@@ -2221,4 +2387,6 @@ PyObject *PyFtrace_clear_error_log(PyObject *self, PyObject *args,
 
 void PyFtrace_at_exit(void)
 {
+	if (seq.buffer)
+		trace_seq_destroy(&seq);
 }
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index be1b37c..6c4a109 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -54,6 +54,15 @@ PyObject *PyTep_init_local(PyTep *self, PyObject *args,
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
 PyObject *PyTfsInstance_dir(PyTfsInstance *self);
 
 PyObject *PyKprobe_event(PyKprobe *self);
diff --git a/src/ftracepy.c b/src/ftracepy.c
index 763a7d2..c4458f0 100644
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

