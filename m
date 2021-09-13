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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 214EDC433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 15:11:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 070FC61004
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 15:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346480AbhIMPMP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 11:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343899AbhIMPMI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 11:12:08 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6342C0ABEF5
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 06:56:55 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id j13so14502922edv.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 06:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YRzysAb4w4mi8tI0EC4PFcNsiKhgEROsrrUxg9MPBDw=;
        b=etzU1zppHDGDVSzsW5FlrkTC6oEiYc4kKHIKzW2kzgKvkjjtZlqCg3fQfgpjAhpv8A
         Ecm72ue72/hZfs1aMZIOzaA6gzZo7cbVZxiJbWoqvq7B7qZcBaJCToCpxtR7HweZI16f
         IvxMgqYFdLJTPb5lx7E01/2BFDNf5XEGpJ3Rz4sSIypg46RDW8Y3jSyJlp+0EA64M5yl
         vBA3iuN+vxLc06n4ZxiZXkBDHdbbBqGSjM9ClvjQY/1Bpph2Dsd+PPD2VjPUKXgwO6Kd
         kevNVEutm5Kpm9uROh7H7JH4pjMEJVUvNlpY7RXHAsiDPPNaO73kw6xzfiig15UOPjnT
         V5eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YRzysAb4w4mi8tI0EC4PFcNsiKhgEROsrrUxg9MPBDw=;
        b=tt5aIbUxu+DX+bsMOLEFWFvziRL9j8Js/II59pt1w5FAHb5ttb7RwF0GwwsFtTk31v
         7Zp8PXdk+JsCohC0ceIGbB4Ikrd0vyyayAYoe+PTzmy57w1bzrKX9nJrNKPHUM1U1Xjp
         BGHBaESL0qu34efeJO4RBBudf4+DERiI3lpAx+sXwMqmjgTt/LInXFNYKbv1EpR7V/km
         j0yu1PFKEeHDiMVROlrK5z6s9oxPduTgk2EMyXZquyprv6CbjRqc8ZwKlvDP1orJaGvb
         zVSpAlHfUsoFrGuy8QibDURYvSNH/o8qiHrv4VjSjv6+0foMuV8MkvXJ+UlON7wh7PQ2
         3HaQ==
X-Gm-Message-State: AOAM532d9GYmQQYunwzQBXUHoTm3otLFGupEiDjV3B7NdLdYDtOFEHQb
        kK0N+wH8UkifI5KYd/6dAXbYCr9TdDw=
X-Google-Smtp-Source: ABdhPJwVIw0VDEekBsM7/t/3KYVMWWzbcu4Hce0AmhMxWL1TVJjjbE+DzSzzoZuUGlq6Tj17kCiVkQ==
X-Received: by 2002:a05:6402:3c2:: with SMTP id t2mr4686421edw.261.1631541414155;
        Mon, 13 Sep 2021 06:56:54 -0700 (PDT)
Received: from crow.. ([95.87.199.108])
        by smtp.gmail.com with ESMTPSA id e28sm3934160edc.93.2021.09.13.06.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 06:56:53 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/2] trace-cruncher: Provide short kprobe info print
Date:   Mon, 13 Sep 2021 16:56:38 +0300
Message-Id: <20210913135638.395855-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913135638.395855-1-y.karadz@gmail.com>
References: <20210913135638.395855-1-y.karadz@gmail.com>
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
 examples/kprobe_open.py   |  1 +
 src/ftracepy-utils.c      | 38 ++++++++++++++++++++++++++++++++++++++
 src/ftracepy-utils.h      |  3 +++
 src/ftracepy.c            |  5 +++++
 tracecruncher/ft_utils.py |  8 ++++++++
 5 files changed, 55 insertions(+)

diff --git a/examples/kprobe_open.py b/examples/kprobe_open.py
index 99f6c8c..dff4861 100755
--- a/examples/kprobe_open.py
+++ b/examples/kprobe_open.py
@@ -27,6 +27,7 @@ open_probe.add_ptr_arg(name='mode',
 open_probe.register()
 
 tep = tc.local_tep()
+tc.short_kprobe_print(tep, [open_probe])
 
 def callback(event, record):
     print(tep.info(event, record))
diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index c076d3b..bddc4fc 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -533,6 +533,44 @@ PyObject *PyTep_process(PyTep *self, PyObject *args,
 	return PyUnicode_FromString(seq.buffer);
 }
 
+static int kprobe_info_short(struct trace_seq *s,
+			     struct tep_record *record,
+			     struct tep_event *event,
+			     void *context)
+{
+	/* Do not print the address of the probe (first field). */
+	unsigned long long select_mask = ~0x1;
+
+	tep_record_print_selected_fields(s, record, event, select_mask);
+
+	return 0;
+}
+
+PyObject *PyTep_short_kprobe_print(PyTep *self, PyObject *args,
+						PyObject *kwargs)
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
+					 kprobe_info_short, NULL);
+
+	return PyLong_FromLong(ret);
+}
+
 static bool check_file(struct tracefs_instance *instance, const char *file)
 {
 	if (!tracefs_file_exists(instance, file)) {
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index 6c4a109..9f4c4ba 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -63,6 +63,9 @@ PyObject *PyTep_info(PyTep *self, PyObject *args,
 PyObject *PyTep_process(PyTep *self, PyObject *args,
 				     PyObject *kwargs);
 
+PyObject *PyTep_short_kprobe_print(PyTep *self, PyObject *args,
+						PyObject *kwargs);
+
 PyObject *PyTfsInstance_dir(PyTfsInstance *self);
 
 PyObject *PyKprobe_event(PyKprobe *self);
diff --git a/src/ftracepy.c b/src/ftracepy.c
index c4458f0..cbf0ce0 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -83,6 +83,11 @@ static PyMethodDef PyTep_methods[] = {
 	 METH_VARARGS | METH_KEYWORDS,
 	 "Generic print of a trace event info."
 	},
+	{"short_kprobe_print",
+	 (PyCFunction) PyTep_short_kprobe_print,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Do not print the address of the probe."
+	},
 	{NULL}
 };
 
diff --git a/tracecruncher/ft_utils.py b/tracecruncher/ft_utils.py
index 5caaa76..1fc0648 100644
--- a/tracecruncher/ft_utils.py
+++ b/tracecruncher/ft_utils.py
@@ -29,6 +29,14 @@ def find_event_id(system, event):
     return tep.get_event(system=system, name=event).id()
 
 
+def short_kprobe_print(tep, events):
+    """ Register short (no probe address) print for these kprobe events.
+    """
+    for e in events:
+        if len(e.fields):
+            tep.short_kprobe_print(id=e.evt_id, system=e.system, event=e.name)
+
+
 class event:
     def __init__(self, system, name, static=True):
         """ Constructor.
-- 
2.30.2

