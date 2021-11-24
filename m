Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A70DC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343964AbhKXWhd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:37:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:42810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243451AbhKXWhd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:37:33 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E62F06108B;
        Wed, 24 Nov 2021 22:34:22 +0000 (UTC)
Date:   Wed, 24 Nov 2021 17:34:21 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     "Jerome Marchand" <jmarchan@redhat.com>
Subject: [PATCH] libtracefs: Don't ignore LDFLAGS when linking the shared
 libs
Message-ID: <20211124173421.22d231b2@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Jerome Marchand" <jmarchan@redhat.com>

do_compile_shared_library shouldn't ignore LDFLAGS. That makes it
difficult for packager to follow their distribution packaging
guidelines.

[ Taken from trace-cmd ]
Link: https://lore.kernel.org/all/20211111180318.499099-1-jmarchan@redhat.com/

Signed-off-by: "Jerome Marchand" <jmarchan@redhat.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 scripts/utils.mk | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/utils.mk b/scripts/utils.mk
index 7a88b10..0b3c067 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -56,7 +56,7 @@ do_build_static_lib =				\
 
 do_compile_shared_library =			\
 	($(print_shared_lib_compile)		\
-	$(CC) --shared $^ '-Wl,-soname,$(1),-rpath=$$ORIGIN' -o $@ $(LIBS))
+	$(CC) --shared $^ '-Wl,-soname,$(1),-rpath=$$ORIGIN' -o $@ $(LDFLAGS) $(LIBS))
 
 do_compile_plugin_obj =				\
 	($(print_plugin_obj_compile)		\
-- 
2.31.1

