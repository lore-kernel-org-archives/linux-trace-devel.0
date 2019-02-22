Return-Path: <SRS0=rw6q=Q5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E83C6C4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 18:06:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C51A82070D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 18:06:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbfBVSGD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Feb 2019 13:06:03 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34546 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbfBVSGD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Feb 2019 13:06:03 -0500
Received: by mail-wm1-f68.google.com with SMTP id y185so9431656wmd.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Feb 2019 10:06:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u2EwF0qQ8fIwZ8XAhIn8rabEJP9DpcagTnKdKR/HstQ=;
        b=Nx2kr0uBEMyGhYEhx5REyAwrMK1VLzEsFh9O8QK0KKhdKOZCcqcV/arGaSN8dQBv3g
         2Keh3L0oJGiLeEUUfjWzyVEzjaHa+hhS7yTfB7PWYNKrKmjz8zF3A993oFl7Dx4AGaxk
         KjMjpSZJrpexZH1Ea2UqNGyU9O91/ga3cXKkVCvepzVjWLKo992+jHjboSN0nbT8s/6/
         msY46rFNhl20Y+ndFO0mj3CKb9yH+sPHe/uFAfyWekZjHYDcY8p3MvUW4dFJGY2ljIme
         Ey3RdAwohJ9QSs+xPRgy05TgbOJApdSOIWX75L7h6slsBeuzcu2YV/rcfJHykrafEOja
         DFKw==
X-Gm-Message-State: AHQUAuYcHIy5WOZnMpAP1+hZ25WNgfEGQR9Y9N7bvzOIAZE0wEEFWzUO
        xzwn+RkGnick7IlRj8xKGFQvu/I=
X-Google-Smtp-Source: AHgI3IaBjiTHR6wwL2+L+EFsQeC+vhvzACYqi2JbtE5Q/G1bwqXSNUWEKWb1HDEosY342La3Mp1ksg==
X-Received: by 2002:a1c:d049:: with SMTP id h70mr3253286wmg.81.1550858760348;
        Fri, 22 Feb 2019 10:06:00 -0800 (PST)
Received: from localhost.localdomain ([146.247.46.6])
        by smtp.gmail.com with ESMTPSA id c18sm1320678wre.32.2019.02.22.10.05.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Feb 2019 10:05:59 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v8 12/13] trace-cmd: Add splice() recording from FIFO without additional pipe buffer
Date:   Fri, 22 Feb 2019 20:05:38 +0200
Message-Id: <20190222180539.27439-13-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190222180539.27439-1-kaslevs@vmware.com>
References: <20190222180539.27439-1-kaslevs@vmware.com>
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
 lib/trace-cmd/trace-recorder.c | 70 ++++++++++++++++++++++++++++------
 2 files changed, 61 insertions(+), 12 deletions(-)

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
index d66f112..8058d71 100644
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
@@ -503,10 +554,7 @@ int tracecmd_start_recording(struct tracecmd_recorder *recorder, unsigned long s
 
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

