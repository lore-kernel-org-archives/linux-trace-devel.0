Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80751C54EE9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Sep 2022 15:43:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbiIVPnR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Sep 2022 11:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbiIVPnP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Sep 2022 11:43:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2547FE078
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 08:43:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35D2FB83892
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Sep 2022 15:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6248C433C1;
        Thu, 22 Sep 2022 15:43:10 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1obON3-00Dztg-2j;
        Thu, 22 Sep 2022 11:44:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 1/2] libtracefs: Add tracefs_debug_dir() to generic libtracefs man page
Date:   Thu, 22 Sep 2022 11:44:11 -0400
Message-Id: <20220922154412.3336173-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220922154412.3336173-1-rostedt@goodmis.org>
References: <20220922154412.3336173-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The function tracefs_debug_dir() was missing from the generic libtracefs
man page. Add it.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/libtracefs.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 986557b6279c..470813d5cb40 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -15,6 +15,7 @@ Locations of tracing files and directories:
 	char pass:[*]*tracefs_get_tracing_file*(const char pass:[*]_name_);
 	void *tracefs_put_tracing_file*(char pass:[*]_name_);
 	const char pass:[*]*tracefs_tracing_dir*(void);
+	const char pass:[*]*tracefs_debug_dir*(void);
 	int *tracefs_set_tracing_dir*(char pass:[*]_tracing_dir_)
 
 Trace instances:
-- 
2.35.1

