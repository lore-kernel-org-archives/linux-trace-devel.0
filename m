Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20116C54EE9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 15:24:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbiIVPYP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Sep 2022 11:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbiIVPYM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Sep 2022 11:24:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C50F8F86
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 08:24:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A9286361D
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 15:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D83C433D7;
        Thu, 22 Sep 2022 15:24:08 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1obO4d-00Dzkp-23;
        Thu, 22 Sep 2022 11:25:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 3/9] libtraceevent: Add printk documentation to libtraceevent man page
Date:   Thu, 22 Sep 2022 11:25:04 -0400
Message-Id: <20220922152510.3335601-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220922152510.3335601-1-rostedt@goodmis.org>
References: <20220922152510.3335601-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add the parsing of trace_printk() to the generic documentation page.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtraceevent.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/libtraceevent.txt b/Documentation/libtraceevent.txt
index 6476070737f5..4fe8939788a5 100644
--- a/Documentation/libtraceevent.txt
+++ b/Documentation/libtraceevent.txt
@@ -39,6 +39,12 @@ Register / unregister APIs:
 	int *tep_register_print_function*(struct tep_handle pass:[*]_tep_, tep_func_handler _func_, enum tep_func_arg_type _ret_type_, char pass:[*]_name_, _..._);
 	int *tep_unregister_print_function*(struct tep_handle pass:[*]_tep_, tep_func_handler _func_, char pass:[*]_name_);
 
+Trace printk parsing:
+	void *tep_print_printk*(struct tep_handle pass:[*]tep);
+	void *tep_print_funcs*(struct tep_handle pass:[*]tep);
+	void *tep_set_test_filters*(struct tep_handle pass:[*]tep, int test_filters);
+	void *tep_plugin_print_options*(struct trace_seq pass:[*]s);
+
 Plugins management:
 	struct tep_plugin_list pass:[*]*tep_load_plugins*(struct tep_handle pass:[*]_tep_);
 	void *tep_unload_plugins*(struct tep_plugin_list pass:[*]_plugin_list_, struct tep_handle pass:[*]_tep_);
-- 
2.35.1

