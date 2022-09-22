Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE90C6FA93
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 15:24:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbiIVPYR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Sep 2022 11:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbiIVPYN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Sep 2022 11:24:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89DBDF8C07
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 08:24:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D358B8384D
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 15:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C30C433B5;
        Thu, 22 Sep 2022 15:24:08 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1obO4d-00Dzkv-2B;
        Thu, 22 Sep 2022 11:25:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5/9] libtraceevent: Include meta data functions in libtraceevent man pages
Date:   Thu, 22 Sep 2022 11:25:06 -0400
Message-Id: <20220922152510.3335601-6-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220922152510.3335601-1-rostedt@goodmis.org>
References: <20220922152510.3335601-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add the functions to parse the metadata printk_formats, kallsyms and
saved_cmdlines to the generic libtraceevent man page.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtraceevent.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/libtraceevent.txt b/Documentation/libtraceevent.txt
index 06abaf7a6b74..77b50362cdb8 100644
--- a/Documentation/libtraceevent.txt
+++ b/Documentation/libtraceevent.txt
@@ -46,6 +46,11 @@ Trace printk parsing:
 	void *tep_set_test_filters*(struct tep_handle pass:[*]tep, int test_filters);
 	void *tep_plugin_print_options*(struct trace_seq pass:[*]s);
 
+Meta data parsing:
+	int *tep_parse_saved_cmdlines*(struct tep_handle pass:[*]_tep_, const char pass:[*]_buf_);
+	int *tep_parse_printk_formats*(struct tep_handle pass:[*]_tep_, const char pass:[*]_buf_);
+	int *tep_parse_kallsyms*(struct tep_handle pass:[*]_tep_, const char pass:[*]_buf_);
+
 Plugins management:
 	struct tep_plugin_list pass:[*]*tep_load_plugins*(struct tep_handle pass:[*]_tep_);
 	void *tep_unload_plugins*(struct tep_plugin_list pass:[*]_plugin_list_, struct tep_handle pass:[*]_tep_);
-- 
2.35.1

