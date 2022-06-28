Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90F43C43334
	for <linux-trace-devel@archiver.kernel.org>; Tue, 28 Jun 2022 12:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345193AbiF1MQ2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 28 Jun 2022 08:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345233AbiF1MQ1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 28 Jun 2022 08:16:27 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0174827B2B
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Jun 2022 05:16:26 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id fi2so25331953ejb.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Jun 2022 05:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Bd4i6kukF74dEUHnWS2ndjqU6Fr27S6m9TzF1jL+l+M=;
        b=AeTMVqdP2DYaZeawF5OHdpeqzaKZl/pWypQ8DBk/bJP9XET6JSUy1SaZ6R5qgUazOD
         jGOdsERMmOSNDEy3kc2hMu7FCNUJnumLlCsFf4W5gvWNx4OltmGvnud305Ds91W0BT3P
         a+1HjNlumjH3VsC03ybDPdJTlQTI3B+D2u9VQu+bHf1mFpiHT3vQqOy4RvcSr5ngpa71
         7BE9OT39IbddQTf5vsDeOEx6sH7vEfqgO78GRf5rNE/1cyGMtOpuKqsFqKIaaZYVX3MB
         ppmGH+LBqvjgF8+GSGH2E0j5ehwZ2qQ6HFqhqdEcTm9A9JcV5sSRZDLPvjCtOw5TJtVz
         ofzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bd4i6kukF74dEUHnWS2ndjqU6Fr27S6m9TzF1jL+l+M=;
        b=dZSfotbPiiY/6QkFkuxN7Asei9TmcUbw/K2dBZgjG0s8/Neja5T85XsSWnA5sGYI+v
         nesjJMX1wGbLSeJHuztOKVoyJddGFpjtNeki5EpqUcCB9azP/61jEzmka3TrQqI2qkf1
         k9FGScI612BHzsi6V7dFVQ5zI3Lcd4Huiou0otoUTpG4D8qDQmQ4IfYqrtrAvNuy2KBF
         +qFpEoTjpTcE0uIZEHu11WlHZVk2TEz7CJUaKo+K7oPx6338Vr2RYzAr1IpM/e0ULYRA
         XyI0xW2POqDqi0TLfefrCpcUaMBDvgjAXf564DyhviD1HUmc0tK0cgiO36rsD2xyT4E/
         6B+g==
X-Gm-Message-State: AJIora+i2qZYiYRlTOXlpiM9nHyufJtkgESwS03gJgpSFkr9yAX6XrTB
        vT8NP65I0WmBXJ6fHXteIlKC/Z5JYSHMtQ==
X-Google-Smtp-Source: AGRyM1vDe9Y7WpIaWcTWbZxKJ2H8TExNWvVgFoDIa5CIIc+TdCDwNcoGQ1Hqhjq5ldbn7w9Dhc3wiA==
X-Received: by 2002:a17:907:7207:b0:726:cc89:40ca with SMTP id dr7-20020a170907720700b00726cc8940camr3622637ejc.141.1656418584362;
        Tue, 28 Jun 2022 05:16:24 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k14-20020aa7c04e000000b00431962fe5d4sm9512780edo.77.2022.06.28.05.16.23
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 05:16:24 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 1/3] trace-cruncher: ftrace uprobe raw API
Date:   Tue, 28 Jun 2022 15:16:19 +0300
Message-Id: <20220628121621.572506-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220628121621.572506-1-tz.stoyanov@gmail.com>
References: <20220628121621.572506-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace-cruncher low level wrappers for tracefs library APIs for
uprobe and uretprobe allocation.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 src/ftracepy-utils.c | 48 ++++++++++++++++++++++++++++++++++++++++++++
 src/ftracepy-utils.h |  4 ++++
 src/ftracepy.c       | 10 +++++++++
 3 files changed, 62 insertions(+)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index e8411ae..b39459b 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -2449,6 +2449,54 @@ PyObject *PyFtrace_eprobe(PyObject *self, PyObject *args, PyObject *kwargs)
 	return py_dyn;
 }
 
+static PyObject *alloc_uprobe(PyObject *self, PyObject *args, PyObject *kwargs, bool pret)
+{
+	static char *kwlist[] = {"event", "file", "offset", "fetch_args", NULL};
+	const char *event, *file, *fetchargs = NULL;
+	unsigned long long offset;
+	struct tracefs_dynevent *uprobe;
+	PyObject *py_dyn;
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "ssK|s",
+					 kwlist,
+					 &event,
+					 &file,
+					 &offset,
+					 &fetchargs)) {
+		return NULL;
+	}
+
+	if (pret)
+		uprobe = tracefs_uretprobe_alloc(TC_SYS, event, file, offset, fetchargs);
+	else
+		uprobe = tracefs_uprobe_alloc(TC_SYS, event, file, offset, fetchargs);
+	if (!uprobe) {
+		MEM_ERROR;
+		return NULL;
+	}
+
+	py_dyn = PyDynevent_New(uprobe);
+	/*
+	 * Here we only allocated and initializes a dynamic event object.
+	 * However, no dynamic event is added to the system yet. Hence,
+	 * there is no need to 'destroy' this event at exit.
+	 */
+	set_destroy_flag(py_dyn, false);
+	return py_dyn;
+}
+
+PyObject *PyFtrace_uprobe(PyObject *self, PyObject *args, PyObject *kwargs)
+{
+	return alloc_uprobe(self, args, kwargs, false);
+}
+
+PyObject *PyFtrace_uretprobe(PyObject *self, PyObject *args, PyObject *kwargs)
+{
+	return alloc_uprobe(self, args, kwargs, true);
+}
+
 static PyObject *set_filter(PyObject *args, PyObject *kwargs,
 			    struct tep_handle *tep,
 			    struct tep_event *event)
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index 9491b18..e6fab69 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -257,6 +257,10 @@ PyObject *PyFtrace_kretprobe(PyObject *self, PyObject *args, PyObject *kwargs);
 
 PyObject *PyFtrace_eprobe(PyObject *self, PyObject *args, PyObject *kwargs);
 
+PyObject *PyFtrace_uprobe(PyObject *self, PyObject *args, PyObject *kwargs);
+
+PyObject *PyFtrace_uretprobe(PyObject *self, PyObject *args, PyObject *kwargs);
+
 PyObject *PyFtrace_hist(PyObject *self, PyObject *args,
 					PyObject *kwargs);
 
diff --git a/src/ftracepy.c b/src/ftracepy.c
index 2819da2..29d273f 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -483,6 +483,16 @@ static PyMethodDef ftracepy_methods[] = {
 	 METH_VARARGS | METH_KEYWORDS,
 	 PyFtrace_eprobe_doc,
 	},
+	{"uprobe",
+	 (PyCFunction) PyFtrace_uprobe,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Define a uprobe."
+	},
+	{"uretprobe",
+	 (PyCFunction) PyFtrace_uretprobe,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Define a uretprobe."
+	},
 	{"hist",
 	 (PyCFunction) PyFtrace_hist,
 	 METH_VARARGS | METH_KEYWORDS,
-- 
2.35.3

