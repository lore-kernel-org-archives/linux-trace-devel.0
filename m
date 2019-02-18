Return-Path: <SRS0=zcJY=QZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C2F0C43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Feb 2019 14:55:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FB0821479
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Feb 2019 14:55:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729505AbfBROzA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Feb 2019 09:55:00 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46528 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728893AbfBROzA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Feb 2019 09:55:00 -0500
Received: by mail-wr1-f68.google.com with SMTP id i16so10451008wrs.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 18 Feb 2019 06:54:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f381mcVQ+N5PnipoSDp4SrS6oARs5fbXaT6Ys7gW6/c=;
        b=q6b51pu0Y4fMqnViypMnZOmUm+2daVysKVCRMycaPdSlUOeMALKaScOkw4rma/B1SN
         Y+C8KRTMJmozd2gQYzeHAozdfmRJUbz9ev0N1y+m2QA6cQczftx4BgF7RoZb1sW6OUPt
         COc3tYmlrzJQpxPfPa9b486IrbAdYczLGsbrPSh69rEePCnLkk++EfPzMevgSh+nk3Fa
         cbxoVFFTLc8iDR1toDtWHpBN50krH16ATQwARHZggIgMcrd4xq4c6BFbMMY+1bX9NJ1O
         ZwMAVJuI7vnqMCJ8vARkrsrDKQ37LWn+D7GvI9n1RMp5Jdt+WDFR40VENozCCru5sCUl
         SVWA==
X-Gm-Message-State: AHQUAua2rCa4VsNhX1730nRULewcfQZTh1YqEEbkBFJlGfxfoYlFfiZj
        /ihQjJkZKyYBKSvQScY9Tw==
X-Google-Smtp-Source: AHgI3Iah3T3AvvMa65vRWChiQ+jgeAAldqUY43Wp+fIHPUSlD3nTjCBlGYVOKT8rex29+FDdhMMacA==
X-Received: by 2002:a5d:550f:: with SMTP id b15mr18074830wrv.251.1550501698309;
        Mon, 18 Feb 2019 06:54:58 -0800 (PST)
Received: from localhost.localdomain ([146.247.46.6])
        by smtp.gmail.com with ESMTPSA id n11sm10172528wrw.60.2019.02.18.06.54.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Feb 2019 06:54:57 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@vmware.com, rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v7 01/13] trace-cmd: Minor cleanup in tracecmd_start_recording()
Date:   Mon, 18 Feb 2019 16:54:37 +0200
Message-Id: <20190218145449.13360-2-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190218145449.13360-1-kaslevs@vmware.com>
References: <20190218145449.13360-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Initialize `struct timespec req` only once instead of on every loop iteration
since `sleep` is being constant throughout tracecmd_start_recording() execution.

No changes in behavior intended.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 lib/trace-cmd/trace-recorder.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index 0b8d98a..0bd0657 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -466,7 +466,10 @@ long tracecmd_flush_recording(struct tracecmd_recorder *recorder)
 
 int tracecmd_start_recording(struct tracecmd_recorder *recorder, unsigned long sleep)
 {
-	struct timespec req;
+	struct timespec req = {
+		.tv_sec = sleep / 1000000,
+		.tv_nsec = (sleep % 1000000) * 1000,
+	};
 	long read = 1;
 	long ret;
 
@@ -474,11 +477,9 @@ int tracecmd_start_recording(struct tracecmd_recorder *recorder, unsigned long s
 
 	do {
 		/* Only sleep if we did not read anything last time */
-		if (!read && sleep) {
-			req.tv_sec = sleep / 1000000;
-			req.tv_nsec = (sleep % 1000000) * 1000;
+		if (!read && sleep)
 			nanosleep(&req, NULL);
-		}
+
 		read = 0;
 		do {
 			if (recorder->flags & TRACECMD_RECORD_NOSPLICE)
-- 
2.19.1

