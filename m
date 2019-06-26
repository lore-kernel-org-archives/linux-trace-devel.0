Return-Path: <SRS0=TDtF=UZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22DDAC48BD8
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jun 2019 10:52:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFBDA2082F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jun 2019 10:52:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IAPftJgh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfFZKwY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 06:52:24 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36775 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbfFZKwW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 06:52:22 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so2195490wrs.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jun 2019 03:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OSqeRIKsAbMx4Tm9NXEWvQRKCwfFcBw6qdK6XhGo358=;
        b=IAPftJghTjJJV9KvBrJ1V/KsPOLb2utbc43YhJ7bDqxX/ON1VdKrWgRkw5/iLZovCZ
         VfRag/4V73Bh9/LrcEGH4PSJcRXzt5sAI6hJP9KF9/W3IA16Pe/5D/XJ8iG30OrEwLIf
         8IB0cwQJisBJCBy2GqDg57T9evugq+A/9vZJQCVpmWutw/1u6BFhN74w2Lzy10FWf2+h
         kibchGutMtYiGqVMfHcg8POe6lkekDKeRJ4SJkcvkZudZeOuU8FpRf9eqFhZhlSAQcra
         arFwHTmbxZV6wKVkXDTdg6R7nodFbcW/KXZ23F+xbqsXBw/uuNYnqRl41oOVeOSOStFn
         mAMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OSqeRIKsAbMx4Tm9NXEWvQRKCwfFcBw6qdK6XhGo358=;
        b=DDwaBznPbME3bYpXQXzWWI4X5bKR5opXJi1V5KDFYoahOy/siEdqpgSHKT7x0HsZdt
         OHIZXe3Lo6zdCAZoQKJvPg/z90VcqHUcCDXWXemOg4edoUiio1zZdSgD9DllK48kpBQE
         dlPZWa5DZ02SdJVCrv0jquxnAvbNmPBiFTWAaOwbLm9Cbf+1hjWVsDVG1sqvUZRbwgSh
         OBb1df42VVS3p+jYYa0XRcbfSC4Yft3WPnayHlSL1LYzqahI+Td6hk0iL3ewVPWlhiHm
         otXzQsL65HI+/ZFiVypQykrRlTanFiWG/8LeO44rtQRzTkt6y/CpdbZuuMP2Ic20/g1q
         pvdQ==
X-Gm-Message-State: APjAAAVsUuWObu75vbYieKSJMFRYscVTI7FIVVR7WFAJwg+322Ue2jvc
        o4SJoim4LmraSZyQfz2lZzTH3UpyUQ==
X-Google-Smtp-Source: APXvYqwKIFn9s1SIqpje2J03VGtiXsizmxuZmNTgPtpa778spMBTh6hrl2NnMBIB89BQdgr/3JE4Qg==
X-Received: by 2002:a5d:484e:: with SMTP id n14mr3158615wrs.348.1561546340300;
        Wed, 26 Jun 2019 03:52:20 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id s10sm15456929wrt.49.2019.06.26.03.52.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 03:52:19 -0700 (PDT)
From:   "Slavomir Kaslev (VMware)" <slavomir.kaslev@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v13 03/13] trace-cmd: Add tracecmd_create_recorder_virt() function
Date:   Wed, 26 Jun 2019 13:51:59 +0300
Message-Id: <20190626105209.13200-4-slavomir.kaslev@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626105209.13200-1-slavomir.kaslev@gmail.com>
References: <20190626105209.13200-1-slavomir.kaslev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Slavomir Kaslev <kaslevs@vmware.com>

Add tracecmd_create_recorder_virt() which creates tracecmd_recorder recording
tracing data from the trace_fd parameter instead of from the local systems
tracefs. It will be used for recording tracing data coming from VMs.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 include/trace-cmd/trace-cmd.h  |  1 +
 lib/trace-cmd/trace-recorder.c | 61 +++++++++++++++++++++++++---------
 2 files changed, 47 insertions(+), 15 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 923015e..28b5b38 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -281,6 +281,7 @@ enum {
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

