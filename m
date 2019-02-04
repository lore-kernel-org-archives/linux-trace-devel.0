Return-Path: <SRS0=T0vY=QL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48EAAC282D7
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 06:59:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2011A20811
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 06:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbfBDG7B (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Feb 2019 01:59:01 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42458 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfBDG7A (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Feb 2019 01:59:00 -0500
Received: by mail-wr1-f68.google.com with SMTP id q18so13121828wrx.9
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 Feb 2019 22:58:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S8/m/OZ2EmADcsb4CCYO4FGTMLTjcD4Du9Mh697xVdY=;
        b=EiQjHWDER6i2WSXsxwQprcxvr78daAp0trk6Adw4ymhJjiObhE+1rFvbvjda21Ojzq
         OnG2Ud4Z23fkKcywGGygpNGuvgVpy5tvl/Hrc7G/qCrUw5LvxgrIwt6SbnUvLX9tJ87V
         HdFOvccD5JjX1+RIv7IsZ1uw9b9mwikHvV9viaxRsQaEKzRhDTZFvcSrZfFn7l3KENa3
         Re9k7+dQ8Uv5gVL3N07C/xYdAOKBDJq3F/+GfTv3/YCwQVAjnOr2mjOuBAqwaB7K42uH
         V/I7rENi2FgHmWCT1E4GTHeWX3a8D8MxuMvYPmA764ulcZurTBIheqYDaLYeSQDQKdU7
         cxvA==
X-Gm-Message-State: AHQUAuZtSRkdrKR1J/CU6kowDcKdtq0GABqWlb42qFapAsxOYJ80x1aD
        EwwJR4kK8LoW59+AtLau19v2ylW3bw==
X-Google-Smtp-Source: AHgI3IZlloizZ+5wB0GBKgW4ryRj70bCYF0T6RXpRsBC1ZrvPChLh0lXHQyED7IZkPmvZTWWn0ZZ0A==
X-Received: by 2002:a5d:5285:: with SMTP id c5mr5756354wrv.167.1549263538693;
        Sun, 03 Feb 2019 22:58:58 -0800 (PST)
Received: from localhost.localdomain ([213.145.108.55])
        by smtp.gmail.com with ESMTPSA id q12sm12596809wrx.31.2019.02.03.22.58.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Feb 2019 22:58:57 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, slavomir.kaslev@gmail.com,
        tstoyanov@vmware.com, ykaradzhov@vmware.com
Subject: [RFC PATCH v5 02/11] trace-cmd: Add tracecmd_create_recorder_virt function
Date:   Mon,  4 Feb 2019 08:58:39 +0200
Message-Id: <20190204065848.8248-3-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190204065848.8248-1-kaslevs@vmware.com>
References: <20190204065848.8248-1-kaslevs@vmware.com>
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
index 86b9b53..8b43462 100644
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
index 5331925..83a12f4 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -148,16 +148,22 @@ tracecmd_create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
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
@@ -177,13 +183,9 @@ tracecmd_create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
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
@@ -194,8 +196,9 @@ tracecmd_create_buffer_recorder_fd(int fd, int cpu, unsigned flags, const char *
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
@@ -258,6 +261,26 @@ tracecmd_create_buffer_recorder_maxkb(const char *file, int cpu, unsigned flags,
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

