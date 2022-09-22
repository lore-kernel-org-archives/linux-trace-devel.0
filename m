Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B2F0C6FA82
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 15:24:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbiIVPYU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Sep 2022 11:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232101AbiIVPYO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Sep 2022 11:24:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BDF0F8F8F
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 08:24:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CE7863622
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 15:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BFAFC4347C;
        Thu, 22 Sep 2022 15:24:09 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1obO4d-00Dzky-2F;
        Thu, 22 Sep 2022 11:25:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6/9] libtraceevent: Add some missing functions to generic libtraceevent man page
Date:   Thu, 22 Sep 2022 11:25:07 -0400
Message-Id: <20220922152510.3335601-7-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220922152510.3335601-1-rostedt@goodmis.org>
References: <20220922152510.3335601-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add tep_load_plugins_hook() and tep_add_plugin_path() to the generic
libtraceevent man page.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtraceevent.txt | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/libtraceevent.txt b/Documentation/libtraceevent.txt
index 77b50362cdb8..6f342a8162d7 100644
--- a/Documentation/libtraceevent.txt
+++ b/Documentation/libtraceevent.txt
@@ -59,6 +59,14 @@ Plugins management:
 	int *tep_plugin_add_options*(const char pass:[*]_name_, struct tep_plugin_option pass:[*]_options_);
 	void *tep_plugin_remove_options*(struct tep_plugin_option pass:[*]_options_);
 	void *tep_print_plugins*(struct trace_seq pass:[*]_s_, const char pass:[*]_prefix_, const char pass:[*]_suffix_, const struct tep_plugin_list pass:[*]_list_);
+	void *tep_load_plugins_hook*(struct tep_handle pass:[*]_tep_, const char pass:[*]_suffix_,
+			   void (pass:[*]_load_plugin_)(struct tep_handle pass:[*]tep,
+					       const char pass:[*]path,
+					       const char pass:[*]name,
+					       void pass:[*]data),
+			   void pass:[*]_data_);
+	int *tep_add_plugin_path*(struct tep_handle pass:[*]tep, char pass:[*]path,
+			  enum tep_plugin_load_priority prio);
 
 Event related APIs:
 	struct tep_event pass:[*]*tep_get_event*(struct tep_handle pass:[*]_tep_, int _index_);
-- 
2.35.1

