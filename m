Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD190C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Nov 2021 09:09:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93EFE610A2
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Nov 2021 09:09:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhKAJLo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Nov 2021 05:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbhKAJLo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Nov 2021 05:11:44 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDDFC061764
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Nov 2021 02:09:11 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id f8so40513132edy.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Nov 2021 02:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EurvI2Ss2jj+0FFeY+TsOaNc1bjeg/+ms9WvczUT5Gs=;
        b=UT/N1bk3piEZa/F6hJdH2jhMrveS97ab9yzw6zbyDzz/oIkI4yq5QckZuw9snnc/eg
         BOKbN1dhm+s9IN2cUWtBucDbG6aB+wShT7YagebMbs0k3x6Khn8xRh1qvdbLb4waiPMG
         hGJrVOMgq/2gWDKKc/eX8kqOrb3IhngSCSKuBTFZA5Rxa2fjTxKYQNtEW0Rs+BcGsxUc
         vg/Be9Piz4Ol5SsmDjj7AoNz00Vx30AreyJ0PlZuodIbtVrQ8dlk6Kj3Xp6SnNj+R/VA
         iTC0Nx1BB5424HAQmgqo/sKCTYFDzF63wK1u17Poq2CYsldCcDguBFo3iK3YstV/X2Vh
         B6ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EurvI2Ss2jj+0FFeY+TsOaNc1bjeg/+ms9WvczUT5Gs=;
        b=oNGPicczD7TdipwtsJZmNsXgOSut/hlBsNC/xUBXZvIBGT1fHIxdKzbX/A0PP2yNXS
         x33ek0SGz00TMDH8r05xS6/j0CHh7qVjwdU/zXlqLF7WHRg/7WH+IVFcY/a9Sg4NtdnL
         jsFX/h2/J11Dq+H+BbDJIM7/+Vm76t6Q8NtlL72nQo7T4r3GpNw+I1WoAClUMJbdLDMs
         Z0mWjfyEWRlQDkAO+TVGOZZUxvf29hwyP5E44ytQuhuRNju7alm4YgjzQB+1r96xIjq+
         nun0T67KZxrg0NWfH4YOfdhWqBsOKT27S3ghc4FK+wSOONiVrfzJWvdnxZBuZzuirZbt
         xZYg==
X-Gm-Message-State: AOAM531DqauyIYI7HSAN781zyxPrjU5SDSbGImDik07mdioXNddIcD+f
        uEmIDxzLQjw89Ig9hufSQCc=
X-Google-Smtp-Source: ABdhPJzEdpnpfEvG6DAZVfA51pi9jWQky4COKLFVR/d07budCnXBFwNw0A65aJD+K0+d7/drLBjNFQ==
X-Received: by 2002:a05:6402:50ca:: with SMTP id h10mr8011194edb.277.1635757749988;
        Mon, 01 Nov 2021 02:09:09 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i8sm9873222edc.10.2021.11.01.02.09.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 02:09:09 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 03/12] libtracefs: New kprobes APIs
Date:   Mon,  1 Nov 2021 11:08:55 +0200
Message-Id: <20211101090904.81454-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211101090904.81454-1-tz.stoyanov@gmail.com>
References: <20211101090904.81454-1-tz.stoyanov@gmail.com>
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
 src/tracefs-kprobes.c | 168 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 176 insertions(+)

diff --git a/include/tracefs.h b/include/tracefs.h
index 4e721eb..85185ce 100644
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
index d4c5f9e..906f914 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -20,6 +20,134 @@
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
+ * errno will be set to EBADMSG if addr is NULL.
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
+ * errno will be set to EBADMSG if addr is NULL.
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
@@ -474,3 +602,43 @@ int tracefs_kprobe_clear_probe(const char *system, const char *event, bool force
 
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

