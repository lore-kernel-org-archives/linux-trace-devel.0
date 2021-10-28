Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A07AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 12:09:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1140460F90
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 12:09:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbhJ1MLq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Oct 2021 08:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbhJ1MLo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 08:11:44 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC61EC061745
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Oct 2021 05:09:17 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 5so23268835edw.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Oct 2021 05:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ljLr895lWmcYm6RXNoJYFeiQoE3w3w+TpM4R6A4GSTk=;
        b=UB8YwTlUx+39pN382W6Elg/6rDGVAwmAmDvCIrLcuKIfYJlnnX+LmHpoxmjDfLEf3G
         VGybdx4IQHKy5vsdRm35VBl5xfJzrxbtc7yjEVdIIoGjSBJGMmxb+fL4gp5zCWn7xCr6
         iShMqrCSWXQnuXOb6CdBMcQZNOCO+JgC5tMIYTj2Z7nC9DBO4CGxEa/LPYsXtqkxWBnv
         WxZdrhCjhOXQnLueFgxHqNSKIzddsIE91QsWImvFcxK4BGqpRRYtBC24/wx3LGfC8GKz
         a0vM6Su+kKNwaMe2f6vFwjERGSTz+PVSm14WWqwHARGxR1Qb37eVRgXfxoyuB3kJ8k6e
         xGHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ljLr895lWmcYm6RXNoJYFeiQoE3w3w+TpM4R6A4GSTk=;
        b=FZ2VzN1H+pdpyfiUz+43b/IffhzkU52nSWdJkv+PH/93uwrc6S9BZBK7gtjtz2sh8z
         k7U+seQopfLDUUmr6NJGqa/GDKNVVhEtIte2hWyMaKsUYwQiMtOYcuyHXiQ49Bl+Fmf2
         xS7g3CdxevfThmmCmPq/0Xl9wMyNM99vIbq26zT139ekhhiIswc+NAavQ3o6l5eQrx4W
         vUBzSGZvS7Laso+/HdC8BnDEDpyEWYm4E41OFjRbIoHKilWgbe3/3i/d52tSko+Fjy5P
         0ccFRVPMGlztdVoS+rTrOS0amSBCYOVhd1ZJXJq/24ZSF3CEYz8TpmpxOLn9TZxoWLxG
         kCPg==
X-Gm-Message-State: AOAM530TzPILFDj5lC40ieVOqaEA48ufHDNnuXGpFIcxPd/8UjR55KC+
        WyYcqQgEaRvDAfq9BoM2mBbKsTTkncP39g==
X-Google-Smtp-Source: ABdhPJyKdJvMZ5oOivxKVLNxnxcyksa3UJAfrXcDn84fu7Cf2SSaPpExRqW8IKRmQ4Z3j9q2ivi7jw==
X-Received: by 2002:a50:e006:: with SMTP id e6mr5715885edl.344.1635422956146;
        Thu, 28 Oct 2021 05:09:16 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v6sm1803003edc.52.2021.10.28.05.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 05:09:15 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 06/12] libtracefs: Change tracefs_kprobe_info API
Date:   Thu, 28 Oct 2021 15:09:01 +0300
Message-Id: <20211028120907.101847-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211028120907.101847-1-tz.stoyanov@gmail.com>
References: <20211028120907.101847-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In order to make kprobe APIs consistent with the other libtracefs APIs,
the tracefs_kprobe_info() API is reimplemented and changed to work with
the library kprobe context structure.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs.h     |   5 +-
 src/tracefs-kprobes.c | 175 ++++++++++++++++--------------------------
 2 files changed, 69 insertions(+), 111 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index d4ac8fb..c65f21f 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -260,8 +260,9 @@ int tracefs_kprobe_raw(const char *system, const char *event,
 int tracefs_kretprobe_raw(const char *system, const char *event,
 			  const char *addr, const char *format);
 int tracefs_kprobes_get(enum tracefs_kprobe_type type, struct tracefs_dynevent ***kprobes);
-enum tracefs_kprobe_type tracefs_kprobe_info(const char *group, const char *event,
-					     char **type, char **addr, char **format);
+enum tracefs_kprobe_type tracefs_kprobe_info(struct tracefs_dynevent *kprobe,
+					     char **system, char **event,
+					     char **prefix, char **addr, char **format);
 
 enum tracefs_hist_key_type {
 	TRACEFS_HIST_KEY_NORMAL = 0,
diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index 2e24051..083a3a9 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -234,58 +234,6 @@ int tracefs_kretprobe_raw(const char *system, const char *event,
 	return insert_kprobe("r", system, event, addr, format);
 }
 
-/*
- * Helper function to parse kprobes.
- * @content: The content of kprobe_events on the first iteration.
- *           NULL on next iterations.
- * @saveptr: Same as saveptr for strtok_r
- * @type: Where to store the type (before ':')
- * @system: Store the system of the kprobe (NULL to have event contain
- *          both system and event, as in "kprobes/myprobe").
- * @event: Where to store the event.
- * @addr: Where to store the addr (may be NULL to ignore)
- * @format: Where to store the format (may be NULL to ignore)
- */
-static int parse_kprobe(char *content, char **saveptr,
-			char **type, char **system, char **event,
-			char **addr, char **format)
-{
-	char *p;
-
-	p = strtok_r(content, ":", saveptr);
-	if (!p)
-		return 1; /* eof */
-	*type = p;
-
-	if (system) {
-		p = strtok_r(NULL, "/", saveptr);
-		if (!p)
-			return -1;
-		*system = p;
-	}
-
-	p = strtok_r(NULL, " ", saveptr);
-	if (!p)
-		return -1;
-	*event = p;
-
-	if (addr || format) {
-		p = strtok_r(NULL, " ", saveptr);
-		if (!p)
-			return -1;
-		if (addr)
-			*addr = p;
-	}
-
-	p = strtok_r(NULL, "\n", saveptr);
-	if (!p)
-		return -1;
-	if (format)
-		*format = p;
-
-	return 0;
-}
-
 /**
  * tracefs_kprobes_get - return an array of pointers to kprobes
  * @type: The type of kprobes to return.
@@ -316,74 +264,83 @@ int tracefs_kprobes_get(enum tracefs_kprobe_type type, struct tracefs_dynevent *
 }
 
 /**
- * tracefs_kprobe_info - return the type of kprobe specified.
- * @group: The group the kprobe is in (NULL for the default "kprobes")
- * @event: The name of the kprobe to find.
- * @type: String to return kprobe type (before ':') NULL to ignore.
- * @addr: String to return address kprobe is attached to. NULL to ignore.
- * @format: String to return kprobe format. NULL to ignore.
+ * tracefs_kprobe_info - return details of a kprobe
+ * @kprobe: A kprobe context, describing given kprobe.
+ * @group: return, group in which the kprobe is configured
+ * @event: return, name of the kprobe event
+ * @prefix: return, prefix string of the kprobe
+ *	    for kretprobes, the maxactive count is encoded in the prefix
+ * @addr: return, the function and offset (or address) of the kprobe
+ * @format: return, the format string of the kprobe
  *
- * If @type, @addr, or @format is non NULL, then the returned string
- * must be freed with free(). They will also be set to NULL, and
- * even on error, they may contain strings to be freed. If they are
- * not NULL, then they still need to be freed.
- *
- * Returns TRACEFS_ALL_KPROBES if an error occurs or the kprobe is not found,
- *            or the probe is of an unknown type.
- * TRACEFS_KPROBE if the type of kprobe found is a normal kprobe.
- * TRACEFS_KRETPROBE if the type of kprobe found is a kretprobe.
+ * Returns the type of the kprobe, or TRACEFS_ALL_KPROBES in case of an error.
+ * Any of the @group, @event, @prefix, @addr and @format parameters are optional.
+ * If a valid pointer is passed, in case of success - a string is allocated and returned.
+ * These strings must be freed with free().
  */
-enum tracefs_kprobe_type tracefs_kprobe_info(const char *group, const char *event,
-					     char **type, char **addr, char **format)
+enum tracefs_kprobe_type tracefs_kprobe_info(struct tracefs_dynevent *kprobe,
+					     char **system, char **event,
+					     char **prefix, char **addr, char **format)
 {
-	enum tracefs_kprobe_type rtype = TRACEFS_ALL_KPROBES;
-	char *saveptr;
-	char *content;
-	char *system;
-	char *probe;
-	char *ktype;
-	char *kaddr;
-	char *kfmt;
-	int ret;
-
-	if (!group)
-		group = KPROBE_DEFAULT_GROUP;
-
-	if (type)
-		*type = NULL;
+	if (system)
+		*system = NULL;
+	if (event)
+		*event = NULL;
+	if (prefix)
+		*prefix = NULL;
 	if (addr)
 		*addr = NULL;
 	if (format)
 		*format = NULL;
 
-	content = tracefs_instance_file_read(NULL, KPROBE_EVENTS, NULL);
-	if (!content)
-		return rtype;
-
-	ret = parse_kprobe(content, &saveptr, &ktype, &system, &probe,
-			   &kaddr, &kfmt);
-
-	while (!ret) {
-
-		if (!strcmp(system, group) && !strcmp(probe, event)) {
-			if (type)
-				*type = strdup(ktype);
-			if (addr)
-				*addr = strdup(kaddr);
-			if (format)
-				*format = strdup(kfmt);
+	if (!kprobe)
+		return TRACEFS_ALL_KPROBES;
 
-			switch (*ktype) {
-			case 'p': rtype = TRACEFS_KPROBE; break;
-			case 'r': rtype = TRACEFS_KRETPROBE; break;
-			}
-			break;
+	if (system) {
+		if (kprobe->system) {
+			*system = strdup(kprobe->system);
+			if (!(*system))
+				goto error;
 		}
-		ret = parse_kprobe(NULL, &saveptr, &ktype, &system, &probe,
-				   &kaddr, &kfmt);
 	}
-	free(content);
-	return rtype;
+	if (event) {
+		*event = strdup(kprobe->event);
+		if (!(*event))
+			goto error;
+	}
+	if (prefix) {
+		*prefix = strdup(kprobe->prefix);
+		if (!(*prefix))
+			goto error;
+	}
+	if (addr && kprobe->address) {
+		*addr = strdup(kprobe->address);
+		if (!(*addr))
+			goto error;
+	}
+	if (format && kprobe->format) {
+		*format = strdup(kprobe->format);
+		if (!(*format))
+			goto error;
+	}
+
+	if (kprobe->type == TRACE_DYNEVENT_KPROBE)
+		return TRACEFS_KPROBE;
+	if (kprobe->type == TRACE_DYNEVENT_KRETPROBE)
+		return TRACEFS_KRETPROBE;
+
+error:
+	if (system)
+		free(*system);
+	if (event)
+		free(*event);
+	if (prefix)
+		free(*prefix);
+	if (addr)
+		free(*addr);
+	if (format)
+		free(*format);
+	return TRACEFS_ALL_KPROBES;
 }
 
 static void disable_events(const char *system, const char *event,
-- 
2.31.1

