Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0987C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 24 Jan 2022 08:56:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242524AbiAXI44 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 24 Jan 2022 03:56:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242514AbiAXI44 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 24 Jan 2022 03:56:56 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C5CC06173B
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 00:56:55 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id r22so4530412wra.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 24 Jan 2022 00:56:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xu6vBoYDdtUrdXK8a9RALrAK00fUiEeSHj6CTr9Bwjc=;
        b=ocs7/xs/GfUigL0HcLCINf3J4lN5dacSYCdXrOVI4/D0ZHgrsIEyuG8kBwSVQqdLZl
         SX4jEs/C2mlajg+VJMELCL4Ztz+Xt4S7pCUuICP5pgQy++KlodCytfsJQNF0X8pYTbT0
         N4on2KR6sELHKlRF5Ry1LEbOcAhseUOopL/nKwOa9jQJJKDc6fmuta0OcTLz8XthaA+j
         8iX1QkH37KgYgAxM0AFQxKb2qNDcm0BAKhDmFI5HIXjhgnrCy81l4GySlUz3fMfoj55+
         oPcXYapM74XpsKDvV/gVYtnijrlU+f+aUrvwNH+jCornrMKgLvHHWKz0psHbRCq9+nlC
         CX2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xu6vBoYDdtUrdXK8a9RALrAK00fUiEeSHj6CTr9Bwjc=;
        b=puJ1oNGC+w0LhR2dKugvw8XvGt37ULVoblSBIT2/6c2JFarMjdLuiZRpBk1DpK0tJw
         BS0DnROWBFmQAf0unMsFlKFRTTC+sMfPw9wHXib26GzQ3KiF2eQnNIbcisT2KJ37xVeO
         uH37GD3nZONSxtBtaWdS91+JGUtddYdd/VB7kEuksQRRiWtXndkiD1zdoR0McfF5j/hx
         kAV32wpOTu7ZjdzV7RXLxCSUAC53mgynaBB2xy/CKEn+b0ECBbAf+r14xviWGI01EvjS
         V2hCNJvkRfFyLp2QkO6KwWRwAX5v7gnm6z8AG3HKJfsFwrL9AA8iAsQpNSlA5UMq+vU2
         id5g==
X-Gm-Message-State: AOAM5328VeTEyKA1fFU/TeNnMpdhWTgzY/HXq4oF1vX7ZlPfS/IPMKB/
        0fL/Nxb7v41puRwUZy/oGVLQw3dniyA=
X-Google-Smtp-Source: ABdhPJwA9/L2G8WHX2OmQG+aXy4uaecdNc3c3oLFfS44SdlHZcXBJcTfEKdEZlVb/qcnDO4U42Fu4g==
X-Received: by 2002:a5d:5846:: with SMTP id i6mr5028244wrf.4.1643014614186;
        Mon, 24 Jan 2022 00:56:54 -0800 (PST)
Received: from crow.eng.vmware.com ([146.247.46.134])
        by smtp.gmail.com with ESMTPSA id f14sm14828091wri.44.2022.01.24.00.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 00:56:53 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 07/10] trace-cruncher: APIs for filtering synth. events
Date:   Mon, 24 Jan 2022 10:56:22 +0200
Message-Id: <20220124085625.92297-8-y.karadz@gmail.com>
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
set_filter()
get_filter()
clear_filter()

The new APIs allow for easy manipulation of the filters associated
with a given synthetic event.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 56 ++++++++++++++++++++++++++++++++++++++++++++
 src/ftracepy-utils.h |  9 +++++++
 src/ftracepy.c       | 15 ++++++++++++
 3 files changed, 80 insertions(+)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index af73784..43c0f07 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -2739,6 +2739,62 @@ PyObject *PySynthEvent_is_enabled(PySynthEvent *self, PyObject *args,
 				tracefs_synth_get_name(self->ptrObj));
 }
 
+struct tep_event *synth_get_event(PySynthEvent *event, struct tep_handle **tep_ptr)
+{
+	struct tep_event *tep_evt;
+	struct tep_handle *tep;
+
+	tep = get_tep(NULL, NULL);
+	if (!tep)
+		return NULL;
+
+	tep_evt = tracefs_synth_get_event(tep, event->ptrObj);
+	if (!tep_evt) {
+		TfsError_setstr(NULL, "Failed to get synth. event.");
+		return NULL;
+	}
+
+	if (tep_ptr)
+		*tep_ptr = tep;
+
+	return tep_evt;
+}
+
+PyObject *PySynthEvent_set_filter(PySynthEvent *self, PyObject *args,
+						      PyObject *kwargs)
+{
+	struct tep_handle *tep;
+	struct tep_event *evt;
+
+	evt = synth_get_event(self, &tep);
+	if (!evt)
+		return NULL;
+
+	return set_filter(args, kwargs, tep, evt);
+}
+
+PyObject *PySynthEvent_get_filter(PySynthEvent *self, PyObject *args,
+						      PyObject *kwargs)
+{
+	struct tep_event *evt = synth_get_event(self, NULL);
+
+	if (!evt)
+		return NULL;
+
+	return get_filter(args, kwargs, SYNTH_SYS, evt->name);
+}
+
+PyObject *PySynthEvent_clear_filter(PySynthEvent *self, PyObject *args,
+							PyObject *kwargs)
+{
+	struct tep_event *evt = synth_get_event(self, NULL);
+
+	if (!evt)
+		return NULL;
+
+	return clear_filter(args, kwargs, evt);
+}
+
 PyObject *PyFtrace_set_ftrace_loglevel(PyObject *self, PyObject *args,
 						       PyObject *kwargs)
 {
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index daf1a19..f31b330 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -152,6 +152,15 @@ PyObject *PySynthEvent_disable(PySynthEvent *self, PyObject *args,
 PyObject *PySynthEvent_is_enabled(PySynthEvent *self, PyObject *args,
 						      PyObject *kwargs);
 
+PyObject *PySynthEvent_set_filter(PySynthEvent *self, PyObject *args,
+						      PyObject *kwargs);
+
+PyObject *PySynthEvent_get_filter(PySynthEvent *self, PyObject *args,
+						      PyObject *kwargs);
+
+PyObject *PySynthEvent_clear_filter(PySynthEvent *self, PyObject *args,
+							PyObject *kwargs);
+
 PyObject *PyFtrace_dir(PyObject *self);
 
 PyObject *PyFtrace_detach(PyObject *self, PyObject *args, PyObject *kwargs);
diff --git a/src/ftracepy.c b/src/ftracepy.c
index 62c6de0..50675c0 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -277,6 +277,21 @@ static PyMethodDef PySynthEvent_methods[] = {
 	 METH_VARARGS | METH_KEYWORDS,
 	 "Check if synth. event is enabled."
 	},
+	{"set_filter",
+	 (PyCFunction) PySynthEvent_set_filter,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Define a filter for a synthetic event."
+	},
+	{"get_filter",
+	 (PyCFunction) PySynthEvent_get_filter,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Get the filter of a synthetic event."
+	},
+	{"clear_filter",
+	 (PyCFunction) PySynthEvent_clear_filter,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Clear the filter of a synthetic event."
+	},
 	{NULL, NULL, 0, NULL}
 };
 
-- 
2.32.0

