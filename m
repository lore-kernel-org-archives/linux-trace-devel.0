Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DD01C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Dec 2022 00:16:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiLIAQI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 19:16:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiLIAPl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 19:15:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9A09419F
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Dec 2022 16:15:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50956B826B7
        for <linux-trace-devel@vger.kernel.org>; Fri,  9 Dec 2022 00:15:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C404BC433D2
        for <linux-trace-devel@vger.kernel.org>; Fri,  9 Dec 2022 00:15:15 +0000 (UTC)
Date:   Thu, 8 Dec 2022 19:15:14 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtraceevent: Update gitignore
Message-ID: <20221208191514.47b40ca1@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Update the .gitignore file with the following items:

For quilt:
  .pc
  patches

Editors:
 .#*

Generated:
 libtraceevent.pc
 lib/

Generated in utest:
 trace-utest

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 .gitignore       | 5 +++++
 utest/.gitignore | 1 +
 2 files changed, 6 insertions(+)
 create mode 100644 utest/.gitignore

diff --git a/.gitignore b/.gitignore
index e203d72beadf..39a013b29343 100644
--- a/.gitignore
+++ b/.gitignore
@@ -2,12 +2,17 @@
 TRACEEVENT-CFLAGS
 libtraceevent-dynamic-list
 libtraceevent.so.*
+.pc
+patches
 *.o
 build_prefix
 build_uninstall
 *~
 \#*\#
+.#*
 *.cmd
 *.so
 .*.d
 ep_version.h
+libtraceevent.pc
+lib/
diff --git a/utest/.gitignore b/utest/.gitignore
new file mode 100644
index 000000000000..3620cd04bd42
--- /dev/null
+++ b/utest/.gitignore
@@ -0,0 +1 @@
+trace-utest
-- 
2.35.1

