Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3712C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jan 2022 06:10:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236443AbiA0GKA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Jan 2022 01:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiA0GJ7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Jan 2022 01:09:59 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E221C061714
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 22:09:59 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id p7so2113290edc.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 22:09:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ddW55m7qz+iV4YPph3iI/aKslp0B+MYXVEL/Kx+jNVY=;
        b=Yvx932/s2qPwSt6lz77HJf594nNoTt/3PipQP5X7+MFWtfoyz4hT9j0XBYxiE8PO5U
         A33oNEQkIsPYkxwY2uqb9C1T1hl6Z9xgXb9YiYhoBkHKjCXV9jnSRG0dh5V4e3vUJ4Od
         xuW0Acqs1NPY7FiwrbSz94RninjxNm+CpW7ydRDmnmLkEgM5I2rcQ5VEIQYGf3sr9+jo
         3mPfD0ZH11crw3tcMP4sJjhV15wJlV7eYfMQqxyB7cMr3lbg583Ee/mPZfYl1NJ4Nwn4
         opFw3500lXOc06lr3BCmoieahlRWLlQD41+UgREAPm714Vq+bbODf9Kn9CGFijqQ+U/7
         S2Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ddW55m7qz+iV4YPph3iI/aKslp0B+MYXVEL/Kx+jNVY=;
        b=L9O30C6EzOuB/qkskbdX7IUaq1xRjFozdpjfjNh8Q2/YdiMGIsYNs0SZaQ2hYU4pCo
         DHp/aVP4RM1ZJjnFgprvpdz1Vcb5kU6WGL25fHjAQalfAG4ohcP1zaiRItkK+88hxq9i
         8U7g7laxdvzHYW2RFbZVCu3i7Lyq2HTeY1YqQkijHroXi+mQKFJ28oNE7i9e8wZHV01B
         2IKM9Oy30/jR7mJH6hHm+VX3AhMbMubGaSZn8UNszSCoJPKpkLQQ4rxpJOoALAVTLxS5
         H3eZeFnSzsnXsV9OKr1TF1ZJnuUvRZ9piDBxNWlR/EMf1GvnnO+I8Jk7brWTK/2KZMuB
         vpKA==
X-Gm-Message-State: AOAM533UfBAfxD4tZkV7Sd0POXj0TDz4Tf/Tv3ZHytYwX5ySNZcPY5Qi
        6+ZyFFxNN6lIA1EsiqWdnC7tZKcUrS0=
X-Google-Smtp-Source: ABdhPJyBdY4Sy59/5MIfMT8EtPzkQbG71SdN++Ti4etO2Gdz6uR5fqbyOTIH/XnxZoT5+STBYlTbhQ==
X-Received: by 2002:a05:6402:1395:: with SMTP id b21mr2202517edv.305.1643263797847;
        Wed, 26 Jan 2022 22:09:57 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id t15sm8279846eju.1.2022.01.26.22.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 22:09:57 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/2] trace-cruncher: Add support for event probes
Date:   Thu, 27 Jan 2022 08:09:53 +0200
Message-Id: <20220127060954.22927-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127060954.22927-1-tz.stoyanov@gmail.com>
References: <20220127060954.22927-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Event probe (eprobe) is a new type of ftrace dynamic events, introduced
in the Linux kernel 5.15 version. It is useful to have support for it in
trace-cruncher, as it allows more flexibility when printing event's
data.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 src/ftracepy-utils.c | 32 ++++++++++++++++++++++++++++++++
 src/ftracepy-utils.h |  2 ++
 src/ftracepy.c       |  5 +++++
 3 files changed, 39 insertions(+)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 8c46590..053b659 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -2315,6 +2315,38 @@ struct tep_event *dynevent_get_event(PyDynevent *event,
 	return tep_evt;
 }
 
+PyObject *PyFtrace_eprobe(PyObject *self, PyObject *args, PyObject *kwargs)
+{
+	static char *kwlist[] = {"event", "target_system", "target_event", "fetchargs", NULL};
+	const char *event, *target_system, *target_event, *fetchargs;
+	struct tracefs_dynevent *eprobe;
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "ssss",
+					 kwlist,
+					 &event,
+					 &target_system,
+					 &target_event,
+					 &fetchargs)) {
+		return NULL;
+	}
+
+	eprobe = tracefs_eprobe_alloc(TC_SYS, event, target_system, target_event, fetchargs);
+	if (!eprobe) {
+		MEM_ERROR;
+		return NULL;
+	}
+
+	if (tracefs_dynevent_create(eprobe) < 0) {
+		TfsError_fmt(NULL, "Failed to create eprobe '%s'", event);
+		tracefs_dynevent_free(eprobe);
+		return NULL;
+	}
+
+	return PyDynevent_New(eprobe);
+}
+
 static PyObject *set_filter(PyObject *args, PyObject *kwargs,
 			    struct tep_handle *tep,
 			    struct tep_event *event)
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index 7612df6..c96fd85 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -251,6 +251,8 @@ PyObject *PyFtrace_register_kprobe(PyObject *self, PyObject *args,
 PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
 						      PyObject *kwargs);
 
+PyObject *PyFtrace_eprobe(PyObject *self, PyObject *args, PyObject *kwargs);
+
 PyObject *PyFtrace_hist(PyObject *self, PyObject *args,
 					PyObject *kwargs);
 
diff --git a/src/ftracepy.c b/src/ftracepy.c
index 3f71b5e..0c9f795 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -460,6 +460,11 @@ static PyMethodDef ftracepy_methods[] = {
 	 METH_VARARGS | METH_KEYWORDS,
 	 "Define a kretprobe."
 	},
+	{"register_eprobe",
+	 (PyCFunction) PyFtrace_eprobe,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Define an eprobe."
+	},
 	{"hist",
 	 (PyCFunction) PyFtrace_hist,
 	 METH_VARARGS | METH_KEYWORDS,
-- 
2.34.1

