Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0D88C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Nov 2021 15:44:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A3B56109F
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Nov 2021 15:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhKCPrB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Nov 2021 11:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbhKCPrB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Nov 2021 11:47:01 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63773C061203
        for <linux-trace-devel@vger.kernel.org>; Wed,  3 Nov 2021 08:44:24 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id b12so4260019wrh.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 03 Nov 2021 08:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m/FCV/p7IsZ3hsCfrBJPr62lpyUDQdCydkAOXxPmsjI=;
        b=lSlWPn95Ol4Qg6HcfJfqaHfXWxkKOSvCjr2ZEc+x8aLpjqhgjbRqcrwG2keY2IO2Qb
         T2k6WtYeecnbaXFc5JYCc39yam9yYmB2qAlS7sgLHqkfhgJcJJOovYPIxgYF7dRvcy1T
         ozkBKkY7yO5kCimKlaLX90q490jgbVmCP9awnVbJ4p09OawquhF0sXL92qR3ltKfKlWg
         v/CcOSyrJr1+QIa/zarcBuFmUL6j62rKL1GsesiFRG9YTg0Fb5SReV17OrKhc8vS1BnD
         q+FErOuzjQVq0K51SuhWvdiM9jCiV6raaazGOAXp+Zs0sezc8gIw+ecR8gj1A94V/odp
         ZwBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m/FCV/p7IsZ3hsCfrBJPr62lpyUDQdCydkAOXxPmsjI=;
        b=yk+5JqewBjPkoDbX4fM4QztoBkrPnWN08vU1IBy3R9Mkp9EMrvUIpodMy8U6ZRlvUh
         xZ/BORy8hSEpx3loysxTCGJ+qO2PqFfInWbuA+sOM1VRv8bJ5dNS9A6PMdCMgFqSfGU8
         oB44wXTK13Kx9olQC3ESBufLkj94W9wQYXYKP4ABpW586jixIwQXKy6khQR/mhuo9vKs
         syZ4ec4Jkc8FDueaVAGxLrNigNpKn+Y5zL0F4YE5SsjCx3uXCI4VW9zn2o4eH6Vmqb1O
         0t0/NBNDIE+QTsmhej1EiXvoaQStLp9pRSMcSnyMpKj9Im5ebUCufLUg2pdUAcUWtkjg
         Fnsg==
X-Gm-Message-State: AOAM533kSvfW10onenvNP/Z3M58PTmVv3DaW6zjSgQ8YHlSIXcXMgd3e
        QH+AAjok3h5CGbQoP7+iXX4=
X-Google-Smtp-Source: ABdhPJyJAKC3ucZDyMF9C52n6AvgKgvirIfJc09jgimbvjIlOpE69hc+RHyeaUvOAva3FWwXEHfsQQ==
X-Received: by 2002:a5d:4e52:: with SMTP id r18mr30852054wrt.224.1635954262879;
        Wed, 03 Nov 2021 08:44:22 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p12sm2767866wrr.10.2021.11.03.08.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 08:44:22 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 03/11] libtracefs: New APIs for kprobe allocation
Date:   Wed,  3 Nov 2021 17:44:09 +0200
Message-Id: <20211103154417.246999-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103154417.246999-1-tz.stoyanov@gmail.com>
References: <20211103154417.246999-1-tz.stoyanov@gmail.com>
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
 src/tracefs-kprobes.c | 105 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 110 insertions(+)

diff --git a/include/tracefs.h b/include/tracefs.h
index 470234d..b8f7c09 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -267,6 +267,11 @@ enum tracefs_kprobe_type {
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
index 6fdd8f9..d1279ff 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -20,6 +20,111 @@
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
+ * @system is NULL). Have the name of @event (or @addr if @event is
+ * NULL). Will be inserted to @addr (function name, with or without
+ * offset, or a address). And the @format will define the format
+ * of the kprobe. See the Linux documentation file under:
+ * Documentation/trace/kprobetrace.rst
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
+	if (max) {
+		free(kp->prefix);
+		kp->prefix = NULL;
+		ret = asprintf(&kp->prefix, "r%d:", max);
+		if (ret < 0)
+			goto error;
+	}
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

