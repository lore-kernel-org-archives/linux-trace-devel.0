Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39951C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 24 Jan 2022 08:56:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242513AbiAXI4y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 24 Jan 2022 03:56:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242517AbiAXI4y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Jan 2022 03:56:54 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4296AC06173B
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 00:56:54 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id s18so12165757wrv.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 00:56:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CnLOh1CO/wK4ERt6Hj2WUyNRMmSpSpZ91QAySy6CmT4=;
        b=CqZQke8ihK8VCH+Znd1F3kC7T7/lOMnCNM5vUccwd/RQhey77PLk+aM27ucELpc8yc
         uo4BQAwF2it+cKuI/DVfkBvSbM8pJ29AtLuqRQeKT63VqfVycUzyTzIOXgQjWZ6PvSuc
         +1duoRpQdPP+BI9CN24yoJZCXg7SxYmf0oo3csGTYZ6N1MkLITR6rjaCbjBeL7/g1zzZ
         iDw9VOm1klhvabgXopsFY3cUscUN9MXSFKUXW0BWKxD2OZRaJNJ4ZRtsi73n+3P7Z2bb
         JfDXr7cZJa2Xx3q3Fnq6jrDTm6Dpugb55Tx+xIqCMR36gGT/tBANC2klH8ygTdFglYNq
         PuJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CnLOh1CO/wK4ERt6Hj2WUyNRMmSpSpZ91QAySy6CmT4=;
        b=Gev0PApUQgkbdTDIgxse4mJ2Xq7fIHCbhITIGUMW5OcCaNRXVzrF2NGmv1iGthGVYU
         mibUEIK1f0uqy0S+tl/Ht7yikNHiwx28tBvCwRxqEw7B8s4EP7fkAZtqFTVUCiOPyxQV
         NmRtmVrnq+X3CWUxSwHx3jx9Io88AX+zN64vfTlZl/dmg+vBqXCCM6dLWAn0jPTDJ78F
         Gx17WsQjVM+u6XH/Jt1hRmAYwtiHN8Vy4BOcxVyLzIm6jTIjBQu9ZiARNzARFkvlbWco
         bRuTItsvBvlEQZ06KQ5i5Y1fTLfpzeT97ZzWogYsIwcZlrFMN9xokUqZuuRjDLEGamA5
         LQDQ==
X-Gm-Message-State: AOAM532ntF8AhT/R+w8svGdzKlCyr89iJEe8w4in4ZfRTnJYeTXg1lRD
        0G6Ab47+2Tm7iavWc5ebNklGz9BL4po=
X-Google-Smtp-Source: ABdhPJzbHcONK0RS9qvG1QJIgS45+JaOTGZUtsSWmnvDcj2i6NcOMxqB3JstpB4o9mTY68rmqSZzPA==
X-Received: by 2002:adf:dec3:: with SMTP id i3mr6968376wrn.225.1643014612650;
        Mon, 24 Jan 2022 00:56:52 -0800 (PST)
Received: from crow.eng.vmware.com ([146.247.46.134])
        by smtp.gmail.com with ESMTPSA id f14sm14828091wri.44.2022.01.24.00.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 00:56:52 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 05/10] trace-cruncher: APIs for enabling synth. events
Date:   Mon, 24 Jan 2022 10:56:20 +0200
Message-Id: <20220124085625.92297-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220124085625.92297-1-y.karadz@gmail.com>
References: <20220124085625.92297-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Here we add the following methods to the Python type for synthetic
events:

enable()
disable()
is_enabled()

The 3 new APIs replicate the APIs available for kpobes.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 45 ++++++++++++++++++++++++++++++++++++++++++++
 src/ftracepy-utils.h |  9 +++++++++
 src/ftracepy.c       | 15 +++++++++++++++
 3 files changed, 69 insertions(+)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 244bff9..8a0c3c3 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -2661,6 +2661,51 @@ PyObject *PyFtrace_synth(PyObject *self, PyObject *args,
 	return py_synth;
 }
 
+#define SYNTH_SYS "synthetic"
+
+static bool enable_synth(PySynthEvent *self, PyObject *args, PyObject *kwargs,
+			 bool enable)
+{
+	struct tracefs_instance *instance;
+
+	if (!get_instance_from_arg(args, kwargs, &instance))
+		return NULL;
+
+	return event_enable_disable(instance, SYNTH_SYS,
+				    tracefs_synth_get_name(self->ptrObj),
+				    enable);
+}
+
+PyObject *PySynthEvent_enable(PySynthEvent *self, PyObject *args,
+						  PyObject *kwargs)
+{
+	if (!enable_synth(self, args, kwargs, true))
+		return NULL;
+
+	Py_RETURN_NONE;
+}
+
+PyObject *PySynthEvent_disable(PySynthEvent *self, PyObject *args,
+						   PyObject *kwargs)
+{
+	if (!enable_synth(self, args, kwargs, false))
+		return NULL;
+
+	Py_RETURN_NONE;
+}
+
+PyObject *PySynthEvent_is_enabled(PySynthEvent *self, PyObject *args,
+						      PyObject *kwargs)
+{
+	struct tracefs_instance *instance;
+
+	if (!get_instance_from_arg(args, kwargs, &instance))
+		return NULL;
+
+	return event_is_enabled(instance, SYNTH_SYS,
+				tracefs_synth_get_name(self->ptrObj));
+}
+
 PyObject *PyFtrace_set_ftrace_loglevel(PyObject *self, PyObject *args,
 						       PyObject *kwargs)
 {
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index 40b41d8..daf1a19 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -143,6 +143,15 @@ PyObject *PySynthEvent_register(PySynthEvent *self);
 
 PyObject *PySynthEvent_unregister(PySynthEvent *self);
 
+PyObject *PySynthEvent_enable(PySynthEvent *self, PyObject *args,
+						  PyObject *kwargs);
+
+PyObject *PySynthEvent_disable(PySynthEvent *self, PyObject *args,
+						   PyObject *kwargs);
+
+PyObject *PySynthEvent_is_enabled(PySynthEvent *self, PyObject *args,
+						      PyObject *kwargs);
+
 PyObject *PyFtrace_dir(PyObject *self);
 
 PyObject *PyFtrace_detach(PyObject *self, PyObject *args, PyObject *kwargs);
diff --git a/src/ftracepy.c b/src/ftracepy.c
index 0314aa1..62c6de0 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -262,6 +262,21 @@ static PyMethodDef PySynthEvent_methods[] = {
 	 METH_NOARGS,
 	 "Unregister synth. event from a trace instance."
 	},
+	{"enable",
+	 (PyCFunction) PySynthEvent_enable,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Enable synth. event."
+	},
+	{"disable",
+	 (PyCFunction) PySynthEvent_disable,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Disable synth. event."
+	},
+	{"is_enabled",
+	 (PyCFunction) PySynthEvent_is_enabled,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Check if synth. event is enabled."
+	},
 	{NULL, NULL, 0, NULL}
 };
 
-- 
2.32.0

