Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B210C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 12:09:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FA76610FC
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 12:09:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhJ1MLr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Oct 2021 08:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbhJ1MLp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 08:11:45 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B843FC0613B9
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Oct 2021 05:09:18 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id r4so23322657edi.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Oct 2021 05:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WsoLxa8cLX9iZenPySJS5HYfuk7OataG2QLlzHuauiM=;
        b=nrsyi5DCjSiMo+BiZiOmT2hTdND/9a8488jhzsO2Vk9o3Sh3jKnaDHqNQacd74H+cD
         yPZCekxWNeoMJTcllYS6LCtnXf/61casH/pOg33w9N7TZ8Irg1QQ1MEl0yIzhglDXC6G
         kgdtd9mHycvsvmJEkHN/FZGK2KHXS/k0+gMsNlVPJKuJbXIMvRYBptMcjHnZsPsB02YE
         dqfV3MfY65Gj6D8PS49y8g9toGafWLx7+8EtomYKrEIyOQrGz0n6M1i7+REMXgz3bRke
         q77aEkItqTWfoHH+1oyKwb0sjmsJf3nrSil601Pfwhv78nFQrfzzfE9Ztcply0qYIUnb
         FUTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WsoLxa8cLX9iZenPySJS5HYfuk7OataG2QLlzHuauiM=;
        b=PvNCBffC9bO2JvPQ2SNm7I13GDt2n9jV7YI/XpKsvOg2uQ6SE6I4mPbwFv+jpGqRy6
         bNwaRwx4cvtYCB9KjsIW5sU6ExN4xLJ2LAre49pmg649kLiI440stQidA35CFcxsaEmr
         IeGf7F7P+zwDL1O05nKq7Vt1iOuL888cuptsYSw5Tf5BZQqORXFak1iqU5NuQPchzImX
         4vLDTi/YKkn+eLMSNNsz8UFPkEoc/BGwdKF/9SHhZ5OwWz9VjTX0G65b/61rgZF5VKd9
         gE2fDWNTOlceroGbOJi2pXXvIH/GkP66FuPO4VmhxH3qfkLvVGvHr4kRg7NahzLYUHrP
         zDPg==
X-Gm-Message-State: AOAM530OMWi3eGQL+4vklBdIpKH4/2E3Xd0gEw99fLvmD9FaNMdErT9u
        IZO9uqrv5kUiTpas4Dd/4Np4F0tMHzW4Mg==
X-Google-Smtp-Source: ABdhPJwfRK9lJf6ss+Q4hm8RBy3AJmccbTbGxBnRoJlP5zjXEZ8hypGR/5PgKfQ7hGNK0DeBqkh9XA==
X-Received: by 2002:a50:9b4b:: with SMTP id a11mr5673881edj.316.1635422953427;
        Thu, 28 Oct 2021 05:09:13 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v6sm1803003edc.52.2021.10.28.05.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 05:09:12 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 03/12] libtracefs: New kprobes APIs
Date:   Thu, 28 Oct 2021 15:08:58 +0300
Message-Id: <20211028120907.101847-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211028120907.101847-1-tz.stoyanov@gmail.com>
References: <20211028120907.101847-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In order to be consistent with the other APIs, a new set of kprobe APIs
is introduced:
 tracefs_kprobe_alloc();
 tracefs_kretprobe_alloc();
 tracefs_kprobe_create();
 tracefs_kprobe_destroy();
 tracefs_kprobe_free();
These APIs work with kprobe context, represented by the tracefs_dynevent
structure.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs.h     |   8 ++
 src/tracefs-kprobes.c | 169 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 177 insertions(+)

diff --git a/include/tracefs.h b/include/tracefs.h
index 0240aef..e7d545c 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -247,6 +247,14 @@ enum tracefs_kprobe_type {
 	TRACEFS_KRETPROBE,
 };
 
+struct tracefs_dynevent *
+tracefs_kprobe_alloc(const char *system, const char *event, const char *addr, const char *format);
+struct tracefs_dynevent *
+tracefs_kretprobe_alloc(const char *system, const char *event,
+			const char *addr, const char *format, int max);
+int tracefs_kprobe_create(struct tracefs_dynevent *kprobe);
+int tracefs_kprobe_destroy(struct tracefs_dynevent *kprobe, bool force);
+void tracefs_kprobe_free(struct tracefs_dynevent *kprobe);
 int tracefs_kprobe_raw(const char *system, const char *event,
 		       const char *addr, const char *format);
 int tracefs_kretprobe_raw(const char *system, const char *event,
diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index d4c5f9e..80dc327 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -20,6 +20,135 @@
 #define KPROBE_EVENTS "kprobe_events"
 #define KPROBE_DEFAULT_GROUP "kprobes"
 
+static struct tracefs_dynevent *
+kprobe_alloc(enum trace_dynevent_type type, const char *system, const char *event,
+	     const char *addr, const char *format)
+{
+	struct tracefs_dynevent *kp;
+	const char *sys = system;
+	const char *ename = event;
+	char *tmp;
+
+	if (!addr || !format) {
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
+	if (!kp)
+		return NULL;
+	return kp;
+}
+
+
+/**
+ * tracefs_kprobe_alloc - Allocate new kprobe context
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
+ * The returned pointer must be freed with tracefs_kprobe_free()
+ *
+ * errno will be set to EBADMSG if addr or format is NULL.
+ */
+struct tracefs_dynevent *
+tracefs_kprobe_alloc(const char *system, const char *event, const char *addr, const char *format)
+
+{
+	return kprobe_alloc(TRACE_DYNEVENT_KPROBE, system, event, addr, format);
+}
+
+/**
+ * tracefs_kretprobe_alloc - Allocate new kretprobe context
+ * @system: The system name (NULL for the default kprobes)
+ * @event: The event to create (NULL to use @addr for the event)
+ * @addr: The function and offset (or address) to insert the retprobe
+ * @format: The format string to define the retprobe.
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
+ * The returned pointer must be freed with tracefs_kprobe_free()
+ *
+ * errno will be set to EBADMSG if addr or format is NULL.
+ */
+struct tracefs_dynevent *
+tracefs_kretprobe_alloc(const char *system, const char *event,
+			const char *addr, const char *format, int max)
+{
+	struct tracefs_dynevent *kp;
+	int ret;
+
+	kp = kprobe_alloc(TRACE_DYNEVENT_KRETPROBE, system, event, addr, format);
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
+	dynevent_free(kp);
+	return NULL;
+}
+
+/**
+ * tracefs_kprobe_create - Create a kprobe or kretprobe in the system
+ * @kprobe: Pointer to a kprobe context, describing the probe
+ *
+ * Return 0 on success, or -1 on error.
+ */
+int tracefs_kprobe_create(struct tracefs_dynevent *kprobe)
+{
+	return dynevent_create(kprobe);
+}
+
+/**
+ * tracefs_kprobe_free - Free a kprobe context
+ * @kprobe: Pointer to a kprobe context
+ *
+ * The kprobe/kretprobe, described by this context, is not
+ * removed from the system by this API. It only frees the memory.
+ */
+void tracefs_kprobe_free(struct tracefs_dynevent *kprobe)
+{
+	dynevent_free(kprobe);
+}
+
+
 static int insert_kprobe(const char *type, const char *system,
 			 const char *event, const char *addr,
 			 const char *format)
@@ -474,3 +603,43 @@ int tracefs_kprobe_clear_probe(const char *system, const char *event, bool force
 
 	return ret < 0 ? -1 : 0;
 }
+
+/**
+ * tracefs_kprobe_destroy - Remove a kprobe or kretprobe from the system
+ * @kprobe: A kprobe context, describing the kprobe that will be deleted.
+ *	    If NULL, all kprobes and kretprobes in the system will be deleted
+ * @force: Will attempt to disable all kprobe events and clear them
+ *
+ * The kprobe/kretprobe context is not freed by this API.
+ * It only removes the probe from the system.
+ *
+ * Return 0 on success, or -1 on error.
+ */
+int tracefs_kprobe_destroy(struct tracefs_dynevent *kprobe, bool force)
+{
+	char **instance_list;
+	int ret;
+
+	if (!kprobe) {
+		if (tracefs_instance_file_clear(NULL, KPROBE_EVENTS) == 0)
+			return 0;
+		if (!force)
+			return -1;
+		/* Attempt to disable all kprobe events */
+		return kprobe_clear_probes(NULL, force);
+	}
+
+	/*
+	 * Since we know we are disabling a specific event, try
+	 * to disable it first before clearing it.
+	 */
+	if (force) {
+		instance_list = tracefs_instances(NULL);
+		disable_events(kprobe->system, kprobe->event, instance_list);
+		tracefs_list_free(instance_list);
+	}
+
+	ret = dynevent_destroy(kprobe);
+
+	return ret < 0 ? -1 : 0;
+}
-- 
2.31.1

