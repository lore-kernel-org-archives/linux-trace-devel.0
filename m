Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF7AC433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Nov 2021 15:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B471B610EA
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Nov 2021 15:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbhKCPrD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Nov 2021 11:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbhKCPrD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Nov 2021 11:47:03 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA20C061714
        for <linux-trace-devel@vger.kernel.org>; Wed,  3 Nov 2021 08:44:26 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id c71-20020a1c9a4a000000b0032cdcc8cbafso2173145wme.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 03 Nov 2021 08:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ip4dlo5AYQ4QHnMXw18iYgumz2fdqoA8+XnbhNcOLUw=;
        b=dQikdMelrDU1B2XA/JCYNB9kAPsKq04wrtbApVkU5ZlvuiQjPaOpckvXYYvU61S58c
         WjcLKiZuoexOpaldnUBJbOaLt+3frWvaTg8CyhxQEjguBL+dqodhZeX2b89+2KE0asTI
         V0zeIum3S4RsNywyNeMA5OEn+5q6N9eB0xa3gnTiMIe5lMjkBAxl8Wk9plXGaELygMC6
         SF2/hvtnGkNBoymGbeunewW7UlROsZ99mGieH4pGRs7REwwVa2p+Y9K10z/TP0oIGm49
         +q9RgesLLBtIAqBkikJ55tSu4mCm8tbow3NXCvhlwyq1Z5DPWrpeL5gmiAl5TOzzbIaO
         FrAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ip4dlo5AYQ4QHnMXw18iYgumz2fdqoA8+XnbhNcOLUw=;
        b=uVY+UNxmARMoHicI2sTz0gMaQH4fowxXzDVmg/ZZpVtPCR8BVhsukhGZMsOHeN29pT
         e+N67lq5PnDYFGLB6j7cpqlZBqnAs+P8krHy5g/nYUTQenA54L9em5tS4KIV2gonGJXm
         EFJtua6K0HPnZU6quyD1xcGDMpMo8GC8vDDUlzRmE9bSEzzEZAcLnCbcFe+2v/jGs6P7
         tYcWXyAmFKNYuLnU2oEu8ZAEj4oYdi7ME5kx+hiq9je6BXCMczt+1oYcbIoJOdVpNRfX
         32u57QyDMp6ed189maSIW9zKy/cTvfvuui58cEBqID9LQqxbwF0ToX/RaB87nMMc1CJV
         DIIw==
X-Gm-Message-State: AOAM533MRockvD5Uv8Jf/r9gt7il4D/NYTOgobiS1pHPko0w+6PtynKn
        bP5oCkhutg+cpveoYXRC1YK3p5W+l2hilg==
X-Google-Smtp-Source: ABdhPJxRhQo9NQ3RKnuoBB5TWHarvYAi1RRM5gav+2gVP2MeZx1EGWK1garQHBM1Hdk8YPq9M00chQ==
X-Received: by 2002:a1c:1d42:: with SMTP id d63mr15869501wmd.184.1635954264932;
        Wed, 03 Nov 2021 08:44:24 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p12sm2767866wrr.10.2021.11.03.08.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 08:44:24 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 05/11] libtracefs: Change tracefs_kprobe_info API
Date:   Wed,  3 Nov 2021 17:44:11 +0200
Message-Id: <20211103154417.246999-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103154417.246999-1-tz.stoyanov@gmail.com>
References: <20211103154417.246999-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In order to make kprobe APIs consistent with the other libtracefs APIs,
the tracefs_kprobe_info() API is reimplemented and changed to work with
the library dynamic event structure.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs.h     |  11 +--
 src/tracefs-kprobes.c | 172 ++++++++++++++++--------------------------
 2 files changed, 66 insertions(+), 117 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 6bf45c3..8ff9d12 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -261,12 +261,6 @@ void tracefs_dynevent_list_free(struct tracefs_dynevent **events);
 struct tracefs_dynevent **
 tracefs_dynevent_get_all(unsigned long type_mask, const char *system);
 
-enum tracefs_kprobe_type {
-	TRACEFS_ALL_KPROBES,
-	TRACEFS_KPROBE,
-	TRACEFS_KRETPROBE,
-};
-
 struct tracefs_dynevent *
 tracefs_kprobe_alloc(const char *system, const char *event, const char *addr, const char *format);
 struct tracefs_dynevent *
@@ -276,8 +270,9 @@ int tracefs_kprobe_raw(const char *system, const char *event,
 		       const char *addr, const char *format);
 int tracefs_kretprobe_raw(const char *system, const char *event,
 			  const char *addr, const char *format);
-enum tracefs_kprobe_type tracefs_kprobe_info(const char *group, const char *event,
-					     char **type, char **addr, char **format);
+enum tracefs_dynevent_type tracefs_kprobe_info(struct tracefs_dynevent *kprobe,
+					       char **system, char **event,
+					       char **prefix, char **addr, char **format);
 
 enum tracefs_hist_key_type {
 	TRACEFS_HIST_KEY_NORMAL = 0,
diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index 72a4a35..eb71df3 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -210,125 +210,79 @@ int tracefs_kretprobe_raw(const char *system, const char *event,
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
- * tracefs_kprobe_info - return the type of kprobe specified.
- * @group: The group the kprobe is in (NULL for the default "kprobes")
- * @event: The name of the kprobe to find.
- * @type: String to return kprobe type (before ':') NULL to ignore.
- * @addr: String to return address kprobe is attached to. NULL to ignore.
- * @format: String to return kprobe format. NULL to ignore.
- *
- * If @type, @addr, or @format is non NULL, then the returned string
- * must be freed with free(). They will also be set to NULL, and
- * even on error, they may contain strings to be freed. If they are
- * not NULL, then they still need to be freed.
+ * tracefs_kprobe_info - return details of a kprobe
+ * @kprobe: A kprobe context, describing given kprobe.
+ * @group: return, group in which the kprobe is configured
+ * @event: return, name of the kprobe event
+ * @prefix: return, prefix string of the kprobe
+ *	    for kretprobes, the maxactive count is encoded in the prefix
+ * @addr: return, the function and offset (or address) of the kprobe
+ * @format: return, the format string of the kprobe
  *
- * Returns TRACEFS_ALL_KPROBES if an error occurs or the kprobe is not found,
- *            or the probe is of an unknown type.
- * TRACEFS_KPROBE if the type of kprobe found is a normal kprobe.
- * TRACEFS_KRETPROBE if the type of kprobe found is a kretprobe.
+ * Returns the type of the kprobe, or TRACEFS_DYNEVENT_MAX in case of an error.
+ * Any of the @group, @event, @prefix, @addr and @format parameters are optional.
+ * If a valid pointer is passed, in case of success - a string is allocated and returned.
+ * These strings must be freed with free().
  */
-enum tracefs_kprobe_type tracefs_kprobe_info(const char *group, const char *event,
-					     char **type, char **addr, char **format)
+enum tracefs_dynevent_type tracefs_kprobe_info(struct tracefs_dynevent *kprobe,
+					       char **system, char **event,
+					       char **prefix, char **addr, char **format)
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
+		return TRACEFS_DYNEVENT_MAX;
 
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
+	return kprobe->type;
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
+	return TRACEFS_DYNEVENT_MAX;
 }
-- 
2.31.1

