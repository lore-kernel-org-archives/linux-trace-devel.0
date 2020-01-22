Return-Path: <SRS0=9Wso=3L=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAB2DC2D0DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 15:00:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FEA82465B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 15:00:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U6ZVuTSb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgAVPAK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 22 Jan 2020 10:00:10 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41155 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbgAVPAK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 10:00:10 -0500
Received: by mail-lj1-f195.google.com with SMTP id h23so7154083ljc.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 22 Jan 2020 07:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5cTGrODYd3dJjy50DGZIcltWX7fMy2sP1MkBDzwPeqw=;
        b=U6ZVuTSbSDf+HGLZrhmZXemqPGHYvGrP4hfS2++o3i550Sdqk1LX0UaXYBzU0Xqe3d
         84NlG48dve0mjytSKPW8zpy+xTZIftE54xZtU3C3/+51PdZBAnHd7L6DeYo4lvRECTQy
         71NQU0XMyJjZeA9wQQBYotAaJSVq+wOi0dUNEKzg9oNvsKyR7EEx/59jX2gRTdR3x9K6
         gj0QQnuHBC1M7hXzk0FIfULcU3Z898BqiA2JWkgqZJwAhQWBAmuisKysdUEEEEHapJyQ
         eXlW0VzTBtqJdOd57bdRnjRkrIbzymKyO9KEbLoPYOu7ooVqVVf14FtapKOhC8KPFI6K
         ndIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5cTGrODYd3dJjy50DGZIcltWX7fMy2sP1MkBDzwPeqw=;
        b=MoIanmVK6kjTp1y7zJ9Sxzv4yrJvenrgxDkNfnF/xPUYlR3lc7zts5ig21chP7GcgN
         vna1r9iFU1cUMp76EX6Kt+mOPtU6FC5HGvQ9uxYze1xI/sr45n3oVMrycoOHnWCqxCQq
         2waf9D9rMzt5BVHme0wb5UGD5RTP/f5uYCKRfH8GxrpUATFX3d3uVto1eoH9uJf1Pmkq
         S0QHmXiq3PWGY0ITO5ZLQoBWnS2QksBwRlo+Ol/vA49A3oaNwbYDE3OrPu/LaYW5IgS1
         mIW4t/9MxDCmNoyGFJaV49mqvq3qm18t/+rA2K+Oh7jBY0O/2srhcAsp8Ox3w3dH4PPv
         bbxQ==
X-Gm-Message-State: APjAAAW/aLhpgFfvMIaJq1ot0isEtsAw1+8gPHbPzWN6iYLZtFgvJCny
        UQ3/VaZ+1fqJti145FhZjWP92J9a
X-Google-Smtp-Source: APXvYqxbd7M8lLtxbnrgWT6WniDH47DxPl0clGefUQX7G7t8bdIXmUUvlgb3tW5+8NnY7CT3C2foLw==
X-Received: by 2002:a2e:3309:: with SMTP id d9mr19783067ljc.262.1579705208196;
        Wed, 22 Jan 2020 07:00:08 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id l7sm20722803lfc.80.2020.01.22.07.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 07:00:07 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/7] trace-cmd,libtraceevent: Remove TEP_PLUGIN_OPTIONS
Date:   Wed, 22 Jan 2020 16:59:57 +0200
Message-Id: <20200122150002.763233-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200122150002.763233-1-tz.stoyanov@gmail.com>
References: <20200122150002.763233-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When loading a plugin, the current API searches for
TEP_PLUGIN_OPTIONS array in plugin's symbols and loads
any options from it. This API duplicates
 tep_plugin_add_options()
In order to simplify the APIs, The duplicated TEP_PLUGIN_OPTIONS
is removed as an API, as it is not used by any existing plugin.
The tep_plugin_add_options() API is the only way to register
plugin options.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/traceevent/event-parse.h | 20 --------------------
 lib/traceevent/event-plugin.c    | 11 -----------
 2 files changed, 31 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 72f7aaf..cb1b46e 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -77,33 +77,13 @@ struct tep_plugin_option {
  *
  *   int TEP_PLUGIN_UNLOADER(struct tep_handle *tep)
  *
- * TEP_PLUGIN_OPTIONS:  (optional)
- *   Plugin options that can be set before loading
- *
- *   struct tep_plugin_option TEP_PLUGIN_OPTIONS[] = {
- *	{
- *		.name = "option-name",
- *		.description = "description of option to show users",
- *	},
- *	{
- *		.name = NULL,
- *	},
- *   };
- *
- *   Array must end with .name = NULL;
- *
- *   If .value is not set, then it is considered a boolean and only
- *   .set will be processed. If .value is defined, then it is considered
- *   a string option and .set will be ignored.
  */
 #define TEP_PLUGIN_LOADER tep_plugin_loader
 #define TEP_PLUGIN_UNLOADER tep_plugin_unloader
-#define TEP_PLUGIN_OPTIONS tep_plugin_options
 #define _MAKE_STR(x)	#x
 #define MAKE_STR(x)	_MAKE_STR(x)
 #define TEP_PLUGIN_LOADER_NAME MAKE_STR(TEP_PLUGIN_LOADER)
 #define TEP_PLUGIN_UNLOADER_NAME MAKE_STR(TEP_PLUGIN_UNLOADER)
-#define TEP_PLUGIN_OPTIONS_NAME MAKE_STR(TEP_PLUGIN_OPTIONS)
 
 enum tep_format_flags {
 	TEP_FIELD_IS_ARRAY	= 1,
diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index bbe87d4..8c48ccf 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -427,7 +427,6 @@ load_plugin(struct tep_handle *tep, const char *path,
 	    const char *file, void *data)
 {
 	struct tep_plugin_list **plugin_list = data;
-	struct tep_plugin_option *options;
 	tep_plugin_load_func func;
 	struct tep_plugin_list *list;
 	char *plugin;
@@ -447,16 +446,6 @@ load_plugin(struct tep_handle *tep, const char *path,
 		goto out_free;
 	}
 
-	options = dlsym(handle, TEP_PLUGIN_OPTIONS_NAME);
-	if (options) {
-		while (options->name) {
-			ret = update_option(file, options);
-			if (ret < 0)
-				goto out_free;
-			options++;
-		}
-	}
-
 	func = dlsym(handle, TEP_PLUGIN_LOADER_NAME);
 	if (!func) {
 		warning("could not find func '%s' in plugin '%s'\n%s\n",
-- 
2.24.1

