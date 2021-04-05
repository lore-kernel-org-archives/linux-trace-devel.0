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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 846A0C433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Apr 2021 14:21:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61831613B5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  5 Apr 2021 14:21:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241302AbhDEOVd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 5 Apr 2021 10:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241296AbhDEOVc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 5 Apr 2021 10:21:32 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0756C061756
        for <linux-trace-devel@vger.kernel.org>; Mon,  5 Apr 2021 07:21:26 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id b7so17085679ejv.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 05 Apr 2021 07:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UbjbDWjwzWugMAjtBnvBRAXg2Dp3jMe0PfbrEbxyyxU=;
        b=mlKMhI2OoEDi5DEM0U9G3WBhOxMBQtQcZ86BhpIRun/tE5cm7EG5wnT/XuI8+CxUQ2
         y6w+wrAqdtE12psR4jL72WzEwFNWNm36f/Ach4dAMHBQhkY5Zln/yMCJAIyopHJC4i4c
         46+MbGjqCnZ4DMMeSa622i/TOdcTwCshuzMO8NKzrLV6R88HSf0EiKDYhDjZLmTuX8Ep
         4naN+TvIe5PaBJko1Xq1YfsAhHIlm0U/xGp/dyqEyTWqjUUOONCzq4eS7qNg2RAG/uQD
         mp+b2TRdK4vBvRRtbwEEyYklSlulwBCcqHTE+mdSFKZRCmXZu/5L/Li0sBV8/tEGJuWs
         UTyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UbjbDWjwzWugMAjtBnvBRAXg2Dp3jMe0PfbrEbxyyxU=;
        b=hQYxvLj8rsU231ylHlsDwyFj0TA/VTNiGDIn2bTaPQ4PwuhkV4qHsXzawCriD0B7d1
         axGXMvsIvtJd7Ec2t986cKfxt3iRcMw7AMELL7ipPgH3sECDPhrwtTxCjw/owsfzpSZm
         PLbWeSTVILdDnDETEiRGm0iGWXryPzLR91WFc93gS+hHWahIrlWZQni7S/l0DBRcRAKT
         vmkcGjpg0RAkq6PLGG9opO2n5F8hOnJlU2XZHwPM6S6k7EzwGjlF5TDTw2MHYxierzWf
         P5oNW9y7DzHJar6jOaAG7yWJJA56/h99RK9xZ2PH5oqf0udIeTyh6ONwiI3CNtfJtYrs
         8dTw==
X-Gm-Message-State: AOAM532qYPkulGahmqg2IzN4sB5hCCT9jp4ETJXSrjw2yPWV1p4bDxKM
        xPS7rOQ2rIzq1uu/1psVpao=
X-Google-Smtp-Source: ABdhPJz4HMaOIpCKQJXYIs6bWPpmc4dWkoBxIOFqSCzaKaKx8Y80SRfv2hTvo3LVr5YIseDj4tHtkg==
X-Received: by 2002:a17:906:3886:: with SMTP id q6mr1467539ejd.118.1617632485421;
        Mon, 05 Apr 2021 07:21:25 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.133])
        by smtp.gmail.com with ESMTPSA id e5sm3156972edr.64.2021.04.05.07.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 07:21:25 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 4/5] libtracefs: Option's bit masks to be owned by the instance
Date:   Mon,  5 Apr 2021 17:21:06 +0300
Message-Id: <20210405142107.507711-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210405142107.507711-1-y.karadz@gmail.com>
References: <20210405142107.507711-1-y.karadz@gmail.com>
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
 include/tracefs-local.h                 |  6 ++++++
 include/tracefs.h                       |  2 +-
 src/tracefs-instance.c                  | 14 ++++++++++++++
 src/tracefs-tools.c                     | 18 ++++++++----------
 5 files changed, 30 insertions(+), 14 deletions(-)

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
 
diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 0a746f2..0a083f9 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -37,4 +37,10 @@ struct tracefs_options_mask {
 	unsigned long long	mask;
 };
 
+struct tracefs_options_mask *
+supported_opts_mask(struct tracefs_instance *instance);
+
+struct tracefs_options_mask *
+enabled_opts_mask(struct tracefs_instance *instance);
+
 #endif /* _TRACE_FS_LOCAL_H */
diff --git a/include/tracefs.h b/include/tracefs.h
index 0665e8d..6e9cf55 100644
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
index 0df313c..4d78be6 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -23,8 +23,22 @@ struct tracefs_instance {
 	char	*trace_dir;
 	char	*name;
 	int	flags;
+	struct tracefs_options_mask	supported_opts;
+	struct tracefs_options_mask	enabled_opts;
 };
 
+__hidden inline struct tracefs_options_mask *
+supported_opts_mask(struct tracefs_instance *instance)
+{
+	return &instance->supported_opts;
+}
+
+__hidden inline struct tracefs_options_mask *
+enabled_opts_mask(struct tracefs_instance *instance)
+{
+	return &instance->enabled_opts;
+}
+
 /**
  * instance_alloc - allocate a new ftrace instance
  * @trace_dir - Full path to the tracing directory, where the instance is
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index a932216..980ad47 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -215,9 +215,8 @@ static struct tracefs_options_mask *trace_get_options(struct tracefs_instance *i
 	DIR *dir = NULL;
 	long long val;
 
-	bitmask = calloc(1, sizeof(struct tracefs_options_mask));
-	if (!bitmask)
-		return NULL;
+	bitmask = enabled? enabled_opts_mask(instance) :
+			   supported_opts_mask(instance);
 	dname = tracefs_instance_get_file(instance, "options");
 	if (!dname)
 		goto error;
@@ -247,7 +246,6 @@ error:
 	if (dir)
 		closedir(dir);
 	tracefs_put_tracing_file(dname);
-	free(bitmask);
 	return NULL;
 }
 
@@ -255,8 +253,8 @@ error:
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
@@ -267,8 +265,8 @@ struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instan
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
@@ -278,7 +276,7 @@ struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance
 static int trace_config_option(struct tracefs_instance *instance,
 			       enum tracefs_option_id id, bool set)
 {
-	char *set_str = set ? "1" : "0";
+	const char *set_str = set ? "1" : "0";
 	char file[PATH_MAX];
 	const char *name;
 
@@ -366,7 +364,7 @@ bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_o
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

