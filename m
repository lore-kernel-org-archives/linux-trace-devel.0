Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4398C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 11:10:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A15EE611EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 11:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbhKDLNb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Nov 2021 07:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbhKDLNb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Nov 2021 07:13:31 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2D5C06127A
        for <linux-trace-devel@vger.kernel.org>; Thu,  4 Nov 2021 04:10:53 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id s13so8028506wrb.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 04 Nov 2021 04:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LTqS8vdcJgzwrfsIlI1Nfthrli6ypMP3daK2KmPM/m0=;
        b=fcZHykNhmPRO/SYgqa1RUUXi4aVcCcBDY52eTl5TAlhpY4nfsGdNtHTAb73fVvxgo7
         VVvWrgk3rSnRth46xavbqSUwn76cedBZiY/3Xy6FPwitTQurbeSbv1/GoXOM4I9+oLRA
         cfgGuCXhY2Bb6m1v6WHT3DBVdUjsFnzQSJu+BPGzWM7VrO4yuxMuy1gR4Y5XCMpEB7bz
         S4UXtf6nehyV9D/FWyvr9ZhTacOdGd1yOV0mccJ+JSVjaEzq/xdEr7xs29vOsn+8yvlM
         4LfmptiVDcTm/ZUbYMvF6S0G2VBa3MvdMm8x9KeqxYiGGc4JgaZYgs6GeUnrfDBXoGHi
         DjdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LTqS8vdcJgzwrfsIlI1Nfthrli6ypMP3daK2KmPM/m0=;
        b=xvEjUYGm6WsVlQqODAspKN4SCQD5NsCSPZDxVxWSP0pvW+qHH/g9Y8edNycwJS7+qT
         n5Im6fO4yHEW859n+cAa8oY/hRxJRpA9sY97pXai5SWzv0pQCf/cTNFDrkmsGKXj92sw
         ArgnebhVYXj90C+TxfQeA5zWMI1D1xVDH0PuzglVbgRnXEqJj9XxnNLDNl8xrwUfEVuL
         CP2q/YvEd8Vo0hJkHYWH3pacm+EDEx+soBSAKIo0EHGzVsHvhL4JVcBP4p8BPDe2+NAN
         hkyPoHGd64+xsDAGoKYJOBHZhtbr2jTaSjzig0UnKMvd5m0mO1ZbG+O41kcrHORbYSB4
         K4ZA==
X-Gm-Message-State: AOAM533YLMrdJkpCOHDwrmF5jqbMyIcSm/uOxzYMbWWhxb6u2eV5mkrA
        4rivrWLiAWh4fG2HdcDaVwE=
X-Google-Smtp-Source: ABdhPJxx9ojcnzb72b0ML2sLPn7x1J02dyi0XiMi0KxuADTercZrJJM+JjeFxHM4M5j3ylLiU/B/1Q==
X-Received: by 2002:a05:6000:252:: with SMTP id m18mr41619888wrz.117.1636024251999;
        Thu, 04 Nov 2021 04:10:51 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l18sm5080843wrt.81.2021.11.04.04.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 04:10:51 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 02/10] libtracefs: New APIs for kprobe allocation
Date:   Thu,  4 Nov 2021 13:10:39 +0200
Message-Id: <20211104111047.302660-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211104111047.302660-1-tz.stoyanov@gmail.com>
References: <20211104111047.302660-1-tz.stoyanov@gmail.com>
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
index 81f22af..3b2fc50 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -263,6 +263,11 @@ enum tracefs_kprobe_type {
 	TRACEFS_KRETPROBE,
 };
 
+struct tracefs_dynevent *
+tracefs_kprobe_alloc(const char *system, const char *event, const char *addr, const char *format);
+struct tracefs_dynevent *
+tracefs_kretprobe_alloc(const char *system, const char *event,
+			const char *addr, const char *format, int max);
 int tracefs_kprobe_raw(const char *system, const char *event,
 		       const char *addr, const char *format);
 int tracefs_kretprobe_raw(const char *system, const char *event,
diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index 6fdd8f9..b2dcb0e 100644
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
+			const char *addr, const char *format, int max)
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

