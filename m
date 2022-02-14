Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D45FC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Feb 2022 23:50:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiBNXuM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Feb 2022 18:50:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiBNXuL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Feb 2022 18:50:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B836814033
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Feb 2022 15:50:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66E86B80E12
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Feb 2022 23:50:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6266C340E9
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Feb 2022 23:49:59 +0000 (UTC)
Date:   Mon, 14 Feb 2022 18:49:58 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd: Fix trace-cmd report --events
Message-ID: <20220214184958.6a1d57a1@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The restructuring of the headers broke the tracecmd_print_events()
function. Instead, pass in the regex to the read_headers() functions to
perform the printing of the events as they are read.

Fixes: b2906b74b02b ("trace-cmd library: Initialize internal sections database on file read")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-input.c | 39 +++++++++++++------------------------
 1 file changed, 14 insertions(+), 25 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 60ac839c5920..ae3a9bbd01e1 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1001,7 +1001,8 @@ static int read_cpus(struct tracecmd_input *handle)
 	return 0;
 }
 
-static int read_headers_v6(struct tracecmd_input *handle, enum tracecmd_file_states state)
+static int read_headers_v6(struct tracecmd_input *handle, enum tracecmd_file_states state,
+			   const char *regex)
 {
 	int ret;
 
@@ -1028,7 +1029,7 @@ static int read_headers_v6(struct tracecmd_input *handle, enum tracecmd_file_sta
 	if (state <= handle->file_state)
 		return 0;
 
-	ret = read_event_files(handle, NULL);
+	ret = read_event_files(handle, regex);
 	if (ret < 0)
 		return -1;
 
@@ -1106,7 +1107,8 @@ static int read_section_header(struct tracecmd_input *handle, unsigned short *id
 	return 0;
 }
 
-static int handle_section(struct tracecmd_input *handle, struct file_section *section)
+static int handle_section(struct tracecmd_input *handle, struct file_section *section,
+			  const char *regex)
 {
 	unsigned short id, flags;
 	unsigned long long size;
@@ -1132,7 +1134,7 @@ static int handle_section(struct tracecmd_input *handle, struct file_section *se
 		ret = read_ftrace_files(handle, NULL);
 		break;
 	case TRACECMD_OPTION_EVENT_FORMATS:
-		ret = read_event_files(handle, NULL);
+		ret = read_event_files(handle, regex);
 		break;
 	case TRACECMD_OPTION_KALLSYMS:
 		ret = read_proc_kallsyms(handle);
@@ -1154,7 +1156,7 @@ static int handle_section(struct tracecmd_input *handle, struct file_section *se
 	return ret;
 }
 
-static int read_headers(struct tracecmd_input *handle)
+static int read_headers(struct tracecmd_input *handle, const char *regex)
 {
 	struct file_section *section;
 
@@ -1174,7 +1176,7 @@ static int read_headers(struct tracecmd_input *handle)
 
 	section = handle->sections;
 	while (section) {
-		if (handle_section(handle, section))
+		if (handle_section(handle, section, NULL))
 			return -1;
 		section = section->next;
 	}
@@ -1198,8 +1200,8 @@ int tracecmd_read_headers(struct tracecmd_input *handle,
 			  enum tracecmd_file_states state)
 {
 	if (!HAS_SECTIONS(handle))
-		return read_headers_v6(handle, state);
-	return read_headers(handle);
+		return read_headers_v6(handle, state, NULL);
+	return read_headers(handle, NULL);
 }
 
 static unsigned long long calc_page_offset(struct tracecmd_input *handle,
@@ -3971,26 +3973,13 @@ int tracecmd_make_pipe(struct tracecmd_input *handle, int cpu, int fd, int cpus)
  */
 void tracecmd_print_events(struct tracecmd_input *handle, const char *regex)
 {
-	struct file_section *sec;
-
 	if (!regex)
 		regex = ".*";
 
-	sec = section_open(handle, TRACECMD_OPTION_HEADER_INFO);
-	if (sec) {
-		read_header_files(handle);
-		section_close(handle, sec);
-	}
-	sec = section_open(handle, TRACECMD_OPTION_FTRACE_EVENTS);
-	if (sec) {
-		read_ftrace_files(handle, regex);
-		section_close(handle, sec);
-	}
-	sec = section_open(handle, TRACECMD_OPTION_EVENT_FORMATS);
-	if (sec) {
-		read_event_files(handle, regex);
-		section_close(handle, sec);
-	}
+	if (!HAS_SECTIONS(handle))
+		read_headers_v6(handle, TRACECMD_FILE_ALL_EVENTS, regex);
+
+	read_headers(handle, regex);
 }
 
 /* Show the cpu data stats */
-- 
2.34.1

