Return-Path: <SRS0=RjDi=YB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E1B1C4360C
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Oct 2019 08:15:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E53D7206C2
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Oct 2019 08:15:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730568AbfJHIPt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Oct 2019 04:15:49 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37524 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730549AbfJHIPt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Oct 2019 04:15:49 -0400
Received: by mail-wm1-f66.google.com with SMTP id f22so2094573wmc.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 08 Oct 2019 01:15:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hh6jsS1FBPi5xDVsy9BUCd1MfW97JEpbT/f4CNhWnAE=;
        b=NhxfpN0G93SXALULkykLgJUmFRZmwDyq6ptzb3ZAusDfL3PSPkoSvRFdS8Zds5JQxZ
         H4/yaWJ+RbuCDY4BunOY6xIVbwzMQHlteRunon4qowuE6JxlOBIfwS8ZiWbLoXAHjMPP
         v7jSvoGvtzNdteOfJDQrQvX6z3VhHTOwAVuyYpzH0Z3vl+rbF29coyUrFlgiz5cT4jqM
         p3kDj/J4JOR47NEt4WiHg6G8rvekL5stwhTzJWoKMJ0GdjskqrFDC71A42VNW6Q1iD6s
         cic9wX+zvEGarjXOoyxlISkYAuVYbgZXVUlGEt9in7p37HuXsx9YdKQ5tL4gYaE3d/bX
         pfxA==
X-Gm-Message-State: APjAAAXiRXzeye4hqV1l2KG2vceeoA+A+UNDOdV/l9MdOT9rk2bKsgE7
        OhHW8wqnWshQvl39xk2glg==
X-Google-Smtp-Source: APXvYqxMlN0LFJonQeOJdn3gYgJNwS9ItJut2oPnwq5tYImJTWD3dxFw5flBSMeJQgJ4ywJq76VD9g==
X-Received: by 2002:a1c:6a0b:: with SMTP id f11mr2916853wmc.78.1570522546994;
        Tue, 08 Oct 2019 01:15:46 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f13sm2201440wmj.17.2019.10.08.01.15.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 01:15:46 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v15 03/13] trace-cmd: Add tracecmd_create_recorder_virt() function
Date:   Tue,  8 Oct 2019 11:15:27 +0300
Message-Id: <20191008081537.11536-4-kaslevs@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191008081537.11536-1-kaslevs@vmware.com>
References: <20191008081537.11536-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add tracecmd_create_recorder_virt() which creates tracecmd_recorder recording
tracing data from the trace_fd parameter instead of from the local systems
tracefs. It will be used for recording tracing data coming from VMs.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 include/trace-cmd/trace-cmd.h  |  1 +
 lib/trace-cmd/trace-recorder.c | 61 +++++++++++++++++++++++++---------
 2 files changed, 47 insertions(+), 15 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 00889fb..65bece5 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -293,6 +293,7 @@ enum {
 void tracecmd_free_recorder(struct tracecmd_recorder *recorder);
 struct tracecmd_recorder *tracecmd_create_recorder(const char *file, int cpu, unsigned flags);
 struct tracecmd_recorder *tracecmd_create_recorder_fd(int fd, int cpu, unsigned flags);
+struct tracecmd_recorder *tracecmd_create_recorder_virt(const char *file, int cpu, unsigned flags, int trace_fd);
 struct tracecmd_recorder *tracecmd_create_recorder_maxkb(const char *file, int cpu, unsigned flags, int maxkb);
 struct tracecmd_recorder *tracecmd_create_buffer_recorder_fd(int fd, int cpu, unsigned flags, const char *buffer);
 struct tracecmd_recorder *tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags, const char *buffer);
diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index 650b259..7a4728f 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -154,16 +154,22 @@ tracecmd_create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
 	recorder->fd1 = fd;
 	recorder->fd2 = fd2;
 
-	if (flags & TRACECMD_RECORD_SNAPSHOT)
-		ret = asprintf(&path, "%s/per_cpu/cpu%d/snapshot_raw", buffer, cpu);
-	else
-		ret = asprintf(&path, "%s/per_cpu/cpu%d/trace_pipe_raw", buffer, cpu);
-	if (ret < 0)
-		goto out_free;
+	if (buffer) {
+		if (flags & TRACECMD_RECORD_SNAPSHOT)
+			ret = asprintf(&path, "%s/per_cpu/cpu%d/snapshot_raw",
+				       buffer, cpu);
+		else
+			ret = asprintf(&path, "%s/per_cpu/cpu%d/trace_pipe_raw",
+				       buffer, cpu);
+		if (ret < 0)
+			goto out_free;
+
+		recorder->trace_fd = open(path, O_RDONLY);
+		free(path);
 
-	recorder->trace_fd = open(path, O_RDONLY);
-	if (recorder->trace_fd < 0)
-		goto out_free;
+		if (recorder->trace_fd < 0)
+			goto out_free;
+	}
 
 	if ((recorder->flags & TRACECMD_RECORD_NOSPLICE) == 0) {
 		ret = pipe(recorder->brass);
@@ -183,13 +189,9 @@ tracecmd_create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
 		recorder->pipe_size = pipe_size;
 	}
 
-	free(path);
-
 	return recorder;
 
  out_free:
-	free(path);
-
 	tracecmd_free_recorder(recorder);
 	return NULL;
 }
@@ -200,8 +202,9 @@ tracecmd_create_buffer_recorder_fd(int fd, int cpu, unsigned flags, const char *
 	return tracecmd_create_buffer_recorder_fd2(fd, -1, cpu, flags, buffer, 0);
 }
 
-struct tracecmd_recorder *
-tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags, const char *buffer)
+static struct tracecmd_recorder *
+__tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags,
+				  const char *buffer)
 {
 	struct tracecmd_recorder *recorder;
 	int fd;
@@ -264,6 +267,34 @@ tracecmd_create_buffer_recorder_maxkb(const char *file, int cpu, unsigned flags,
 	goto out;
 }
 
+struct tracecmd_recorder *
+tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags,
+				const char *buffer)
+{
+	return __tracecmd_create_buffer_recorder(file, cpu, flags, buffer);
+}
+
+/**
+ * tracecmd_create_recorder_virt - Create a recorder reading tracing data
+ * from the trace_fd file descriptor instead of from the local tracefs
+ * @file: output filename where tracing data will be written
+ * @cpu: which CPU is being traced
+ * @flags: flags configuring the recorder (see TRACECMD_RECORDER_* enums)
+ * @trace_fd: file descriptor from where tracing data will be read
+ */
+struct tracecmd_recorder *
+tracecmd_create_recorder_virt(const char *file, int cpu, unsigned flags,
+			      int trace_fd)
+{
+	struct tracecmd_recorder *recorder;
+
+	recorder = __tracecmd_create_buffer_recorder(file, cpu, flags, NULL);
+	if (recorder)
+		recorder->trace_fd = trace_fd;
+
+	return recorder;
+}
+
 struct tracecmd_recorder *tracecmd_create_recorder_fd(int fd, int cpu, unsigned flags)
 {
 	const char *tracing;
-- 
2.20.1

