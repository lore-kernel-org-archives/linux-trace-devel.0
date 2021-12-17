Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 221A9C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Dec 2021 05:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbhLQFuu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 00:50:50 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60312 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233085AbhLQFus (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 00:50:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06EAFB82738
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Dec 2021 05:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8731DC36AED;
        Fri, 17 Dec 2021 05:50:44 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1my68h-00056w-GL;
        Fri, 17 Dec 2021 00:50:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 09/15] libtracefs: Quiet mv: cannot stat message for libtracefs.a
Date:   Fri, 17 Dec 2021 00:50:35 -0500
Message-Id: <20211217055041.19559-10-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211217055041.19559-1-rostedt@goodmis.org>
References: <20211217055041.19559-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The following shows up on a normal make:

  mv: cannot stat '/work/git/libtracefs.git/lib/tracefs/libtracefs.a': No such file or directory

In order to help with a multithreaded make, the moving of the libtracefs.a
before removing it appears to fix some issues. But now we get a message if
it doesn't already exist. Only move it and remove it if it already exists.

Fixes: 550d8358 ("libtracefs: make the libtracefs.a gen more robust")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 scripts/utils.mk | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/scripts/utils.mk b/scripts/utils.mk
index c9b908f1c5d9..af0f14fcbfa7 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -60,7 +60,10 @@ do_app_build =						\
 
 do_build_static_lib =				\
 	($(print_static_lib_build)		\
-	mv $@ $@.rm; $(RM) $@.rm;  $(AR) rcs $@ $^)
+	if [ -f $@ ]; then			\
+	    mv $@ $@.rm; $(RM) $@.rm;		\
+	fi;					\
+	$(AR) rcs $@ $^)
 
 do_compile_shared_library =			\
 	($(print_shared_lib_compile)		\
-- 
2.33.0

