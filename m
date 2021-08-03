Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F542C43214
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 17:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6906061040
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 17:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237815AbhHCRGq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 13:06:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237544AbhHCRGU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 13:06:20 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12F00611AD;
        Tue,  3 Aug 2021 17:06:09 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mAxrk-002ucE-1O; Tue, 03 Aug 2021 13:06:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v3 18/22] libtracefs: Add Makefile rule to create sqlhist
Date:   Tue,  3 Aug 2021 13:06:02 -0400
Message-Id: <20210803170606.694085-19-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803170606.694085-1-rostedt@goodmis.org>
References: <20210803170606.694085-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add a Makefile rule to extract the example from the man page and create a
sqlhist executable from it.

  make sqlhist

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Makefile b/Makefile
index 96d7f5528a56..7f382c304b9b 100644
--- a/Makefile
+++ b/Makefile
@@ -364,11 +364,21 @@ $(bdir)/libtracefs.so.$(TRACEFS_VERSION): force
 	$(Q)mkdir -p $(bdir)
 	$(Q)$(MAKE) -C $(src)/src libtracefs.so
 
+$(bdir)/sqlhist.c: Documentation/libtracefs-sql.txt
+	cat $< | sed -ne '/^EXAMPLE/,/FILES/ { /EXAMPLE/,+2d ; /^FILES/d ;  /^--/d ; p}' > $@
+
+$(bdir)/sqlhist.o: $(bdir)/sqlhist.c
+	$(CC) -g -Wall -c -o $@ $^ -Iinclude/ $(LIBTRACEEVENT_INCLUDES)
+
+sqlhist: $(bdir)/sqlhist.o $(LIBTRACEFS_STATIC)
+	$(CC) -o $@ $^ $(LIBTRACEEVENT_LIBS)
+
 clean:
 	$(MAKE) -C $(src)/utest clean
 	$(MAKE) -C $(src)/src clean
 	$(RM) $(TARGETS) $(bdir)/*.a $(bdir)/*.so $(bdir)/*.so.* $(bdir)/*.o $(bdir)/.*.d
 	$(RM) $(PKG_CONFIG_FILE)
 	$(RM) $(VERSION_FILE)
+	$(RM) $(bdir)/sqlhist.o $(bdir)/sqlhist.c sqlhist
 
 .PHONY: clean
-- 
2.30.2

