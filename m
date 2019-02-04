Return-Path: <SRS0=T0vY=QL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72C64C282D7
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 07:09:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 400362081B
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 07:09:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfBDHJJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Feb 2019 02:09:09 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43619 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbfBDHJI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Feb 2019 02:09:08 -0500
Received: by mail-wr1-f65.google.com with SMTP id r2so1468359wrv.10
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 Feb 2019 23:09:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kI3IuMD7C5qSiSz4Zis0PplHVi2r/Ugs3P/CD04QUkg=;
        b=I8Zw/ZzvTxB8GYpe/nHoZ/q2dJNDki2kkbimzRQWhyMlodIhf+bvfKO4Hhi1+LfwvU
         IkY7bRMKiOpzc5+gTrpEuOBiyGeXHp3e2Egd1HC8HTbRyE15E57VuSmOpICDdGT4vxVc
         3wYjzjU75oNRnIDUxaS17ebkBGNnLdttBD0vAkXUcFvZd6IrKrGlCMzEjw9tj2lzX4pH
         L0yZQi3GvVpbt10ZbB9lCWCxF8cycnmD31WIV2v4qps5QivRMRKFCEgSBFcTzByISxMA
         P/v+3qvze2l0qhdcq4OgT82xUQUXN+CvudnhVfpm+2xOwG+PoG4ej8Xza8edIOqsa6YB
         NNFQ==
X-Gm-Message-State: AHQUAuZvyniDNfahhQpsrO1vZ8pDepv71qqkdR0a+MqIjRjisrjjtPcd
        yk/t8V3IJ2bOy59HRjYNCxiKoppjig==
X-Google-Smtp-Source: AHgI3Ibqg2FuKebLp28sTMxJhYKg6AbifcxE20qO1xRr6k2tB2I0sDgJ5t7MUN4/pbqJhjQjHPsL0A==
X-Received: by 2002:adf:ee06:: with SMTP id y6mr6354164wrn.60.1549264146949;
        Sun, 03 Feb 2019 23:09:06 -0800 (PST)
Received: from localhost.localdomain ([213.145.108.55])
        by smtp.gmail.com with ESMTPSA id w12sm13222378wrr.23.2019.02.03.23.09.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Feb 2019 23:09:06 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, slavomir.kaslev@gmail.com,
        tstoyanov@vmware.com, ykaradzhov@vmware.com
Subject: [PATCH 4/8] trace-cmd: Check if connection is done when reading data in tracecmd_msg_read_data
Date:   Mon,  4 Feb 2019 09:08:51 +0200
Message-Id: <20190204070855.8921-5-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190204070855.8921-1-kaslevs@vmware.com>
References: <20190204070855.8921-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Now that tracecmd_msg_done/tracecmd_msg_set_done can be used in both server and
client context, check if the connection is shutting down in tracecmd_msg_read_data.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-msg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
index ef2a6d8..f7ce863 100644
--- a/tracecmd/trace-msg.c
+++ b/tracecmd/trace-msg.c
@@ -603,7 +603,7 @@ int tracecmd_msg_read_data(struct tracecmd_msg_handle *msg_handle, int ofd)
 	ssize_t s;
 	int ret;
 
-	for (;;) {
+	while (!tracecmd_msg_done(msg_handle)) {
 		ret = tracecmd_msg_recv_wait(msg_handle->fd, &msg);
 		if (ret < 0) {
 			if (ret == -ETIMEDOUT)
-- 
2.19.1

