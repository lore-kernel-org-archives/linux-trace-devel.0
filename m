Return-Path: <SRS0=o21U=56=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E033C352BE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Apr 2020 15:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B136206D5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Apr 2020 15:56:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Deyhc5uD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728935AbgDNP4R (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Apr 2020 11:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729163AbgDNP4L (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Apr 2020 11:56:11 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9682C061A0E
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Apr 2020 08:56:10 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id v9so283284ljk.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Apr 2020 08:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wGQg7+viLlgGVVPbE/rIUkf2ybiRTIaIqrgLgPHvcyU=;
        b=Deyhc5uDHJ7P3r3LQD2HZSw8+gvcsqQ7ce4itdX0sydMSFYnZ3ITXZkIOciWjfjRQI
         9Gv4HA4wmlpVWo2JGKaI4hgjAnW5OcPczIE/b/k2ALDFvBq+u/Cp/d0ba5ayE8rRuh8g
         k/fRPyU5UN+AeH9mk1v/bdfxH2HOtoy1sQWr+16hh6OK3cAJtL4xSbYYUT2N6lcd9V3B
         g7gbZV9ans/mBmflIpIQ0PchDxwgRtQQS9VvN6QveGl6McJm6yCAiIljUwYnXxz3now0
         SiqXhNAYtTnZMK8cXPO2eSu+1mr08/imVWOHxYbbJQI/fs/JWd5bnhkomhIszBiXoVe9
         nFDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wGQg7+viLlgGVVPbE/rIUkf2ybiRTIaIqrgLgPHvcyU=;
        b=e2nDkiQ4Hx/NUVuKYa/jX3OAm1fmzDNZsXuD2L8eEcDz0QLBvlibhMyqCUEQ99X7lU
         aGNJ0U8xeMYt5F03zBnDkAHeeOgG36RBzjpwEactS9Q3pl/nN5bOopSq3jkrWfRkmQjc
         6Mme43aN3VrAJylzXCqYROzM/yIaDVdxxYwFyGRI4OKC7k7exgHidzb1Jg1rsYpQNZWL
         beqe0gBJZS64bDr67W3HGfKCPaEFIN89MTpab946QwbM0EPfdo4p8FZCVT05ZR18quTd
         phjyeqVgsGZYVyfSPNnmkQOISzoGVs3DZDg7YD0X5aDI/k1DLq7U3TQujcnGVvORYyG+
         g65Q==
X-Gm-Message-State: AGi0PuaAPYb1M/SCrAArCb/4zUGJSohm34EjAH16ZwxCceGyrvf2I7vn
        2gSwLDh7Ysci4iLJpYJb128=
X-Google-Smtp-Source: APiQypKEr1Cfwx3mqVHFh21EG9zj+KXd65M9TUFLA5Bt9AmIT85It319k8FdL8oeuvA5clA6Gi6Mmw==
X-Received: by 2002:a2e:9013:: with SMTP id h19mr495407ljg.277.1586879769179;
        Tue, 14 Apr 2020 08:56:09 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b2sm11408534ljp.63.2020.04.14.08.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 08:56:08 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 1/3] trace-cmd: Add new tracefs APIs for checking if a ftrace file / directory exists
Date:   Tue, 14 Apr 2020 18:56:02 +0300
Message-Id: <20200414155604.31401-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200414155604.31401-1-tz.stoyanov@gmail.com>
References: <20200414155604.31401-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some ftrace files and directories are optional, depending on specific
kernel configuration or version. It is a good practice to check if
the file / directory exist, before trying to access it.
There are a lot of places in trace-cmd implementation with such checks.
The new libtracefs APIs can be used for this, they are ftarce instance aware:
 bool tracefs_file_exist(struct tracefs_instance *instance, char *name);
 bool tracefs_dir_exist(struct tracefs_instance *instance, char *name);

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs/tracefs.h      |  3 +++
 lib/tracefs/tracefs-instance.c | 46 +++++++++++++++++++++++++++++++++-
 2 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
index 85690b66..bc8bebcb 100644
--- a/include/tracefs/tracefs.h
+++ b/include/tracefs/tracefs.h
@@ -33,6 +33,9 @@ int tracefs_instance_file_write(struct tracefs_instance *instance,
 char *tracefs_instance_file_read(struct tracefs_instance *instance,
 				 char *file, int *psize);
 
+bool tracefs_file_exist(struct tracefs_instance *instance, char *name);
+bool tracefs_dir_exist(struct tracefs_instance *instance, char *name);
+
 /* events */
 void tracefs_list_free(char **list);
 char **tracefs_event_systems(const char *tracing_dir);
diff --git a/lib/tracefs/tracefs-instance.c b/lib/tracefs/tracefs-instance.c
index b96ab61c..a9ab64bd 100644
--- a/lib/tracefs/tracefs-instance.c
+++ b/lib/tracefs/tracefs-instance.c
@@ -13,7 +13,7 @@
 #include <errno.h>
 #include <sys/stat.h>
 #include <fcntl.h>
-
+#include <linux/limits.h>
 #include "tracefs.h"
 #include "tracefs-local.h"
 
@@ -247,3 +247,47 @@ char *tracefs_instance_file_read(struct tracefs_instance *instance,
 
 	return buf;
 }
+
+static bool check_file_exist(struct tracefs_instance *instance,
+			     char *name, bool dir)
+{
+	char file[PATH_MAX];
+	struct stat st;
+	char *path;
+	int ret;
+
+	path = tracefs_instance_get_dir(instance);
+	snprintf(file, PATH_MAX, "%s/%s", path, name);
+	tracefs_put_tracing_file(path);
+	ret = stat(file, &st);
+	if (ret < 0)
+		return false;
+
+	return !dir == !S_ISDIR(st.st_mode);
+}
+
+/**
+ * tracefs_file_exist - Check if a file with given name exists in given instance
+ * @instance: ftrace instance, can be NULL for the top instance
+ * @name: name of the file
+ *
+ * Returns true if the file exists, false otherwise
+ *
+ * If a directory with the given name exists, false is returned.
+ */
+bool tracefs_file_exist(struct tracefs_instance *instance, char *name)
+{
+	return check_file_exist(instance, name, false);
+}
+
+/**
+ * tracefs_dir_exist - Check if a directory with given name exists in given instance
+ * @instance: ftrace instance, can be NULL for the top instance
+ * @name: name of the directory
+ *
+ * Returns true if the directory exists, false otherwise
+ */
+bool tracefs_dir_exist(struct tracefs_instance *instance, char *name)
+{
+	return check_file_exist(instance, name, true);
+}
-- 
2.25.1

