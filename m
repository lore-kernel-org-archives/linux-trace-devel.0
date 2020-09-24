Return-Path: <SRS0=Qydk=DB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C303C4346E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Sep 2020 08:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46B2A23772
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Sep 2020 08:57:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A6M/kkMK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbgIXI5b (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Sep 2020 04:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgIXI5a (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Sep 2020 04:57:30 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899B2C0613CE
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Sep 2020 01:57:30 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id j2so2887892wrx.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Sep 2020 01:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DD7DzH+1uZHiL1ja2Xj2Qul/zGwrkIhGowK81J16h9k=;
        b=A6M/kkMK5jiLdxBQ2+W0869GsrB593CCTXIV3sDsAN53BVboKesAet+xwc/F5gtUwd
         8BwNQth+JeexT69lEbmjbeT1IbXohgpM/sKvyD1uq7t70gbGJHjP3MR41MzovgYEAye4
         Fh+6jWeIQe+RR1poqqSQSJ+LUFmev+0ah1w90a+jdds1wEPKmEYRdkvBbxatWQ5ve3lt
         i1Im10pj0+rmSb9Mr6dsWwnfWORVPIBMtQI4VuuuifQ6S8zUyQftyr3mx/8EW02zCAzz
         32DlEcPBbk6+Y3N1QNKpRa9aA+mUlKjkIUrv6zhk47prNpPGVEZA2QxJtSKMU+3RTj5d
         nzdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DD7DzH+1uZHiL1ja2Xj2Qul/zGwrkIhGowK81J16h9k=;
        b=lF33V+bzQ07ME5ADJdMtjHVjGZqQI1cDjLRr2+kRIlvUWSKPy4S5HQzg775h2yyowU
         8CUnPG4neMpoJcDuQ4j8LbrCx5u+3iJMJI4QpudtO6mxrN1XLNQ2Ao4ZyPlir2cvQyfg
         lbYN8czEovpTiI5e/1ErEVUCZmD/gEe7x3vHOcSDAEXfXFl2vU5qiUjAfXvQBY23So/9
         67UjNTliKqr6IMYAlz8m2Egd11ISzFyHeYDZnyJci0fLz1pcgtaZZmViUixd8bl6Qzgl
         DacRvOlTnQVLK572HWLf91APsFrMxiJe5Pislz/QXVIEQ0yrli28JfPRGiaD0ie0cGSO
         g0Cw==
X-Gm-Message-State: AOAM532uYeKPRcKewdelllBYT5m4Cy1wwpKCByqR3hE/Nk2jiTNhIR1v
        9O1paAeUMsZPgzuqpUN7AD7k0rTsMZBKoA==
X-Google-Smtp-Source: ABdhPJzurGZaRM4TM1nUFImYf2308pZT9DFC6Y2mdaGDJNi2WuhXGuCEVo71+kVf3zStCF7D8YGiAg==
X-Received: by 2002:a5d:470e:: with SMTP id y14mr3916219wrq.354.1600937849228;
        Thu, 24 Sep 2020 01:57:29 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u17sm3062385wri.45.2020.09.24.01.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 01:57:28 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] tools lib traceevent: Man page for tep_add_plugin_path() API
Date:   Thu, 24 Sep 2020 11:57:26 +0300
Message-Id: <20200924085726.112758-1-tz.stoyanov@gmail.com>
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

