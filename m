Return-Path: <SRS0=bLRU=W4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E2F2C3A5A4
	for <linux-trace-devel@archiver.kernel.org>; Sun,  1 Sep 2019 12:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E51C623429
	for <linux-trace-devel@archiver.kernel.org>; Sun,  1 Sep 2019 12:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567340797;
	bh=o10V2pXCtZUxkcUZXrySKodK+RykJQdeuRI8Jp2uTl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=UODZ0oglRSrMkVCFtoshMRFvUWKU9oLuZxqNwcpFiCFCrvZHH7RLd5NFfmkYYIOU0
	 OVuJyhhV0LdhX3B99mqd3cnq0LPccU9CkI51MMie4MpYsfbmQLK3qF56WT2mNO2tOg
	 5VQSyT5Tt6Mc342dMVyR+eCrY3mb7CtWbatk3qmo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbfIAMYl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 1 Sep 2019 08:24:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729090AbfIAMYl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 1 Sep 2019 08:24:41 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.35.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DF282342E;
        Sun,  1 Sep 2019 12:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567340680;
        bh=o10V2pXCtZUxkcUZXrySKodK+RykJQdeuRI8Jp2uTl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LbmMbWNRNST3nECHCdfHyj+pysVwHY3bHSyq6Dzmn0n8VxeA8VhTiUxaWqyZ/0/JS
         vYQm6s0GLOUyvGHnKzkiTYaFKQAgesMTFACiM3VAXU8qo7evCl2rHPwu2AO3sxBfB6
         GD4gdYglSqIwTu8d4YZEEsNoBtPJC+VjrsJpM4n8=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Patrick McLean <chutzpah@gentoo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 21/47] libtraceevent: Change users plugin directory
Date:   Sun,  1 Sep 2019 09:23:00 -0300
Message-Id: <20190901122326.5793-22-acme@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190901122326.5793-1-acme@kernel.org>
References: <20190901122326.5793-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

To be compliant with XDG user directory layout, the user's plugin
directory is changed from ~/.traceevent/plugins to
~/.local/lib/traceevent/plugins/

Suggested-by: Patrick McLean <chutzpah@gentoo.org>
Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Patrick McLean <chutzpah@gentoo.org>
Cc: linux-trace-devel@vger.kernel.org
Link: https://lore.kernel.org/linux-trace-devel/20190313144206.41e75cf8@patrickm/
Link: http://lore.kernel.org/linux-trace-devel/20190801074959.22023-4-tz.stoyanov@gmail.com
Link: http://lore.kernel.org/lkml/20190805204355.344622683@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Makefile       | 6 +++---
 tools/lib/traceevent/event-plugin.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 8352d53dcb5a..a39cdd0d890d 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -62,15 +62,15 @@ set_plugin_dir := 1
 
 # Set plugin_dir to preffered global plugin location
 # If we install under $HOME directory we go under
-# $(HOME)/.traceevent/plugins
+# $(HOME)/.local/lib/traceevent/plugins
 #
 # We dont set PLUGIN_DIR in case we install under $HOME
 # directory, because by default the code looks under:
-# $(HOME)/.traceevent/plugins by default.
+# $(HOME)/.local/lib/traceevent/plugins by default.
 #
 ifeq ($(plugin_dir),)
 ifeq ($(prefix),$(HOME))
-override plugin_dir = $(HOME)/.traceevent/plugins
+override plugin_dir = $(HOME)/.local/lib/traceevent/plugins
 set_plugin_dir := 0
 else
 override plugin_dir = $(libdir)/traceevent/plugins
diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index 8ca28de9337a..e1f7ddd5a6cf 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -18,7 +18,7 @@
 #include "event-utils.h"
 #include "trace-seq.h"
 
-#define LOCAL_PLUGIN_DIR ".traceevent/plugins"
+#define LOCAL_PLUGIN_DIR ".local/lib/traceevent/plugins/"
 
 static struct registered_plugin_options {
 	struct registered_plugin_options	*next;
-- 
2.21.0

