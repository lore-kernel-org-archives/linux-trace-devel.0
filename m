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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 721D4C43462
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Apr 2021 13:20:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AF4161103
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Apr 2021 13:20:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235204AbhDBNUI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Apr 2021 09:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234628AbhDBNUI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Apr 2021 09:20:08 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F90C061788
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Apr 2021 06:20:07 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id l4so7392105ejc.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 02 Apr 2021 06:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=way23HTlDFl1I+zj39yE/jKSjDkwDVOGnVSs5PzWLd8=;
        b=Iam+Q3nb8wmuT0SFOANXPWZDd3fAkJASo8Don2LIOk5ueWv6pHt1DrOcV3bJL13hLC
         Ch3kPHoCDmQuLpSyi+pREQRB8FMC4zxF3uvYGmz5DXhcSdup/HpfEBffbzv5aFfG4Lbo
         nokNL/Fc5iZjpsiYuUjPNNqo4HGtUzkhR79yvwoZKFRjQqgyO/z8OGziPFNxHrvv+Qgx
         64WmFwMIhkDqt6w0nwjpZxZCX0q19ayk39sxXp9k/tUagYTMeKoyTgqjwTR/O3DkpCS1
         7GtxInzxMsq1ucHpPe8axm+ZehmlvjaQ5FVIg6XrqdgHUmtpiuCsq6bkPtRA9UrmZBsy
         VMsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=way23HTlDFl1I+zj39yE/jKSjDkwDVOGnVSs5PzWLd8=;
        b=A62fLTYnJYcTaoN6M8z/WFehX5V73/dhjZqTKMNWJ6pHlC60buAYyL0LXgNt3X5PMK
         Cb6FXogGvP6vJmihMl69gj9L6KYwWinT0mAbsOdQtIKYjL8AxOitmiUqiY3zPvt1UNw6
         28TQXANpZNGVnhdUpe0/OMbZ7AqkacoMAYyeiaKT/RYBkVhGDloRR5DnVJZT3spQUKye
         /4YwKYqrg7zkd6773OOoBEilGGB2r9VqTvqfVeMfmSrLVU3TUCDm7vjYlSjvlzH/D8Ir
         Dbjyw/F2xwUsKGEBJYy7OSZ5zqMjTJPyBQ94qgKDEd8icWkE+D/K3VUt82yO7a+/ihSt
         G1Ww==
X-Gm-Message-State: AOAM531zxWc6GS8BA4ndB7Bmena+bX2aRY6zOlmqgWXW+CVlgzZUfxSq
        1OJ1auoBONmV1Uh6ej7HC1Y=
X-Google-Smtp-Source: ABdhPJyr0hyPXr8TjLVxn9ryLY94JsRQgC30isYkp2AVMbiWJKqU9G+pBETQV3JbuwUdMZy07AszMw==
X-Received: by 2002:a17:906:7806:: with SMTP id u6mr13115603ejm.130.1617369605861;
        Fri, 02 Apr 2021 06:20:05 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.133])
        by smtp.gmail.com with ESMTPSA id n3sm4120476ejj.113.2021.04.02.06.20.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 06:20:05 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 5/6] libtracefs: Option's bit masks to be owned by the instance
Date:   Fri,  2 Apr 2021 16:19:46 +0300
Message-Id: <20210402131947.346235-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210402131947.346235-1-y.karadz@gmail.com>
References: <20210402131947.346235-1-y.karadz@gmail.com>
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
 Documentation/libtracefs-option-get.txt |  4 +---
 include/tracefs.h                       |  6 +++---
 src/tracefs-instance.c                  | 24 ++++++++++++------------
 3 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/Documentation/libtracefs-option-get.txt b/Documentation/libtracefs-option-get.txt
index 9b3cb56..3290f24 100644
--- a/Documentation/libtracefs-option-get.txt
+++ b/Documentation/libtracefs-option-get.txt
@@ -52,14 +52,13 @@ EXAMPLE
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
@@ -67,7 +66,6 @@ if (!options) {
 	/* Failed to get options, enabled in the top instance */
 } else {
 	...
-	free(options);
 }
 ...
 
diff --git a/include/tracefs.h b/include/tracefs.h
index 0665e8d..9efa91a 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -132,11 +132,11 @@ enum tracefs_option_id {
 #define TRACEFS_OPTION_MAX (TRACEFS_OPTION_VERBOSE + 1)
 
 struct tracefs_options_mask;
-bool tracefs_option_is_set(struct tracefs_options_mask *options,
+bool tracefs_option_is_set(const struct tracefs_options_mask *options,
 			   enum tracefs_option_id id);
-struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance);
+const struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance);
 bool tracefs_option_is_supported(struct tracefs_instance *instance, enum tracefs_option_id id);
-struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance *instance);
+const struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance *instance);
 bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_option_id id);
 int tracefs_option_enable(struct tracefs_instance *instance, enum tracefs_option_id id);
 int tracefs_option_diasble(struct tracefs_instance *instance, enum tracefs_option_id id);
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index 49645eb..9cb4b6d 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -27,6 +27,8 @@ struct tracefs_instance {
 	char	*trace_dir;
 	char	*name;
 	int	flags;
+	struct tracefs_options_mask	supported_opts;
+	struct tracefs_options_mask	enabled_opts;
 };
 
 /**
@@ -695,9 +697,8 @@ static struct tracefs_options_mask *trace_get_options(struct tracefs_instance *i
 	DIR *dir = NULL;
 	long long val;
 
-	bitmask = calloc(1, sizeof(struct tracefs_options_mask));
-	if (!bitmask)
-		return NULL;
+	bitmask = enabled? &instance->enabled_opts : &instance->supported_opts;
+
 	dname = tracefs_instance_get_file(instance, "options");
 	if (!dname)
 		goto error;
@@ -727,7 +728,6 @@ error:
 	if (dir)
 		closedir(dir);
 	tracefs_put_tracing_file(dname);
-	free(bitmask);
 	return NULL;
 }
 
@@ -735,10 +735,10 @@ error:
  * tracefs_options_get_supported - Get all supported trace options in given instance
  * @instance: ftrace instance, can be NULL for the top instance
  *
- * Returns allocated bitmask structure with all trace options, supported in given
- * instance, or NULL in case of an error. The returned structure must be freed with free()
+ * Returns bitmask structure with all trace options, supported in given instance,
+ * or NULL in case of an error.
  */
-struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance)
+const struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance)
 {
 	return trace_get_options(instance, false);
 }
@@ -747,10 +747,10 @@ struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instan
  * tracefs_options_get_enabled - Get all currently enabled trace options in given instance
  * @instance: ftrace instance, can be NULL for the top instance
  *
- * Returns allocated bitmask structure with all trace options, enabled in given
- * instance, or NULL in case of an error. The returned structure must be freed with free()
+ * Returns allocated bitmask structure with all trace options, enabled in given instance,
+ * or NULL in case of an error.
  */
-struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance *instance)
+const struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance *instance)
 {
 	return trace_get_options(instance, true);
 }
@@ -758,7 +758,7 @@ struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance
 static int trace_config_option(struct tracefs_instance *instance,
 			       enum tracefs_option_id id, bool set)
 {
-	char *set_str = set ? "1" : "0";
+	const char *set_str = set ? "1" : "0";
 	char file[PATH_MAX];
 	const char *name;
 
@@ -846,7 +846,7 @@ bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_o
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

