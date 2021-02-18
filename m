Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C883C433E6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Feb 2021 03:39:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDC8660C3D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Feb 2021 03:39:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhBRDjc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Feb 2021 22:39:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbhBRDjb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Feb 2021 22:39:31 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A8CC061756
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Feb 2021 19:38:51 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id f14so1688336ejc.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Feb 2021 19:38:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aeAeuS3Pbwd0HdlLko5OgDl88SaryKmUmK9r2gCalS4=;
        b=mhcsbVNoqrsh0u5PF8ZJz7NGZ63U5rIaefgXknPMdEtr5zTm5LmwfZe+0d4sBxdUWc
         Z3fOZ2uwkfLan2fdM0BJrJYP4A7Fydymx8zdgWnFXwyBGU8G8JAuB1KCDmae/h12iI2f
         bIsx3oYeCKLXyi97dkiR67nARATV+sYsznzd/WQ+cPLId02T+ILxOAGVXssAiRIIgYvN
         deWdtvvmzJ3gvq+QbcMXPPj4U0WRcUAW7OOyC1lwH6BA9n5LITHkWxqaMkjrlF1mnMo8
         o78coQrLyYt9kqejzqB2qjwjVb97AYFtLPifsHIWYnp0m7ik5/q7+jXm42Bv+oDiOAaw
         gsZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aeAeuS3Pbwd0HdlLko5OgDl88SaryKmUmK9r2gCalS4=;
        b=FXxad7H4Yg7n9bJvfbctUr3GHoW0QuGnBgIci+hE1Xg0Azb7+FHmn2397xJ7UvxK5c
         nceweVrifwCYywA+p7wlo0z0sPVE8g2965K+QxAsXXeKZPX2jTmPQXvjiLufZxMZm2Yt
         IXMJr0rlbxJk6Vi7EzePqsxBclCLN3p2qzS7KJ/GoTPWczjQBrr9gvjmsB56PV13+ElI
         HgVwmSONj8Whtz0BXWSNCrsSZ8t7+d0LHT/bOSEbqeOBEOHTOow2Jurh29Wm2URhLY+B
         /cM2MRruXh4dI+VQdjFa0Dewqin5S8B25IxBTQzAuFIZzlVFPFArdiCTaJeL82EtS1l7
         YVhw==
X-Gm-Message-State: AOAM532jAJCzAu1yZtEfsxbivf141a7nqm46s8PZpqp4oolMHUiLAYO/
        xS8C0Q6vDElS/BZq8FvIEO2lMAmWM8IUHg==
X-Google-Smtp-Source: ABdhPJxhsPj+BVG16NOaG8M/Qq44wKnUOhrtyNjMElR97ufIBiQZSXKwjYt/g0tImIVr2gmFCBItAg==
X-Received: by 2002:a17:906:1681:: with SMTP id s1mr2004894ejd.229.1613619529965;
        Wed, 17 Feb 2021 19:38:49 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i4sm1796979eje.90.2021.02.17.19.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 19:38:49 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] libtracefs: Document new instance APIs
Date:   Thu, 18 Feb 2021 05:38:45 +0200
Message-Id: <20210218033846.1891289-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210218033846.1891289-1-tz.stoyanov@gmail.com>
References: <20210218033846.1891289-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added documentation for these new APIs:
 tracefs_instance_alloc()
 tracefs_instance_get_trace_dir()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-instances-manage.txt | 34 +++++++++++++++----
 Documentation/libtracefs-instances-utils.txt  | 16 +++++++--
 2 files changed, 41 insertions(+), 9 deletions(-)

diff --git a/Documentation/libtracefs-instances-manage.txt b/Documentation/libtracefs-instances-manage.txt
index a831ef2..e7dc393 100644
--- a/Documentation/libtracefs-instances-manage.txt
+++ b/Documentation/libtracefs-instances-manage.txt
@@ -3,7 +3,7 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_instance_create, tracefs_instance_destroy, tracefs_instance_free,
+tracefs_instance_create, tracefs_instance_destroy, tracefs_instance_alloc, tracefs_instance_free,
 tracefs_instance_is_new - Manage trace instances.
 
 SYNOPSIS
@@ -14,6 +14,7 @@ SYNOPSIS
 
 struct tracefs_instance pass:[*]*tracefs_instance_create*(const char pass:[*]_name_);
 int *tracefs_instance_destroy*(struct tracefs_instance pass:[*]_instance_);
+struct tracefs_instance pass:[*]*tracefs_instance_alloc*(const char pass:[*]_tracing_dir_, const char pass:[*]_name_);
 void *tracefs_instance_free*(struct tracefs_instance pass:[*]_instance_);
 bool *tracefs_instance_is_new*(struct tracefs_instance pass:[*]_instance_);
 
@@ -28,12 +29,22 @@ system, nor other instances, as events enabled in the main tracing system
 or other instances do not affect the given instance.
 
 The _tracefs_instance_create()_ function allocates and initializes a new
-tracefs_instance structure and returns it. If the instance does not yet
-exist in the system, it will be created.
+tracefs_instance structure and returns it. If the instance with _name_ does
+not yet exist in the system, it will be created. The _name_ could be NULL,
+then the new tracefs_instance structure is initialised for the top instance.
+Note that the top instance cannot be created in the system, if it does not
+exist.
 
 The _tracefs_instance_destroy()_ frees the _instance_ structure, and will
 also remove the trace instance from the system.
 
+The _tracefs_instance_alloc()_ function allocates a new tracefs_instance structure
+for existing trace instance. If the instance does not exist in the system, the function
+fails. The _tracing_dir_ parameter points to the system trace directory. It can be
+NULL, then default system trace directory is used. This parameter is useful to allocate
+instances to trace directories, copied from another machine. The _name_ is the name of
+the instance, or NULL for the top instance in the given _tracing_dir_.
+
 The _tracefs_instance_free()_ function frees the tracefs_instance structure,
 without removing the trace instance from the system.
 
@@ -43,8 +54,8 @@ before that.
 
 RETURN VALUE
 ------------
-The _tracefs_instance_create()_ function returns a pointer to a newly allocated
-tracefs_instance structure. It must be freed with _tracefs_instance_destroy()_ or
+The _tracefs_instance_create()_ and _tracefs_instance_alloc()_ functions return a pointer to
+a newly allocated tracefs_instance structure. It must be freed with _tracefs_instance_destroy()_ or
 _tracefs_instance_free()_.
 
 The _tracefs_instance_destroy()_ function returns -1 in case of an error,
@@ -54,7 +65,7 @@ The _tracefs_instance_is_new()_ function returns true if the
 _tracefs_instance_create()_ that allocated _instance_ also created the
 trace instance in the system, or false if the trace instance already
 existed in the system when _instance_ was allocated by
-_tracefs_instance_create()_.
+_tracefs_instance_create()_ or _tracefs_instance_alloc()_.
 
 EXAMPLE
 -------
@@ -74,6 +85,17 @@ struct tracefs_instance *inst = tracefs_instance_create("foo");
 		tracefs_instance_destroy(inst);
 	else
 		tracefs_instance_free(inst);
+...
+
+struct tracefs_instance *inst = tracefs_instance_alloc(NULL, "bar");
+	if (!inst) {
+		/* Error allocating 'bar' trace instance */
+		...
+	}
+
+	...
+
+	tracefs_instance_free(inst);
 --
 FILES
 -----
diff --git a/Documentation/libtracefs-instances-utils.txt b/Documentation/libtracefs-instances-utils.txt
index 3bd54a5..f559406 100644
--- a/Documentation/libtracefs-instances-utils.txt
+++ b/Documentation/libtracefs-instances-utils.txt
@@ -3,7 +3,8 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_instance_get_name, tracefs_instances_walk, tracefs_instance_exists -
+tracefs_instance_get_name, tracefs_instance_get_trace_dir,
+tracefs_instances_walk, tracefs_instance_exists -
 Helper functions for working with tracing instances.
 
 SYNOPSIS
@@ -13,6 +14,7 @@ SYNOPSIS
 *#include <tracefs.h>*
 
 const char pass:[*]*tracefs_instance_get_name*(struct tracefs_instance pass:[*]_instance_);
+const char pass:[*]*tracefs_instance_get_trace_dir*(struct tracefs_instance pass:[*]_instance_);
 int *tracefs_instances_walk*(int (pass:[*]_callback_)(const char pass:[*], void pass:[*]), void pass:[*]_context)_;
 bool *tracefs_instance_exists*(const char pass:[*]_name_);
 
@@ -25,6 +27,9 @@ Helper functions for working with trace instances.
 The _tracefs_instance_get_name()_ function returns the name of the given _instance_.
 Note that the top instance has no name, the function returns NULL for it.
 
+The _tracefs_instance_get_trace_dir()_ function returns the tracing directory, where
+the given _instance_ is configured.
+
 The _tracefs_instances_walk()_ function walks through all configured tracing
 instances in the system and calls _callback_ for each one of them. The _context_
 argument is passed to the _callback_, together with the instance name. If the
@@ -39,6 +44,9 @@ RETURN VALUE
 The _tracefs_instance_get_name()_ returns a string or NULL in case of the top
 instance. The returned string must _not_ be freed.
 
+The _tracefs_instance_get_trace_dir()_ returns a string or NULL in case of an error.
+The returned string must _not_ be freed.
+
 The _tracefs_instances_walk()_ function returns 0, if all instances were iterated, 1
 if the iteration was stopped by the _callback_, or -1 in case of an error.
 
@@ -54,11 +62,13 @@ EXAMPLE
 struct tracefs_instance *inst;
 ....
 char *name = tracefs_instance_get_name(inst);
-
 	if(name) {
 		/* Got name of the instance */
 	}
-
+char *dir = tracefs_instance_get_trace_dir(inst);
+	if(dir) {
+		/* Got tracing directory of the instance */
+	}
 ...
 static int instance_walk(char *name, void *context)
 {
-- 
2.29.2

