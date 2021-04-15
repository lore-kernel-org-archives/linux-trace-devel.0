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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BDF2C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Apr 2021 12:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE202613B6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Apr 2021 12:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbhDOMNt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 15 Apr 2021 08:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232767AbhDOMNt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 15 Apr 2021 08:13:49 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8450C061756
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Apr 2021 05:13:24 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id w3so36552824ejc.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Apr 2021 05:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ir2uoBhaBlCM9nU/EcKA4NdYTmn8iA9rSHmkquNWHJk=;
        b=p0/u8FEOlUOgrGpWUINq8kXPKba51kprMW6OkzJXgL2ppOyFQBkGrF+i4ZbID8g36L
         zGy+2pAhDt0Pu5yZ6rFZUv3YyFkCqUgE2A+K85dRXkHiyRQ3ux/AoQOXRM4TohtHl4Ev
         /O3CN6jx5gIj9mtiK1guS07+zc6nhdwCkJRmbvOEsG7/mSTeIv8GP/FybZaA8yq48oyM
         z07odcdH0b9Djfv8c2dkA3iMHOFaflnrNW+DWysqwUCz0toumH5ZcMya+h9dvBoD+Rnw
         njeoU/vEI2/nnysaOOMVKqYRpNCETg/2tQz1BvnGiagVe/0jCoFLS1dbPVf+Tr+XyP9t
         oRgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ir2uoBhaBlCM9nU/EcKA4NdYTmn8iA9rSHmkquNWHJk=;
        b=bOEYc/5BR/gpp2jgYFwrvFT6Dz9TW/gWzJ3peoi/aoDCMag2JjZaKfJMjYC6ifH6Kn
         WpM8x9bIkt4ken+L2kgIKTFhkOVheH/YMNiTH92QCEOYSAESdzHb7Hzrs0eYenX20BVq
         xEzfaJHzfQB4nDkA9leUkG0Yxzlzquxudiasj/3QCXjcV4EjCy0vl0jc2rXgsdyexu4z
         JBT8SpDico4RFM0dySVFGIfrRYNiyVQzEEvk4ZddoDXQeVewQFZNuKD5ePNfeOUdaBz6
         uJ7wPWzzkHHqQ1FBRL/94NyWrq5MafcOUzTQXfWvcTOWCnG75YGLHIKGRrWwuyBUcHfB
         Eh9Q==
X-Gm-Message-State: AOAM533I0JSd2nVpfHYJdAW0SGKjl51L//WRxWD0hAN8YWWrO4cKqxVR
        7d0mlSivoKbUGuncND44eD0=
X-Google-Smtp-Source: ABdhPJxic/diuunNSNyKyU4QcYLY/LYHU3swalOoYPUbO6C8k9NccMJksIysMvuIrbVNIZmP8u6OGw==
X-Received: by 2002:a17:906:e949:: with SMTP id jw9mr3197290ejb.433.1618488803551;
        Thu, 15 Apr 2021 05:13:23 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.55])
        by smtp.gmail.com with ESMTPSA id o20sm2364863eds.65.2021.04.15.05.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 05:13:23 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     tz.stoyanov@gmail.com, linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/3] libtracefs: Add more methods for writing to files
Date:   Thu, 15 Apr 2021 15:13:09 +0300
Message-Id: <20210415121311.59787-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210415121311.59787-1-y.karadz@gmail.com>
References: <20210415121311.59787-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

For the moment the library provides only one method for writing to
tracefs files, that is:

int tracefs_instance_file_write()

This method first truncates the size of the file to 0 (clearing it),
then writes new content to this file. Essentially this method overwrites
(clear + write). In this patch we add two additional methids:

int tracefs_instance_file_append()

which writes without clearing and

int tracefs_instance_file_clear()

which clears without writing anything. Those two new APIs have various
use-cases. For example one can use the two methods when adding/clearing
kprobes.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 include/tracefs.h      |  4 +++
 src/tracefs-instance.c | 74 +++++++++++++++++++++++++++++++++---------
 2 files changed, 63 insertions(+), 15 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 55ee867..551c37c 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -33,6 +33,10 @@ tracefs_instance_get_file(struct tracefs_instance *instance, const char *file);
 char *tracefs_instance_get_dir(struct tracefs_instance *instance);
 int tracefs_instance_file_write(struct tracefs_instance *instance,
 				const char *file, const char *str);
+int tracefs_instance_file_append(struct tracefs_instance *instance,
+				 const char *file, const char *str);
+int tracefs_instance_file_clear(struct tracefs_instance *instance,
+				const char *file);
 char *tracefs_instance_file_read(struct tracefs_instance *instance,
 				 const char *file, int *psize);
 int tracefs_instance_file_read_number(struct tracefs_instance *instance,
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index b8ce36f..2aeb529 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -337,21 +337,41 @@ const char *tracefs_instance_get_trace_dir(struct tracefs_instance *instance)
 	return NULL;
 }
 
-static int write_file(const char *file, const char *str)
+static int write_file(const char *file, const char *str, int flags)
 {
-	int ret;
+	int ret = 0;
 	int fd;
 
-	fd = open(file, O_WRONLY | O_TRUNC);
+	fd = open(file, flags);
 	if (fd < 0) {
 		tracefs_warning("Failed to open '%s'", file);
 		return -1;
 	}
-	ret = write(fd, str, strlen(str));
+
+	if (str)
+		ret = write(fd, str, strlen(str));
+
 	close(fd);
 	return ret;
 }
 
+static int instance_file_write(struct tracefs_instance *instance,
+			       const char *file, const char *str, int flags)
+{
+	struct stat st;
+	char *path;
+	int ret;
+
+	path = tracefs_instance_get_file(instance, file);
+	if (!path)
+		return -1;
+	ret = stat(path, &st);
+	if (ret == 0)
+		ret = write_file(path, str, flags);
+	tracefs_put_tracing_file(path);
+
+	return ret;
+}
 
 /**
  * tracefs_instance_file_write - Write in trace file of specific instance.
@@ -364,19 +384,43 @@ static int write_file(const char *file, const char *str)
 int tracefs_instance_file_write(struct tracefs_instance *instance,
 				 const char *file, const char *str)
 {
-	struct stat st;
-	char *path;
-	int ret;
+	return instance_file_write(instance, file, str, O_WRONLY | O_TRUNC);
+}
 
-	path = tracefs_instance_get_file(instance, file);
-	if (!path)
-		return -1;
-	ret = stat(path, &st);
-	if (ret == 0)
-		ret = write_file(path, str);
-	tracefs_put_tracing_file(path);
+/**
+ * tracefs_instance_file_append - Append to a trace file of specific instance.
+ * @instance: ftrace instance, can be NULL for the top instance.
+ * @file: name of the file.
+ * @str: nul terminated string, that will be appended to the file.
+ *
+ * Returns the number of appended bytes, or -1 in case of an error.
+ */
+int tracefs_instance_file_append(struct tracefs_instance *instance,
+				 const char *file, const char *str)
+{
+	return instance_file_write(instance, file, str, O_WRONLY);
+}
 
-	return ret;
+/**
+ * tracefs_instance_file_clear - Clear a trace file of specific instance.
+ * Note, it only opens with O_TRUNC and closes the file. If the file has
+ * content that does not get cleared in this way, this will not have any
+ * effect. For example, set_ftrace_filter can have probes that are not
+ * cleared by O_TRUNC:
+ *
+ * echo "schedule:stacktrace" > set_ftrace_filter
+ *
+ * This function will not clear the above "set_ftrace_filter" after that
+ * command.
+ * @instance: ftrace instance, can be NULL for the top instance.
+ * @file: name of the file to clear.
+ *
+ * Returns 0 on success, or -1 in case of an error.
+ */
+int tracefs_instance_file_clear(struct tracefs_instance *instance,
+				const char *file)
+{
+	return instance_file_write(instance, file, NULL, O_WRONLY | O_TRUNC);
 }
 
 /**
-- 
2.25.1

