Return-Path: <SRS0=t+9I=SE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75C7CC10F0E
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49DF42147C
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731640AbfDBNms (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Apr 2019 09:42:48 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37103 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731874AbfDBNmo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Apr 2019 09:42:44 -0400
Received: by mail-wm1-f67.google.com with SMTP id v14so3783744wmf.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 02 Apr 2019 06:42:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AwHcVjQPrJxM8t+IVxCpmICfebBJLeVLZ3ZHzLqNUx0=;
        b=QFOtys63fs9vGPlOEYixtImLxgFcLw3y7vnZo6pmJxqxXbgMKOfQE2r6HxwWCDZDH9
         sI/LZO2/iPpFENioKghDJ46UtvpAnfKwl085HAyREPaXycJCMSgi5UldFoV2l5yME39B
         IQYBFWQ3SopQrC4reSw8ogDzKzd/KwFl5dPvg47dAyvTp0fS1+PsaTOLlPOs0YTtlWqu
         cTXDlGqbCnLpeF+oUmjN1adtTlSiXvdlTlc8ppMT/uer1k1cJmkrM2I/OCc+P7qgtZu5
         wmjo7HUMmEEt+qr9pZ9f6jfZDFmD+ApzAB+Kyts7a/JqQZpsF0AJ5XvCgsmEm3z8727N
         G1Ig==
X-Gm-Message-State: APjAAAWEZZ6WwvSs9UmZa7HLI9In714ugRWFX+Ue0lUzUEdxauxeP7Mc
        EL1E9LbfBJOjBxCpqw5Rng==
X-Google-Smtp-Source: APXvYqxzY+/uqo8bxJfpTZY6s18JelX+EMJVL7+wF2AwiXzDIqEu91qxejRzYNV685iKCaBv25WqRA==
X-Received: by 2002:a1c:f618:: with SMTP id w24mr3896073wmc.3.1554212562183;
        Tue, 02 Apr 2019 06:42:42 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id h84sm19207083wmf.15.2019.04.02.06.42.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Apr 2019 06:42:41 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v8 03/11] trace-cmd: Add tracecmd_create_recorder_virt function
Date:   Tue,  2 Apr 2019 16:42:11 +0300
Message-Id: <20190402134230.30988-6-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190402134230.30988-1-kaslevs@vmware.com>
References: <20190402134230.30988-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add tracecmd_create_recorder_virt function that will be used for
tracing VM guests.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 include/trace-cmd/trace-cmd.h  |  1 +
 lib/trace-cmd/trace-recorder.c | 53 ++++++++++++++++++++++++----------
 2 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 9cfb987..057f096 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -277,6 +277,7 @@ enum {
 void tracecmd_free_recorder(struct tracecmd_recorder *recorder);
 struct tracecmd_recorder *tracecmd_create_recorder(const char *file, int cpu, unsigned flags);
 struct tracecmd_recorder *tracecmd_create_recorder_fd(int fd, int cpu, unsigned flags);
+struct tracecmd_recorder *tracecmd_create_recorder_virt(const char *file, int cpu, unsigned flags, int trace_fd);
 struct tracecmd_recorder *tracecmd_create_recorder_maxkb(const char *file, int cpu, unsigned flags, int maxkb);
 struct tracecmd_recorder *tracecmd_create_buffer_recorder_fd(int fd, int cpu, unsigned flags, const char *buffer);
 struct tracecmd_recorder *tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags, const char *buffer);
diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index 0bd0657..1b84bb5 100644
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
@@ -264,6 +267,26 @@ tracecmd_create_buffer_recorder_maxkb(const char *file, int cpu, unsigned flags,
 	goto out;
 }
 
+struct tracecmd_recorder *
+tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags,
+				const char *buffer)
+{
+	return __tracecmd_create_buffer_recorder(file, cpu, flags, buffer);
+}
+
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
2.19.1

