Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D7EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Dec 2021 05:50:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbhLQFuq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 00:50:46 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60304 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbhLQFuq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 00:50:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A406EB82736
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Dec 2021 05:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D8CC36AEA;
        Fri, 17 Dec 2021 05:50:44 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1my68h-00056e-Ca;
        Fri, 17 Dec 2021 00:50:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 03/15] libtracefs: Fix stream example
Date:   Fri, 17 Dec 2021 00:50:29 -0500
Message-Id: <20211217055041.19559-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211217055041.19559-1-rostedt@goodmis.org>
References: <20211217055041.19559-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The sample in libtracefs-stream.txt references SPLICE_F_NONBLOCK but that
requires including "fcntl.h" and defining _GNU_SOURCE. Without that, the
sample fails to compile. Adding $(CFLAGS) to the build adds the
_GNU_SOURCE define.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-stream.txt | 1 +
 samples/Makefile                    | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtracefs-stream.txt b/Documentation/libtracefs-stream.txt
index 7d723c5e5673..68ec8c3649ba 100644
--- a/Documentation/libtracefs-stream.txt
+++ b/Documentation/libtracefs-stream.txt
@@ -51,6 +51,7 @@ EXAMPLE
 #include <stdlib.h>
 #include <unistd.h>
 #include <signal.h>
+#include <fcntl.h>
 
 #include <tracefs.h>
 
diff --git a/samples/Makefile b/samples/Makefile
index 6ee57fecacbd..4ccd28dcebaa 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -63,7 +63,7 @@ $(EXAMPLES): $(patsubst %,$(bdir)/%,$(TARGETS))
 #	$(CC) -g -Wall -c -o $@ $^ -I../include/ $(LIBTRACEEVENT_INCLUDES)
 
 $(bdir)/%.o: %.c
-	$(CC) -g -Wall -c -o $@ $^ -I../include/ $(LIBTRACEEVENT_INCLUDES)
+	$(CC) -g -Wall -c $(CFLAGS) -o $@ $^ -I../include/ $(LIBTRACEEVENT_INCLUDES)
 
 clean:
 	$(RM) $(bdir)/*
-- 
2.33.0

