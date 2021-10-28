Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 759D8C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 12:09:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E9D1610CA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 12:09:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhJ1MLq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Oct 2021 08:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbhJ1MLo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 08:11:44 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C259C061570
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Oct 2021 05:09:17 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id g10so23644703edj.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Oct 2021 05:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fRAAQ15U8EMiL+7gPZYm4PDX3yI+I2zZVefNxYlW4K8=;
        b=iE4vjsQS0SKQjs+9jC8JtUUyfyjlKPmR+6ym2zXhP5pCUf/nVy0/soNXX4qEHBITOD
         CVT9KUBUlT8n7/Y9V9aETeSqZyY3kIQSS3k7f77qSQBVPatpn6MhRDe54sftpx1YLnbV
         u7jB5onuMP+MvuMMLyNIV1cNzywG1DIKJPAUyaY7GSl8kcz/O9WrJBAkofA6j8Murb6c
         xm4oHgZkGXPWsFXj8HZ8ysNL3emSAvEMkYVRDAHrduC9adMSRqBDFRHY7nyFDDrLppC2
         HcdhWIDnZ29nVyEy4EjrdTZPg0Nnw6oj95uWEmyfKc2QZtYu4BRzlPL7fEqBpcnuHFDJ
         imaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fRAAQ15U8EMiL+7gPZYm4PDX3yI+I2zZVefNxYlW4K8=;
        b=iElZdBSigemu90BYsv/Cn2cxDFoXrrrUCUffqjL/WnlLowbXYSkWnln6GRWJiqxvM9
         BKeU98WlLecYuyXUyhCA8SzwHFyRC3/tP7d/OgFtkxI0JboWZVfhtGSB73Jkb+hS7VBT
         jI3HFcs1q9Geo3ZCGbk8eegjQ6edCJoeDDbqdvpcbZvNe9mOdv5TjqVfFATqBCL0cG6H
         WmPbkEGMs+nB0ljQ8LKt4ccRV6CAMxtV/SddKw9NI6tX9pmQWoHVw/OeWDdUYfttV2dg
         zgC2RWQKpuK8Ge9ZanU6/1v1oorMqi8LE/s9oqK/6jvwjDnxZUJL0CtVzJpSA/uIbiCa
         VtQA==
X-Gm-Message-State: AOAM532lUp6mOce2ffjb40AQ2NKwDcTSvmPpcVehrzCIIjKudUgfrlYr
        CmSbXPr5yjQDPQ7he5Ke1wmFYEX3JwC19Q==
X-Google-Smtp-Source: ABdhPJzOMd/U5/2e/O+4DWOWdvKniwiGY3bO7B5xM9N8dS+sUApS+oSKCDtk6dSmVCojpsxpkrfSBQ==
X-Received: by 2002:a50:d8ce:: with SMTP id y14mr5692831edj.92.1635422955130;
        Thu, 28 Oct 2021 05:09:15 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v6sm1803003edc.52.2021.10.28.05.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 05:09:14 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 05/12] libtracefs: Reimplement tracefs_kprobes_get API
Date:   Thu, 28 Oct 2021 15:09:00 +0300
Message-Id: <20211028120907.101847-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211028120907.101847-1-tz.stoyanov@gmail.com>
References: <20211028120907.101847-1-tz.stoyanov@gmail.com>
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
 src/tracefs-kprobes.c | 127 +++++++++++-------------------------------
 2 files changed, 33 insertions(+), 96 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index c7b9179..d4ac8fb 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -259,7 +259,7 @@ int tracefs_kprobe_raw(const char *system, const char *event,
 		       const char *addr, const char *format);
 int tracefs_kretprobe_raw(const char *system, const char *event,
 			  const char *addr, const char *format);
-char **tracefs_kprobes_get(enum tracefs_kprobe_type type);
+int tracefs_kprobes_get(enum tracefs_kprobe_type type, struct tracefs_dynevent ***kprobes);
 enum tracefs_kprobe_type tracefs_kprobe_info(const char *group, const char *event,
 					     char **type, char **addr, char **format);
 
diff --git a/src/tracefs-kprobes.c b/src/tracefs-kprobes.c
index 1e08b75..2e24051 100644
--- a/src/tracefs-kprobes.c
+++ b/src/tracefs-kprobes.c
@@ -287,77 +287,32 @@ static int parse_kprobe(char *content, char **saveptr,
 }
 
 /**
- * tracefs_kprobes_get - return a list kprobes (by group/event name)
+ * tracefs_kprobes_get - return an array of pointers to kprobes
  * @type: The type of kprobes to return.
+ * @kprobes: return, array of pointers to kprobes
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
+ * In case of an error, -1 is returned and @kprobes is not modified.
+ * In case of success, the count of requested kprobes is returned. An array of
+ * pointers to kprobes is allocated and returned in @kprobes. The size of this array
+ * is the returned count + 1, as the last element is a NULL pointer. The array must be
+ * freed with tracefs_dynevent_list_free().
+ * The @kprobes parameter is optional. If NULL is passed, only the count of the kprobes is returned.
  */
-char **tracefs_kprobes_get(enum tracefs_kprobe_type type)
+int tracefs_kprobes_get(enum tracefs_kprobe_type type, struct tracefs_dynevent ***kprobes)
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
+	unsigned long mask = 0;
 
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
-
-		tmp = tracefs_list_add(list, event);
-		if (!tmp)
-			goto fail;
-		list = tmp;
- next:
-		ret = parse_kprobe(NULL, &saveptr, &ktype, NULL, &event, NULL, NULL);
-	}
+	if (type == TRACEFS_KPROBE || type == TRACEFS_ALL_KPROBES)
+		DYNEVENT_ADD_BIT(mask, TRACE_DYNEVENT_KPROBE);
+	if (type == TRACEFS_KRETPROBE || type == TRACEFS_ALL_KPROBES)
+		DYNEVENT_ADD_BIT(mask, TRACE_DYNEVENT_KRETPROBE);
 
-	if (!list)
-		list = trace_list_create_empty();
- out:
-	free(content);
-	return list;
- fail:
-	tracefs_list_free(list);
-	list = NULL;
-	goto out;
+	return dynevent_get_all(mask, NULL, kprobes);
 }
 
 /**
@@ -465,30 +420,17 @@ static void disable_events(const char *system, const char *event,
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
-		return -1;
+	ret = tracefs_kprobes_get(TRACEFS_ALL_KPROBES, &kprobes);
+	/* No krpobes or error getting them */
+	if (ret <= 0)
+		return ret;
 
 	instance_list = tracefs_instances(NULL);
 	/*
@@ -504,26 +446,21 @@ static int kprobe_clear_probes(const char *group, bool force)
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
@@ -538,7 +475,7 @@ static int kprobe_clear_probes(const char *group, bool force)
 	}
  out:
 	tracefs_list_free(instance_list);
-	tracefs_list_free(kprobe_list);
+	tracefs_dynevent_list_free(&kprobes);
 	return ret;
 }
 
-- 
2.31.1

