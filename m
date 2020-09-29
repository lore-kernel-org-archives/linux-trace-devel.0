Return-Path: <SRS0=wnl5=DG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95B50C4727C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 17:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 248C52076B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 17:36:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PgkQvlXi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgI2Rgf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Sep 2020 13:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727328AbgI2Rgf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 13:36:35 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51593C061755;
        Tue, 29 Sep 2020 10:36:35 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id v12so5680241wmh.3;
        Tue, 29 Sep 2020 10:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DD7DzH+1uZHiL1ja2Xj2Qul/zGwrkIhGowK81J16h9k=;
        b=PgkQvlXipDTpEnANT7Tzruij6z1vuJcMUPyUPhnqrDkQq9qvG1xRADMjx+7bxlOLuh
         oWRMOek/8yZ5FTzOVm2++La1fyr+YcTuWX6pV9jRu6ilFXZYKdnUo7IJ9T+RAYQlxIbB
         3/I++f8hN+IhofkBp7YhXsX2wrcc1I+fHdJoScCtX6jzdWEgMnQnQ0AZO2ZSmMUWKl0b
         COeDzsPR4p2NXhQ4+wDfvvODbCqiSvEm/Wh/9ilF3gmQHB916Db3gsLr0e94AW1VJdLd
         UNkmW8Nk/0oxLBp77Ir1dqY6qO/KZvqhQxO3Kip2yVKcm6IyNxD7dZ5T9olBVH0kA9cO
         Ymgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DD7DzH+1uZHiL1ja2Xj2Qul/zGwrkIhGowK81J16h9k=;
        b=TDTH2k8JegIQIe4j0tfsUja+JuXWp7FxfoYhC9zifWD5utHSKZPIy+lrZjiHzpVf+a
         QYS7OhxfWaW1eoyAxN0WiRl+OeVfGdCPi6Hz+bHBiNhnpCB78NdsHtuj4+j2BhkVwgjb
         U+kKqykneEZAxAc5P0KY6xMwhoTq/1ujMzaIR4n/Odfr1garmk6IeXcMOGhGPQJHsqCO
         5MfrGb+9il7pYmxXxhjPbiIZCE+Aj11GAANICyBdOyxV8bzju1HVhcmmd2pBx25RtSHa
         QQQYxtTO8LcShYT4JDGX6VENHPa5W0EjGDqs99PFjB6oEP2Qe9QpwbN3vWSApaZ8nkq6
         VBjw==
X-Gm-Message-State: AOAM533ElSz8jAkQunqHXcDv4HD2EBrLOR91/9uTXiUMfGBfxBT/VLju
        /JmUuUkWM0DTmaAOXt7XE9dYjI2bhSMaJBG+
X-Google-Smtp-Source: ABdhPJxznl1PXXAp2qD2o7ffI3O+KjVr+g0JtxlqvyMvGFJZU2zOaGBrg/RDhOs5wcOR6pa0RjYKmg==
X-Received: by 2002:a1c:2c0a:: with SMTP id s10mr5762516wms.103.1601400994002;
        Tue, 29 Sep 2020 10:36:34 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q20sm6197394wmj.5.2020.09.29.10.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 10:36:33 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     arnaldo.melo@gmail.com
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] tools lib traceevent: Man page for tep_add_plugin_path() API
Date:   Tue, 29 Sep 2020 20:36:32 +0300
Message-Id: <20200929173632.252076-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add documentation of tep_add_plugin_path() API in the libtraceevent plugin man page.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../Documentation/libtraceevent-plugins.txt   | 22 +++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt b/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt
index 4d6394397d92..e584b8c777ad 100644
--- a/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt
+++ b/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt
@@ -3,7 +3,7 @@ libtraceevent(3)
 
 NAME
 ----
-tep_load_plugins, tep_unload_plugins, tep_load_plugins_hook - Load / unload traceevent plugins.
+tep_load_plugins, tep_unload_plugins, tep_load_plugins_hook, tep_add_plugin_path - Load / unload traceevent plugins.
 
 SYNOPSIS
 --------
@@ -19,6 +19,8 @@ void *tep_load_plugins_hook*(struct tep_handle pass:[*]_tep_, const char pass:[*
 					       const char pass:[*]name,
 					       void pass:[*]data),
 			   void pass:[*]_data_);
+int *tep_add_plugin_path*(struct tep_handle pass:[*]tep, char pass:[*]path,
+			  enum tep_plugin_load_priority prio);
 --
 
 DESCRIPTION
@@ -52,16 +54,30 @@ _tep_load_plugins()_. The _tep_ argument is trace event parser context. The
 _plugin_list_ is the list of loaded plugins, returned by
 the _tep_load_plugins()_ function.
 
-The _tep_load_plugins_hook_ function walks through all directories with plugins
+The _tep_load_plugins_hook()_ function walks through all directories with plugins
 and calls user specified _load_plugin()_ hook for each plugin file. Only files
 with given _suffix_ are considered to be plugins. The _data_ is a user specified
 context, passed to _load_plugin()_. Directories and the walk order are the same
 as in _tep_load_plugins()_ API.
 
+The _tep_add_plugin_path()_ functions adds additional directories with plugins in
+the _tep_->plugins_dir list. It must be called before _tep_load_plugins()_ in order
+the plugins from the new directories to be loaded. The _tep_ argument is trace event
+parser context. The _path_ is the full path to the new plugin directory. The _prio_
+argument specifies the loading priority of plugins from the new directory. The loading
+priority is important in case of different versions of the same plugin located in
+multiple plugin directories.The last loaded plugin wins. The priority can be:
+[verse]
+--
+	_TEP_PLUGIN_FIRST_	- Load plugins from this directory first
+	_TEP_PLUGIN_LAST_	- Load plugins from this directory last
+--
+
 RETURN VALUE
 ------------
 The _tep_load_plugins()_ function returns a list of successfully loaded plugins,
 or NULL in case no plugins are loaded.
+The _tep_add_plugin_path()_ function returns -1 in case of an error, 0 otherwise.
 
 EXAMPLE
 -------
@@ -71,6 +87,8 @@ EXAMPLE
 ...
 struct tep_handle *tep = tep_alloc();
 ...
+tep_add_plugin_path(tep, "~/dev_plugins", TEP_PLUGIN_LAST);
+...
 struct tep_plugin_list *plugins = tep_load_plugins(tep);
 if (plugins == NULL) {
 	/* no plugins are loaded */
-- 
2.26.2

