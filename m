Return-Path: <SRS0=t+9I=SE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A730BC10F00
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:42:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ED572146E
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:42:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731773AbfDBNmq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Apr 2019 09:42:46 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45796 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731863AbfDBNmk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Apr 2019 09:42:40 -0400
Received: by mail-wr1-f67.google.com with SMTP id s15so16710428wra.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 02 Apr 2019 06:42:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f381mcVQ+N5PnipoSDp4SrS6oARs5fbXaT6Ys7gW6/c=;
        b=CXirjWWaaTDNP2c4X8gTxRUuZ4V6f9LvugSYK+uR8i2Gk/QzNHDiVITqfV36SBrOuD
         CVhPBs3nn9U/sr9ZgmzLcxHWXES5Nxfol50VtT2OgQ0Fzr9qLIOt5IOsbWnL9TXWoT0i
         KC78WQbAOD9AJ0qjym/JaEMUC4AsuriVCS8uh/Em/WZx6VDuu0BF+2+XcSoW87hRW/UM
         iuDIvLriKhI745X4iZIa4csufdnfdaUO6wdGgotVPrlcJ2ZeKVclLw6QDJyZ1B2Gmkuq
         0dS0bdlagJMLMUBA0v2+XREdDzF+j9cq4AP4ysSLHrsI0bfur9KgdNrSQOlyyeky2Rvc
         92QA==
X-Gm-Message-State: APjAAAUeE7Pgpxg8Px8VDbwiTpYsZXrp+FmrsJzPwQUhIMX8mqpmG38X
        kFAZdq1+M2Ae5vopK355pw==
X-Google-Smtp-Source: APXvYqxSddoQUYA6mzR4rsAf0xfr/lr8CgJY7i0IhyTizdJFgrT+3mSo3pM72mSBRnRbJtwwCnTxzw==
X-Received: by 2002:adf:e692:: with SMTP id r18mr48378456wrm.231.1554212558879;
        Tue, 02 Apr 2019 06:42:38 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id h84sm19207083wmf.15.2019.04.02.06.42.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Apr 2019 06:42:38 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Cc:     slavomir.kaslev@gmail.com
Subject: [RFC PATCH v8 01/13] trace-cmd: Minor cleanup in tracecmd_start_recording()
Date:   Tue,  2 Apr 2019 16:42:08 +0300
Message-Id: <20190402134230.30988-3-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190402134230.30988-1-kaslevs@vmware.com>
References: <20190402134230.30988-1-kaslevs@vmware.com>
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

