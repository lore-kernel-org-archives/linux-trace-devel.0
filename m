Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED4E8C43461
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 17:23:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF72E613A9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 17:23:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235958AbhDPRYB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 16 Apr 2021 13:24:01 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:55932 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235935AbhDPRYA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 16 Apr 2021 13:24:00 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 16 Apr 2021 10:23:30 -0700
Received: from vypre.com (unknown [10.21.244.206])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 93DA12045B;
        Fri, 16 Apr 2021 10:23:34 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 1/3] trace-cmd list: Have -o read the options directory instead of file
Date:   Fri, 16 Apr 2021 13:23:29 -0400
Message-ID: <20210416172331.3870833-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210416172331.3870833-1-rostedt@goodmis.org>
References: <20210416172331.3870833-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-002.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The trace_options file only shows the options that are available when a
tracer is set. This is annoying as one needs to enable the tracer in order
to see all the options that are available.

Starting with Linux v4.4, all tracers options are displayed in the options
directory. Walk through the options directory instead of simply reading
the trace_options file.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-list.c | 48 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 2 deletions(-)

diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index 63216b43..0ba49853 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -255,13 +255,57 @@ static void show_tracers(void)
 	show_file("available_tracers");
 }
 
-
 static void show_options(void)
 {
+	struct dirent *dent;
+	struct stat st;
+	char *path;
+	DIR *dir;
+
+	path = tracefs_get_tracing_file("options");
+	if (!path)
+		goto show_file;
+	if (stat(path, &st) < 0)
+		goto show_file;
+
+	if ((st.st_mode & S_IFMT) != S_IFDIR)
+		goto show_file;
+
+	dir = opendir(path);
+	if (!dir)
+		die("Can not read instance directory");
+
+	while ((dent = readdir(dir))) {
+		const char *name = dent->d_name;
+		long long val;
+		char *file;
+		int ret;
+
+		if (strcmp(name, ".") == 0 ||
+		    strcmp(name, "..") == 0)
+			continue;
+
+		ret = asprintf(&file, "options/%s", name);
+		if (ret < 0)
+			die("Failed to allocate file name");
+		ret = tracefs_instance_file_read_number(NULL, file, &val);
+		if (!ret) {
+			if (val)
+				printf("%s\n", name);
+			else
+				printf("no%s\n", name);
+		}
+		free(file);
+	}
+	closedir(dir);
+	tracefs_put_tracing_file(path);
+	return;
+
+ show_file:
+	tracefs_put_tracing_file(path);
 	show_file("trace_options");
 }
 
-
 static void show_clocks(void)
 {
 	char *clocks;
-- 
2.29.2

