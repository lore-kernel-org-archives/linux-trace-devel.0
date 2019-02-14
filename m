Return-Path: <SRS0=y1VY=QV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7ECEC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 14:14:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FC372080A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 14:14:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404744AbfBNOOG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Feb 2019 09:14:06 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50976 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404604AbfBNOOG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Feb 2019 09:14:06 -0500
Received: by mail-wm1-f68.google.com with SMTP id x7so6422353wmj.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Feb 2019 06:14:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oh0KoxWnrM8SSEH5x1pOPfEmIJf6WwPUsqeRaw53WTc=;
        b=pUV0DXm1DvxY5tVU/J1Oysqt3LxsO7gHsm4mWWo4rhB3mc53ew4htdxZzAm1ZDjkrU
         JM2cK+bVYBzgaT0Y785bsBNtA4P46MMe0U994rYxo1tdVjJ+hcOq7hZiDrfqLPhF7Ust
         OiVGfPqo0tAf8ydIfcStdQf4g38l5+wiqt1x+1H0lnOE1pFOWWi2gDIzgI9+ATSxCIvB
         3U5GGcpNi/PJLXQ+/TTubUgbe5BEZ/Dq3M7NltkFE7/Qljl1UcNVBmgHuCaJ1apAj3pz
         S8ZmA2+3cPUi9OPBEiTbzj07d/7aP8Yf0dcUEC0ViCISLt5V9gIgegG0WlHyZqvW6B+v
         mqug==
X-Gm-Message-State: AHQUAubIvl57CBDnPJUYk7B8r798UjuaP77P2V7+pqwfEGnNCgC+DOnO
        fnybVqbFnrHZC17AOa+wgA==
X-Google-Smtp-Source: AHgI3IafLV4m36C7XW8ReaVABHKcIzOzk1iUsqC+jaJ8tA6XvMLncjPMC7J7nnqy4kulhN1y8R45iQ==
X-Received: by 2002:a1c:9e4a:: with SMTP id h71mr3032430wme.82.1550153643772;
        Thu, 14 Feb 2019 06:14:03 -0800 (PST)
Received: from localhost.localdomain ([213.145.108.55])
        by smtp.gmail.com with ESMTPSA id m4sm1844840wml.2.2019.02.14.06.14.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 06:14:03 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v6 10/11] trace-cmd: Add splice() recording from FIFO without additional pipe buffer
Date:   Thu, 14 Feb 2019 16:13:34 +0200
Message-Id: <20190214141335.28144-11-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190214141335.28144-1-kaslevs@vmware.com>
References: <20190214141335.28144-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When `trace-cmd record` is reading tracing data over FIFO we can do a direct
splice from the FIFO to the output file descriptor instead of doing two through
an additional pipe buffer. This patch implements specialized tracecmd_recorder
data transfer version for this case.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 include/trace-cmd/trace-cmd.h  |  3 +-
 lib/trace-cmd/trace-recorder.c | 81 +++++++++++++++++++++++++++-------
 2 files changed, 67 insertions(+), 17 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 6a21e66..52962e9 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -270,8 +270,9 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd);
 
 enum {
 	TRACECMD_RECORD_NOSPLICE	= (1 << 0),	/* Use read instead of splice */
-	TRACECMD_RECORD_SNAPSHOT	= (1 << 1),	/* extract from snapshot */
+	TRACECMD_RECORD_SNAPSHOT	= (1 << 1),	/* Extract from snapshot */
 	TRACECMD_RECORD_BLOCK		= (1 << 2),	/* Block on splice write */
+	TRACECMD_RECORD_NOBRASS		= (1 << 3),	/* Splice directly without a brass pipe */
 };
 
 void tracecmd_free_recorder(struct tracecmd_recorder *recorder);
diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index e45e2d1..8058d71 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -8,6 +8,7 @@
 #include <stdlib.h>
 #include <fcntl.h>
 #include <time.h>
+#include <poll.h>
 #include <unistd.h>
 #include <errno.h>
 
@@ -26,6 +27,8 @@
 # define SPLICE_F_GIFT		8
 #endif
 
+#define POLL_TIMEOUT_MS		1000
+
 struct tracecmd_recorder {
 	int		fd;
 	int		fd1;
@@ -40,6 +43,7 @@ struct tracecmd_recorder {
 	int		pages;
 	int		count;
 	unsigned	fd_flags;
+	unsigned	trace_fd_flags;
 	unsigned	flags;
 };
 
@@ -127,6 +131,8 @@ tracecmd_create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
 	if (!(recorder->flags & TRACECMD_RECORD_BLOCK))
 		recorder->fd_flags |= SPLICE_F_NONBLOCK;
 
+	recorder->trace_fd_flags = SPLICE_F_MOVE;
+
 	/* Init to know what to free and release */
 	recorder->trace_fd = -1;
 	recorder->brass[0] = -1;
@@ -171,7 +177,8 @@ tracecmd_create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
 			goto out_free;
 	}
 
-	if ((recorder->flags & TRACECMD_RECORD_NOSPLICE) == 0) {
+	if (!(recorder->flags & (TRACECMD_RECORD_NOSPLICE |
+				 TRACECMD_RECORD_NOBRASS))) {
 		ret = pipe(recorder->brass);
 		if (ret < 0)
 			goto out_free;
@@ -372,7 +379,7 @@ static long splice_data(struct tracecmd_recorder *recorder)
 	long ret;
 
 	read = splice(recorder->trace_fd, NULL, recorder->brass[1], NULL,
-		      recorder->pipe_size, SPLICE_F_MOVE);
+		      recorder->pipe_size, recorder->trace_fd_flags);
 	if (read < 0) {
 		if (errno != EAGAIN && errno != EINTR) {
 			warning("recorder error in splice input");
@@ -399,6 +406,39 @@ static long splice_data(struct tracecmd_recorder *recorder)
 	return total_read;
 }
 
+/*
+ * Returns -1 on error.
+ *          or bytes of data read.
+ */
+static long direct_splice_data(struct tracecmd_recorder *recorder)
+{
+	struct pollfd pfd = {
+		.fd = recorder->trace_fd,
+		.events = POLLIN,
+	};
+	long read;
+	int ret;
+
+	ret = poll(&pfd, 1, POLL_TIMEOUT_MS);
+	if (ret < 0)
+		return -1;
+
+	if (!(pfd.revents | POLLIN))
+		return 0;
+
+	read = splice(recorder->trace_fd, NULL, recorder->fd, NULL,
+		      recorder->pipe_size, recorder->trace_fd_flags);
+	if (read < 0) {
+		if (errno == EAGAIN || errno == EINTR)
+			return 0;
+
+		warning("recorder error in splice input");
+		return -1;
+	}
+
+	return read;
+}
+
 /*
  * Returns -1 on error.
  *          or bytes of data read.
@@ -433,6 +473,17 @@ static long read_data(struct tracecmd_recorder *recorder)
 	return r;
 }
 
+static long move_data(struct tracecmd_recorder *recorder)
+{
+	if (recorder->flags & TRACECMD_RECORD_NOSPLICE)
+		return read_data(recorder);
+
+	if (recorder->flags & TRACECMD_RECORD_NOBRASS)
+		return direct_splice_data(recorder);
+
+	return splice_data(recorder);
+}
+
 static void set_nonblock(struct tracecmd_recorder *recorder)
 {
 	long flags;
@@ -440,8 +491,11 @@ static void set_nonblock(struct tracecmd_recorder *recorder)
 	/* Do not block on reads for flushing */
 	flags = fcntl(recorder->trace_fd, F_GETFL);
 	fcntl(recorder->trace_fd, F_SETFL, flags | O_NONBLOCK);
+	recorder->trace_fd_flags |= SPLICE_F_NONBLOCK;
 
-	/* Do not block on streams for write */
+	/* Do not block on pipes for write */
+	flags = fcntl(recorder->fd, F_GETFL);
+	fcntl(recorder->fd, F_SETFL, flags | O_NONBLOCK);
 	recorder->fd_flags |= SPLICE_F_NONBLOCK;
 }
 
@@ -455,10 +509,7 @@ long tracecmd_flush_recording(struct tracecmd_recorder *recorder)
 	set_nonblock(recorder);
 
 	do {
-		if (recorder->flags & TRACECMD_RECORD_NOSPLICE)
-			ret = read_data(recorder);
-		else
-			ret = splice_data(recorder);
+		ret = move_data(recorder);
 		if (ret < 0)
 			return ret;
 		total += ret;
@@ -487,7 +538,10 @@ long tracecmd_flush_recording(struct tracecmd_recorder *recorder)
 
 int tracecmd_start_recording(struct tracecmd_recorder *recorder, unsigned long sleep)
 {
-	struct timespec req;
+	struct timespec req = {
+		.tv_sec = sleep / 1000000,
+		.tv_nsec = (sleep % 1000000) * 1000,
+	};
 	long read = 1;
 	long ret;
 
@@ -495,17 +549,12 @@ int tracecmd_start_recording(struct tracecmd_recorder *recorder, unsigned long s
 
 	do {
 		/* Only sleep if we did not read anything last time */
-		if (!read && sleep) {
-			req.tv_sec = sleep / 1000000;
-			req.tv_nsec = (sleep % 1000000) * 1000;
+		if (!read && sleep)
 			nanosleep(&req, NULL);
-		}
+
 		read = 0;
 		do {
-			if (recorder->flags & TRACECMD_RECORD_NOSPLICE)
-				ret = read_data(recorder);
-			else
-				ret = splice_data(recorder);
+			ret = move_data(recorder);
 			if (ret < 0)
 				return ret;
 			read += ret;
-- 
2.19.1

