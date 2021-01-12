Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12453C433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Jan 2021 09:21:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C845C22E03
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Jan 2021 09:21:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390592AbhALJVM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Jan 2021 04:21:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390589AbhALJVL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Jan 2021 04:21:11 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6A2C061795
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Jan 2021 01:20:30 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id t16so2428852ejf.13
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Jan 2021 01:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CGhx8KRs4ZRB0rmZ70t4SlriLR8QQVI5iZDuvM+X5GI=;
        b=WXAsV/b3ylObNgtN1sOWzzbLXaZt2g3OpVBk82MaCthDadDs7ayhTWM1fkAG05Sly4
         Cl556gc19HWhVQ5UbsMsMTyk6Ehbv8gcL5rw2gujYtBtDwR9RZuWr2CR8hN4NUvowtED
         P7t9dgVsnIDCIQaI4QWMKHtRBqRrlZ51H6bIuiioU4bYQyzJY3RcqmXvdWWb7tK0YGh9
         G2VDlZnt5doCRANxyh1OwEnlzIFsc7YgWyVF301XSbaRp7T/B4J4OQiR/4nBKHQzKkTW
         JBlfPELlHApBSYXnM86epJ7Ksn7xQcxHhA/JJRhXwN770nKtGQWDyXmpSbnozuJZVVKu
         +CTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CGhx8KRs4ZRB0rmZ70t4SlriLR8QQVI5iZDuvM+X5GI=;
        b=FDMg/rm5XD2QTmMjDyHrG3Bd8rOj09y9jr9KGjPk7gD3Mx2aDuLTkfo9Exw48X+aFJ
         uM9Wq5J8V2AQAs891d5mI2DIo+5+tDDT2kruRM46+Iz2V/pAt4bbHB7Q4lrS9Y2aAg/d
         sZtCZNKeP1YrcqkeBCoFbzjiHQC3KCvxzb9myl+qwOKACEvMkO6y8BAft/0L6UMqGv/7
         eEVlBZRv1zX2nzC7ZLtV0OHIxJVX8dOcBx/Cxicn56vpOH7DSBidYJhoBthAW4nsG5kq
         d3kvTDN35isklBWFEfDVMUXQjh6KJ1ch+H1xo1+f5E+SuQjz/ITDbIUugHP/xZ3k9lnn
         m5xg==
X-Gm-Message-State: AOAM531LOcWactTRx+aOx8SnJm1WS5ItlrBuFdqj48FYVMKJoy5NiaGi
        KCs+LwwexX4x6lpWbBFibr8=
X-Google-Smtp-Source: ABdhPJyixxOdZbFWfTlo7qeiYpt0WnhhCBbuvOWfksS3eS6SJrjhh7onwUgyfQWx9q5BEigp1OdAmw==
X-Received: by 2002:a17:906:cc9c:: with SMTP id oq28mr2540867ejb.224.1610443229364;
        Tue, 12 Jan 2021 01:20:29 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id rl7sm929187ejb.107.2021.01.12.01.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 01:20:28 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/7] libtracefs: New APIs for opening and reading ftrace files
Date:   Tue, 12 Jan 2021 11:20:19 +0200
Message-Id: <20210112092024.605705-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210112092024.605705-1-tz.stoyanov@gmail.com>
References: <20210112092024.605705-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

These new APIs can be used to read long long integer from frtace file
and to open ftrace file:
  tracefs_instance_file_read_number();
  tracefs_instance_file_open();

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs.h      |  4 +++
 src/tracefs-instance.c | 60 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 06e2130..bec8369 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -30,6 +30,10 @@ int tracefs_instance_file_write(struct tracefs_instance *instance,
 				const char *file, const char *str);
 char *tracefs_instance_file_read(struct tracefs_instance *instance,
 				 const char *file, int *psize);
+int tracefs_instance_file_read_number(struct tracefs_instance *instance,
+				      const char *file, long long *res);
+int tracefs_instance_file_open(struct tracefs_instance *instance,
+			       const char *file, int mode);
 int tracefs_instances_walk(int (*callback)(const char *, void *), void *context);
 
 bool tracefs_instance_exists(const char *name);
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index 6dc85ee..97bbb00 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -14,7 +14,7 @@
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <dirent.h>
-#include <linux/limits.h>
+#include <limits.h>
 #include "tracefs.h"
 #include "tracefs-local.h"
 
@@ -301,6 +301,64 @@ char *tracefs_instance_file_read(struct tracefs_instance *instance,
 	return buf;
 }
 
+/**
+ * tracefs_instance_file_read_number - Read long long integer from a trace file.
+ * @instance: ftrace instance, can be NULL for the top instance
+ * @file: name of the file
+ * @res: The integer from the file.
+ *
+ * Returns 0 if the reading is successful and the result is stored in res, -1
+ * in case of an error.
+ */
+int tracefs_instance_file_read_number(struct tracefs_instance *instance,
+				      const char *file, long long *res)
+{
+	long long num;
+	int ret = -1;
+	int size = 0;
+	char *str;
+
+	str = tracefs_instance_file_read(instance, file, &size);
+	if (size && str) {
+		errno = 0;
+		num = strtoll(str, NULL, 0);
+		if (errno == 0) {
+			*res = num;
+			ret = 0;
+		}
+	}
+	free(str);
+	return ret;
+}
+
+/**
+ * tracefs_instance_file_open - Open a trace file for reading and writing
+ * @instance: ftrace instance, can be NULL for the top instance
+ * @file: name of the file
+ * @mode: file open flags, -1 for default O_RDWR
+ *
+ * Returns -1 in case of an error, or a valid file descriptor otherwise.
+ * The returned FD must be closed with close()
+ */
+int tracefs_instance_file_open(struct tracefs_instance *instance,
+			       const char *file, int mode)
+{
+	int flags = O_RDWR;
+	int fd = -1;
+	char *path;
+
+	path = tracefs_instance_get_file(instance, file);
+	if (!path)
+		return -1;
+
+	if (mode >= 0)
+		flags = mode;
+	fd = open(path, flags);
+	tracefs_put_tracing_file(path);
+
+	return fd;
+}
+
 static bool check_file_exists(struct tracefs_instance *instance,
 			     char *name, bool dir)
 {
-- 
2.29.2

