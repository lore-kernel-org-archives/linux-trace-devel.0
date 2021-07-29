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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0493EC4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 13:23:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E139260184
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 13:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237775AbhG2NXl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 09:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237860AbhG2NXT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 09:23:19 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA76AC061796
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Jul 2021 06:23:15 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id h24-20020a1ccc180000b029022e0571d1a0so4033099wmb.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Jul 2021 06:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9i0nCS57yxoQ/3u+Fl54q8TDksECXrY0fgv/R72MHEY=;
        b=t8XARsycZW+q4qhe3OmcgqshSQ5rlCYymyrp1pwJnOc5dee5MkEdJpDttXfWYznPyl
         95UqU6SMpH6rc0JR+e3agims/0vi80C/8hTpzMRywlsy35ICI4N9qJbepBlVRw/gCCl9
         EAYNk/n+Q2lfydAuSzM2Vb4oOXCE4uzHU87KvOlpiqHDOjLTiEQTBOIzxZawNxYjs111
         rw96DDXlxRu+tYZ595I8wooiPdVHSVKSuleHVstG48GPmCTv/mRkU4/yMqSjk+8JZgW5
         TeFQltEIU7C6qJXKCJBNQUPHenw4stk25rfpyLlAQZgv5xravMghzNH8YPTHVsgJJBHr
         vnoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9i0nCS57yxoQ/3u+Fl54q8TDksECXrY0fgv/R72MHEY=;
        b=PYtMym6m5FF8bPDePElrAZr3iHQy+ZdaQX+Jhkku9uCgnw1LyUouYr9ycdO9Mo21cC
         DeDn9+28b9ye32WH4qNcwkroBhCC1mMUOirhOkxPe1SYW/N5W9IixcLRwQ8xlqy0EQay
         +291Eo0/DNSN/kYcJhSSKCFPGT0ZvAOs+LXXvt4XGCeJ5gdYeaATFU4JDLVcA9QVBfJv
         c3eCWGc+Lj95844gVRW17rdZrTELvtO9SmKF0yE7Xiww4yRkWC/+GasQ2kxt85P24jfS
         NuTLLWrM14okdXLmHZq08Bd67sLNdZ8uRFkQlHRiwgJlAUqUK51689v8oyRgYT1yhtAL
         gg7A==
X-Gm-Message-State: AOAM5330Q1WvD4GX81am7JlanewLUwACAbgW6tFP4sAFRw9KYwEF3SQZ
        7L/2qTQXOHnEyqkvy50A0pjRT4uhzLo=
X-Google-Smtp-Source: ABdhPJxbSFTg/Pxn9ydZtRQJQibTwTmjHP61VtIFo6pkj7EzqDLntiPcT5q4qdUqYYJEn43uXLVvlQ==
X-Received: by 2002:a1c:c918:: with SMTP id f24mr4759514wmb.88.1627564994322;
        Thu, 29 Jul 2021 06:23:14 -0700 (PDT)
Received: from crow.. ([146.247.46.131])
        by smtp.gmail.com with ESMTPSA id c12sm1501503wrm.29.2021.07.29.06.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 06:23:13 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/2] trace-cruncher: Provide short info print
Date:   Thu, 29 Jul 2021 16:22:56 +0300
Message-Id: <20210729132256.86569-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210729132256.86569-1-y.karadz@gmail.com>
References: <20210729132256.86569-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The default event handler for parsing ("info print") includes
the address of the probe. This address can be valuable for kernel
developers, but is meaningless if you only care for userspace.
Here we add a method that allows the user to register an alternative
event handler that doesn't show the address.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 examples/kprobe_open.py   |  5 ++--
 src/ftracepy-utils.c      | 54 +++++++++++++++++++++++++++++++++++++++
 src/ftracepy-utils.h      |  3 +++
 src/ftracepy.c            |  5 ++++
 tracecruncher/ft_utils.py |  7 +++++
 5 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/examples/kprobe_open.py b/examples/kprobe_open.py
index 5b217d3..7242e5e 100755
--- a/examples/kprobe_open.py
+++ b/examples/kprobe_open.py
@@ -17,16 +17,17 @@ open_probe.add_string_arg(name='file', param_id=2)
 
 open_probe.add_ptr_arg(name='flags',
                        param_id=3,
-                       param_type='x64')
+                       param_type='u64')
 
 open_probe.add_ptr_arg(name='mode',
                        param_id=3,
-                       param_type='x64',
+                       param_type='u64',
                        offset=8)
 
 open_probe.register()
 
 tep = tc.local_tep()
+tc.register_event_prints(tep, [open_probe])
 
 def callback(event, record):
     print(tep.info(event, record))
diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 3c000a7..0f0e907 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -454,6 +454,60 @@ PyObject *PyTep_process(PyTep *self, PyObject *args,
 	return PyUnicode_FromString(seq.buffer);
 }
 
+static int info_short(struct trace_seq *s,
+		      struct tep_record *record,
+		      struct tep_event *event,
+		      void *context)
+{
+	struct tep_format_field *field;
+
+	field = event->format.fields->next;
+	while (field) {
+		/*
+		 * For the moment all number fields are printed as hex.
+		 *
+		 * TODO: Find a way to specify if the field will have
+		 * the bit flag TEP_FIELD_IS_LONG set at the time the
+		 * kprobe is created. This way we will be able to specify
+		 * if a number field in the probe will be printed as hex
+		 * or as dec.
+		 */
+		if (is_number(field))
+			field->flags |= TEP_FIELD_IS_LONG;
+
+		trace_seq_printf(s, " %s=", field->name);
+		tep_print_field(s, record->data, field);
+		field = field->next;
+	}
+
+	return 0;
+}
+
+PyObject *PyFtrace_register_event_print(PyTep *self, PyObject *args,
+						     PyObject *kwargs)
+{
+	static char *kwlist[] = {"system", "event", "id", NULL};
+	const char *system, *event;
+	int ret, id = -1;
+
+	system = event = NO_ARG;
+
+	if(!PyArg_ParseTupleAndKeywords(args,
+					kwargs,
+					"ss|i",
+					kwlist,
+					&system,
+					&event,
+					&id)) {
+		return false;
+	}
+
+	ret = tep_register_event_handler(self->ptrObj, id, system, event,
+					 info_short, NULL);
+
+	return PyLong_FromLong(ret);
+}
+
 static bool check_file(struct tracefs_instance *instance, const char *file)
 {
 	if (!tracefs_file_exists(instance, file)) {
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index aca1ccc..37b785e 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -53,6 +53,9 @@ PyObject *PyTep_info(PyTep *self, PyObject *args,
 PyObject *PyTep_process(PyTep *self, PyObject *args,
 				     PyObject *kwargs);
 
+PyObject *PyFtrace_register_event_print(PyTep *self, PyObject *args,
+						     PyObject *kwargs);
+
 PyObject *PyFtrace_dir(PyObject *self);
 
 PyObject *PyFtrace_create_instance(PyObject *self, PyObject *args,
diff --git a/src/ftracepy.c b/src/ftracepy.c
index e948b15..b095f64 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -83,6 +83,11 @@ static PyMethodDef PyTep_methods[] = {
 	 METH_VARARGS | METH_KEYWORDS,
 	 "Generic print of a trace event info."
 	},
+	{"register_event_parser",
+	 (PyCFunction) PyFtrace_register_event_print,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Register default event print."
+	},
 	{NULL}
 };
 
diff --git a/tracecruncher/ft_utils.py b/tracecruncher/ft_utils.py
index 8c245b1..9c4d330 100644
--- a/tracecruncher/ft_utils.py
+++ b/tracecruncher/ft_utils.py
@@ -29,6 +29,13 @@ def find_event_id(system, event):
     return tep.get_event(system=system, name=event).id()
 
 
+def register_event_prints(tep, events):
+    """ Register default (short) print for these events.
+    """
+    for e in events:
+        tep.register_event_parser(id=e.evt_id, system=e.system, event=e.name)
+
+
 class event:
     def __init__(self, system, name, static=True):
         """ Constructor.
-- 
2.30.2

