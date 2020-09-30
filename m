Return-Path: <SRS0=+svU=DH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88337C4727E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Sep 2020 11:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C80320709
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Sep 2020 11:20:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DL+OOTzW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbgI3LU2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Sep 2020 07:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729268AbgI3LU1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Sep 2020 07:20:27 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6AEC061755;
        Wed, 30 Sep 2020 04:20:27 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id e2so1330243wme.1;
        Wed, 30 Sep 2020 04:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FHqS4T2vGgN4ivt95AoBTsDaPfnjn41/2ahIzPZ2LPg=;
        b=DL+OOTzWysHURoloxs3LkplMURrusLwQkaocQ3+iV6I7ytApFrLd412iAvdWUiD/XT
         ibbltAMMIYIqUwjtL7FShLkfh2qjFSW8eMV1SedB0gbWwOpwBehMoaUb8rnio2Ej5TyY
         kCjEA4oamvfOzg6wzFpevxxXBQua2i9S4OgPedtRMEBVNNH0CW/14sVrcgi3wvu66yKu
         jHKsCT9/RMk21fzj9FX8byD4dODC7nhI0rJ/GEB5tLqlXSFziybW5p29ApSwAGvKLhZB
         hMFF1DlGhFzCFnioxElyQOkYIbOaWKQTXn5PYR0Oxqiw5TsvPLKK5C1yE0ZHAcKcEBS3
         2MDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FHqS4T2vGgN4ivt95AoBTsDaPfnjn41/2ahIzPZ2LPg=;
        b=QCIPvd6BCmXYBT5Rp2jD5SCJXhfZkF5pYegBU2SKPC8nEBtb49NhXLrYRcdW4Sf8FX
         MNRSTzn50AydOCNRTmA9/bYBHWBJBiT2EJS1tVouq3YBaDgym28OEVd7wlfbYwWvWC36
         JnRer1AnHf2cbp/iobUeVc/A9pHPA6M8c0YVeC7PtlejyyxJn7wxcS7L8tQypmGoXaBT
         LATTPybwihraS/FG4MZ3HKVnA0eH/pphYFiT9ET6KsutpWvXkchmSiO5HL4XYF+7SpPg
         vXjAJvmXBD5l2Nig2JuHLtHNWKO0byCZONBm8vvi++CBZxBtGl4P5KrxKgiHd3U094F/
         ggyw==
X-Gm-Message-State: AOAM531VRn3gLzZBExD6RZQPM40F4Jz5PynhMFazXZKTMsukbeqJB9+f
        kw34OYZWLdqbFBbNVnXYUZs=
X-Google-Smtp-Source: ABdhPJw6unAiTppXW1wLC3ZYUCQMnPg0I0+3kVB6mW4b5fmm8JAHgoZ7OarBMUqFneta+sHOx1K9cA==
X-Received: by 2002:a05:600c:22cf:: with SMTP id 15mr2487729wmg.146.1601464826096;
        Wed, 30 Sep 2020 04:20:26 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i16sm2387553wrq.73.2020.09.30.04.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 04:20:25 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     arnaldo.melo@gmail.com
Cc:     rostedt@goodmis.org, mtk.manpages@gmail.com,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] tools lib traceevent: Man page for tep_add_plugin_path() API
Date:   Wed, 30 Sep 2020 14:20:23 +0300
Message-Id: <20200930112023.281975-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add documentation of tep_add_plugin_path() API in the libtraceevent
plugin man page.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
v2 changes:
 - Fixed grammar mistakes, found by Steven Rostedt.

 .../Documentation/libtraceevent-plugins.txt   | 25 +++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt b/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt
index 4d6394397d92..4b7ac5c5217b 100644
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
@@ -52,16 +54,33 @@ _tep_load_plugins()_. The _tep_ argument is trace event parser context. The
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
+for the plugins from the new directories to be loaded. The _tep_ argument is
+the trace event parser context. The _path_ is the full path to the new plugin
+directory. The _prio_ argument specifies the loading priority order for the
+new directory of plugins. The loading priority is important in case of different
+versions of the same plugin located in multiple plugin directories.The last loaded
+plugin wins. The priority can be:
+[verse]
+--
+	_TEP_PLUGIN_FIRST_	- Load plugins from this directory first
+	_TEP_PLUGIN_LAST_	- Load plugins from this directory last
+--
+Where the plugins in TEP_PLUGIN_LAST" will take precedence over the
+plugins in the other directories.
+
 RETURN VALUE
 ------------
 The _tep_load_plugins()_ function returns a list of successfully loaded plugins,
 or NULL in case no plugins are loaded.
+The _tep_add_plugin_path()_ function returns -1 in case of an error, 0 otherwise.
 
 EXAMPLE
 -------
@@ -71,6 +90,8 @@ EXAMPLE
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

