Return-Path: <SRS0=y1VY=QV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56C77C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 14:07:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D4F72229F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 14:07:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbfBNOHh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Feb 2019 09:07:37 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53036 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728665AbfBNOHg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Feb 2019 09:07:36 -0500
Received: by mail-wm1-f67.google.com with SMTP id m1so6439741wml.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Feb 2019 06:07:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/L+sxL3MJASp3TmTH7GNw+LnZZpZclu+Ja3ElVg4RD8=;
        b=m+Zorr3Bn7UEl/LP2fUvLjdGJPhcGRAZMxuT7WC0sNZHK3qhvaJjM3YndAVFcH1AGj
         m0m5Wn2IA3+o5/Oi2OEmneTXFxh4NdHx1nKzfyr84uGoommH5NjXcJ5HfjQNvBQjAaeW
         5GmlWZI00Kto5xS8OCwysFbyna2E8BsIfI5YqPZbQTqvcdjPtovVI7SwWbJQenGXbbYj
         ipMfP2c5Hhi6ZgNgPho4UnK9dtk5BXLhk2NYulxvEdJXJfQcZXsUcuaQwwCOC5vDO5dp
         VPJpx2JxGWJCCcziSnOn5P9Dw4JBwW8DzHuFxrDFH0rWu8qYxxP9pazS6IlOylkQuGss
         ZS2w==
X-Gm-Message-State: AHQUAuZBUITTZbFtT5wHAWPdIDsqvDApq61wVPRqxi5lYfIgBPuqpQ2Y
        DSYKcBrUHc8N9Zg6YSGmaw==
X-Google-Smtp-Source: AHgI3Ibfj9fwM/pztkmzcb/0rbZ2f+p57Ffj2Jjb3qO9pKSf3BYiLZQotP/c8Xn/MThR/HYD1Cu/QA==
X-Received: by 2002:a1c:9810:: with SMTP id a16mr2858203wme.37.1550153255050;
        Thu, 14 Feb 2019 06:07:35 -0800 (PST)
Received: from localhost.localdomain ([213.145.108.55])
        by smtp.gmail.com with ESMTPSA id c9sm2067220wrs.84.2019.02.14.06.07.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 06:07:34 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [PATCH 2/3] trace-cmd: Add defines for splice() flags on systems with old glibc
Date:   Thu, 14 Feb 2019 16:07:22 +0200
Message-Id: <20190214140723.27804-2-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190214140723.27804-1-kaslevs@vmware.com>
References: <20190214140723.27804-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Use SPLICE_F_ defines to refer to splice() flags instead of their numeric
values. This should be only necessary on systems with glibc version < 2.5.

No changes in behavior intended.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 lib/trace-cmd/trace-recorder.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index b941cdc..1b6a995 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -26,6 +26,13 @@
 # define F_GETPIPE_SZ	1032 /* The Linux number for the option */
 #endif
 
+#ifndef SPLICE_F_MOVE
+# define SPLICE_F_MOVE		1
+# define SPLICE_F_NONBLOCK	2
+# define SPLICE_F_MORE		4
+# define SPLICE_F_GIFT		8
+#endif
+
 struct tracecmd_recorder {
 	int		fd;
 	int		fd1;
@@ -122,10 +129,10 @@ tracecmd_create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
 	recorder->cpu = cpu;
 	recorder->flags = flags;
 
-	recorder->fd_flags = 1; /* SPLICE_F_MOVE */
+	recorder->fd_flags = SPLICE_F_MOVE;
 
 	if (!(recorder->flags & TRACECMD_RECORD_BLOCK))
-		recorder->fd_flags |= 2; /* and NON_BLOCK */
+		recorder->fd_flags |= SPLICE_F_NONBLOCK;
 
 	/* Init to know what to free and release */
 	recorder->trace_fd = -1;
@@ -349,7 +356,7 @@ static long splice_data(struct tracecmd_recorder *recorder)
 	long ret;
 
 	read = splice(recorder->trace_fd, NULL, recorder->brass[1], NULL,
-		      recorder->pipe_size, 1 /* SPLICE_F_MOVE */);
+		      recorder->pipe_size, SPLICE_F_MOVE);
 	if (read < 0) {
 		if (errno != EAGAIN && errno != EINTR) {
 			warning("recorder error in splice input");
@@ -421,7 +428,7 @@ static void set_nonblock(struct tracecmd_recorder *recorder)
 	fcntl(recorder->trace_fd, F_SETFL, flags | O_NONBLOCK);
 
 	/* Do not block on streams for write */
-	recorder->fd_flags |= 2; /* NON_BLOCK */
+	recorder->fd_flags |= SPLICE_F_NONBLOCK;
 }
 
 long tracecmd_flush_recording(struct tracecmd_recorder *recorder)
-- 
2.19.1

