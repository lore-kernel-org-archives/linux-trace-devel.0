Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AE36C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 11:10:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E653D6120D
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 11:10:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbhKDLNe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Nov 2021 07:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbhKDLNd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Nov 2021 07:13:33 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C102C061714
        for <linux-trace-devel@vger.kernel.org>; Thu,  4 Nov 2021 04:10:55 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id d5so8017733wrc.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 04 Nov 2021 04:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fu5V6a0d2lDfrGpQ1H2u4m65RZAhJD/RXqpbNZyDkVc=;
        b=BwJd/FEA2r/OSVCdowsNj4/7NARaeixCAV22InR9Jq27vKPzwHjDEnTxTHQaczhKYs
         RorRy+S+5xD+LqOGoEf2tv2C6wQJaflcRyk4dVl1/T5Q5Kesboxm5KxngkZhLpST/GvA
         ICM6oobOIWl50/pZNyISrrl5u8Cy+MD66SdzB8/A4EwogCGYIqq+5fCvXTwvLnZiyTZb
         scybEXd12kqO0USoOCY0cx/1IEaNvu4WwZFVdrZuL4nE1eEfO3hunlFaUDmnRPLmBSSn
         vFLLPMCW5TubNc4t9Zcp5drxQMlsFEXrgczxVkxGLVPXsbZ0z6MaKSOUGoZX4NAuEkm6
         zHUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fu5V6a0d2lDfrGpQ1H2u4m65RZAhJD/RXqpbNZyDkVc=;
        b=QAjcdkvJ1Lr6EiPeohGOISbtxiUzqZNWTb3f2Hkqn+Byikh3Dls7vNrG/WDBBSYlYh
         hcih4kd3625o5QcS9uv20s+YjyGgXI+Ou1QFz55y05OWdn1G1sdb5lZtdnxxsRKUAPvB
         77nBLY+d1qTgWC2HP40coHUW4ZUl/Qn5I4avYgeldE516JKveboNcp39SRslvawA1qJm
         YDbNUI1MP9cnquAIhP0587pesg9K89GfTkmVdWp8sOEHUluaFknSsW47K6i6AulMvXIL
         jEneZyjFxpfTGhlMsjuWov+KZd6G/YKk59P7oAnEaIpnpOJVdAPdJZPGf950r0eGI9hA
         VLmg==
X-Gm-Message-State: AOAM532UgwRftcjrbHU+Mr16vKOAIwtDz5+OuHXy+91zyMx+7dFf4rj0
        ozzRKVCCTdispMmUqaT1e8c4q4HhMn7Ppw==
X-Google-Smtp-Source: ABdhPJwB2RSsNRWy8DE2XuEpX5TkesdVHleoruFGw8mwOrYD+8KATXXgF8CApSQM2uHi+fGnioDrJw==
X-Received: by 2002:a5d:64ea:: with SMTP id g10mr3508181wri.137.1636024254252;
        Thu, 04 Nov 2021 04:10:54 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l18sm5080843wrt.81.2021.11.04.04.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 04:10:53 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 04/10] libtracefs: Change tracefs_kprobe_info API
Date:   Thu,  4 Nov 2021 13:10:41 +0200
Message-Id: <20211104111047.302660-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211104111047.302660-1-tz.stoyanov@gmail.com>
References: <20211104111047.302660-1-tz.stoyanov@gmail.com>
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
 src/tracefs-kprobes.c | 159 ++++++++++++------------------------------
 2 files changed, 48 insertions(+), 122 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 7d9a9af..8377ade 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -257,12 +257,6 @@ void tracefs_dynevent_list_free(struct tracefs_dynevent **events);
 struct tracefs_dynevent **
 tracefs_dynevent_get_all(enum tracefs_dynevent_type types, const char *system);
 
-enum tracefs_kprobe_type {
-	TRACEFS_ALL_KPROBES,
-	TRACEFS_KPROBE,
-	TRACEFS_KRETPROBE,
-};
-
 struct tracefs_dynevent *
 tracefs_kprobe_alloc(const char *system, const char *event, const char *addr, const char *format);
 struct tracefs_dynevent *
@@ -272,8 +266,9 @@ int tracefs_kprobe_raw(const char *system, const char *event,
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
index f67a93a..a391637 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -214,125 +214,56 @@ int tracefs_kretprobe_raw(const char *system, const char *event,
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
-{
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
-	if (addr)
-		*addr = NULL;
-	if (format)
-		*format = NULL;
-
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
 
-			switch (*ktype) {
-			case 'p': rtype = TRACEFS_KPROBE; break;
-			case 'r': rtype = TRACEFS_KRETPROBE; break;
+enum tracefs_dynevent_type tracefs_kprobe_info(struct tracefs_dynevent *kprobe,
+					       char **system, char **event,
+					       char **prefix, char **addr, char **format)
+{
+	char **lv[] = { system, event, prefix, addr, format };
+	char **rv[] = { &kprobe->system, &kprobe->event, &kprobe->prefix,
+			&kprobe->address, &kprobe->format };
+	int i;
+
+	if (!kprobe)
+		return TRACEFS_DYNEVENT_MAX;
+
+	for (i = 0; i < ARRAY_SIZE(lv); i++)
+		*lv[i] = NULL;
+
+	for (i = 0; i < ARRAY_SIZE(lv); i++) {
+		if (lv[i]) {
+			if (*rv[i]) {
+				*lv[i] = strdup(*rv[i]);
+				if (!*lv[i])
+					goto error;
+			} else {
+				*lv[i] = NULL;
 			}
-			break;
 		}
-		ret = parse_kprobe(NULL, &saveptr, &ktype, &system, &probe,
-				   &kaddr, &kfmt);
 	}
-	free(content);
-	return rtype;
+
+	return kprobe->type;
+
+error:
+	for (i--; i >= 0; i--) {
+		if (lv[i])
+			free(*lv[i]);
+	}
+
+	return TRACEFS_DYNEVENT_MAX;
 }
-- 
2.31.1

