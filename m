Return-Path: <SRS0=wZju=UE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55335C28CC6
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 Jun 2019 11:19:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35E6820872
	for <linux-trace-devel@archiver.kernel.org>; Wed,  5 Jun 2019 11:19:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbfFELTm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 5 Jun 2019 07:19:42 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54443 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbfFELTl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 5 Jun 2019 07:19:41 -0400
Received: by mail-wm1-f66.google.com with SMTP id g135so1854825wme.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 05 Jun 2019 04:19:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uLvuMS4zyXcsMGYHz/eG5dczspTna0pC14rzNTn4878=;
        b=HYk9MU7FxE1dOnTLcn5iJECQrU3HlylFJ8O9CXP6rC8VD5W2WkS3Lcb6A7ZtiFVBcz
         jrjCA4XCsIWH9RF6CLtU3BMgiFaeRjOPKyeiSr4oW9MJu0k2E8RjTb5XneNUJlcivdB2
         Nr3jSbE1JMZlEu/kXNArOIVOsZ5cvD6U3ZSq3hZjNbO2Gir5OhyLr5w4kOAw3tjDGIaW
         +DTVlNfZXmU6858OvmBDDPHwzcLStbkQQE1y6TEkIQ/GQrNI9Av45X8GCZNmp1QSuX7l
         6zb1tM0B8ConNknUasI0JwK7v7tfXsO+GCFkJL5qDzzT+XR/PT5UqoJfezEZq9hasNGI
         SWPg==
X-Gm-Message-State: APjAAAVWk/GNXHzh+IW9y6D3GfKbNJK2vl1D6B2wa/Uhc6JGwASgtkXX
        qxfV9nFwxgAjBq14uVD5uFSnw6wl
X-Google-Smtp-Source: APXvYqzUQx6BrmmlyJLZgJEbFf2SPfLrS39+01+Ze9MW6KX7U4hXVgWzdcwUb8NmPJBoOdu99ICP0w==
X-Received: by 2002:a7b:cc97:: with SMTP id p23mr5150715wma.120.1559733579755;
        Wed, 05 Jun 2019 04:19:39 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id 16sm15583084wmx.45.2019.06.05.04.19.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 05 Jun 2019 04:19:39 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 2/2] trace-cmd: Fix a possible race condition and deadlock in trace-cmd
Date:   Wed,  5 Jun 2019 14:19:37 +0300
Message-Id: <20190605111937.17894-2-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605111937.17894-1-tstoyanov@vmware.com>
References: <20190605111937.17894-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When pipes are used for communication between trace-cmd main
thread and per-cpu recorder threads, there is a possible race
condition in stop_threads(), which can cause a deadlock between
the main thread and cpu recorder thread:
   In trace_stream_read(), the select() call can return 0 if threads
   have no data to send. This will force stop_threads() to stop reading
   the thread's pipes and enter a waitpid() loop, to wait for all threads
   to be terminated. However, there is a case when some threads are still
   flushing its data - tracecmd_flush_recording() tries a blocking write()
   to the pipe. A dead lock appears - the cpu thread is blocked in write(),
   as its buffer is full and no one is reading it. The main thread is blocked
   in waitpid(), to wait the same thread to exit.
The deadlock can be (randomly) observed with the command
"trace-cmd profile -p function -F sleep 10"

The proposed fix removes the select timeout, makes the call blocking,
to ensure the threads are flushed its data before going in waitpid() loop.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/trace-record.c | 3 +--
 tracecmd/trace-stream.c | 6 ++++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 4523128..2f5fbd9 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -626,7 +626,6 @@ static void delete_thread_data(void)
 
 static void stop_threads(enum trace_type type)
 {
-	struct timeval tv = { 0, 0 };
 	int ret;
 	int i;
 
@@ -643,7 +642,7 @@ static void stop_threads(enum trace_type type)
 	/* Flush out the pipes */
 	if (type & TRACE_TYPE_STREAM) {
 		do {
-			ret = trace_stream_read(pids, recorder_threads, &tv);
+			ret = trace_stream_read(pids, recorder_threads, NULL);
 		} while (ret > 0);
 	}
 
diff --git a/tracecmd/trace-stream.c b/tracecmd/trace-stream.c
index dad3466..3814a35 100644
--- a/tracecmd/trace-stream.c
+++ b/tracecmd/trace-stream.c
@@ -92,6 +92,7 @@ int trace_stream_read(struct pid_record_data *pids, int nr_pids, struct timeval
 	struct pid_record_data *last_pid;
 	fd_set rfds;
 	int top_rfd = 0;
+	int nr_fd;
 	int ret;
 	int i;
 
@@ -119,18 +120,23 @@ int trace_stream_read(struct pid_record_data *pids, int nr_pids, struct timeval
 		return 1;
 	}
 
+	nr_fd = 0;
 	FD_ZERO(&rfds);
 
 	for (i = 0; i < nr_pids; i++) {
 		/* Do not process closed pipes */
 		if (pids[i].closed)
 			continue;
+		nr_fd++;
 		if (pids[i].brass[0] > top_rfd)
 			top_rfd = pids[i].brass[0];
 
 		FD_SET(pids[i].brass[0], &rfds);
 	}
 
+	if (!nr_fd)
+		return 0;
+
 	ret = select(top_rfd + 1, &rfds, NULL, NULL, tv);
 
 	if (ret > 0)
-- 
2.21.0

