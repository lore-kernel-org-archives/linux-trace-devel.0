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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA15BC433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Jan 2021 15:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B27712336D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Jan 2021 15:24:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390567AbhATPXc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Jan 2021 10:23:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390847AbhATPNp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Jan 2021 10:13:45 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837DAC0613D3
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jan 2021 07:13:04 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id e15so3164558wme.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jan 2021 07:13:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PtKzkgGu3ALXGV3VHLzz5lqTJr+GbH9+joF4w3GwVnk=;
        b=TmXFktN3OaHjMdzfZZot1sIFHgb5bVSJ/hnXhfTyShPhv1pZPXG06C91bmxVukMqnK
         xao9FUEQ8GfKQGiDhHz5UE0S2fZpcrDkWGewxk5nzO0w1ujFW27N/gayFtYfTHbLGk3S
         TJ7RfEVbwL5+JqxLCEagFQp1rzong1xzHgW5lIM7t7GKM1GS0RLz+WWFT2RG4v1N46WQ
         U3df3jfrZR7J2ChyjXZmiXFfZqlKcNFYlQaORdeCyK/7jxDWo/y81oEVVIKLs2JRkAW7
         MifCI8XMKoCV/VCo31kHwTYql0n0VNdSGlJgxPISMBbiiBM6vI+CxbnY6CW7pijYVL2q
         /iOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PtKzkgGu3ALXGV3VHLzz5lqTJr+GbH9+joF4w3GwVnk=;
        b=sacRHfAVZhEi5i1d3sEzXJMJcgCtxZ61XT01E3gvDO6dabUN1nEq368mCEPJZnbnpI
         rJJJFYTpGnn9xIBli4k/dIB3UJiyyHCfGIpnHtcdL6NCOFDE/9FFCN2Afu8++bx9OMGk
         rGPV/zUhN7h6li3XAC/1ohn+wfu2/7ogvGUTDy5g6I3NjZAi5YunNgU8OM3E1FMy5bb8
         EswyMwAVl2MuuxARlUru/UldD3eyULtfL2LNCCLXfN+vcwMcSdaKhMFuGvvP2YHYGo0a
         GZ5yY2CPDAKTGNdMB6Gk49kQZ2UocTNZkGbqh9uVfyCwEGW9bnSnYLDyWsVfvNYcB/RJ
         pZtA==
X-Gm-Message-State: AOAM531sMaUQA9RbNE1gdiY4CV/thxB6ZvKkPPE0qgIKFcFWDMEd+KhE
        LbwBFqp0z/Q6Z1mXtBsNOSQ=
X-Google-Smtp-Source: ABdhPJzpnLxiOHeKJL6vxW7kk6hxKhgfRfk52hC3bjBFYm89EOO2+KPClKPtjUWXVlvu5rpHnVHYFg==
X-Received: by 2002:a1c:4057:: with SMTP id n84mr4733948wma.141.1611155583279;
        Wed, 20 Jan 2021 07:13:03 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id c11sm4571106wmd.36.2021.01.20.07.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 07:13:02 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 4/5] libtracefs: New APIs for getting existing trace instance
Date:   Wed, 20 Jan 2021 17:12:55 +0200
Message-Id: <20210120151256.43075-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210120151256.43075-1-tz.stoyanov@gmail.com>
References: <20210120151256.43075-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new API allocates an instance structure for existing trace instance.
It has an optional tracing_dir parameter, which allows to get instances
from non default trace directory. If the instance with the given name does
not exist, the API fails. If no name is given, the structure for the top
instance in the given trace directory is allocated and returned.

struct tracefs_instance *tracefs_instance_alloc(const char *tracing_dir,
					        const char *name);

This helper API is added also, to get the tracing directory where the
instance is configured. In most cases this should be the default system
trace directroy mount point.

const char *tracefs_instance_get_trace_dir(struct tracefs_instance *instance);

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs.h      |  3 +++
 src/tracefs-instance.c | 57 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/include/tracefs.h b/include/tracefs.h
index 2df596f..3059dbb 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -20,9 +20,12 @@ struct tracefs_instance;
 
 void tracefs_instance_free(struct tracefs_instance *instance);
 struct tracefs_instance *tracefs_instance_create(const char *name);
+struct tracefs_instance *tracefs_instance_alloc(const char *tracing_dir,
+						const char *name);
 int tracefs_instance_destroy(struct tracefs_instance *instance);
 bool tracefs_instance_is_new(struct tracefs_instance *instance);
 const char *tracefs_instance_get_name(struct tracefs_instance *instance);
+const char *tracefs_instance_get_trace_dir(struct tracefs_instance *instance);
 char *
 tracefs_instance_get_file(struct tracefs_instance *instance, const char *file);
 char *tracefs_instance_get_dir(struct tracefs_instance *instance);
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index 468da1b..0df4e13 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -151,6 +151,49 @@ error:
 	return NULL;
 }
 
+/**
+ * tracefs_instance_alloc - Allocate an instance structure for existing trace instance
+ * @tracing_dir: full path to the system trace directory, where the new instance is
+ *		 if NULL, the default top tracing directory is used.
+ * @name: Name of the instance.
+ *
+ * Allocates and initializes a new instance structure. If the instance does not
+ * exist, do not create it and exit with error.
+ * Returns a pointer to a newly allocated instance, or NULL in case of an error
+ * or the requested instance does not exists.
+ * The returned instance must be freed by tracefs_instance_free().
+ */
+struct tracefs_instance *tracefs_instance_alloc(const char *tracing_dir,
+						const char *name)
+{
+	struct tracefs_instance *inst = NULL;
+	char file[PATH_MAX];
+	const char *tdir;
+	struct stat st;
+	int ret;
+
+	if (tracing_dir) {
+		ret = stat(tracing_dir, &st);
+		if (ret < 0 || !S_ISDIR(st.st_mode))
+			return NULL;
+		tdir = tracing_dir;
+
+	} else
+		tdir = tracefs_tracing_dir();
+	if (!tdir)
+		return NULL;
+
+	if (name) {
+		sprintf(file, "%s/instances/%s", tdir, name);
+		ret = stat(file, &st);
+		if (ret < 0 || !S_ISDIR(st.st_mode))
+			return NULL;
+	}
+	inst = instance_alloc(tdir, name);
+
+	return inst;
+}
+
 /**
  * tracefs_instance_destroy - Remove a ftrace instance
  * @instance: Pointer to the instance to be removed
@@ -247,6 +290,20 @@ const char *tracefs_instance_get_name(struct tracefs_instance *instance)
 	return NULL;
 }
 
+/**
+ * tracefs_instance_get_trace_dir - return the top trace directory, where the instance is confuigred
+ * @instance: ftrace instance
+ *
+ * Returns the top trace directory where the given @instance is configured.
+ * The returned string must *not* be freed.
+ */
+const char *tracefs_instance_get_trace_dir(struct tracefs_instance *instance)
+{
+	if (instance)
+		return instance->trace_dir;
+	return NULL;
+}
+
 static int write_file(const char *file, const char *str)
 {
 	int ret;
-- 
2.29.2

