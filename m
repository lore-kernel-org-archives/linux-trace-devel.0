Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D9E3C2D0E4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Nov 2020 20:46:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8E5220721
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Nov 2020 20:46:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728938AbgKWUqJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 23 Nov 2020 15:46:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:48798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728869AbgKWUqJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 23 Nov 2020 15:46:09 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D006B206B6
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Nov 2020 20:46:08 +0000 (UTC)
Date:   Mon, 23 Nov 2020 15:46:07 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2] tracefs events: Do not process str_read_file() if size
 is zero
Message-ID: <20201123154607.5e43e1ff@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If a file has no size (nothing is read), then str_read_file() frees the
buffer and returns zero. The problem is that all callers of str_read_file()
uses the buffer supplied if the value returned is not a negative. This
causes the freed buffer being used by the callers if the file read existed
but had no content.

This is apparent when using a copy of the tracefs directory, where some file
exist, but have no content, then loading the events would cause a segfault.

Change the callers to check the return value of str_read_file() for zero or
negative, and do not go further if it is.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
Changes since v1:

   Have the callers of str_read_file() check for less than zero, as
   the first patch would never allocate the passed in buffer.

 tracefs-events.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tracefs-events.c b/tracefs-events.c
index ca1d22b..631c310 100644
--- a/tracefs-events.c
+++ b/tracefs-events.c
@@ -411,7 +411,7 @@ char **tracefs_tracers(const char *tracing_dir)
 		goto out_free;
 
 	len = str_read_file(available_tracers, &buf);
-	if (len < 0)
+	if (len <= 0)
 		goto out_free;
 
 	len = 0;
@@ -471,7 +471,7 @@ static int load_events(struct tep_handle *tep,
 			goto next_event;
 
 		len = str_read_file(format, &buf);
-		if (len < 0)
+		if (len <= 0)
 			goto next_event;
 
 		ret = tep_parse_event(tep, buf, len, system);
@@ -501,7 +501,7 @@ static int read_header(struct tep_handle *tep, const char *tracing_dir)
 		goto out;
 
 	len = str_read_file(header, &buf);
-	if (len < 0)
+	if (len <= 0)
 		goto out;
 
 	tep_parse_header_page(tep, buf, len, sizeof(long));
-- 
2.25.4

