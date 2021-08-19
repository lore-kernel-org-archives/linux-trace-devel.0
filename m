Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E984C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 13:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3ADB161152
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 13:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbhHSNJW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 09:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239300AbhHSNJW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 09:09:22 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6ECDC06175F
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Aug 2021 06:08:45 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id u1so3848410wmm.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Aug 2021 06:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=exxhBB9HQJpIT3YeImkIDLdy1+Bj/A3dViZPXiYEuGI=;
        b=PNhGeDRZnKQ9XX+lEgqnTCUYQawSL4iH3TTV8U+78ws2AU/BlNlO+nufNRqm6wVYnn
         qM9yUpJmFXKsN8hnllf5quCzMPqfKesq+b1BkKsnGvn22dEq64wfQ6BaP+qjGusDU/PB
         rsv3hmabYVcorCVpbyV2lhvpF3oQ8k4hK85uJtLUuTxauOF3SmOBlZcwwEYf2tBAO2jS
         I4hAqlpCkU/mSr9Nv72ekYGi4diNBzBtStiLzPKi7Pl8XB23UyXsuEP5BwXYhD42BEMP
         nrx69WABVBjy9p7D1iQ5aGMAG6MzmDSPEtv39fTmFAJXj9UgGqP42c2dCLgzItWqUGhS
         ZEuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=exxhBB9HQJpIT3YeImkIDLdy1+Bj/A3dViZPXiYEuGI=;
        b=FBpE1jEmZWjiCGSbxzy8e34d2vISn7MZOXKLsAOGvnPSisHRKYT1/RD7f/FTE2SGvG
         lo3JQ2VEpvSSragXhXweAczqe4hjLzNwD5VxvnBbLe1RpVhKT+9G7P1dK/1H7OjQj0uH
         xss55r6N9+Iri0WLCgUXW8FgZwoZ70kUBK4o9Nl7XzsSxj9gQlEi6BhF6+CSHz+GTWqh
         eumsFv3cy8HsonGGX5vLIv/XKVubs9V7jnRm89VDCVwYFzVLwxofI2rEVqffZYLetitT
         aCUG4fxhqfLjR309QMOeSquqXUsnMlToQs/Af7ziqLQYMLwdiyFSpjQH3Rfknrf4lHbw
         uuCA==
X-Gm-Message-State: AOAM533uoVsCwyU6DNz0JnRyXRNqK76G2RzlsOmlHo/8hmmfaw7qDUE+
        fI7wpkCrQy6qAsg1z7I2Vi/OVbCYVpQ=
X-Google-Smtp-Source: ABdhPJy3TqHAn6KO/qTdQD1QSxAeB233dPEag22NcpvEmcGMPIZa+7Zzu/3ORoqzlO6/m33FyJG5Yg==
X-Received: by 2002:a05:600c:3514:: with SMTP id h20mr9186643wmq.31.1629378524246;
        Thu, 19 Aug 2021 06:08:44 -0700 (PDT)
Received: from crow.eng.vmware.com ([146.247.46.133])
        by smtp.gmail.com with ESMTPSA id f17sm2889978wrt.49.2021.08.19.06.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 06:08:43 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 6/7] trace-cruncher: Define Python type for kprobes
Date:   Thu, 19 Aug 2021 16:08:26 +0300
Message-Id: <20210819130827.12327-7-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210819130827.12327-1-y.karadz@gmail.com>
References: <20210819130827.12327-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Adding this new Python type is a preparation for a general
refactorung of the way kprobes are handled by trace-cruncher.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 34 ++++++++++++++++++++++++++++++++++
 src/ftracepy-utils.h | 14 ++++++++++++++
 src/ftracepy.c       | 32 ++++++++++++++++++++++++++++++++
 3 files changed, 80 insertions(+)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 5d7d9af..b8bcb4c 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -1366,6 +1366,40 @@ PyObject *PyFtrace_tc_event_system(PyObject *self)
 	return PyUnicode_FromString(TC_SYS);
 }
 
+struct ftracepy_kprobe {
+	char *event;
+	char *function;
+	char *probe;
+};
+
+PyObject *PyKprobe_event(PyKprobe *self)
+{
+	return PyUnicode_FromString(self->ptrObj->event);
+}
+
+PyObject *PyKprobe_system(PyKprobe *self)
+{
+	return PyUnicode_FromString(TC_SYS);
+}
+
+PyObject *PyKprobe_function(PyKprobe *self)
+{
+	return PyUnicode_FromString(self->ptrObj->function);
+}
+
+PyObject *PyKprobe_probe(PyKprobe *self)
+{
+	return PyUnicode_FromString(self->ptrObj->probe);
+}
+
+void ftracepy_kprobe_free(struct ftracepy_kprobe *kp)
+{
+	free(kp->event);
+	free(kp->function);
+	free(kp->probe);
+	free(kp);
+}
+
 static int unregister_kprobe(const char *event)
 {
 	return tracefs_kprobe_clear_probe(TC_SYS, event, true);
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index 04de1f3..17e07e5 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -24,6 +24,12 @@ C_OBJECT_WRAPPER_DECLARE(tep_handle, PyTep)
 
 C_OBJECT_WRAPPER_DECLARE(tracefs_instance, PyTfsInstance)
 
+struct ftracepy_kprobe;
+
+void ftracepy_kprobe_free(struct ftracepy_kprobe *kp);
+
+C_OBJECT_WRAPPER_DECLARE(ftracepy_kprobe, PyKprobe);
+
 PyObject *PyTepRecord_time(PyTepRecord* self);
 
 PyObject *PyTepRecord_cpu(PyTepRecord* self);
@@ -48,6 +54,14 @@ PyObject *PyTep_get_event(PyTep *self, PyObject *args,
 
 PyObject *PyTfsInstance_dir(PyTfsInstance *self);
 
+PyObject *PyKprobe_event(PyKprobe *self);
+
+PyObject *PyKprobe_system(PyKprobe *self);
+
+PyObject *PyKprobe_function(PyKprobe *self);
+
+PyObject *PyKprobe_probe(PyKprobe *self);
+
 PyObject *PyFtrace_dir(PyObject *self);
 
 PyObject *PyFtrace_detach(PyObject *self, PyObject *args, PyObject *kwargs);
diff --git a/src/ftracepy.c b/src/ftracepy.c
index 3c55e50..c434af9 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -86,6 +86,34 @@ C_OBJECT_WRAPPER(tracefs_instance, PyTfsInstance,
 		 tracefs_instance_destroy,
 		 tracefs_instance_free)
 
+static PyMethodDef PyKprobe_methods[] = {
+	{"event",
+	 (PyCFunction) PyKprobe_event,
+	 METH_NOARGS,
+	 "Get the name of the kprobe event."
+	},
+	{"system",
+	 (PyCFunction) PyKprobe_system,
+	 METH_NOARGS,
+	 "Get the system name of the kprobe event."
+	},
+	{"function",
+	 (PyCFunction) PyKprobe_function,
+	 METH_NOARGS,
+	 "Get the function name of the kprobe event."
+	},
+	{"probe",
+	 (PyCFunction) PyKprobe_probe,
+	 METH_NOARGS,
+	 "Get the kprobe event definition."
+	},
+	{NULL, NULL, 0, NULL}
+};
+
+C_OBJECT_WRAPPER(ftracepy_kprobe, PyKprobe,
+		 NO_DESTROY,
+		 ftracepy_kprobe_free)
+
 static PyMethodDef ftracepy_methods[] = {
 	{"dir",
 	 (PyCFunction) PyFtrace_dir,
@@ -322,6 +350,9 @@ PyMODINIT_FUNC PyInit_ftracepy(void)
 	if (!PyTfsInstanceTypeInit())
 		return NULL;
 
+	if (!PyKprobeTypeInit())
+		return NULL;
+
 	TFS_ERROR = PyErr_NewException("tracecruncher.ftracepy.tfs_error",
 				       NULL, NULL);
 
@@ -337,6 +368,7 @@ PyMODINIT_FUNC PyInit_ftracepy(void)
 	PyModule_AddObject(module, "tep_event", (PyObject *) &PyTepEventType);
 	PyModule_AddObject(module, "tep_record", (PyObject *) &PyTepRecordType);
 	PyModule_AddObject(module, "tracefs_instance", (PyObject *) &PyTfsInstanceType);
+	PyModule_AddObject(module, "ftracepy_kprobe", (PyObject *) &PyKprobeType);
 
 	PyModule_AddObject(module, "tfs_error", TFS_ERROR);
 	PyModule_AddObject(module, "tep_error", TEP_ERROR);
-- 
2.30.2

