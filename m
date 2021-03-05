Return-Path: <SRS0=uRrw=ID=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96310C4332B
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Mar 2021 23:00:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A31F650A9
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Mar 2021 23:00:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhCEW7v (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Mar 2021 17:59:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:48108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230058AbhCEW7t (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Mar 2021 17:59:49 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9DD16509B
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Mar 2021 22:59:48 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lIJQB-0020AT-VH
        for linux-trace-devel@vger.kernel.org; Fri, 05 Mar 2021 17:59:47 -0500
Message-ID: <20210305225947.846442317@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 05 Mar 2021 17:52:27 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/9 v2] trace-cmd: Move the input state updates into the functions that
 change the state
References: <20210305225223.794554327@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

It makes more sense to have the functions that change the state of the
descriptor to change the value that stores the state. This makes it more
robust in case these functions are called by something other than
tracecmd_read_headers(). That way the state changes with the update, and this
removes the dependency on create_file_fd with the state changes.

Link: https://lore.kernel.org/linux-trace-devel/20210301143857.396768544@goodmis.org

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 9ef7b9f16951..debc8160880e 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -395,6 +395,8 @@ static int read_header_files(struct tracecmd_input *handle)
 	handle->ftrace_files_start =
 		lseek64(handle->fd, 0, SEEK_CUR);
 
+	handle->file_state = TRACECMD_FILE_HEADERS;
+
 	return 0;
 
  failed_read:
@@ -596,6 +598,8 @@ static int read_ftrace_files(struct tracecmd_input *handle, const char *regex)
 		regfree(ereg);
 	}
 
+	handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
+
 	return 0;
 }
 
@@ -678,6 +682,8 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
 		regfree(ereg);
 	}
 
+	handle->file_state = TRACECMD_FILE_ALL_EVENTS;
+
 	return 0;
 
  failed:
@@ -713,6 +719,9 @@ static int read_proc_kallsyms(struct tracecmd_input *handle)
 	tracecmd_parse_proc_kallsyms(pevent, buf, size);
 
 	free(buf);
+
+	handle->file_state = TRACECMD_FILE_KALLSYMS;
+
 	return 0;
 }
 
@@ -740,6 +749,8 @@ static int read_ftrace_printk(struct tracecmd_input *handle)
 
 	free(buf);
 
+	handle->file_state = TRACECMD_FILE_PRINTK;
+
 	return 0;
 }
 
@@ -788,32 +799,27 @@ int tracecmd_read_headers(struct tracecmd_input *handle)
 	ret = read_header_files(handle);
 	if (ret < 0)
 		return -1;
-	handle->file_state = TRACECMD_FILE_HEADERS;
+
 	tep_set_long_size(handle->pevent, handle->long_size);
 
 	ret = read_ftrace_files(handle, NULL);
 	if (ret < 0)
 		return -1;
-	handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
 
 	ret = read_event_files(handle, NULL);
 	if (ret < 0)
 		return -1;
-	handle->file_state = TRACECMD_FILE_ALL_EVENTS;
 
 	ret = read_proc_kallsyms(handle);
 	if (ret < 0)
 		return -1;
-	handle->file_state = TRACECMD_FILE_KALLSYMS;
 
 	ret = read_ftrace_printk(handle);
 	if (ret < 0)
 		return -1;
-	handle->file_state = TRACECMD_FILE_PRINTK;
 
 	if (read_and_parse_cmdlines(handle) < 0)
 		return -1;
-	handle->file_state = TRACECMD_FILE_CMD_LINES;
 
 	if (read_cpus(handle) < 0)
 		return -1;
@@ -2829,6 +2835,9 @@ static int read_and_parse_cmdlines(struct tracecmd_input *handle)
 	cmdlines[size] = 0;
 	tracecmd_parse_cmdlines(pevent, cmdlines, size);
 	free(cmdlines);
+
+	handle->file_state = TRACECMD_FILE_CMD_LINES;
+
 	return 0;
 }
 
-- 
2.30.0


