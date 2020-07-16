Return-Path: <SRS0=576e=A3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FE7CC433E2
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jul 2020 09:19:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CF0E20775
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jul 2020 09:19:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P1iDkA23"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgGPJTa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Jul 2020 05:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbgGPJT3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Jul 2020 05:19:29 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37057C061755
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jul 2020 02:19:29 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id h28so4255107edz.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jul 2020 02:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AvdrCYaja6El0tIcdXmkEmAN0iDUN7i43Om0l/9Yck0=;
        b=P1iDkA23eB110Cj/JIfO4lHv/azaXX5d2pPXn+cqTnR3+byCljWHW0WmIMGiRqvw9K
         4kUe1uco/Wxul0JXSagsPzUOHzjY63yRXkBiAl4nENfbGqrMb+u7833sjYRF7UYzWoF/
         O+ekY5SVBq0aWV+Du7VTjTVt8dH+HqPtJAy4rt0e7sqrdK/++fGyHW8iArG16/63uKPj
         DXQoeaK/jgkruguDREuZ1Xdjgq/BzxLSixzL83JWGBasNV9y8wbw+QZDVdcVv/uiowrx
         P/xSCZ3ZSdj5pXGPKrVjSPY+xx4mPzpoRkTzdWT8jIv76wxGWb2FENsQP2m8WzcVSa6M
         hTBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AvdrCYaja6El0tIcdXmkEmAN0iDUN7i43Om0l/9Yck0=;
        b=P+CXO3fcNFYUe3oOa11KOf6evAKMyOSwae1jKTbIVY9PgrY3E+VudF/8MQnq+rvz+i
         VjI3J79OYOhaDhUteY4wc+0bjhPFA+f6hKcEazc+hdmA+ZUOLGPTYow7q28LPOg9eZYv
         hDFfhi2Ae3oO0dxKcbFbjtM5gFlxObQKTHPEofit7jgzjOdHuERIpwbdhbTMi0bn4o9M
         1S5Yo6KuKFBd5OWSZ58789ahNpq0LMOd7lVJFbHs7pExm5sFg2ggi3GC9kavU63oTBLQ
         n/VMIay8vn91qlA/88R32pzcO5MO02VK//+ih2kR/BiQ8T1os77cN4uTVfBJk9txprG0
         kOsA==
X-Gm-Message-State: AOAM531lsHXl0eehgs50AnGxoUp5FFcHhhhmaP2oSzPdZ20OJ4eeIkJy
        qtfloFsFuKCIN4QA4VbJqAhWWAvPRvg=
X-Google-Smtp-Source: ABdhPJwyt+hvJjaFGzX2GccHJ0kIUFB94LvKMLhTA+fCctyyM1xuht27XiGn7uKy2L7YhZdiBmfFtQ==
X-Received: by 2002:a50:9e02:: with SMTP id z2mr3452157ede.87.1594891167823;
        Thu, 16 Jul 2020 02:19:27 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x9sm4431534ejw.28.2020.07.16.02.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 02:19:27 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/8] tools lib traceevent: Document tep_load_plugins_hook()
Date:   Thu, 16 Jul 2020 12:19:16 +0300
Message-Id: <20200716091923.2613228-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716091923.2613228-1-tz.stoyanov@gmail.com>
References: <20200716091923.2613228-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add description of tep_load_plugins_hook() traceevent API. Updated
library man pages with description of the tep_load_plugins_hook() API.

Link: https://lore.kernel.org/r/CAM9d7cgLBWCrEHwz+Lhv5x5EXGcNWB0QQoeGh3OKh2JfR=dV9Q@mail.gmail.com
Link: https://lore.kernel.org/linux-trace-devel/20200714103027.2477584-2-tz.stoyanov@gmail.com

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 .../Documentation/libtraceevent-plugins.txt   | 25 ++++++++++++++++++-
 tools/lib/traceevent/event-plugin.c           | 16 ++++++++++++
 2 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt b/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt
index 596032ade31f..4d6394397d92 100644
--- a/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt
+++ b/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt
@@ -3,7 +3,7 @@ libtraceevent(3)
 
 NAME
 ----
-tep_load_plugins, tep_unload_plugins - Load / unload traceevent plugins.
+tep_load_plugins, tep_unload_plugins, tep_load_plugins_hook - Load / unload traceevent plugins.
 
 SYNOPSIS
 --------
@@ -13,6 +13,12 @@ SYNOPSIS
 
 struct tep_plugin_list pass:[*]*tep_load_plugins*(struct tep_handle pass:[*]_tep_);
 void *tep_unload_plugins*(struct tep_plugin_list pass:[*]_plugin_list_, struct tep_handle pass:[*]_tep_);
+void *tep_load_plugins_hook*(struct tep_handle pass:[*]_tep_, const char pass:[*]_suffix_,
+			   void (pass:[*]_load_plugin_)(struct tep_handle pass:[*]tep,
+					       const char pass:[*]path,
+					       const char pass:[*]name,
+					       void pass:[*]data),
+			   void pass:[*]_data_);
 --
 
 DESCRIPTION
@@ -22,11 +28,13 @@ directories. The _tep_ argument is trace event parser context.
 The plugin directories are :
 [verse]
 --
+	- Directories, specified in _tep_->plugins_dir with priority TEP_PLUGIN_FIRST
 	- System's plugin directory, defined at the library compile time. It
 	  depends on the library installation prefix and usually is
 	  _(install_preffix)/lib/traceevent/plugins_
 	- Directory, defined by the environment variable _TRACEEVENT_PLUGIN_DIR_
 	- User's plugin directory, located at _~/.local/lib/traceevent/plugins_
+	- Directories, specified in _tep_->plugins_dir with priority TEP_PLUGIN_LAST
 --
 Loading of plugins can be controlled by the _tep_flags_, using the
 _tep_set_flag()_ API:
@@ -44,6 +52,12 @@ _tep_load_plugins()_. The _tep_ argument is trace event parser context. The
 _plugin_list_ is the list of loaded plugins, returned by
 the _tep_load_plugins()_ function.
 
+The _tep_load_plugins_hook_ function walks through all directories with plugins
+and calls user specified _load_plugin()_ hook for each plugin file. Only files
+with given _suffix_ are considered to be plugins. The _data_ is a user specified
+context, passed to _load_plugin()_. Directories and the walk order are the same
+as in _tep_load_plugins()_ API.
+
 RETURN VALUE
 ------------
 The _tep_load_plugins()_ function returns a list of successfully loaded plugins,
@@ -63,6 +77,15 @@ if (plugins == NULL) {
 }
 ...
 tep_unload_plugins(plugins, tep);
+...
+void print_plugin(struct tep_handle *tep, const char *path,
+		  const char *name, void *data)
+{
+	pritnf("Found libtraceevent plugin %s/%s\n", path, name);
+}
+...
+tep_load_plugins_hook(tep, ".so", print_plugin, NULL);
+...
 --
 
 FILES
diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index 1d4f1809cf17..aa6f43290cd3 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -543,6 +543,22 @@ load_plugins_dir(struct tep_handle *tep, const char *suffix,
 	closedir(dir);
 }
 
+/**
+ * tep_load_plugins_hook - call a user specified callback to load a plugin
+ * @tep: handler to traceevent context
+ * @suffix: filter only plugin files with given suffix
+ * @load_plugin: user specified callback, called for each plugin file
+ * @data: custom context, passed to @load_plugin
+ *
+ * Searches for traceevent plugin files and calls @load_plugin for each
+ * The order of plugins search is:
+ *  - Directories, specified in @tep->plugins_dir and priority TEP_PLUGIN_FIRST
+ *  - Directory, specified at compile time with PLUGIN_TRACEEVENT_DIR
+ *  - Directory, specified by environment variable TRACEEVENT_PLUGIN_DIR
+ *  - In user's home: ~/.local/lib/traceevent/plugins/
+ *  - Directories, specified in @tep->plugins_dir and priority TEP_PLUGIN_LAST
+ *
+ */
 void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
 			   void (*load_plugin)(struct tep_handle *tep,
 					       const char *path,
-- 
2.26.2

