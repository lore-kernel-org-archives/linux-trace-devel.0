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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41E95C433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Jan 2021 05:05:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E28023772
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Jan 2021 05:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731575AbhAOFFO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Jan 2021 00:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726361AbhAOFFO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Jan 2021 00:05:14 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3B5C061786
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Jan 2021 21:04:18 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id w1so11507226ejf.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Jan 2021 21:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ptMlY7gFRD7MomV3w62QcfI2MNa6nf68S716lDFDzZ0=;
        b=eCcJPO2G9aL5FXM+PbcyNGm7qXb3J8VvP2E4NUZ/WcobXO+NE/RKsbqZUpPqkIVKjf
         jsXf9ioFm3XTZwjdUm4d+2FVd5/otOz9Hf0ObEfjpwX7GNlqcPdsim4REaq2U0Qrahdn
         J1PDpb7ZR37S+8YEY33ckORTockYc0nvc3JkMXNOYWmgcQWQWjFGQluQSW6r/bPR1qUc
         EgKYaagfR1s1mF+hEbMTgCwCZ9LI9jE3x1VEvD/SDzjGcx651BBhfz3rPQMUsZ5yJdkk
         PIUZ41XVkiMjDGsyEftW7KLw7lox1Z+yIGw8E8qm5t88EgCZLzdrG0OLdJQ55P5DSJaY
         XMjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ptMlY7gFRD7MomV3w62QcfI2MNa6nf68S716lDFDzZ0=;
        b=JMxplaJrPf4JEIEgUbOmY472pJDWOuQU3/Z2pNonculm1G30GLfK14uDKNAdbFYgFy
         0YZHXhvDDxfbB/5iuxL7q2Zp7sSygzHzrwXeJ5HS94r/v/vS6cfZQJXtC64nmPrVIvm6
         ffdcVPk7jedIjfLpe2srfdJgwNCExySQPmrQn9opABYBSMRp/wU0xL7LZ+ykpLB8OhCi
         Q9btTJyUJXFSpTuxqHEF8sV8fXzluJqCIGK+vwRw2mTgylEazXmlGilMjA/smfwUSF1J
         wzOe+a8PG4wqiWaLXKRSoMsktO7Plrjnc0lS3yTArEN+D060p05aTc7hd8aUU4K9qtZv
         uebw==
X-Gm-Message-State: AOAM532Vf7vq0auzw0UbhLZMyM98B7/n4wNtsi2Agf/QnsRZjvZqSq51
        BA0fE+0lT6xdPwzh/IoOO8I=
X-Google-Smtp-Source: ABdhPJyEUGt5hhFaR29l5znvPXsh4dREstHEWHjmgNPyyxVuXzi9Vt8cRTkCu5cy0pI33DEqeXKpVg==
X-Received: by 2002:a17:906:ae42:: with SMTP id lf2mr7304045ejb.487.1610687057070;
        Thu, 14 Jan 2021 21:04:17 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d4sm3055670edq.36.2021.01.14.21.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 21:04:16 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/5] libtracefs: New APIs for getting existing trace instance
Date:   Fri, 15 Jan 2021 07:04:09 +0200
Message-Id: <20210115050410.1194011-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210115050410.1194011-1-tz.stoyanov@gmail.com>
References: <20210115050410.1194011-1-tz.stoyanov@gmail.com>
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

struct tracefs_instance *tracefs_instance_get(const char *tracing_dir,
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
index 1f10a00..20aa995 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -20,9 +20,12 @@ struct tracefs_instance;
 
 void tracefs_instance_free(struct tracefs_instance *instance);
 struct tracefs_instance *tracefs_instance_create(const char *name);
+struct tracefs_instance *tracefs_instance_get(const char *tracing_dir,
+					      const char *name);
 int tracefs_instance_destroy(struct tracefs_instance *instance);
 bool tracefs_instance_is_new(struct tracefs_instance *instance);
 const char *tracefs_instance_get_name(struct tracefs_instance *instance);
+const char *tracefs_instance_get_trace_dir(struct tracefs_instance *instance);
 char *
 tracefs_instance_get_file(struct tracefs_instance *instance, const char *file);
 char *tracefs_instance_get_dir(struct tracefs_instance *instance);
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index 468da1b..112e237 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -151,6 +151,49 @@ error:
 	return NULL;
 }
 
+/**
+ * tracefs_instance_get - Allocate an instance structure for existing trace instance
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
+struct tracefs_instance *tracefs_instance_get(const char *tracing_dir,
+					      const char *name)
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

