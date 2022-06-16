Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2702EC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jun 2022 15:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbiFPPaN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Jun 2022 11:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377893AbiFPPaN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Jun 2022 11:30:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0903FDA7
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jun 2022 08:30:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1C61ACE25B0
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jun 2022 15:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1BFC3411F;
        Thu, 16 Jun 2022 15:30:08 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1o1rRf-002j56-8b;
        Thu, 16 Jun 2022 11:30:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 2/4] trace-cmd utest: Rename tracefs-utest.c to tracecmd-utest.c
Date:   Thu, 16 Jun 2022 11:29:59 -0400
Message-Id: <20220616153001.649858-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220616153001.649858-1-rostedt@goodmis.org>
References: <20220616153001.649858-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Now that the unit tests will be testing trace-cmd and not libtracefs,
rename the file to reflect that.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/Makefile                              | 2 +-
 utest/{tracefs-utest.c => tracecmd-utest.c} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename utest/{tracefs-utest.c => tracecmd-utest.c} (100%)

diff --git a/utest/Makefile b/utest/Makefile
index 2cf9974591d8..2b8f85f21a24 100644
--- a/utest/Makefile
+++ b/utest/Makefile
@@ -8,7 +8,7 @@ TARGETS = $(bdir)/trace-utest
 
 OBJS =
 OBJS += trace-utest.o
-OBJS += tracefs-utest.o
+OBJS += tracecmd-utest.o
 
 LIBS += -lcunit $(LIBTRACEEVENT_LDLAGS) $(LIBTRACEFS_LDLAGS)
 
diff --git a/utest/tracefs-utest.c b/utest/tracecmd-utest.c
similarity index 100%
rename from utest/tracefs-utest.c
rename to utest/tracecmd-utest.c
-- 
2.35.1

