Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B62C433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 24 Jan 2022 08:56:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242518AbiAXI4v (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 24 Jan 2022 03:56:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242522AbiAXI4v (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Jan 2022 03:56:51 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B6D3C06173D
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 00:56:51 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id r14so1591956wrc.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 00:56:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9tAHNhhRNdTYm1Qet3axot0lJ8+/Ofd4flCPsYy5/T4=;
        b=cmCrZJ6KRogXH8w8xF1cDodFs7KqvedxCPEPJ3MAs1+JkT57tDsblI5YPfhclxjq+g
         kI+uxO7cbSPxq3Xuo2f6tyxnn7EyrfgVB5PP13IihsioGsgC0PXOf5ky2vtdobf6taJz
         zTV3B+Mr2qKUAAjhOGRtAxLSEuMmeMF+YwwXZMVdh0f6joLyXAgTGzxsCwna6fAVlFJE
         HM8J5LYjooJuemdVt130xElP0oFowcs8ltJOHon9LMf2hsLhJ9Mjb1ihp1y3BEGcRBs+
         PjzKFnEzcuMy4rh5vT/ug6soHrF/fXodr3ARPD7jbk8b979Bv6Xa3ZjQROvKYx4iMT+Z
         2EAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9tAHNhhRNdTYm1Qet3axot0lJ8+/Ofd4flCPsYy5/T4=;
        b=LveJYrWWsXex2hW7P0UpefIVCeiiAnHafwa0sS8g06TGEGEZjJBcy9K7pIM924bUaa
         ZFX3S15XYPeOfyQK95SQyNpZhYlbfnjZ4lbV/eDx02uzC4PAPpvpPvisCjwfofF2F16P
         7LfYVeVj3G9+DVd0ZA0kxnfB9XHuSBO5zclZwYvaapniNyHTIAt5Uiy+QpkD2J6dlKIW
         GMVkyxALuIitfVNqq5236U0p1/GREG4lkNjkHSpSK4xcRY+06lho//bzUk+QD8LdagD4
         u3gNGhf1S+036ZlIWLuZFzhtFJ0bkZ4u07L+JYfxNW1zuCtC7nkypsnUObhxl2gvGA5Q
         fzFA==
X-Gm-Message-State: AOAM530cT7LCQXXjvLCj3Oml4McBcV2KM1viqwjroCd2fYUAmyn2PvbU
        23e3RqBmfwx/9YlpmmsK9qDYO40kIx8=
X-Google-Smtp-Source: ABdhPJwDtUkUa3UYr348kcwF+K3i6gkRMIY6KBCVdwEZ1hNBz9b+5n9bPTryPSpeoyzfW5gJN7CZ7Q==
X-Received: by 2002:a5d:6f17:: with SMTP id ay23mr13287362wrb.135.1643014609533;
        Mon, 24 Jan 2022 00:56:49 -0800 (PST)
Received: from crow.eng.vmware.com ([146.247.46.134])
        by smtp.gmail.com with ESMTPSA id f14sm14828091wri.44.2022.01.24.00.56.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 00:56:49 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 03/10] trace-cruncher: APIs for adding arithmetic fields to synth. events
Date:   Mon, 24 Jan 2022 10:56:18 +0200
Message-Id: <20220124085625.92297-4-y.karadz@gmail.com>
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
add_delta_start(),
add_delta_end(),
add_delta_T(),
add_sum()

The new APIs allows for adding to the new synthetic event, fields that
are calculated from the fields of the original 'start' and 'end' events
by using simple addition or subtraction.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 81 ++++++++++++++++++++++++++++++++++++++++++++
 src/ftracepy-utils.h | 12 +++++++
 src/ftracepy.c       | 20 +++++++++++
 3 files changed, 113 insertions(+)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 42bd9d0..9245b07 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -1073,6 +1073,87 @@ PyObject *PySynthEvent_add_end_fields(PySynthEvent *self, PyObject *args,
 	return synth_add_fields(self, args, kwargs, false);
 }
 
+static inline void add_synth_field_err(const char *field, const char *event)
+{
+	TfsError_fmt(NULL, "Failed to add field '%s' to synth. event %s",
+		     field, event);
+}
+
+static inline PyObject *
+add_synth_field(PySynthEvent *self, PyObject *args, PyObject *kwargs,
+		enum tracefs_synth_calc calc)
+{
+	static char *kwlist[] = {"name", "start_field", "end_field", NULL};
+	const char *start_field, *end_field, *name;
+	int ret;
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "sss",
+					 kwlist,
+					 &name,
+					 &start_field,
+					 &end_field)) {
+		return NULL;
+	}
+
+	ret = tracefs_synth_add_compare_field(self->ptrObj,
+					      start_field, end_field, calc,
+					      name);
+	if (ret < 0) {
+		add_synth_field_err(name, tracefs_synth_get_name(self->ptrObj));
+		return NULL;
+	}
+
+	Py_RETURN_NONE;
+}
+
+PyObject *PySynthEvent_add_delta_start(PySynthEvent *self, PyObject *args,
+							   PyObject *kwargs)
+{
+	return add_synth_field(self, args, kwargs, TRACEFS_SYNTH_DELTA_START);
+}
+
+PyObject *PySynthEvent_add_delta_end(PySynthEvent *self, PyObject *args,
+							 PyObject *kwargs)
+{
+	return add_synth_field(self, args, kwargs, TRACEFS_SYNTH_DELTA_END);
+}
+
+PyObject *PySynthEvent_add_sum(PySynthEvent *self, PyObject *args,
+						   PyObject *kwargs)
+{
+	return add_synth_field(self, args, kwargs, TRACEFS_SYNTH_ADD);
+}
+
+PyObject *PySynthEvent_add_delta_T(PySynthEvent *self, PyObject *args,
+						       PyObject *kwargs)
+{
+	static char *kwlist[] = {"name", "hd", NULL};
+	const char *name = "delta_T";
+	const char* time_rez;
+	int ret, hd = 0;
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "|sp",
+					 kwlist,
+					 &name,
+					 &hd)) {
+		return NULL;
+	}
+
+	time_rez = hd ? TRACEFS_TIMESTAMP : TRACEFS_TIMESTAMP_USECS;
+	ret = tracefs_synth_add_compare_field(self->ptrObj, time_rez, time_rez,
+					      TRACEFS_SYNTH_DELTA_END, name);
+	if (ret < 0) {
+		add_synth_field_err(name, tracefs_synth_get_name(self->ptrObj));
+		return NULL;
+	}
+
+	Py_RETURN_NONE;
+}
+
 PyObject *PyFtrace_dir(PyObject *self)
 {
 	return PyUnicode_FromString(tracefs_tracing_dir());
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index 3c6c0f3..7b798fc 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -127,6 +127,18 @@ PyObject *PySynthEvent_add_start_fields(PySynthEvent *self, PyObject *args,
 PyObject *PySynthEvent_add_end_fields(PySynthEvent *self, PyObject *args,
 							  PyObject *kwargs);
 
+PyObject *PySynthEvent_add_delta_start(PySynthEvent *self, PyObject *args,
+							   PyObject *kwargs);
+
+PyObject *PySynthEvent_add_delta_end(PySynthEvent *self, PyObject *args,
+							 PyObject *kwargs);
+
+PyObject *PySynthEvent_add_delta_T(PySynthEvent *self, PyObject *args,
+						       PyObject *kwargs);
+
+PyObject *PySynthEvent_add_sum(PySynthEvent *self, PyObject *args,
+						   PyObject *kwargs);
+
 PyObject *PyFtrace_dir(PyObject *self);
 
 PyObject *PyFtrace_detach(PyObject *self, PyObject *args, PyObject *kwargs);
diff --git a/src/ftracepy.c b/src/ftracepy.c
index 44114f0..066fc65 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -232,6 +232,26 @@ static PyMethodDef PySynthEvent_methods[] = {
 	 METH_VARARGS | METH_KEYWORDS,
 	 "Add fields from the end event to save."
 	},
+	{"add_delta_start",
+	 (PyCFunction) PySynthEvent_add_delta_start,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Add 'start - end' field."
+	},
+	{"add_delta_end",
+	 (PyCFunction) PySynthEvent_add_delta_end,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Add 'end - start' field."
+	},
+	{"add_delta_T",
+	 (PyCFunction) PySynthEvent_add_delta_T,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Add time-difference field."
+	},
+	{"add_sum",
+	 (PyCFunction) PySynthEvent_add_delta_T,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Add 'start + end' field."
+	},
 	{NULL, NULL, 0, NULL}
 };
 
-- 
2.32.0

