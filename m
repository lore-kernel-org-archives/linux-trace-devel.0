Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 463AEC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Nov 2021 09:09:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27ABF610CC
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Nov 2021 09:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbhKAJLs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Nov 2021 05:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231695AbhKAJLq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Nov 2021 05:11:46 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CCBAC061746
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Nov 2021 02:09:13 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id g10so61835860edj.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Nov 2021 02:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TPIYuMY68qMbfOdn/HdVPq5zPT9wl+zo/FObx8lw/WY=;
        b=KfaJoFHM+i+st1zPrhcN+eBm+YdUZWBt61+WkxjVAd+KhTknxBdhBkNRojMHdZYD7l
         NwMZbUSUW+6LXUbpFw53yx/PidDVaiUyzP7OQ+VE5vH4/y8gpj56jHGhYsCR+DGZZCAl
         tYoQVM3hWWyt3RvcKJlmllLV0bztz4/znnS/aCfNCAmDARNA/iEFcGRLxTsAQ7iZfxjx
         1BX3Hi4Ia/Q4XiEmIABICr9cmSO5FeQIMmg5dUm+q6os5hgdG9vu+ZJqv/5WQzooeV8S
         EVb3YqZbbrzK3R8ebhc/dlS0XgtLAzYyL4RefrOjsz5rdgA27Ot44t/EWPblZb56saKQ
         BH3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TPIYuMY68qMbfOdn/HdVPq5zPT9wl+zo/FObx8lw/WY=;
        b=gCt1RXG18QCkAbvp6QU3SidX+JKPvcXaPXOt75t4ZpfBIB0GUQT8AeDPxTNLuc+Iip
         QOlmS0snsDrGleiI9+ckOlRMDubJHWtUuJ5iKOTZ0ISOkaBSHmwDIwhUu+NmGc2rL2QQ
         AEiNd/8k6KuamjeeHovYiVJ9a/bw7PgOJoKu8hygUUm+5yRxFMFLnyXVXqlnmguFa/Fa
         zfhuGfAqw4CJNtRzZGlD04qwdk8lfv/9r1x3owP3oDycl3wp0TI35w1zvNIxwGYkutZK
         jYSd1gHlqn7DDLrR2g3MkRLLnPFyVz4GpfRX8Fvkge8GMu4701jMmVa24iAKmDNVY9aU
         56RA==
X-Gm-Message-State: AOAM533ep2p/FkHhkZMR40csdMONVIrHDuCYSd15cWkL7PeO4f3kT3r6
        lqQ37Agr8arTxTLklFbIJMc=
X-Google-Smtp-Source: ABdhPJx7Sn2bXvv8R8upDiFXDdSjZqQ1MS4YYiGm25HwQC9imDOOOzqvYjizSUVvrOKNyDBBfMs9pg==
X-Received: by 2002:a17:906:2887:: with SMTP id o7mr34155860ejd.425.1635757751982;
        Mon, 01 Nov 2021 02:09:11 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i8sm9873222edc.10.2021.11.01.02.09.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 02:09:11 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 05/12] libtracefs: Reimplement tracefs_kprobes_get API
Date:   Mon,  1 Nov 2021 11:08:57 +0200
Message-Id: <20211101090904.81454-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211101090904.81454-1-tz.stoyanov@gmail.com>
References: <20211101090904.81454-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In order to unify the code and reuse the internal helpers for dynamic
events helpers, the tracefs_kprobes_get() API is reimplemented using
the new dynamic events APIs.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs.h     |   2 +-
 src/tracefs-kprobes.c | 121 ++++++++++--------------------------------
 2 files changed, 28 insertions(+), 95 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index d72582b..27da808 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -259,7 +259,7 @@ int tracefs_kprobe_raw(const char *system, const char *event,
 		       const char *addr, const char *format);
 int tracefs_kretprobe_raw(const char *system, const char *event,
 			  const char *addr, const char *format);
-char **tracefs_kprobes_get(enum tracefs_kprobe_type type);
+struct tracefs_dynevent **tracefs_kprobes_get(enum tracefs_kprobe_type type);
 enum tracefs_kprobe_type tracefs_kprobe_info(const char *group, const char *event,
 					     char **type, char **addr, char **format);
 
diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index 0596f34..be49e7d 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -286,77 +286,28 @@ static int parse_kprobe(char *content, char **saveptr,
 }
 
 /**
- * tracefs_kprobes_get - return a list kprobes (by group/event name)
+ * tracefs_kprobes_get - return an array of pointers to kprobes
  * @type: The type of kprobes to return.
  *
- * If @type is TRACEFS_ALL_KPROBES all kprobes in the kprobe_events
- * are returned. Otherwise if it is TRACEFS_KPROBE, then only
+ * If @type is TRACEFS_ALL_KPROBES all kprobes in the system are returned.
+ * Otherwise if it is TRACEFS_KPROBE, then only
  * normal kprobes (p:) are returned, or if type is TRACEFS_KRETPROBE
  * then only kretprobes (r:) are returned.
  *
- * Returns a list of strings that contain the kprobes that exist
- * in the kprobe_events files. The strings returned are in the
- * "group/event" format.
- * The list must be freed with tracefs_list_free().
- * If there are no kprobes, a list is still returned, but it contains
- * only a NULL pointer.
- * On error, NULL is returned.
+ * In case of an error, NULL is returned.
+ * In case of success, an array of pointers to kprobes is allocated and returned.
+ * The last element is a NULL pointer. The array must be freed with tracefs_dynevent_list_free().
  */
-char **tracefs_kprobes_get(enum tracefs_kprobe_type type)
+struct tracefs_dynevent **tracefs_kprobes_get(enum tracefs_kprobe_type type)
 {
-	char **list = NULL;
-	char *content;
-	char *saveptr;
-	char *event;
-	char *ktype;
-	int ret;
-
-	errno = 0;
-	content = tracefs_instance_file_read(NULL, KPROBE_EVENTS, NULL);
-	if (!content) {
-		if (errno)
-			return NULL;
-		/* content is NULL on empty file, return an empty list */
-		return trace_list_create_empty();
-	}
-
-	ret = parse_kprobe(content, &saveptr, &ktype, NULL, &event, NULL, NULL);
-
-	while (!ret) {
-		char **tmp;
-
-		if (type != TRACEFS_ALL_KPROBES) {
-			switch (*ktype) {
-			case 'p':
-				if (type != TRACEFS_KPROBE)
-					goto next;
-				break;
-			case 'r':
-				if (type != TRACEFS_KRETPROBE)
-					goto next;
-				break;
-			default:
-				goto next;
-			}
-		}
+	unsigned long mask = 0;
 
-		tmp = tracefs_list_add(list, event);
-		if (!tmp)
-			goto fail;
-		list = tmp;
- next:
-		ret = parse_kprobe(NULL, &saveptr, &ktype, NULL, &event, NULL, NULL);
-	}
+	if (type == TRACEFS_KPROBE || type == TRACEFS_ALL_KPROBES)
+		SET_BIT(mask, TRACE_DYNEVENT_KPROBE);
+	if (type == TRACEFS_KRETPROBE || type == TRACEFS_ALL_KPROBES)
+		SET_BIT(mask, TRACE_DYNEVENT_KRETPROBE);
 
-	if (!list)
-		list = trace_list_create_empty();
- out:
-	free(content);
-	return list;
- fail:
-	tracefs_list_free(list);
-	list = NULL;
-	goto out;
+	return dynevent_get_all(mask, NULL);
 }
 
 /**
@@ -464,29 +415,16 @@ static void disable_events(const char *system, const char *event,
 	return;
 }
 
-static int clear_kprobe(const char *system, const char *event)
-{
-	/* '-' + ':' + '/' + '\n' + '\0' = 5 bytes */
-	int len = strlen(system) + strlen(event) + 5;
-	char content[len];
-
-	sprintf(content, "-:%s/%s", system, event);
-	return tracefs_instance_file_append(NULL, KPROBE_EVENTS, content);
-}
-
 static int kprobe_clear_probes(const char *group, bool force)
 {
+	struct tracefs_dynevent **kprobes;
 	char **instance_list;
-	char **kprobe_list;
-	char *saveptr;
-	char *system;
-	char *kprobe;
-	char *event;
 	int ret;
 	int i;
 
-	kprobe_list = tracefs_kprobes_get(TRACEFS_ALL_KPROBES);
-	if (!kprobe_list)
+	kprobes = tracefs_kprobes_get(TRACEFS_ALL_KPROBES);
+	/* No krpobes or error getting them */
+	if (!kprobes)
 		return -1;
 
 	instance_list = tracefs_instances(NULL);
@@ -503,26 +441,21 @@ static int kprobe_clear_probes(const char *group, bool force)
 	 */
 	ret = group ? 0 : -1;
 
-	for (i = 0; kprobe_list[i]; i++) {
-		kprobe = kprobe_list[i];
-
-		system = strtok_r(kprobe, "/", &saveptr);
-		if (!system)
-			goto out;
-
-		event = strtok_r(NULL," ", &saveptr);
-		if (!event)
-			goto out;
+	for (i = 0; kprobes[i]; i++) {
 
 		/* Skip if this does not match a given system */
-		if (group && strcmp(system, group) != 0)
-			continue;
+		if (group) {
+			if (!kprobes[i]->system)
+				continue;
+			if (strcmp(kprobes[i]->system, group) != 0)
+				continue;
+		}
 
 		if (force)
-			disable_events(system, event, instance_list);
+			disable_events(kprobes[i]->system, kprobes[i]->event, instance_list);
 
 		if (group) {
-			ret = clear_kprobe(system, event);
+			ret = dynevent_destroy(kprobes[i]);
 			if (ret < 0)
 				goto out;
 		} else {
@@ -537,7 +470,7 @@ static int kprobe_clear_probes(const char *group, bool force)
 	}
  out:
 	tracefs_list_free(instance_list);
-	tracefs_list_free(kprobe_list);
+	tracefs_dynevent_list_free(kprobes);
 	return ret;
 }
 
-- 
2.31.1

