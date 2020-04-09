Return-Path: <SRS0=lsLa=5Z=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6034AC2BB86
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 13:28:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 376282072F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 13:28:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JOaaAD1b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgDIN2c (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Apr 2020 09:28:32 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:44793 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbgDIN2c (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Apr 2020 09:28:32 -0400
Received: by mail-lf1-f67.google.com with SMTP id 131so7860587lfh.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Apr 2020 06:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yDbsjsf0fa/m4NJ1OsjkfzThQeEW/rDZdhpouDM8e/c=;
        b=JOaaAD1boU2Iy9aRnoXi8LCijF3hEldKtpg7jGQyuViAqE+FdNPRy/TW361CkQbaWz
         LF3wUP24tK83UGSCDIa0RL95eAutGWMrupMZadW2FKB+oS2/X1KnslYELzHVBzJALjwz
         RMVX5ZCSFT0mtT8lDzvAlFAnTVFpCHK4MI2M4GQGzhEUIu0BN7FCyYIUvsWQKxBuQC8P
         tr2QaYc3Fst3SlAzHXX39O30AfHQtmI5mx9yh/a/EL38ZdwKo6mspWGahULS5jp1nmgO
         i0amCTSwo482mxOhfgewu4nExpA9y2Bw5CRvZl8HMA+qlALd9GP5FKBHjWAIN8oLqRzd
         wkMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yDbsjsf0fa/m4NJ1OsjkfzThQeEW/rDZdhpouDM8e/c=;
        b=TV7LsS9DOgC03wzc5mpGdv9wq91M5pjD3eTHxnEMw6/hM0j/gSaFvpZrVjWstWtE0r
         DE3RWZFJCKfVSXdgPKNWWVoKyMSL9npmDwxOTBEGugq3Az963+7imSFCNXo0luafTMUF
         7KhGvfjNyHE7EGYjrVqMDtvFoL7C5PxmZ7STdJT3U1Q/4viyfhFIKKD8Q+U3SbOoDDkB
         rIUmmaMwLb/JM230klZoPYV5nmfWzBW3Smjv/TpHsovZFxDnv8OmuvnGpNlr54zxYv3q
         x48IkN6uj9ykA+AMhjttMdCORa380rGS/4c87+FE5YQfrdR424BrRy8N2pTsYcsXLt5f
         VXvA==
X-Gm-Message-State: AGi0Pua6v/N6UEY2Jod0YQevm5lMwLf7DQlwjp9TyDF9soDaATm2QGrh
        v/E6huGAIyg8k/HfsgWQMbA=
X-Google-Smtp-Source: APiQypIUh2WB0/dqM+tlOeeEM3S/bncjUAOb2da6FZ3qsrHlmvMs+GvzYZ7xwh8PufKOLOWnZmYQFA==
X-Received: by 2002:a19:dc05:: with SMTP id t5mr3107248lfg.156.1586438910334;
        Thu, 09 Apr 2020 06:28:30 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id 64sm15237121ljj.41.2020.04.09.06.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 06:28:29 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] trace-cmd: Add new API tracecmd_open_head()
Date:   Thu,  9 Apr 2020 16:28:25 +0300
Message-Id: <20200409132825.79475-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200409132825.79475-1-tz.stoyanov@gmail.com>
References: <20200409132825.79475-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add an API to create a tracecmd_handle from a file,
read and parse only the trace headers from the file.
This allows to implement opening a trace file on
stages - reading the trace headers and reading the trace data.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h |  1 +
 lib/trace-cmd/trace-input.c   | 28 ++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 3f96bbde..e22aa251 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -143,6 +143,7 @@ typedef void (*tracecmd_handle_init_func)(struct tracecmd_input *handle,
 struct tracecmd_input *tracecmd_alloc(const char *file);
 struct tracecmd_input *tracecmd_alloc_fd(int fd);
 struct tracecmd_input *tracecmd_open(const char *file);
+struct tracecmd_input *tracecmd_open_head(const char *file);
 struct tracecmd_input *tracecmd_open_fd(int fd);
 void tracecmd_ref(struct tracecmd_input *handle);
 void tracecmd_close(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index ee9bfb52..efc8d4bd 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3175,6 +3175,34 @@ struct tracecmd_input *tracecmd_open(const char *file)
 	return tracecmd_open_fd(fd);
 }
 
+/**
+ * tracecmd_open_head - create a tracecmd_handle from a given file, read
+ *			read and parse only the trace headers from the file
+ * @file: the file name of the file that is of tracecmd data type.
+ */
+struct tracecmd_input *tracecmd_open_head(const char *file)
+{
+	struct tracecmd_input *handle;
+	int fd;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0)
+		return NULL;
+
+	handle = tracecmd_alloc_fd(fd);
+	if (!handle)
+		return NULL;
+
+	if (tracecmd_read_headers(handle) < 0)
+		goto fail;
+
+	return handle;
+
+fail:
+	tracecmd_close(handle);
+	return NULL;
+}
+
 /**
  * tracecmd_ref - add a reference to the handle
  * @handle: input handle for the trace.dat file
-- 
2.25.1

