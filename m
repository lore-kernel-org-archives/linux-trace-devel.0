Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A8E1C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Nov 2021 09:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239118AbhKVJdu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Nov 2021 04:33:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:55216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239121AbhKVJdk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Nov 2021 04:33:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00FCA60F22;
        Mon, 22 Nov 2021 09:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637573434;
        bh=3Yw3+pcOGVLDQcCjIAjJOvy1BjQE0ReqA+ZCmtuOROs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TE4hXhPPx552Kf5w4pweICzkWOubvJ/AfqNX4oSV52E3vjj1nm5PB62vip1epllr6
         bbxgc3hbHPfwtJYBBU2XrtvR9adQvvr+CT8CbJB1DmmFYNFA1yAIas0nERXaqjeSsy
         oleivJ2s7lj1T7QtzmvG0LexXzJkEpLCjhdRwMYAEe1ZbcuyIUPF0JdwrPSxigZitS
         rfxLv67vdTWdvnLNH4OAF+uBClfdnmFC9KIdwD426kEkIXDz9IQpnZI8lY8yPQMufT
         6pfHPPOJYMm/JnzRtZE3zNQDByN74TrLh39DIT5U9UdCNaRyTZlG5HtQuqjb2qHqcs
         491luLVtdFIoQ==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Beau Belgrave <beaub@linux.microsoft.com>
Cc:     linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Tom Zanussi <zanussi@kernel.org>,
        linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 3/5] samples/trace_event: Add '__rel_loc' using sample event
Date:   Mon, 22 Nov 2021 18:30:30 +0900
Message-Id: <163757343050.510314.2876529802471645178.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <163757340321.510314.9399950115238632705.stgit@devnote2>
References: <163757340321.510314.9399950115238632705.stgit@devnote2>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add '__rel_loc' using sample event for testing.
User can use this for testing purpose. There is
no reason to use this macro from the kernel.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 Changes in v2:
  - Add __rel_loc bitmask sample.
---
 samples/trace_events/trace-events-sample.c |    3 +++
 samples/trace_events/trace-events-sample.h |   33 ++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/samples/trace_events/trace-events-sample.c b/samples/trace_events/trace-events-sample.c
index 1a72b7d95cdc..4d34dc0b0fee 100644
--- a/samples/trace_events/trace-events-sample.c
+++ b/samples/trace_events/trace-events-sample.c
@@ -21,6 +21,7 @@ static const char *random_strings[] = {
 
 static void simple_thread_func(int cnt)
 {
+	unsigned long bitmask[1] = {0xdeadbeefUL};
 	int array[6];
 	int len = cnt % 5;
 	int i;
@@ -43,6 +44,8 @@ static void simple_thread_func(int cnt)
 	trace_foo_with_template_cond("prints other times", cnt);
 
 	trace_foo_with_template_print("I have to be different", cnt);
+
+	trace_foo_rel_loc("Hello __rel_loc", cnt, bitmask);
 }
 
 static int simple_thread(void *arg)
diff --git a/samples/trace_events/trace-events-sample.h b/samples/trace_events/trace-events-sample.h
index e61471ab7d14..5ab74fc9a2df 100644
--- a/samples/trace_events/trace-events-sample.h
+++ b/samples/trace_events/trace-events-sample.h
@@ -506,6 +506,39 @@ DEFINE_EVENT_PRINT(foo_template, foo_with_template_print,
 	TP_ARGS(foo, bar),
 	TP_printk("bar %s %d", __get_str(foo), __entry->bar));
 
+/*
+ * There are yet another __rel_loc dynamic data attribute. If you
+ * use __rel_dynamic_array() and __rel_string() etc. macros, you
+ * can use this attribute. There is no difference from the viewpoint
+ * of functionality with/without 'rel' but the encoding is a bit
+ * different. This is expected to be used with user-space event,
+ * there is no reason that the kernel event use this, but only for
+ * testing.
+ */
+
+TRACE_EVENT(foo_rel_loc,
+
+	TP_PROTO(const char *foo, int bar, unsigned long *mask),
+
+	TP_ARGS(foo, bar, mask),
+
+	TP_STRUCT__entry(
+		__rel_string(	foo,	foo	)
+		__field(	int,	bar	)
+		__rel_bitmask(	bitmask,
+			BITS_PER_BYTE * sizeof(unsigned long)	)
+	),
+
+	TP_fast_assign(
+		__assign_rel_str(foo, foo);
+		__entry->bar = bar;
+		__assign_rel_bitmask(bitmask, mask,
+			BITS_PER_BYTE * sizeof(unsigned long));
+	),
+
+	TP_printk("foo_rel_loc %s, %d, %s", __get_rel_str(foo), __entry->bar,
+		  __get_rel_bitmask(bitmask))
+);
 #endif
 
 /***** NOTICE! The #if protection ends here. *****/

