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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B122C43460
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 18:04:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DCCB6115B
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 18:04:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbhDISE4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 14:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233896AbhDISE4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 14:04:56 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F93C061761
        for <linux-trace-devel@vger.kernel.org>; Fri,  9 Apr 2021 11:04:43 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id v6so8763834ejo.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 09 Apr 2021 11:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F8OZiczL+uisWegoFaN+MtiVT5SO5pNjHCiRYvONrmw=;
        b=VwT1Hv0qtC8ZnMCSclgiBU5ELyztDMRoXiAV34mcmLD7hEGJmW/LsFB9CYall23QKM
         J7dBVC2Gq5BEbRyr9tvQwbriiJL0PULHwAZooPwNE7auxc4/Jejauml/iSkXiBKf9pkD
         mSORZLk5rrwCOd1fc1qUqpuwbLNSaVsSku052qEZllXvK6oMUHyP1eEz/S1ORR9DLJOJ
         nxJoJEQjXENRRPCkF/2KGXhVxNJILxYTdJlkEjsOJ82g/0McOcs0BXj0i0/zd14eTHzH
         DziL/KIpw97mShil3LiirpljL3vKd0oY5bjEnJUa6zZbxOFR0qvV/b/p6496bkY8XOl4
         C5ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F8OZiczL+uisWegoFaN+MtiVT5SO5pNjHCiRYvONrmw=;
        b=fbdLkQ/P2ebARnTwY+X+Nbj16Qk+mfRA5H8a0r83vGq80DKZ08cAx92ZbT67OcojtG
         lma/o4FSQ3tmwB8/bTziW4LCLGL8aAoa4lmYvG0W4gHXgcp7mQczz2Z0c1JGJvpL3Mmg
         46ibJDhKIIjkvtDXIvsh6AknFRUOZs4m6mlrdTPigcFanXB+nqSfiehbm3aMHKdqIvri
         43kbvuFnN7PvjKqURwGeWJShvhwB3w4G3WlZ1Vr9/Unhis7yXVGAj1IOizNq/4kM6e72
         b4M9oJlBt1dFc6HXCzNMBQMo3bgE/hhaOrqdmqYz5unQe0qOenRbKqSCRgxoB9ega6kH
         62HQ==
X-Gm-Message-State: AOAM533UCAQr9m6ksGPx34WdejnfYdANkU4Aw3T84yQGRjVYHQoawPB5
        qXWoqovUi1jnb8Vlh/KGsHk=
X-Google-Smtp-Source: ABdhPJxdoo80kZCdMSpHvPnaY2kM5vVR32fc0EFuFeSjwvsMuFiV6xYFdPKzggKXYcJSod9Lvn4ocA==
X-Received: by 2002:a17:906:b341:: with SMTP id cd1mr17205900ejb.391.1617991481755;
        Fri, 09 Apr 2021 11:04:41 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.133])
        by smtp.gmail.com with ESMTPSA id b14sm1865568edx.39.2021.04.09.11.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 11:04:41 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 4/5] libtracefs: Option's bit masks to be owned by the instance
Date:   Fri,  9 Apr 2021 21:04:22 +0300
Message-Id: <20210409180423.72497-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210409180423.72497-1-y.karadz@gmail.com>
References: <20210409180423.72497-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If the instance owns two mask objects, we no longer need to
dynamically allocate memory in tracefs_options_get_supported() and
tracefs_options_get_enabled(). This will simplify the code on the
caller side, since the user is no longer responsible for freeing
those masks.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 Documentation/libtracefs-option-get.txt |  7 +--
 include/tracefs-local.h                 |  8 +++
 include/tracefs.h                       |  2 +-
 src/tracefs-instance.c                  | 15 +++++
 src/tracefs-tools.c                     | 74 ++++++++++++-------------
 5 files changed, 61 insertions(+), 45 deletions(-)

diff --git a/Documentation/libtracefs-option-get.txt b/Documentation/libtracefs-option-get.txt
index 9b3cb56..4f5291e 100644
--- a/Documentation/libtracefs-option-get.txt
+++ b/Documentation/libtracefs-option-get.txt
@@ -40,8 +40,7 @@ given _instance_. If _instance_ is NULL, the top trace instance is used.
 RETURN VALUE
 ------------
 The _tracefs_options_get_supported()_ and _tracefs_options_get_enabled()_ functions return pointer
-to allocated bitmask with trace options, or NULL in case of an error. The returned bitmask must be
-freed with free();
+to allocated bitmask with trace options, or NULL in case of an error.
 
 The _tracefs_option_is_supported()_ and _tracefs_option_is_enabled()_ functions return true if the
 option in supported / enabled, or false otherwise.
@@ -52,14 +51,13 @@ EXAMPLE
 --
 #include <tracefs.h>
 ...
-struct tracefs_options_mask *options;
+const struct tracefs_options_mask *options;
 ...
 options = tracefs_options_get_supported(NULL);
 if (!options) {
 	/* Failed to get supported options */
 } else {
 	...
-	free(options);
 }
 ...
 options = tracefs_options_get_enabled(NULL);
@@ -67,7 +65,6 @@ if (!options) {
 	/* Failed to get options, enabled in the top instance */
 } else {
 	...
-	free(options);
 }
 ...
 
diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 076b013..eb8c81b 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -25,6 +25,8 @@ struct tracefs_instance {
 	int			flags;
 	int			ftrace_filter_fd;
 	int			ftrace_notrace_fd;
+	struct tracefs_options_mask	supported_opts;
+	struct tracefs_options_mask	enabled_opts;
 };
 
 extern pthread_mutex_t toplevel_lock;
@@ -48,4 +50,10 @@ char *trace_find_tracing_dir(void);
 #define DEFFILEMODE (S_IRUSR|S_IWUSR|S_IRGRP|S_IWGRP|S_IROTH|S_IWOTH) /* 0666*/
 #endif
 
+struct tracefs_options_mask *
+supported_opts_mask(struct tracefs_instance *instance);
+
+struct tracefs_options_mask *
+enabled_opts_mask(struct tracefs_instance *instance);
+
 #endif /* _TRACE_FS_LOCAL_H */
diff --git a/include/tracefs.h b/include/tracefs.h
index e1fbef6..ea9dbd0 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -132,7 +132,7 @@ enum tracefs_option_id {
 #define TRACEFS_OPTION_MAX (TRACEFS_OPTION_VERBOSE + 1)
 
 struct tracefs_options_mask;
-bool tracefs_option_is_set(struct tracefs_options_mask *options,
+bool tracefs_option_is_set(const struct tracefs_options_mask *options,
 			   enum tracefs_option_id id);
 struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance);
 bool tracefs_option_is_supported(struct tracefs_instance *instance, enum tracefs_option_id id);
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index 599c3a7..74122aa 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -21,6 +21,21 @@
 
 #define FLAG_INSTANCE_NEWLY_CREATED	(1 << 0)
 
+struct tracefs_options_mask	toplevel_supported_opts;
+struct tracefs_options_mask	toplevel_enabled_opts;
+
+__hidden inline struct tracefs_options_mask *
+supported_opts_mask(struct tracefs_instance *instance)
+{
+	return instance? &instance->supported_opts : &toplevel_supported_opts;
+}
+
+__hidden inline struct tracefs_options_mask *
+enabled_opts_mask(struct tracefs_instance *instance)
+{
+	return instance? &instance->enabled_opts : &toplevel_enabled_opts;
+}
+
 /**
  * instance_alloc - allocate a new ftrace instance
  * @trace_dir - Full path to the tracing directory, where the instance is
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index fc9644a..f539323 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -211,56 +211,52 @@ enum tracefs_option_id tracefs_option_id(const char *name)
 static struct tracefs_options_mask *trace_get_options(struct tracefs_instance *instance,
 						      bool enabled)
 {
+	pthread_mutex_t *lock = instance ? &instance->lock : &toplevel_lock;
 	struct tracefs_options_mask *bitmask;
 	enum tracefs_option_id id;
+	unsigned long long set;
 	char file[PATH_MAX];
-	struct dirent *dent;
-	char *dname = NULL;
-	DIR *dir = NULL;
+	struct stat st;
 	long long val;
+	char *path;
+	int ret;
 
-	bitmask = calloc(1, sizeof(struct tracefs_options_mask));
-	if (!bitmask)
-		return NULL;
-	dname = tracefs_instance_get_file(instance, "options");
-	if (!dname)
-		goto error;
-	dir = opendir(dname);
-	if (!dir)
-		goto error;
-
-	while ((dent = readdir(dir))) {
-		if (*dent->d_name == '.')
-			continue;
-		if (enabled) {
-			snprintf(file, PATH_MAX, "options/%s", dent->d_name);
-			if (tracefs_instance_file_read_number(instance, file, &val) != 0 ||
-			    val != 1)
-				continue;
+	bitmask = enabled? enabled_opts_mask(instance) :
+			   supported_opts_mask(instance);
+
+	for (id = 1; id < TRACEFS_OPTION_MAX; id++) {
+		snprintf(file, PATH_MAX, "options/%s", options_map[id]);
+		path = tracefs_instance_get_file(instance, file);
+		if (!path)
+			return NULL;
+
+		set = 1;
+		ret = stat(path, &st);
+		if (ret < 0 || !S_ISREG(st.st_mode)) {
+			set = 0;
+		} else if (enabled) {
+			ret = tracefs_instance_file_read_number(instance, file, &val);
+			if (ret != 0 || val != 1)
+				set = 0;
 		}
-		id = tracefs_option_id(dent->d_name);
-		if (id > TRACEFS_OPTION_INVALID)
-			bitmask->mask |= (1ULL << (id - 1));
+
+		pthread_mutex_lock(lock);
+		bitmask->mask = (bitmask->mask & ~(1ULL << (id - 1))) | (set << (id - 1));
+		pthread_mutex_unlock(lock);
+
+		tracefs_put_tracing_file(path);
 	}
-	closedir(dir);
-	tracefs_put_tracing_file(dname);
 
-	return bitmask;
 
-error:
-	if (dir)
-		closedir(dir);
-	tracefs_put_tracing_file(dname);
-	free(bitmask);
-	return NULL;
+	return bitmask;
 }
 
 /**
  * tracefs_options_get_supported - Get all supported trace options in given instance
  * @instance: ftrace instance, can be NULL for the top instance
  *
- * Returns allocated bitmask structure with all trace options, supported in given
- * instance, or NULL in case of an error. The returned structure must be freed with free()
+ * Returns bitmask structure with all trace options, supported in given instance,
+ * or NULL in case of an error.
  */
 struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance)
 {
@@ -271,8 +267,8 @@ struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instan
  * tracefs_options_get_enabled - Get all currently enabled trace options in given instance
  * @instance: ftrace instance, can be NULL for the top instance
  *
- * Returns allocated bitmask structure with all trace options, enabled in given
- * instance, or NULL in case of an error. The returned structure must be freed with free()
+ * Returns bitmask structure with all trace options, enabled in given instance,
+ * or NULL in case of an error.
  */
 struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance *instance)
 {
@@ -282,7 +278,7 @@ struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance
 static int trace_config_option(struct tracefs_instance *instance,
 			       enum tracefs_option_id id, bool set)
 {
-	char *set_str = set ? "1" : "0";
+	const char *set_str = set ? "1" : "0";
 	char file[PATH_MAX];
 	const char *name;
 
@@ -370,7 +366,7 @@ bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_o
  * Returns true if an option with given id is set in the bitmask,
  * false if it is not set.
  */
-bool tracefs_option_is_set(struct tracefs_options_mask *options,
+bool tracefs_option_is_set(const struct tracefs_options_mask *options,
 			   enum tracefs_option_id id)
 {
 	if (id > TRACEFS_OPTION_INVALID)
-- 
2.27.0

