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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6835C433DB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Jan 2021 05:05:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F7B023772
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Jan 2021 05:05:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729833AbhAOFFC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Jan 2021 00:05:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726361AbhAOFFB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Jan 2021 00:05:01 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4264BC0613D6
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Jan 2021 21:04:17 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id by1so5156944ejc.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Jan 2021 21:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DEipbYOY0q/m9MWeFZQuPDdlQiJOwq1nZTmlB+nMhI0=;
        b=b7xsEaClTUM01Sd3zuugzI4s7+tb7hIDY+pFBvfN0y9tSOu/Ved99blXdokTLkj9gK
         woBUMAZ3BbBVAatXv2lLpmZRMxoA3Yeie+tf7NC8PU5MjzAPodhIqFzB+uunLTEX8ryd
         GYQRveTvbxYwkyLBJAxsG2vR1EQdnCKQxQ/C0LQaI+EKl1BSepyjgFKtsotIm2NiL5Z/
         6tjGqVUmxJ7/nNnlwzdHcI5MTctqwcE+7GxjkNpk4TYFf+XqhKzuLdmMH7WniUv8f4Pd
         raR9yUBInNkqf9Pr54m3HzixnhZKm2WVsbUFWEh9QiCz2dlSrskji8WOeIjSVDqQU3YM
         Yl1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DEipbYOY0q/m9MWeFZQuPDdlQiJOwq1nZTmlB+nMhI0=;
        b=I+Th/hvYX/ZSYEfSmUdKUNR5x8IvM2ZS/Fp1oWTNAO48MFQd+foRrFFTOREx04EjFn
         +MFl2PXgB8bl1Ll6HYcAZ5l29KUUnpWNdVJ2EqD58a24TGJ02Xp1gd30e6Tw333jd/Kl
         CJL40DAidWfHBAyUjrzZc8D9fF2qjY3OyM3c5zfx9bxq1xmkYPQkidFWY46pAePUb2v0
         xXo7GYSRY90WiRejz/rkV5v3rudhygCaQ4yyrcZPl8gTHm3Eo9/siX8f+mzANdTmqUch
         R8ASWGim6xIPPnsuvkZwypdWW01SPV5owVIt6lUpO+8SZ3mofdixH7F7bkxhoF4hRlQw
         RuQA==
X-Gm-Message-State: AOAM530e8q0GmrYbnYjpzJdsADm+QB5fFIxH6vYNA2HEEZNvvscK8fQl
        aTHEyPogBgGugIWlzGNsjv4MlzHwvcqJ7MFz
X-Google-Smtp-Source: ABdhPJy+mIby8xaHSwoZ8/YEXGSFV/yOSHuPVizSw6dQDKiM5F12sPoi3mZppqAI6zUdZZJeBNv65w==
X-Received: by 2002:a17:907:d25:: with SMTP id gn37mr7373790ejc.381.1610687056047;
        Thu, 14 Jan 2021 21:04:16 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d4sm3055670edq.36.2021.01.14.21.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 21:04:15 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/5] libtracefs: Add information about top tracing directory in instance structure
Date:   Fri, 15 Jan 2021 07:04:08 +0200
Message-Id: <20210115050410.1194011-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210115050410.1194011-1-tz.stoyanov@gmail.com>
References: <20210115050410.1194011-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There are use cases, where the library could be used with non default
system trace directory - for example a partial copy of a system trace
directory from another machine. More flexibility is added to the tracefs
library, to handle these use cases. The full path to the system trace
directory is added in the instance structure and is used to get trace
files from that instance.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 src/tracefs-instance.c | 80 ++++++++++++++++++++++++++----------------
 1 file changed, 49 insertions(+), 31 deletions(-)

diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index b5f8298..468da1b 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -20,30 +20,43 @@
 
 #define FLAG_INSTANCE_NEWLY_CREATED	(1 << 0)
 struct tracefs_instance {
+	char	*trace_dir;
 	char	*name;
 	int	flags;
 };
 
 /**
  * instance_alloc - allocate a new ftrace instance
+ * @trace_dir - Full path to the tracing directory, where the instance is
  * @name: The name of the instance (instance will point to this)
  *
  * Returns a newly allocated instance, or NULL in case of an error.
  */
-static struct tracefs_instance *instance_alloc(const char *name)
+static struct tracefs_instance *instance_alloc(const char *trace_dir, const char *name)
 {
 	struct tracefs_instance *instance;
 
 	instance = calloc(1, sizeof(*instance));
-	if (instance && name) {
+	if (!instance)
+		goto error;
+	instance->trace_dir = strdup(trace_dir);
+	if (!instance->trace_dir)
+		goto error;
+	if (name) {
 		instance->name = strdup(name);
-		if (!instance->name) {
-			free(instance);
-			instance = NULL;
-		}
+		if (!instance->name)
+			goto error;
 	}
 
 	return instance;
+
+error:
+	if (instance) {
+		free(instance->name);
+		free(instance->trace_dir);
+		free(instance);
+	}
+	return NULL;
 }
 
 /**
@@ -56,6 +69,7 @@ void tracefs_instance_free(struct tracefs_instance *instance)
 {
 	if (!instance)
 		return;
+	free(instance->trace_dir);
 	free(instance->name);
 	free(instance);
 }
@@ -105,12 +119,16 @@ bool tracefs_instance_is_new(struct tracefs_instance *instance)
 struct tracefs_instance *tracefs_instance_create(const char *name)
 {
 	struct tracefs_instance *inst = NULL;
+	char *path = NULL;
+	const char *tdir;
 	struct stat st;
 	mode_t mode;
-	char *path;
 	int ret;
 
-	inst = instance_alloc(name);
+	tdir = tracefs_tracing_dir();
+	if (!tdir)
+		return NULL;
+	inst = instance_alloc(tdir, name);
 	if (!inst)
 		return NULL;
 
@@ -170,18 +188,18 @@ int tracefs_instance_destroy(struct tracefs_instance *instance)
 char *
 tracefs_instance_get_file(struct tracefs_instance *instance, const char *file)
 {
-	char *path;
-	char *buf;
+	char *path = NULL;
 	int ret;
 
-	if (instance && instance->name) {
-		ret = asprintf(&buf, "instances/%s/%s", instance->name, file);
-		if (ret < 0)
-			return NULL;
-		path = tracefs_get_tracing_file(buf);
-		free(buf);
-	} else
-		path = tracefs_get_tracing_file(file);
+	if (!instance)
+		return tracefs_get_tracing_file(file);
+	if (!instance->name)
+		ret = asprintf(&path, "%s/%s", instance->trace_dir, file);
+	else
+		ret = asprintf(&path, "%s/instances/%s/%s",
+			       instance->trace_dir, instance->name, file);
+	if (ret < 0)
+		return NULL;
 
 	return path;
 }
@@ -196,21 +214,21 @@ tracefs_instance_get_file(struct tracefs_instance *instance, const char *file)
  */
 char *tracefs_instance_get_dir(struct tracefs_instance *instance)
 {
-	char *buf;
-	char *path;
+	char *path = NULL;
 	int ret;
 
-	if (instance && instance->name) {
-		ret = asprintf(&buf, "instances/%s", instance->name);
-		if (ret < 0) {
-			warning("Failed to allocate path for instance %s",
-				 instance->name);
-			return NULL;
-		}
-		path = tracefs_get_tracing_file(buf);
-		free(buf);
-	} else
-		path = trace_find_tracing_dir();
+	if (!instance) /* Top instance of default system trace directory */
+		return trace_find_tracing_dir();
+
+	if (!instance->name)
+		return strdup(instance->trace_dir);
+
+	ret = asprintf(&path, "%s/instances/%s", instance->trace_dir, instance->name);
+	if (ret < 0) {
+		warning("Failed to allocate path for instance %s",
+			 instance->name);
+		return NULL;
+	}
 
 	return path;
 }
-- 
2.29.2

