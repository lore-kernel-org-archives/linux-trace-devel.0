Return-Path: <SRS0=rw6q=Q5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A1B4C10F00
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 18:05:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68E32207E0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 18:05:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727739AbfBVSFt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Feb 2019 13:05:49 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36399 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727722AbfBVSFt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Feb 2019 13:05:49 -0500
Received: by mail-wr1-f67.google.com with SMTP id o17so3351359wrw.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Feb 2019 10:05:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f381mcVQ+N5PnipoSDp4SrS6oARs5fbXaT6Ys7gW6/c=;
        b=mJ7c7udx4SKryOIMyQz6Z8rLRiVhDpFpNR8/IUVaGxfuROHa4xduPZgN7Grgk9I1qu
         YHID9SxLXoTUDtNTPjicZYbSNfofwhyTHjjikNAX2m8xuTTpHGADxj0pcSsDaVHeF9uS
         Pb0hfAkIA0gx06yEIVmZNVyZEpXF/7vQ6K5us4FKOKyVlFYy1cLFUUSmVKUXViNnNETV
         L7ie9p1ct6XzjNTgfyaynpYjuFJ+E6J2UDyhRu8aRSvkTqN5TZ+dwJTwS68qluafWWsN
         2w+jiMfm+4CKjmTyKtZjjKX0/tJ9JNEq2zCLysrAHWH76rVFrOwhoGN3vaXOJZ5eLV/o
         7MRg==
X-Gm-Message-State: AHQUAuagBtSwACwTPVKyBZKXzKF4l7YYgr5Ex/WXigZ1rx05BQooERQZ
        ED+TravDSAv1LD5rWoFepO8mobg=
X-Google-Smtp-Source: AHgI3IYqxg/VVO4UokulmHvH2MnHeZ2554i9ACdeRifCKhPHMmWby1EUA5j2LXFMGP7vCgL0mWTBHA==
X-Received: by 2002:a5d:500c:: with SMTP id e12mr4094357wrt.27.1550858746987;
        Fri, 22 Feb 2019 10:05:46 -0800 (PST)
Received: from localhost.localdomain ([146.247.46.6])
        by smtp.gmail.com with ESMTPSA id c18sm1320678wre.32.2019.02.22.10.05.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Feb 2019 10:05:46 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v8 01/13] trace-cmd: Minor cleanup in tracecmd_start_recording()
Date:   Fri, 22 Feb 2019 20:05:27 +0200
Message-Id: <20190222180539.27439-2-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190222180539.27439-1-kaslevs@vmware.com>
References: <20190222180539.27439-1-kaslevs@vmware.com>
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

