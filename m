Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92459C433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Nov 2021 10:46:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7511661AAD
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Nov 2021 10:46:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbhKOKtN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Nov 2021 05:49:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbhKOKs6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Nov 2021 05:48:58 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D88BC0613B9
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Nov 2021 02:46:02 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id g14so6179696edb.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Nov 2021 02:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8PbFluYxM42X1L+Slvpt4jNgCEqCaKXabQBVgjBPpDU=;
        b=d0pVijQHldYGRxG9hqYkySih25+/VHKZtCg59nGs5ZZcPtIKpg0U/3wuYLltzknH56
         skuILuwMmRTJj1SLtSXIxia2Bffcr2EEhsDmVQLPNtDzGDpi+UTgkHIGjM5ZoWAUftN8
         Lol3ld6vTdG0LmEVQfVh9/szGnFZv2u7uTpJYp1Ex84cu/Dh59sVNIw9dROUipvMEO9D
         9hQH83DANMDDNiCh6pZjHqaDFsNdMw1v1hm9nSw1vqMemMko7Dffy2zXSkK/vD6LNCeB
         vKffEzdarAcOzndWmjXYfsdSKQ7WeAjXtn+1MxSSOECSF1rNj5GJ9cWQmZh2X+MWxC8T
         GG9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8PbFluYxM42X1L+Slvpt4jNgCEqCaKXabQBVgjBPpDU=;
        b=Mh2wWRVqEBt/RWQ1KRAw7avcIhBAjonYvTro2V57H6CVSbY4XDPzwbDJaOEOdQVGBh
         W7+7ZAfyxjs80qXFmx3LVHWbkqYy8dAoCuzkCpcQXvNbgSlSg7cwPfQ2g3ZFvhvOrKHt
         hEidTznW+P/4zxOlRdHFiwlABwS6qvimWDAPoLmwfO6s2mbZX/dW/ZuQ80Vdj2DJe4tU
         wehIE6yr8c00M+D1iChrtoTGJfic8FQYBacHLQgYmSHmh9USEWaCSUgpUsMwG+Raw2DB
         Pk52bM3MJ5a+Shd6+YC1A5eUX+/F8Di1ZUHekGtgOAoAZWKN852l7OXO+mSmzgJoFnyI
         p8pA==
X-Gm-Message-State: AOAM531Bjfhd5lbxqx/ghViEtanCG3CNlEatWJQGLSqNWuXzntDYTcrl
        PCS4A7A12WuDjVJ7vjIuQFo=
X-Google-Smtp-Source: ABdhPJxhacALg+lavbINp4j8h5ych3yIWkCmCU3ZUgHaiNgmBahIJJ84eVS0mu554TAJ/en2zxQFjg==
X-Received: by 2002:a17:907:6e26:: with SMTP id sd38mr49134077ejc.90.1636973160832;
        Mon, 15 Nov 2021 02:46:00 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e12sm6315509ejs.86.2021.11.15.02.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 02:46:00 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 02/15] libtracefs: New APIs for kprobe allocation
Date:   Mon, 15 Nov 2021 12:45:43 +0200
Message-Id: <20211115104556.121359-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115104556.121359-1-tz.stoyanov@gmail.com>
References: <20211115104556.121359-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In order to be consistent with the other APIs, new APIs for kprobe
allocation are introduced:
 tracefs_kprobe_alloc();
 tracefs_kretprobe_alloc();
These APIs allocate new kpobe dynamic event, that can be used with
tracefs_dynevent_... set of APIs.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs.h     |   5 ++
 src/tracefs-kprobes.c | 109 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 114 insertions(+)

diff --git a/include/tracefs.h b/include/tracefs.h
index eceb1f5..dfd9b51 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -267,6 +267,11 @@ enum tracefs_kprobe_type {
 	TRACEFS_KRETPROBE,
 };
 
+struct tracefs_dynevent *
+tracefs_kprobe_alloc(const char *system, const char *event, const char *addr, const char *format);
+struct tracefs_dynevent *
+tracefs_kretprobe_alloc(const char *system, const char *event,
+			const char *addr, const char *format, unsigned int max);
 int tracefs_kprobe_raw(const char *system, const char *event,
 		       const char *addr, const char *format);
 int tracefs_kretprobe_raw(const char *system, const char *event,
diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index 6fdd8f9..b9aeb9d 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -20,6 +20,115 @@
 #define KPROBE_EVENTS "kprobe_events"
 #define KPROBE_DEFAULT_GROUP "kprobes"
 
+static struct tracefs_dynevent *
+kprobe_alloc(enum tracefs_dynevent_type type, const char *system, const char *event,
+	     const char *addr, const char *format)
+{
+	struct tracefs_dynevent *kp;
+	const char *sys = system;
+	const char *ename = event;
+	char *tmp;
+
+	if (!addr) {
+		errno = EBADMSG;
+		return NULL;
+	}
+	if (!sys)
+		sys = KPROBE_DEFAULT_GROUP;
+
+	if (!event) {
+		ename = strdup(addr);
+		if (!ename)
+			return NULL;
+		tmp = strchr(ename, ':');
+		if (tmp)
+			*tmp = '\0';
+	}
+
+	kp = dynevent_alloc(type, sys, ename, addr, format);
+	if (!event)
+		free((char *)ename);
+
+	return kp;
+}
+
+/**
+ * tracefs_kprobe_alloc - Allocate new kprobe
+ * @system: The system name (NULL for the default kprobes)
+ * @event: The event to create (NULL to use @addr for the event)
+ * @addr: The function and offset (or address) to insert the probe
+ * @format: The format string to define the probe.
+ *
+ * Allocate a kprobe context that will be in the @system group (or kprobes if
+ * @system is NULL). Have the name of @event (or @addr if @event is NULL). Will
+ * be inserted to @addr (function name, with or without offset, or a address).
+ * And the @format will define the format of the kprobe.
+ *
+ * See the Linux documentation file under:
+ *  Documentation/trace/kprobetrace.rst
+ *
+ * The kprobe is not created in the system.
+ *
+ * Return a pointer to a kprobe context on success, or NULL on error.
+ * The returned pointer must be freed with tracefs_dynevent_free()
+ *
+ * errno will be set to EBADMSG if addr is NULL.
+ */
+struct tracefs_dynevent *
+tracefs_kprobe_alloc(const char *system, const char *event, const char *addr, const char *format)
+
+{
+	return kprobe_alloc(TRACEFS_DYNEVENT_KPROBE, system, event, addr, format);
+}
+
+/**
+ * tracefs_kretprobe_alloc - Allocate new kretprobe
+ * @system: The system name (NULL for the default kprobes)
+ * @event: The event to create (NULL to use @addr for the event)
+ * @addr: The function and offset (or address) to insert the retprobe
+ * @format: The format string to define the retprobe.
+ * @max: Maximum number of instances of the specified function that
+ *	 can be probed simultaneously, or 0 for the default value.
+ *
+ * Allocate a kretprobe that will be in the @system group (or kprobes if
+ * @system is NULL). Have the name of @event (or @addr if @event is
+ * NULL). Will be inserted to @addr (function name, with or without
+ * offset, or a address). And the @format will define the raw format
+ * of the kprobe. See the Linux documentation file under:
+ * Documentation/trace/kprobetrace.rst
+ * The kretprobe is not created in the system.
+ *
+ * Return a pointer to a kprobe context on success, or NULL on error.
+ * The returned pointer must be freed with tracefs_dynevent_free()
+ *
+ * errno will be set to EBADMSG if addr is NULL.
+ */
+struct tracefs_dynevent *
+tracefs_kretprobe_alloc(const char *system, const char *event,
+			const char *addr, const char *format, unsigned int max)
+{
+	struct tracefs_dynevent *kp;
+	int ret;
+
+	kp = kprobe_alloc(TRACEFS_DYNEVENT_KRETPROBE, system, event, addr, format);
+	if (!kp)
+		return NULL;
+
+	if (!max)
+		return kp;
+
+	free(kp->prefix);
+	kp->prefix = NULL;
+	ret = asprintf(&kp->prefix, "r%d:", max);
+	if (ret < 0)
+		goto error;
+
+	return kp;
+error:
+	tracefs_dynevent_free(kp);
+	return NULL;
+}
+
 static int insert_kprobe(const char *type, const char *system,
 			 const char *event, const char *addr,
 			 const char *format)
-- 
2.33.1

