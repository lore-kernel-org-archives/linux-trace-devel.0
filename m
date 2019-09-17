Return-Path: <SRS0=9KLN=XM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A2AEC4CECE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Sep 2019 13:15:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE15621852
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Sep 2019 13:15:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbfIQNPu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Sep 2019 09:15:50 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35493 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727465AbfIQNPu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Sep 2019 09:15:50 -0400
Received: by mail-wm1-f67.google.com with SMTP id y21so3151642wmi.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 17 Sep 2019 06:15:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1HyflqO0II7y9lDFdsBf9h3CANr/yJyTbeRPCrCF+Nw=;
        b=gVNjBej1QRFLBxM1N51DValvW59qfbAZuRzR7FVsrOcVwqTj4WJe7ioYcGy+3VSoeX
         JEy7EjEtqsJVgfcbSx1liVvdnzn0ykdtt98t7QUX7YBruhGBdzowRtskfqN5EoHTPjzx
         YC5ubG/VEY3sVOh5lrCEZ9dQKr8kP5CjpqMroqyPlCh/9AT63BZU2dZkbQhWI/JXXsEj
         +d5/PlJWkvMooDtEhzm5iX7T/G3hCltrf2QS3UCURXVu/bpCTsc6ftt4QkKMTurmvZA3
         abXU7b+Z3JlXJ+xe9SnM8gMEnh0roTV9T3WLl9f3bDjQONquU30lq0Pq6ZYxztjOpiOU
         TMQA==
X-Gm-Message-State: APjAAAWDhYTRlcVYOWaNSklO+WMb8lqW1YS4Iikzw9Y8j6VfbtB2bVbY
        dY2o63JHC/uN1S1xjyMYdA==
X-Google-Smtp-Source: APXvYqzqcfxGTdT0lxQ80yshepHwHpExQIXB78tcGW/ttrtFJdOA82OVMP5z7O/HgsZX/fVQz5d9Vw==
X-Received: by 2002:a05:600c:34e:: with SMTP id u14mr3286607wmd.110.1568726148703;
        Tue, 17 Sep 2019 06:15:48 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d22sm1667265wmb.44.2019.09.17.06.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Sep 2019 06:15:48 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v14 03/13] trace-cmd: Add tracecmd_create_recorder_virt() function
Date:   Tue, 17 Sep 2019 16:15:28 +0300
Message-Id: <20190917131538.31926-4-kaslevs@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190917131538.31926-1-kaslevs@vmware.com>
References: <20190917131538.31926-1-kaslevs@vmware.com>
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
index 03d8c47..e722243 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -282,6 +282,7 @@ enum {
 void tracecmd_free_recorder(struct tracecmd_recorder *recorder);
 struct tracecmd_recorder *tracecmd_create_recorder(const char *file, int cpu, unsigned flags);
 struct tracecmd_recorder *tracecmd_create_recorder_fd(int fd, int cpu, unsigned flags);
+struct tracecmd_recorder *tracecmd_create_recorder_virt(const char *file, int cpu, unsigned flags, int trace_fd);
 struct tracecmd_recorder *tracecmd_create_recorder_maxkb(const char *file, int cpu, unsigned flags, int maxkb);
 struct tracecmd_recorder *tracecmd_create_buffer_recorder_fd(int fd, int cpu, unsigned flags, const char *buffer);
 struct tracecmd_recorder *tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags, const char *buffer);
diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index 0bd0657..0ea7a87 100644
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

