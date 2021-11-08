Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8845C433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 08:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B820961208
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 08:04:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237446AbhKHIGz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 03:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237433AbhKHIGy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 03:06:54 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58749C061570
        for <linux-trace-devel@vger.kernel.org>; Mon,  8 Nov 2021 00:04:10 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id j21so58786292edt.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Nov 2021 00:04:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g5y4JKxCW95q80MrAIv4cs6zp/FN3hiMfsAH+/jv0vI=;
        b=QrLEUVAFR1J2Kum0Jumi95oDjIsJLH93Ufzg7a2+NwymjvaM40o9rLHS/vCaTqTmcc
         YZ7Yo5R307feN7pc3S87UQJGqWELmlaNhQFi9nJa1uEvDIZAKbHkaAw3SVJAbNvMoICJ
         /0RXguE2HP4J0wbEh47STXRfYvatUqPqBYvVMYQEJG/lC0JdqqoQMvMYthuP9OpTs+1V
         rsv4IVEHuQaN8J9GGeNbN8LXi9sxiMB5Hitept1iV842wc0L+RMImXQledEmVV4yyQ4X
         JKvUeMLs/2YA4Zen20SGWVf7Ysr1dV6mrOfuXhYpU3pd8858fspC7g7bjUrGzrXZYCbt
         WAbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g5y4JKxCW95q80MrAIv4cs6zp/FN3hiMfsAH+/jv0vI=;
        b=yOj9xVP+pBpo0nuVyHOLl6LGbkygsO1t3vgpDilDSt4MkNkceqbPQGOeDk043RXn3b
         k+eexupUjeZoywRsLGIf43sgVAUJfPMVDdR9CqccARKkgB/caJNbuCFsImsb8pdRi2DA
         JUQdSE+f8HZs9/T6SXqA2+jnrKEi2jEybApnp+gUyscZVYrW4p+aUDokIRu189T+FaYO
         yjJOa9PjBPz3usB7F5bn2zP8NruGnnyTVyiYfSMe6AVWpWkRWKhjbchKBH0UItdNP0rJ
         ot3jdZ0IFpTJcwjmEbCLcBjEzd2PFgoA+RMx4+C8cRAqm5bQDdHivxCipWjOYvg84NTE
         BkdA==
X-Gm-Message-State: AOAM532b1jRCfdQUEQPdkPLAnsY6hUTf8wW3GOSVMjKqAdrqWvUjtBvG
        3UAF7+xB9IStdd1bcOSigqsJFbhEoIOcgw==
X-Google-Smtp-Source: ABdhPJyJJ81UjBHySzzISueC3fbGIPbYPNvvq2KbylBQLRJPNQE2ijOKxzemzyKysq0Kd/BFqSF1uw==
X-Received: by 2002:a17:906:8a62:: with SMTP id hy2mr51275854ejc.347.1636358648977;
        Mon, 08 Nov 2021 00:04:08 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id mp5sm7962309ejc.68.2021.11.08.00.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 00:04:08 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 02/12] libtracefs: New APIs for kprobe allocation
Date:   Mon,  8 Nov 2021 10:03:54 +0200
Message-Id: <20211108080404.55814-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211108080404.55814-1-tz.stoyanov@gmail.com>
References: <20211108080404.55814-1-tz.stoyanov@gmail.com>
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
2.31.1

