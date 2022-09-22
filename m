Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB623C6FA94
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 15:24:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbiIVPYQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Sep 2022 11:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbiIVPYM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Sep 2022 11:24:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF1AF8F8A
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 08:24:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AA1663621
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 15:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0163EC433C1;
        Thu, 22 Sep 2022 15:24:09 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1obO4d-00Dzl1-2I;
        Thu, 22 Sep 2022 11:25:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 7/9] libtraceevent: Add man page for tep_plugin_add_option()
Date:   Thu, 22 Sep 2022 11:25:08 -0400
Message-Id: <20220922152510.3335601-8-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220922152510.3335601-1-rostedt@goodmis.org>
References: <20220922152510.3335601-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The man page for tep_plugin_add_option() was missing, so add it.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtraceevent-plugins.txt | 9 ++++++++-
 Documentation/libtraceevent.txt         | 1 +
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtraceevent-plugins.txt b/Documentation/libtraceevent-plugins.txt
index 24d8ad84ef5c..4ca78d453d73 100644
--- a/Documentation/libtraceevent-plugins.txt
+++ b/Documentation/libtraceevent-plugins.txt
@@ -3,7 +3,8 @@ libtraceevent(3)
 
 NAME
 ----
-tep_load_plugins, tep_unload_plugins, tep_load_plugins_hook, tep_add_plugin_path - Load / unload traceevent plugins.
+tep_load_plugins, tep_unload_plugins, tep_load_plugins_hook, tep_add_plugin_path,
+tep_plugin_add_option - Load / unload traceevent plugins.
 
 SYNOPSIS
 --------
@@ -21,6 +22,7 @@ void *tep_load_plugins_hook*(struct tep_handle pass:[*]_tep_, const char pass:[*
 			   void pass:[*]_data_);
 int *tep_add_plugin_path*(struct tep_handle pass:[*]tep, char pass:[*]path,
 			  enum tep_plugin_load_priority prio);
+int *tep_plugin_add_option*(const char pass:[*]_name_, const char pass:[*]_val_);
 --
 
 DESCRIPTION
@@ -76,6 +78,11 @@ plugin wins. The priority can be:
 Where the plugins in TEP_PLUGIN_LAST" will take precedence over the
 plugins in the other directories.
 
+The *tep_plugin_add_option()* sets options defined by a plugin. The _name_ is the
+name of the option to set to _val_. Plugins can add options to change its behavior
+and *tep_plugin_add_option()* is used by the application to make those modifications.
+
+
 RETURN VALUE
 ------------
 The *tep_load_plugins()* function returns a list of successfully loaded plugins,
diff --git a/Documentation/libtraceevent.txt b/Documentation/libtraceevent.txt
index 6f342a8162d7..045437cb2282 100644
--- a/Documentation/libtraceevent.txt
+++ b/Documentation/libtraceevent.txt
@@ -45,6 +45,7 @@ Trace printk parsing:
 	void *tep_print_funcs*(struct tep_handle pass:[*]tep);
 	void *tep_set_test_filters*(struct tep_handle pass:[*]tep, int test_filters);
 	void *tep_plugin_print_options*(struct trace_seq pass:[*]s);
+	int *tep_plugin_add_option*(const char pass:[*]_name_, const char pass:[*]_val_);
 
 Meta data parsing:
 	int *tep_parse_saved_cmdlines*(struct tep_handle pass:[*]_tep_, const char pass:[*]_buf_);
-- 
2.35.1

