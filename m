Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18016C43460
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 21:07:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB02E613D1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 21:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236915AbhDVVIL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Apr 2021 17:08:11 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:20414 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236877AbhDVVIK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 17:08:10 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Thu, 22 Apr 2021 14:07:31 -0700
Received: from vypre.com (unknown [10.21.244.251])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id E466D2046C;
        Thu, 22 Apr 2021 14:07:34 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     Nicolas Sterchele <nicolas@sterchelen.net>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 2/2] trace-cmd: Fix up the die() formats
Date:   Thu, 22 Apr 2021 17:07:30 -0400
Message-ID: <20210422210730.857958-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210422210730.857958-1-rostedt@goodmis.org>
References: <20210422210730.857958-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-001.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

After adding the printf format attribute to die(), gcc found several
places that the wrong format specifier (or no specifier) was used.

Fix them all up.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-dump.c   | 14 +++++++-------
 tracecmd/trace-record.c |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 3f56f65a..98425b98 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -150,13 +150,13 @@ static void dump_initial_format(int fd)
 
 	/* check initial bytes */
 	if (read_file_bytes(fd, buf, sizeof(magic)))
-		die("cannot read %d bytes magic", sizeof(magic));
+		die("cannot read %ld bytes magic", sizeof(magic));
 	if (memcmp(buf, magic, sizeof(magic)) != 0)
 		die("wrong file magic");
 
 	/* check initial tracing string */
 	if (read_file_bytes(fd, buf, strlen(TRACING_STR)))
-		die("cannot read %d bytes tracing string", strlen(TRACING_STR));
+		die("cannot read %ld bytes tracing string", strlen(TRACING_STR));
 	buf[strlen(TRACING_STR)] = 0;
 	if (strncmp(buf, TRACING_STR, strlen(TRACING_STR)) != 0)
 		die("wrong tracing string: %s", buf);
@@ -194,7 +194,7 @@ static void dump_header_page(int fd)
 
 	/* check header string */
 	if (read_file_bytes(fd, buf, strlen(HEAD_PAGE_STR) + 1))
-		die("cannot read %d bytes header string", strlen(HEAD_PAGE_STR));
+		die("cannot read %ld bytes header string", strlen(HEAD_PAGE_STR));
 	if (strncmp(buf, HEAD_PAGE_STR, strlen(HEAD_PAGE_STR)) != 0)
 		die("wrong header string: %s", buf);
 
@@ -215,7 +215,7 @@ static void dump_header_event(int fd)
 
 	/* check header string */
 	if (read_file_bytes(fd, buf, strlen(HEAD_PAGE_EVENT) + 1))
-		die("cannot read %d bytes header string", strlen(HEAD_PAGE_EVENT));
+		die("cannot read %ld bytes header string", strlen(HEAD_PAGE_EVENT));
 	if (strncmp(buf, HEAD_PAGE_EVENT, strlen(HEAD_PAGE_EVENT)) != 0)
 		die("wrong header string: %s", buf);
 
@@ -263,7 +263,7 @@ static void dump_events_format(int fd)
 	while (systems) {
 
 		if (read_file_string(fd, buf, DUMP_SIZE))
-			die("cannot read the name of the $dth system", systems);
+			die("cannot read the name of the %dth system", systems);
 		if (read_file_number(fd, &events, 4))
 			die("cannot read the count of the events in system %s",
 			     buf);
@@ -598,10 +598,10 @@ static void dump_clock(int fd)
 		die("cannot read clock size");
 	clock = calloc(1, size);
 	if (!clock)
-		die("cannot allocate clock %d bytes", size);
+		die("cannot allocate clock %lld bytes", size);
 
 	if (read_file_bytes(fd, clock, size))
-		die("cannot read clock %d bytes", size);
+		die("cannot read clock %lld bytes", size);
 	clock[size] = 0;
 	do_print((SUMMARY | CLOCK), "\t\t%s\n", clock);
 	free(clock);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index fd03a605..db23c001 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3838,7 +3838,7 @@ static void setup_guest(struct buffer_instance *instance)
 
 	fd = open(file, O_CREAT|O_WRONLY|O_TRUNC, 0644);
 	if (fd < 0)
-		die("Failed to open", file);
+		die("Failed to open %s", file);
 
 	/* Start reading tracing metadata */
 	if (tracecmd_msg_read_data(msg_handle, fd))
-- 
2.29.2

