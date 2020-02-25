Return-Path: <SRS0=gJb8=4N=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B77A5C35E04
	for <linux-trace-devel@archiver.kernel.org>; Tue, 25 Feb 2020 18:07:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93FCE206E6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 25 Feb 2020 18:07:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JpUE+cFA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731149AbgBYSHn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 25 Feb 2020 13:07:43 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45866 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728762AbgBYSHn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 25 Feb 2020 13:07:43 -0500
Received: by mail-lj1-f194.google.com with SMTP id e18so15047117ljn.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Feb 2020 10:07:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VxTZuCgsAECMs149+L1CDnuvd19WDlutn5UqJcE9bSE=;
        b=JpUE+cFAfk5rg92q8zTx4xW0zVH21X7RjzJmjg1W18Euac9+tMLiMNScoyu1G8xp+x
         KrPVvQhJjKumkqpJr1rskTHKw/8HZcp3LQEVGeFltF+mOSNxNkCfdd0ReFs21IRggqiq
         30Sm2cEzQ3pXtdpc27QdsotFebBCMaHofaNQm0/1aOgT/Gjd1Or/yTduCQ8+cyI+YOsK
         mEZQW00tcOsTiVzQFKQyygcIne5kgD1Yso4m3xbmOun2hmh8crG12tCGVJziL0LH8ay9
         Ag85IPgOptKKKM3IqJBTbpI4hhmnVHQjQnmmP4C8WLVWc2Yzxt2cjwM2fTM8joX7t4I7
         Litg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VxTZuCgsAECMs149+L1CDnuvd19WDlutn5UqJcE9bSE=;
        b=NqWuwnvHksQOulf7SKEZubEhQvZlORix3KgOtw0WecGmZkEzEEBvA9RashM97h/k/k
         wnffZC46W7dJeoeHI9o+GpRGZnrcwjVRm1KHmN8T+UQRbIiA0/8rSH8Osl/PNjoSOf6g
         zqV0/RikezEz8mbAJHTANrVzBCpClt56oVtLk50MY1nzNBOVvCSxhCS/LQX87vVObxz+
         MjFTxuOe9rr/M0hyfutI40jrtt3Yj/4N1IOHCNwz0QS1/AugXsz4W+NKRI3+uIP42NG3
         EXqS+vktcP6EavHvSOGsAC+E+t/uDS2ngS6mgIIR0DUh12/q28kgOZh5cIiA8Oz4TCIi
         ZK2w==
X-Gm-Message-State: ANhLgQ0MgbehyFBRGQ9dLu6GR9Z1gJm3as4vtFQHj84nZpp7Uy7uxDcD
        VKuAlvhTDnF9q+zo6fhyXqxlarpXL6w=
X-Google-Smtp-Source: APXvYqxSZRat+MqSaqOOOb0/3o8zJNLi95tBzaNRESYwI43jYRFNYaB7AS2qlLajJ/KbXDedgyRYJQ==
X-Received: by 2002:a2e:9841:: with SMTP id e1mr162317ljj.23.1582654059572;
        Tue, 25 Feb 2020 10:07:39 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v15sm4141438lfg.51.2020.02.25.10.07.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 10:07:38 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 1/4] trace-cmd: Add new tracefs APIs for checking if a ftrace file / directory exists
Date:   Tue, 25 Feb 2020 20:07:30 +0200
Message-Id: <20200225180733.89344-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200225180733.89344-1-tz.stoyanov@gmail.com>
References: <20200225180733.89344-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some ftrace files and directories are optional, depending on specific kernel configuration or version.
It is a good practice to check if the file / directory exist, before trying to access it. There are a lot of places in trace-cmd implementation with such checks.
The new libtracefs APIs can be used for this, they are ftarce instance aware:
 bool tracefs_file_exist(struct tracefs_instance *instance, char *name);
 bool tracefs_dir_exist(struct tracefs_instance *instance, char *name);

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs/tracefs.h      |  3 +++
 lib/tracefs/tracefs-instance.c | 49 +++++++++++++++++++++++++++++++++-
 2 files changed, 51 insertions(+), 1 deletion(-)

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
index b96ab61c..67123e7c 100644
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
 
@@ -247,3 +247,50 @@ char *tracefs_instance_file_read(struct tracefs_instance *instance,
 
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
+	if (dir && !S_ISDIR(st.st_mode))
+		return false;
+	if (!dir && S_ISDIR(st.st_mode))
+		return false;
+
+	return true;
+}
+
+/**
+ * tracefs_file_exist - Check if a file with given name exists in given instance
+ * @instance: ftrace instance, can be NULL for the top instance
+ * @name: name of the file
+ *
+ * Returns true if the file exists, false otherwise
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
2.24.1

