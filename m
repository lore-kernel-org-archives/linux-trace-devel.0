Return-Path: <SRS0=y1VY=QV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00921C10F04
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 14:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6366222B6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 14:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404606AbfBNOOA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Feb 2019 09:14:00 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40033 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404695AbfBNOOA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Feb 2019 09:14:00 -0500
Received: by mail-wm1-f65.google.com with SMTP id q21so6236814wmc.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Feb 2019 06:13:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8CgUUY1biRmrlWDl71WHBVB0JS4hyfZsFB7NqoyligE=;
        b=qGJg/+ljKLnmL8dPJPrIP35r3u4WO3TpDIqfDnzrhc51/7tpNTY3G5UZkXqnjYENJT
         GdOYZwce5cFUuwR1bzwXRa7V8DgV+nCt1Q3fL/BBTHsIGd1cuXIqdKAPhWEZSgyCgZvC
         OhVMITjGE0dKnJzEIq139WkspGfApuE22FFuG0OR/PMIJX46TCEbFlabW+6N3rN+RxoR
         43hFekp5rT/o8KMYkP20o5P5bRBLFzFaSN0PrX0iBgl4QBMZRDBzu/6gP8ZICh0XzK3s
         4TDyphmhAy2WKBSi9S8Ah9cWq8qtP1spqeooqtqBN7pvKsVKJC4SfrqT77iOMD4n9DZD
         6N0w==
X-Gm-Message-State: AHQUAubemWziednqTNSJlU8zNqd7Pq/oIHp4BcdINGhgOhc5pzWWI+MD
        8IKTR3jQvh3nXgEYUkGimQ==
X-Google-Smtp-Source: AHgI3IY1itGoDV1UvnKvOzmS3ZhLoERV8rruSRvMqNZy5VGAh/38EH7POOUxOrJp4VuiVEWOnb5EKQ==
X-Received: by 2002:a1c:4c1a:: with SMTP id z26mr2954430wmf.139.1550153637695;
        Thu, 14 Feb 2019 06:13:57 -0800 (PST)
Received: from localhost.localdomain ([213.145.108.55])
        by smtp.gmail.com with ESMTPSA id m4sm1844840wml.2.2019.02.14.06.13.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 06:13:56 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v6 06/11] trace-cmd: Use splice(2) for vsockets if available
Date:   Thu, 14 Feb 2019 16:13:30 +0200
Message-Id: <20190214141335.28144-7-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190214141335.28144-1-kaslevs@vmware.com>
References: <20190214141335.28144-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Detect if splice(2) reading is supported for vsockets (Linux 4.20 and
later) and use it, or fallback to read/write-ing otherwise.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 lib/trace-cmd/trace-recorder.c |  6 ++--
 tracecmd/trace-record.c        | 56 ++++++++++++++++++++++++++++++++--
 2 files changed, 56 insertions(+), 6 deletions(-)

diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index fc71180..e45e2d1 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -386,10 +386,8 @@ static long splice_data(struct tracecmd_recorder *recorder)
 	ret = splice(recorder->brass[0], NULL, recorder->fd, NULL,
 		     read, recorder->fd_flags);
 	if (ret < 0) {
-		if (errno != EAGAIN && errno != EINTR) {
-			warning("recorder error in splice output");
-			return -1;
-		}
+		if (errno != EAGAIN && errno != EINTR)
+			return ret;
 		return total_read;
 	} else
 		update_fd(recorder, ret);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 8a1a665..e48b270 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2660,12 +2660,61 @@ static int open_vsock(unsigned int cid, unsigned int port)
 
 	return sd;
 }
+
+static int try_splice_read_vsock(void)
+{
+	int ret, sd, brass[2];
+
+	sd = socket(AF_VSOCK, SOCK_STREAM, 0);
+	if (sd < 0)
+		return sd;
+
+	ret = pipe(brass);
+	if (ret < 0)
+		goto out_close_sd;
+
+	/*
+	 * On kernels that don't support splice reading from vsockets
+	 * this will fail with EINVAL, or ENOTCONN otherwise.
+	 * Technically, it should never succeed but if it does, claim splice
+	 * reading is supported.
+	 */
+	ret = splice(sd, NULL, brass[1], NULL, 10, 0);
+	if (ret < 0)
+		ret = errno != EINVAL;
+	else
+		ret = 1;
+
+	close(brass[0]);
+	close(brass[1]);
+out_close_sd:
+	close(sd);
+	return ret;
+}
+
+static bool can_splice_read_vsock(void)
+{
+	static bool initialized, res;
+
+	if (initialized)
+		return res;
+
+	res = try_splice_read_vsock() > 0;
+	initialized = true;
+	return res;
+}
+
 #else
 static inline int open_vsock(unsigned int cid, unsigned int port)
 {
 	die("vsock is not supported");
 	return -1;
 }
+
+static bool can_splice_read_vsock(void)
+{
+	return false;
+}
 #endif
 
 static int do_accept(int sd)
@@ -2870,13 +2919,16 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 
 	if (instance->flags & BUFFER_FL_GUEST) {
 		int sd;
+		unsigned int flags;
 
 		sd = open_vsock(instance->cid, instance->client_ports[cpu]);
 		if (sd < 0)
 			die("Failed to connect to agent");
 
-		return tracecmd_create_recorder_virt(
-			file, cpu, recorder_flags | TRACECMD_RECORD_NOSPLICE, sd);
+		flags = recorder_flags;
+		if (!can_splice_read_vsock())
+			flags |= TRACECMD_RECORD_NOSPLICE;
+		return tracecmd_create_recorder_virt(file, cpu, flags, sd);
 	}
 
 	if (brass)
-- 
2.19.1

