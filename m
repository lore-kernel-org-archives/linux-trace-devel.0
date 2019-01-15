Return-Path: <SRS0=27yZ=PX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0501CC43387
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Jan 2019 10:20:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3DC220656
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Jan 2019 10:20:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfAOKUZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Jan 2019 05:20:25 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33349 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728202AbfAOKUZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Jan 2019 05:20:25 -0500
Received: by mail-wm1-f67.google.com with SMTP id r24so663256wmh.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Jan 2019 02:20:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nd8y511s+A/T4Y90+0rzK89MVPcmgwYh3Gn5/KfZXEU=;
        b=iMgTcZKNfxOzXT6Tz/NPft9MjzxgtVLqOeA+PAxuG8CrXjSeuaRec8QnRqcVY7osJJ
         mqqSu4ViXc7p15aNkiURouV2QpXa275FICNvFMcjbY9n93BEfKmMzq2xR3qyCM7FVqqo
         67tJHJdGf2Wa2Kresk7SmohnafUCJGevegm1IhsxKt1yzrmne7XVQ9AW7vVKxj0xl4VJ
         Ok1RAdYaqZo3dEKhqrgJv1Nm+wBMVXBfGJJrGr/K3A9ISTFvEmjYW6Yz2ezM/wmpnq3j
         qvQKyhAIFLU8xmWkReXVpd6+DOrrCvbJ4YUCL1bQccGEMqKf86lzAJCV1PMPcR+ONRuy
         LOiw==
X-Gm-Message-State: AJcUukcheLsnvf7gR6mNik6iptviyYSj6wvPz5iqmfEmIKY7yMg05xAs
        8zKydu20rTZu8Yk+MyqEn3xSUm08
X-Google-Smtp-Source: ALg8bN6Z+JtIguqp19je/7mKCp7DeGzrpm01CijFfaKeDO6/ASI/TYzTjT/2GzX7qDlqvCUhPTdfBQ==
X-Received: by 2002:a1c:7d54:: with SMTP id y81mr2705558wmc.106.1547547623167;
        Tue, 15 Jan 2019 02:20:23 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t70sm51058516wmd.36.2019.01.15.02.20.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Jan 2019 02:20:22 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH] kernel-shark-qt: Handle the case when the range of the model is too small
Date:   Tue, 15 Jan 2019 12:18:57 +0200
Message-Id: <20190115101857.25857-1-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The size of the bin must be equal or greater than 1, hence the range
must be equal or greater than the number of bins. When this condition
is not satisfied, the range has to be extended, instead of just leaving
the model unset.

Reported-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/libkshark-model.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel-shark-qt/src/libkshark-model.c b/kernel-shark-qt/src/libkshark-model.c
index 76e2940..2094795 100644
--- a/kernel-shark-qt/src/libkshark-model.c
+++ b/kernel-shark-qt/src/libkshark-model.c
@@ -102,8 +102,10 @@ static void ksmodel_set_in_range_bining(struct kshark_trace_histo *histo,
 	struct kshark_entry *last;
 
 	/* The size of the bin must be >= 1, hence the range must be >= n. */
-	if (n == 0 || range < n)
-		return;
+	if (n == 0 || range < n) {
+		range = n;
+		max = min + n;
+	}
 
 	/*
 	 * If the number of bins changes, allocate memory for the descriptor of
-- 
2.17.1

