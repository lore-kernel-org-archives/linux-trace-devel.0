Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35A09C43381
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Mar 2021 14:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04DA96146D
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Mar 2021 14:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234920AbhCAOkX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Mar 2021 09:40:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:60636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235441AbhCAOkV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Mar 2021 09:40:21 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D278364E2E;
        Mon,  1 Mar 2021 14:38:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lGjhJ-001Puk-QO; Mon, 01 Mar 2021 09:38:57 -0500
Message-ID: <20210301143857.694136727@goodmis.org>
User-Agent: quilt/0.66
Date:   Mon, 01 Mar 2021 09:37:31 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 7/8] trace-cmd input: Validate the input handle when copying from it
References: <20210301143724.540985351@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Now that there's validation states, make sure that the input handle is at
the correct state to validate it.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 9a4b1f4e118a..53c2722f46e7 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3491,6 +3491,10 @@ static int copy_header_files(struct tracecmd_input *handle, int fd)
 {
 	unsigned long long size;
 
+	/* The input handle has to have at least read the headers */
+	if (handle->file_state < TRACECMD_FILE_HEADERS)
+		return -1;
+
 	lseek64(handle->fd, handle->header_files_start, SEEK_SET);
 
 	/* "header_page"  */
@@ -3522,6 +3526,10 @@ static int copy_ftrace_files(struct tracecmd_input *handle, int fd)
 	unsigned int count;
 	unsigned int i;
 
+	/* The input handle has to have at least read the ftrace events */
+	if (handle->file_state < TRACECMD_FILE_FTRACE_EVENTS)
+		return -1;
+
 	if (read_copy_size4(handle, fd, &count) < 0)
 		return -1;
 
@@ -3545,6 +3553,10 @@ static int copy_event_files(struct tracecmd_input *handle, int fd)
 	unsigned int count;
 	unsigned int i,x;
 
+	/* The input handle has to have at least read all its events */
+	if (handle->file_state < TRACECMD_FILE_ALL_EVENTS)
+		return -1;
+
 	if (read_copy_size4(handle, fd, &systems) < 0)
 		return -1;
 
@@ -3577,6 +3589,10 @@ static int copy_proc_kallsyms(struct tracecmd_input *handle, int fd)
 {
 	unsigned int size;
 
+	/* The input handle has to have at least has kallsyms */
+	if (handle->file_state < TRACECMD_FILE_KALLSYMS)
+		return -1;
+
 	if (read_copy_size4(handle, fd, &size) < 0)
 		return -1;
 	if (!size)
@@ -3592,6 +3608,10 @@ static int copy_ftrace_printk(struct tracecmd_input *handle, int fd)
 {
 	unsigned int size;
 
+	/* The input handle has to have at least has printk stored */
+	if (handle->file_state < TRACECMD_FILE_PRINTK)
+		return -1;
+
 	if (read_copy_size4(handle, fd, &size) < 0)
 		return -1;
 	if (!size)
@@ -3607,6 +3627,10 @@ static int copy_command_lines(struct tracecmd_input *handle, int fd)
 {
 	unsigned long long size;
 
+	/* The input handle has to have at least read the cmdlines */
+	if (handle->file_state < TRACECMD_FILE_CMD_LINES)
+		return -1;
+
 	if (read_copy_size8(handle, fd, &size) < 0)
 		return -1;
 	if (!size)
-- 
2.30.0


