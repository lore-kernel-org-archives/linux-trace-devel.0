Return-Path: <SRS0=T0vY=QL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08049C282C4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 07:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D66CA2081B
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 07:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbfBDHJG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Feb 2019 02:09:06 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34155 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727419AbfBDHJG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Feb 2019 02:09:06 -0500
Received: by mail-wm1-f68.google.com with SMTP id y185so9313526wmd.1
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 Feb 2019 23:09:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DmkT+igkX9jSkAVe7Z+C6GyQ+YKiMwaPl4tcAEr2XnE=;
        b=MM+4wH2S09eK+xV6DSi6ytKc1KIoRa4iRy2a7HdBYfRXcf4GRKuo30wRx+Ez8JYf9e
         E/uKn7PoiqSYkaWn2xt079uil5juqg2Ysa+/WeugkSI9QS/mSjmedXJ58tViTtAsPcCT
         QKGwHbTtCSQCk+nONDqYVg2ivDTXxk9bmEI3p8GHY2Ughwq70WFaF5MiYhmzjShR5Ou6
         Z6mZfujCZStHbJZhRMDT9UI/azipHNELmITjCcIXL54ebCrGuzdMS+ZhcHs00O3uvLB5
         es+leJZGHf0k2TBnheefm3ydFAIr8k9mFBZAneUhTjD/5Cm3z55sbdpIp8+GWscfrk2o
         CuMw==
X-Gm-Message-State: AHQUAuYWw+CFlFPXTooC5jnO/9jCBAZBimgENFqARbWKmMLOlSZHcyK8
        R99dmwjlmTpEQyx19yjUNG5YKsMIpA==
X-Google-Smtp-Source: AHgI3Ia8ui1NW2hAKNwWe+ZR4PGYiCPm6qRN9LJ2Gk+M1TG2gq12yq7svOhCJ5/GIqfd5Asp8mKmAA==
X-Received: by 2002:a1c:6a0f:: with SMTP id f15mr4554432wmc.68.1549264144554;
        Sun, 03 Feb 2019 23:09:04 -0800 (PST)
Received: from localhost.localdomain ([213.145.108.55])
        by smtp.gmail.com with ESMTPSA id w12sm13222378wrr.23.2019.02.03.23.09.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Feb 2019 23:09:03 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, slavomir.kaslev@gmail.com,
        tstoyanov@vmware.com, ykaradzhov@vmware.com
Subject: [PATCH 2/8] trace-cmd: Rename error_operation_for_server
Date:   Mon,  4 Feb 2019 09:08:49 +0200
Message-Id: <20190204070855.8921-3-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190204070855.8921-1-kaslevs@vmware.com>
References: <20190204070855.8921-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

No changes in behavior intended.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-msg.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
index 418a22d..ffebce7 100644
--- a/tracecmd/trace-msg.c
+++ b/tracecmd/trace-msg.c
@@ -345,6 +345,12 @@ void tracecmd_msg_set_done(struct tracecmd_msg_handle *msg_handle)
 	msg_server->done = true;
 }
 
+static void error_operation(struct tracecmd_msg *msg)
+{
+	warning("Message: cmd=%d size=%d\n",
+		ntohl(msg->hdr.cmd), ntohl(msg->hdr.size));
+}
+
 /*
  * A return value of 0 indicates time-out
  */
@@ -432,15 +438,6 @@ static bool process_option(struct tracecmd_msg_handle *msg_handle,
 	return false;
 }
 
-static void error_operation_for_server(struct tracecmd_msg *msg)
-{
-	u32 cmd;
-
-	cmd = ntohl(msg->hdr.cmd);
-
-	warning("Message: cmd=%d size=%d\n", cmd, ntohl(msg->hdr.size));
-}
-
 struct tracecmd_msg_handle *
 tracecmd_msg_handle_alloc(int fd, unsigned long flags)
 {
@@ -545,7 +542,7 @@ int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle)
 	return pagesize;
 
 error:
-	error_operation_for_server(&msg);
+	error_operation(&msg);
 	return ret;
 }
 
@@ -670,7 +667,7 @@ int tracecmd_msg_read_data(struct tracecmd_msg_handle *msg_handle, int ofd)
 	return 0;
 
 error:
-	error_operation_for_server(&msg);
+	error_operation(&msg);
 	msg_free(&msg);
 	return ret;
 }
@@ -709,7 +706,7 @@ int tracecmd_msg_collect_data(struct tracecmd_msg_handle *msg_handle, int ofd)
 	return 0;
 
 error:
-	error_operation_for_server(&msg);
+	error_operation(&msg);
 	msg_free(&msg);
 	return ret;
 }
-- 
2.19.1

