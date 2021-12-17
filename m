Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B477AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Dec 2021 05:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbhLQFuz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 00:50:55 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:50066 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbhLQFuw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 00:50:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 29BCCCE23EE
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Dec 2021 05:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65367C36AE9;
        Fri, 17 Dec 2021 05:50:49 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1my68h-00056z-Gz;
        Fri, 17 Dec 2021 00:50:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 10/15] libtracefs: Quiet "Nothing to be done for" messages
Date:   Fri, 17 Dec 2021 00:50:36 -0500
Message-Id: <20211217055041.19559-11-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211217055041.19559-1-rostedt@goodmis.org>
References: <20211217055041.19559-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When doing a make after everything is already built, we have "Nothing to
de done" messages that are rather annoying.

$ make
  DESCEND            src libtracefs.so
make[1]: Nothing to be done for 'libtracefs.so'.
  DESCEND            src libtracefs.a
make[1]: '/work/git/libtracefs.git/lib/tracefs/libtracefs.a' is up to date.

This is because the target in the src directory for these are already
done, so it reports there is nothing to be done, as that's what make does
if you specify a target (and the descent into he directory specifies the
target that is displayed).

By marking the target as .PHONY will suppress that message.

Because "libtracefs.so" depends on $(LIBTRACEFS_SHARED_SO), the latter
needs to be part of the .PHONY and not the former.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/Makefile b/src/Makefile
index 8f258a218f97..f284c70a640a 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -70,3 +70,5 @@ ifneq ($(dep_includes),)
 endif
 
 $(bdir)/tracefs-sqlhist.o tracefs-sqlhist.o: sqlhist.tab.h
+
+.PHONY: $(LIBTRACEFS_SHARED_SO) $(LIBTRACEFS_STATIC)
-- 
2.33.0

