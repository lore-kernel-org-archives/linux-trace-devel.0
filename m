Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66DC2C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Nov 2021 12:16:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E76061262
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Nov 2021 12:16:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbhKEMTK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Nov 2021 08:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhKEMTJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Nov 2021 08:19:09 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC37C061714
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Nov 2021 05:16:29 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id c4so13388676wrd.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Nov 2021 05:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g5y4JKxCW95q80MrAIv4cs6zp/FN3hiMfsAH+/jv0vI=;
        b=ArL6OSdi+veAi5X5WiLWl/hzrANiYn0h9mt4QCkHdqsev6mYSh15yH0V5yeLexMxVR
         NnFYyyqdLc/uBUMrZom941qXCKahOq6m4ttsTd3P7q+JQYINs48IciK988A6apw3Noiz
         eQrdWWWHVTDHbvSJtqwGrv7DfFOa2Ca70YMZEtHp7ymyAV2/j9LN2D2dxwW06cQ+Lk2b
         1Jsm8EUcwNAvhZsBrPxvmFxhcV1XsMGXOPam9rCsnt8pcfbhv4qnCFWdMVWc3nQLnTzZ
         qsWANlB3zPlzyTuY5UBC1pb/qLhwFv5lO4Yvmc3JqJtaBdMUuWiBYdfOSFYbgdp/MW2Y
         WIZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g5y4JKxCW95q80MrAIv4cs6zp/FN3hiMfsAH+/jv0vI=;
        b=RYeRLlLDQ4xzlsApvwPol6/qHvyA1+JA2WUkgJdNFVT8tXjdSwKfOZFIG2zecsMUKk
         uriDorUmZyCRJ7xyWBdqsECh1sKXmVOuSvkQgU6ndCsE1KxkVKk0TdfnuB5pBZNgon86
         lNmDaQ7lnCmN7TgW+/p6WhZfGIUO3wjKMcEWNFEppJIEiNwWSH86nWP87P4nTWcgb00K
         /iTyZ0FkFTSF8ndcyujYurLwUN087Zh8AqItZQPX17eo9Jvd+tW50gliro2dOdSoBNSO
         ygCZTdpSO7iJrKNs5eBVbHY0n4UcIMEicJpiBtwbxSwqxM0C5ZjWTcoUe5/rCMcZXMFa
         ZprQ==
X-Gm-Message-State: AOAM53137rLGgIFuH82aSTBTq4tmLZ1o+vWuhnEvaegRsJzgTyjAsi00
        XcTbpa4Vr4Q9oVkI3Bwtd0s=
X-Google-Smtp-Source: ABdhPJyUMxd5eHShu+UW68joo1m1Muw1UDN+KbpomeD6mQKGFF6LIeUR57U8OsOdQSALEq9OA+7HGg==
X-Received: by 2002:adf:ec90:: with SMTP id z16mr47021171wrn.247.1636114588474;
        Fri, 05 Nov 2021 05:16:28 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x13sm7936531wrr.47.2021.11.05.05.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 05:16:27 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 02/12] libtracefs: New APIs for kprobe allocation
Date:   Fri,  5 Nov 2021 14:16:14 +0200
Message-Id: <20211105121624.398717-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211105121624.398717-1-tz.stoyanov@gmail.com>
References: <20211105121624.398717-1-tz.stoyanov@gmail.com>
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

