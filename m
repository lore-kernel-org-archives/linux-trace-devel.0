Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 918CCC433B4
	for <linux-trace-devel@archiver.kernel.org>; Sat, 10 Apr 2021 00:37:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 622026113A
	for <linux-trace-devel@archiver.kernel.org>; Sat, 10 Apr 2021 00:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235215AbhDJAhr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 20:37:47 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:22266 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235248AbhDJAhq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 20:37:46 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 9 Apr 2021 17:37:27 -0700
Received: from vypre.com (unknown [10.21.244.131])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 4AB9921457;
        Fri,  9 Apr 2021 17:37:31 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 3/3] libtracefs: Add loading of mappings in fill_local_events_system()
Date:   Fri, 9 Apr 2021 20:37:27 -0400
Message-ID: <20210410003727.2288762-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210410003727.2288762-1-rostedt@goodmis.org>
References: <20210410003727.2288762-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-002.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When writing some code for parsing, I found that tracefs_local_events()
did not load the necessary information to have the printing of events work
just right. It left out reading kallsyms, saved_cmdlines, and
printk_formats, which are necessary for several events to print properly.

Have fill_local_events_system() read and load those files such that the
events can be printed fully. If there's a problem with reading and loading
any of these, it does not make the function called failed. This is a best
effort approach.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-events.c | 66 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index ab474e0..f37ada1 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -599,6 +599,70 @@ static bool contains(const char *name, const char * const *names)
 	return false;
 }
 
+static void load_kallsyms(struct tep_handle *tep)
+{
+	char *buf;
+
+	if (str_read_file("/proc/kallsyms", &buf, false) < 0)
+		return;
+
+	tep_parse_kallsyms(tep, buf);
+	free(buf);
+}
+
+static void load_saved_cmdlines(const char *tracing_dir,
+				struct tep_handle *tep)
+{
+	char *path;
+	char *buf;
+	int ret;
+
+	path = trace_append_file(tracing_dir, "saved_cmdlines");
+	if (!path)
+		return;
+
+	ret = str_read_file(path, &buf, false);
+	free(path);
+	if (ret < 0)
+		return;
+
+	tep_parse_saved_cmdlines(tep, buf);
+	free(buf);
+}
+
+static void load_printk_formats(const char *tracing_dir,
+				struct tep_handle *tep)
+{
+	char *path;
+	char *buf;
+	int ret;
+
+	path = trace_append_file(tracing_dir, "printk_formats");
+	if (!path)
+		return;
+
+	ret = str_read_file(path, &buf, false);
+	free(path);
+	if (ret < 0)
+		return;
+
+	tep_parse_printk_formats(tep, buf);
+	free(buf);
+}
+
+/*
+ * Do a best effort attempt to load kallsyms, saved_cmdlines and
+ * printk_formats. If they can not be loaded, then this will not
+ * do the mappings. But this does not fail the loading of events.
+ */
+static void load_mappings(const char *tracing_dir,
+			  struct tep_handle *tep)
+{
+	load_kallsyms(tep);
+	load_saved_cmdlines(tracing_dir, tep);
+	load_printk_formats(tracing_dir, tep);
+}
+
 static int fill_local_events_system(const char *tracing_dir,
 				    struct tep_handle *tep,
 				    const char * const *sys_names,
@@ -638,6 +702,8 @@ static int fill_local_events_system(const char *tracing_dir,
 	if (!sys_names || contains("ftrace", sys_names))
 		load_events(tep, tracing_dir, "ftrace");
 
+	load_mappings(tracing_dir, tep);
+
 	/* always succeed because parsing failures are not critical */
 	ret = 0;
 out:
-- 
2.29.2

