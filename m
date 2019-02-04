Return-Path: <SRS0=T0vY=QL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D79DC282C4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 06:59:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB1E620811
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 06:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbfBDG7Q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Feb 2019 01:59:16 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54650 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfBDG7Q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Feb 2019 01:59:16 -0500
Received: by mail-wm1-f67.google.com with SMTP id a62so11910836wmh.4
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 Feb 2019 22:59:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BLuQN/bAKgJ8I0YFAGQgYKvqZfR8uQV6+xYGJ04W4N8=;
        b=ldObPestTtdgbg71RO//nJ2k5ieV+dgyWtmWoyvjCc3M6asc8LGY3I9L11QUx8Sg/9
         jSetCygcPN+Gqtg/ykbwBD1PtUoFQseCep4J/nsCzLXH+1YVuyeOfO07NoaT5MBmA8gR
         EMXp7fymKfABJ8HiB3OCayurqY/KSVqCYPLo/0slRb17RfWtvNIfMjhcpiCzEu88MHTN
         1X4gQmX1mb2yWf0ySSWNJWT4wV5tpwVXOVJWC7sns3/SQphD+zJXAwNFXFYg37borPLm
         uTkFgE7jh4QKK96VLujiod0Chy3GTQbPd5qflhqwBmiY0kYtxNRAVimZlHsI3eJJmhd+
         ZcVA==
X-Gm-Message-State: AHQUAuY35Tm38vVu9o2LL3/ldAjVFtiFON7gC0no2z7SkrpiBuur2gre
        dt4GyAMBrcl5c4Iu6Sz1IiD7c1sRZQ==
X-Google-Smtp-Source: AHgI3IZYa1ELp9qfNHjPtFQ9TwKg04XyrVLzi3g6lnkqRWkKlQiTSHWJv6h54B1DORyhhnlZG3FjdA==
X-Received: by 2002:a1c:a8d2:: with SMTP id r201mr11492610wme.81.1549263554010;
        Sun, 03 Feb 2019 22:59:14 -0800 (PST)
Received: from localhost.localdomain ([213.145.108.55])
        by smtp.gmail.com with ESMTPSA id q12sm12596809wrx.31.2019.02.03.22.59.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Feb 2019 22:59:13 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, slavomir.kaslev@gmail.com,
        tstoyanov@vmware.com, ykaradzhov@vmware.com
Subject: [RFC PATCH v5 10/11] trace-cmd: Set both input and output to non-blocking when recording is stopped
Date:   Mon,  4 Feb 2019 08:58:47 +0200
Message-Id: <20190204065848.8248-11-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190204065848.8248-1-kaslevs@vmware.com>
References: <20190204065848.8248-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When tracing VMs over FIFOs both the agent and the host recording process might
get blocked doing IO over a FIFO when the other side is gone. In this case we
won't get EPIPE error (as in the vsockets case) since the FIFOs will always be
opened by the hypervisor.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 lib/trace-cmd/trace-recorder.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index b750935..1c12c9e 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -40,6 +40,7 @@ struct tracecmd_recorder {
 	int		pages;
 	int		count;
 	unsigned	fd_flags;
+	unsigned	trace_fd_flags;
 	unsigned	flags;
 };
 
@@ -121,6 +122,8 @@ tracecmd_create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
 	if (!(recorder->flags & TRACECMD_RECORD_BLOCK))
 		recorder->fd_flags |= 2; /* and NON_BLOCK */
 
+	recorder->trace_fd_flags = 1; /* SPLICE_F_MOVE */
+
 	/* Init to know what to free and release */
 	recorder->trace_fd = -1;
 	recorder->brass[0] = -1;
@@ -366,7 +369,7 @@ static long splice_data(struct tracecmd_recorder *recorder)
 	long ret;
 
 	read = splice(recorder->trace_fd, NULL, recorder->brass[1], NULL,
-		      recorder->pipe_size, 1 /* SPLICE_F_MOVE */);
+		      recorder->pipe_size, recorder->trace_fd_flags);
 	if (read < 0) {
 		if (errno != EAGAIN && errno != EINTR) {
 			warning("recorder error in splice input");
@@ -434,9 +437,12 @@ static void set_nonblock(struct tracecmd_recorder *recorder)
 	/* Do not block on reads for flushing */
 	flags = fcntl(recorder->trace_fd, F_GETFL);
 	fcntl(recorder->trace_fd, F_SETFL, flags | O_NONBLOCK);
+	recorder->trace_fd_flags |= 2; /* SPLICE_F_NONBLOCK */
 
 	/* Do not block on streams for write */
-	recorder->fd_flags |= 2; /* NON_BLOCK */
+	flags = fcntl(recorder->fd, F_GETFL);
+	fcntl(recorder->fd, F_SETFL, flags | O_NONBLOCK);
+	recorder->fd_flags |= 2; /* SPLICE_F_NONBLOCK */
 }
 
 long tracecmd_flush_recording(struct tracecmd_recorder *recorder)
-- 
2.19.1

