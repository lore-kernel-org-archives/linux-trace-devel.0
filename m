Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0650FC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Nov 2021 23:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbhKVXxV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Nov 2021 18:53:21 -0500
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:32632 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232007AbhKVXxS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Nov 2021 18:53:18 -0500
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Mon, 22 Nov 2021 15:50:09 -0800
Received: from vypre.local.home (unknown [10.21.245.36])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 1CF4220348;
        Mon, 22 Nov 2021 15:50:11 -0800 (PST)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 11/11] libtracefs/Documentation: Update stream example to have a parameter
Date:   Mon, 22 Nov 2021 18:49:56 -0500
Message-ID: <20211122234956.788401-12-rostedt@goodmis.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211122234956.788401-1-rostedt@goodmis.org>
References: <20211122234956.788401-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-001.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Instead of writing the output of the tracing data to trace.txt, have the
example require a file name. As it is now compiled out, it should not
create some random file that the user will not expect.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-stream.txt | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/Documentation/libtracefs-stream.txt b/Documentation/libtracefs-stream.txt
index 48fc8fa..7d723c5 100644
--- a/Documentation/libtracefs-stream.txt
+++ b/Documentation/libtracefs-stream.txt
@@ -47,6 +47,8 @@ EXAMPLE
 -------
 [source,c]
 --
+#include <stdio.h>
+#include <stdlib.h>
 #include <unistd.h>
 #include <signal.h>
 
@@ -57,13 +59,23 @@ void stop(int sig)
 	tracefs_trace_pipe_stop(NULL);
 }
 
-int main()
+int main(int argc, char **argv)
 {
 	mode_t mode = S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH;
-	const char *filename = "trace.txt";
-	int fd = creat(filename, mode);
+	const char *filename;
+	int fd;
 	int ret;
 
+	if (argc < 2) {
+		fprintf(stderr, "usage: %s output_file\n", argv[0]);
+		exit(-1);
+	}
+	filename = argv[1];
+	fd = creat(filename, mode);
+	if (fd < 0) {
+		perror(filename);
+		exit(-1);
+	}
 	signal(SIGINT, stop);
 	ret = tracefs_trace_pipe_stream(fd, NULL, SPLICE_F_NONBLOCK);
 	close(fd);
-- 
2.31.1

