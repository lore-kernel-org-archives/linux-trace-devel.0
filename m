Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10005C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Dec 2021 00:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhLQAmS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 19:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhLQAmR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 19:42:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5736C06173F
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 16:42:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43EB661FDD
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Dec 2021 00:42:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD6D6C36AE5;
        Fri, 17 Dec 2021 00:42:16 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1my1KB-0004D0-Pl;
        Thu, 16 Dec 2021 19:42:15 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 3/9] libtracefs: Fix sample intermediate build targets
Date:   Thu, 16 Dec 2021 19:42:08 -0500
Message-Id: <20211217004214.16074-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211217004214.16074-1-rostedt@goodmis.org>
References: <20211217004214.16074-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The target for compiling from *.c to *.o in the samples directory had:

  $(bdir)/%.o: %.c

But since the *.c files were extracted, they already included the $(bdir)
in the name, so the above was really matching: $(bdir)/$(bdir)/*.c and not
being used. Remove the extra $(bdir) from the target.

This also exposed a bug that $(CFLAGS) was not included, and the stream.c
failed to build because of the lacking -D_GNU_SOURCE.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 samples/Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/samples/Makefile b/samples/Makefile
index 6ee57fecacbd..2d0d2397c5b4 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -60,10 +60,10 @@ $(EXAMPLES): $(patsubst %,$(bdir)/%,$(TARGETS))
 ## name, and the file will not be discarded by make.
 #
 # $(bdir)/XX.o: $(bdir)/XX.c
-#	$(CC) -g -Wall -c -o $@ $^ -I../include/ $(LIBTRACEEVENT_INCLUDES)
+#	$(CC) -g -Wall $(CFLAGS) -c -o $@ $^ -I../include/ $(LIBTRACEEVENT_INCLUDES)
 
-$(bdir)/%.o: %.c
-	$(CC) -g -Wall -c -o $@ $^ -I../include/ $(LIBTRACEEVENT_INCLUDES)
+%.o: %.c
+	$(CC) -g -Wall $(CFLAGS) -c -o $@ $^ -I../include/ $(LIBTRACEEVENT_INCLUDES)
 
 clean:
 	$(RM) $(bdir)/*
-- 
2.33.0

