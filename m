Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49072C433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 24 Jan 2022 08:56:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242522AbiAXI45 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 24 Jan 2022 03:56:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242526AbiAXI45 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Jan 2022 03:56:57 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFCBC06173B
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 00:56:56 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id f17so12167409wrx.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 00:56:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m5I+tLN69QPUhS4jqG8C1Ixnhn1tRl62HglJZvcNlKY=;
        b=OLqUl8/M7vFoEXJWh1y2MLbBuvuiIwzezsd8baZrtxPkwVvuL6+RkBOCxmzE2Wsqdg
         rS9mkI/bt4plcBuVXlInsdUAwwvIP7fw333o+Bsru0RDRd8iQW8vwj2MAv5kSE34a0/0
         kPSSfwF3gjCdztAWor+HdBS1q8jiwS8jvluZI9WenISjVff/735IyQj21SxAaRmZwPmm
         Kp3ExJwblyAogTGdT+lerAB6coLnKZNiDMODNi7SO4lzSKOpZ1LSw9+CMBVw9Lc70+K2
         /71RQr4EbR/RkU/6MTMf1iJZNhvZpoHWMa+ZJFmfyD5K46HrsItOQkFMceTq24dKiYd3
         T6Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m5I+tLN69QPUhS4jqG8C1Ixnhn1tRl62HglJZvcNlKY=;
        b=3U68Bg5fi87yTb0VM+BDZeG68p8/pCL0tH87uGIQJ2B/Lsx57ZWqGxBCBm1syjQyi3
         gX7g+/ugONZIO/cCRh2l7wspLlH0F0+fjNlcwnnho6npchmRY4l0OgHHz1EeXDV2ZKLK
         uNBMx59pKGYQsJEk1m5euxGq9y2kwwpA0zNeTRkkcD2Jn7T1lxyZCiPx5irPLYi+qFQ9
         dri2WTbeXdZKHc9LWn2KX1Aa9KJ07zmGEAU2l18Czi/4WrnJpOJYF5epV524PB8VrYOG
         H8iNDJNBM3ZHvoJTbBKgg++2WPYrMo+qT33nVmtxVc69Op5FTH9FpKMLHn1Ki4kRIsVn
         f2/w==
X-Gm-Message-State: AOAM533oQxys8COThx7+0g0Lt1D1INtCRvXBaFBeZpwGYFv1n/0zq90/
        hm/lODX+FuWSnNQRz2PATzcrlfakhto=
X-Google-Smtp-Source: ABdhPJzObpN3xXpoOpr1LV0VERLCtJ/vsuJiI2QJAcLzNn8uqjb0JiN9DQigJAlRNLUMwXTYB6sweA==
X-Received: by 2002:a5d:6d45:: with SMTP id k5mr4195932wri.678.1643014615048;
        Mon, 24 Jan 2022 00:56:55 -0800 (PST)
Received: from crow.eng.vmware.com ([146.247.46.134])
        by smtp.gmail.com with ESMTPSA id f14sm14828091wri.44.2022.01.24.00.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 00:56:54 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 08/10] trace-cruncher: API to show descriptor of the synth. event
Date:   Mon, 24 Jan 2022 10:56:23 +0200
Message-Id: <20220124085625.92297-9-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220124085625.92297-1-y.karadz@gmail.com>
References: <20220124085625.92297-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Here we add the following method to the Python type for synthetic
events:
repr()

The new APIs provides a representative descriptor of the synth. event,
including the dynamic event and the two histograms. It can be useful
in the case where the user wants to check what exactly gets passed to
the kernel as definition of a synth event.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 52 ++++++++++++++++++++++++++++++++++++++++++++
 src/ftracepy-utils.h |  2 ++
 src/ftracepy.c       |  5 +++++
 3 files changed, 59 insertions(+)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 43c0f07..8c46590 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -1192,6 +1192,58 @@ PyObject *PySynthEvent_unregister(PySynthEvent *self)
 	Py_RETURN_NONE;
 }
 
+PyObject *PySynthEvent_repr(PySynthEvent *self, PyObject *args, PyObject *kwargs)
+{
+	static char *kwlist[] = {"event", "hist_start", "hist_end", NULL};
+	int event, hist_start, hist_end;
+	char buff[2048] = {0};
+	bool new_line = false;
+	const char *str = NULL;
+
+	event = hist_start = hist_end = true;
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "|ppp",
+					 kwlist,
+					 &event,
+					 &hist_start,
+					 &hist_end)) {
+		return NULL;
+	}
+
+	if (event) {
+		strcat(buff, "synth. event: ");
+		str = tracefs_synth_show_event(self->ptrObj);
+		if (str)
+			strcat(buff, str);
+		new_line = true;
+	}
+
+	if (hist_start) {
+		if (new_line)
+			strcat(buff, "\n");
+		else
+			new_line = true;
+
+		strcat(buff, "hist. start: ");
+		str = tracefs_synth_show_start_hist(self->ptrObj);
+		if (str)
+			strcat(buff, str);
+	}
+
+	if (hist_end) {
+		if (new_line)
+			strcat(buff, "\n");
+
+		strcat(buff, "hist. end: ");
+		str = tracefs_synth_show_end_hist(self->ptrObj);
+		if (str)
+			strcat(buff, str);
+	}
+
+	return PyUnicode_FromString(strdup(buff));
+}
+
 PyObject *PyFtrace_dir(PyObject *self)
 {
 	return PyUnicode_FromString(tracefs_tracing_dir());
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index f31b330..7612df6 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -161,6 +161,8 @@ PyObject *PySynthEvent_get_filter(PySynthEvent *self, PyObject *args,
 PyObject *PySynthEvent_clear_filter(PySynthEvent *self, PyObject *args,
 							PyObject *kwargs);
 
+PyObject *PySynthEvent_repr(PySynthEvent *self, PyObject *args, PyObject *kwargs);
+
 PyObject *PyFtrace_dir(PyObject *self);
 
 PyObject *PyFtrace_detach(PyObject *self, PyObject *args, PyObject *kwargs);
diff --git a/src/ftracepy.c b/src/ftracepy.c
index 50675c0..3f71b5e 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -292,6 +292,11 @@ static PyMethodDef PySynthEvent_methods[] = {
 	 METH_VARARGS | METH_KEYWORDS,
 	 "Clear the filter of a synthetic event."
 	},
+	{"repr",
+	 (PyCFunction) PySynthEvent_repr,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Show a representative descriptor of the synth. event."
+	},
 	{NULL, NULL, 0, NULL}
 };
 
-- 
2.32.0

