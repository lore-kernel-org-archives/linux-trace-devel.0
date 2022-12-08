Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C65AC4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Dec 2022 23:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbiLHXXV convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 18:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbiLHXWs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 18:22:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF329D8B3
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Dec 2022 15:21:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A536620BA
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Dec 2022 23:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8BBC433D2
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Dec 2022 23:21:48 +0000 (UTC)
Date:   Thu, 8 Dec 2022 18:21:46 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Add tep_find_function_info() to main
 libtraceevent man page
Message-ID: <20221208182146.57a87503@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From b552d3ac89c81c22c236086fb8d69c6fbbb51ffb Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Date: Thu, 8 Dec 2022 18:20:43 -0500
Subject: [PATCH] libtraceevent: Add tep_find_function_info() to main
 libtraceevent man page

The prototype of tep_find_function_info() was missing from the main
libtraceevent man page. Add it.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtraceevent.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/libtraceevent.txt b/Documentation/libtraceevent.txt
index 488e689f6c85..442a394d1204 100644
--- a/Documentation/libtraceevent.txt
+++ b/Documentation/libtraceevent.txt
@@ -116,6 +116,8 @@ Functions resolver:
 	void *tep_reset_function_resolver*(struct tep_handle pass:[*]_tep_);
 	const char pass:[*]*tep_find_function*(struct tep_handle pass:[*]_tep_, unsigned long long _addr_);
 	unsigned long long *tep_find_function_address*(struct tep_handle pass:[*]_tep_, unsigned long long _addr_);
+	int *tep_find_function_info*(struct tep_handle pass:[*]_tep_, unsigned long long _addr_, const char pass:[**]_name_,
+			   unsigned long long pass:[*]_start_, unsigned long pass:[*]_size_);
 
 Filter management:
 	struct tep_event_filter pass:[*]*tep_filter_alloc*(struct tep_handle pass:[*]_tep_);
-- 
2.35.1

