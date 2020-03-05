Return-Path: <SRS0=o+Or=4W=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27ADAC3F2CD
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Mar 2020 15:48:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F385A2073B
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Mar 2020 15:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgCEPsk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Mar 2020 10:48:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:35762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbgCEPsk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Mar 2020 10:48:40 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECFC52073B;
        Thu,  5 Mar 2020 15:48:39 +0000 (UTC)
Date:   Thu, 5 Mar 2020 10:48:38 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Make functions in trace-write-local.h inline
Message-ID: <20200305104838.29b8a427@gandalf.local.home>
In-Reply-To: <20200304091220.30936-6-tz.stoyanov@gmail.com>
References: <20200304091220.30936-1-tz.stoyanov@gmail.com>
        <20200304091220.30936-6-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Functions defined in header files really should be marked as static inline
as header files are not to hold the actual code (where a inline is more like
a define, but with stronger typing).

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---

Tzvetomir,

Nothing wrong with your patch, but it made me notice that these functions
were never set as static inline.

-- Steve

 lib/trace-cmd/include/trace-write-local.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/include/trace-write-local.h b/lib/trace-cmd/include/trace-write-local.h
index 94ad910b..046992f1 100644
--- a/lib/trace-cmd/include/trace-write-local.h
+++ b/lib/trace-cmd/include/trace-write-local.h
@@ -8,7 +8,7 @@
 
 /* Local for trace-input.c, trace-output.c and trace-msg.c */
 
-static ssize_t __do_write(int fd, const void *data, size_t size)
+static inline ssize_t __do_write(int fd, const void *data, size_t size)
 {
 	ssize_t tot = 0;
 	ssize_t w;
@@ -26,7 +26,7 @@ static ssize_t __do_write(int fd, const void *data, size_t size)
 	return tot;
 }
 
-static ssize_t
+static inline ssize_t
 __do_write_check(int fd, const void *data, size_t size)
 {
 	ssize_t ret;
-- 
2.20.1

