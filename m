Return-Path: <SRS0=vwyE=AG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C901C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jun 2020 10:05:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D54F206B7
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jun 2020 10:05:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ssHlncAz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390895AbgFYKFZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Jun 2020 06:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390891AbgFYKFY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Jun 2020 06:05:24 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EAE9C0613ED
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jun 2020 03:05:22 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id l2so3817042wmf.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jun 2020 03:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bovpBewt1CLAHKzR6yCJWnBBJD8ipwJkK5F7yOD1C/8=;
        b=ssHlncAz+bX2I7JH/+p1+nuSGzMCs1kwrh+/pKP31BwpK4T8jHNxStlC7SOpY6dJil
         9mA7xmSaTbXvltHX1WPXd+yXAolQ9XxIe157Q2PVfWCvjhInJyBODWvZlk2tWiACvv12
         FM4WCCpiPNmzgqlwY8I44ubgxzZrt+g2QS93HKFMHEaBh1G2uZuUIJloQASmczKAWekO
         dJIUXoFj2dtzIZH7cGAXIjseagM00jH2c7z+M/cfgsqm4OYgHqXgFfjEN9SQM95L8pe3
         AVvgFs3i/5MiUHtm0EP/n2dldsmLHKPAYkVCqCgTXryEI5qps1mcBlKCfbsTaUab3yoy
         /F8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bovpBewt1CLAHKzR6yCJWnBBJD8ipwJkK5F7yOD1C/8=;
        b=OGC1tOQ6WfVJomQC63gkBjWBrfdTLZM5p35r5fG9WdReGAb4/bpwFQwcZWFBDJEgSL
         1qRANU1/AQ8q3LWEFQCbF+b3+SOQPvN60+GFTkScY5GqS2VZeluD36R02Y0n4261wSR8
         uQkyP1zW++hDsOgi18kzbVsX4x/O/bD1B+B37FKolHvOHeSTxSuUjmbcelr7cZgyfaEy
         /5WDzTXgURZFY+8v+oWm7LhqU0KJ2cwYCZerezcxHlReUf+swshAofhUqw6MTafLO+Wd
         kwAW7BFjZyIg3Jz70TL0w3ADY0YwG4sHFuQSxQ1KyhyhTg3uAO+trzGF6Y8qUO5gP4+U
         eqRQ==
X-Gm-Message-State: AOAM531RpbOqAwmKZjgiKJWs1GGCf9+R7gE1E36rWYeNU0tuEa2Y9gES
        YcuKr7qaOE6LSIiXq8kuDLfRIKs/8/g=
X-Google-Smtp-Source: ABdhPJyiB1Gc+yamknRaO2aelv4yOqe/Rvy7xBL4vA/LcD3rLXsg0+ox+ueT/1A6z111rjkMhz4V/Q==
X-Received: by 2002:a1c:2146:: with SMTP id h67mr2598952wmh.46.1593079521422;
        Thu, 25 Jun 2020 03:05:21 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v7sm31268204wrp.45.2020.06.25.03.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 03:05:20 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 03/15] tools lib traceevent: Remove trace-cmd plugin handling routines
Date:   Thu, 25 Jun 2020 13:05:10 +0300
Message-Id: <20200625100516.365338-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200625100516.365338-1-tz.stoyanov@gmail.com>
References: <20200625100516.365338-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Currently there are no trace-cmd related plugins, all of them
are designed to be used with libtraceeevnt. As both libtraceevent
and trace-cmd have logic for managing plugins, the one in trace-cmd
is redundant. Those redundant code is removed and replaced with calls
to libtraceeevnt plugin APIs. When trace-cmd has to load any plugins,
it uses libtraceeevnt to do the job.

Removed trace-cmd functions:
  tracecmd_load_plugins()
  tracecmd_unload_plugins()
  trace_util_load_plugins()
  trace_util_read_plugin_options()
  trace_util_free_options()
  trace_util_print_plugins()
  trace_util_free_plugin_options_list()

A new libtraceevent API is added:
  tep_load_plugins_hook() - the local static
function load_plugins() is exposed as API, as this
functionality is needed be trace-cmd.

Link: http://lore.kernel.org/linux-trace-devel/20190802110101.14759-4-tz.stoyanov@gmail.com

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.h  |  6 ++++++
 tools/lib/traceevent/event-plugin.c | 19 +++++++++----------
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index b77837f75a0d..776c7c24ee79 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -396,6 +396,12 @@ struct tep_plugin_list;
 struct tep_plugin_list *tep_load_plugins(struct tep_handle *tep);
 void tep_unload_plugins(struct tep_plugin_list *plugin_list,
 			struct tep_handle *tep);
+void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
+			   void (*load_plugin)(struct tep_handle *tep,
+					       const char *path,
+					       const char *name,
+					       void *data),
+			   void *data);
 char **tep_plugin_list_options(void);
 void tep_plugin_free_options_list(char **list);
 int tep_plugin_add_options(const char *name,
diff --git a/tools/lib/traceevent/event-plugin.c b/tools/lib/traceevent/event-plugin.c
index e1f7ddd5a6cf..b53d9a53bcf9 100644
--- a/tools/lib/traceevent/event-plugin.c
+++ b/tools/lib/traceevent/event-plugin.c
@@ -365,20 +365,19 @@ load_plugins_dir(struct tep_handle *tep, const char *suffix,
 	closedir(dir);
 }
 
-static void
-load_plugins(struct tep_handle *tep, const char *suffix,
-	     void (*load_plugin)(struct tep_handle *tep,
-				 const char *path,
-				 const char *name,
-				 void *data),
-	     void *data)
+void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
+			   void (*load_plugin)(struct tep_handle *tep,
+					       const char *path,
+					       const char *name,
+					       void *data),
+			   void *data)
 {
 	char *home;
 	char *path;
 	char *envdir;
 	int ret;
 
-	if (tep->flags & TEP_DISABLE_PLUGINS)
+	if (tep && tep->flags & TEP_DISABLE_PLUGINS)
 		return;
 
 	/*
@@ -386,7 +385,7 @@ load_plugins(struct tep_handle *tep, const char *suffix,
 	 * check that first.
 	 */
 #ifdef PLUGIN_DIR
-	if (!(tep->flags & TEP_DISABLE_SYS_PLUGINS))
+	if (!tep || !(tep->flags & TEP_DISABLE_SYS_PLUGINS))
 		load_plugins_dir(tep, suffix, PLUGIN_DIR,
 				 load_plugin, data);
 #endif
@@ -423,7 +422,7 @@ tep_load_plugins(struct tep_handle *tep)
 {
 	struct tep_plugin_list *list = NULL;
 
-	load_plugins(tep, ".so", load_plugin, &list);
+	tep_load_plugins_hook(tep, ".so", load_plugin, &list);
 	return list;
 }
 
-- 
2.26.2

