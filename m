Return-Path: <SRS0=T0vY=QL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45D25C282C4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 07:09:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25A602081B
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 07:09:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbfBDHJN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Feb 2019 02:09:13 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36444 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727572AbfBDHJM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Feb 2019 02:09:12 -0500
Received: by mail-wm1-f67.google.com with SMTP id p6so12119203wmc.1
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 Feb 2019 23:09:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2b7f1jwXJwAtQT3T08sfJGagfJT2amW4KYbbUFSEjwY=;
        b=K8dm12N7vIHAiM3jElow/KlR6Kmg3CXXRibLcVj/jNUbXXHqyMG+0C0CcSAz/pxy9J
         QQD0eKvF4k7moUmJtryk5ocdhxmZGP1W98qNg8MMM8EhmM9RcfKuyBEulVQyJ2kUb/GO
         IO9A9dWfTtDYERkxRDMN6MOy+/GNYfebSV4F97tDgqL9xPsPwF966VXERFOJRB4C4WVl
         sLJGG0L7/xd2e5VORK7FfR0WPKXNu611RlPl0w1aCOBS9EXDDR0y9bPHgwC61vc3gOZ3
         i1uP9Z23sdMBLWzT4yvXDdm23GppDAJN/Gd3EvEjjD9znv5z4nz8aRNespb+2DY6IK97
         ezoA==
X-Gm-Message-State: AHQUAuZdwyuzXtrs+u07aeqJ5a447ttMwMF46V/+YynGi6uQZvdQs/cH
        m3QXAys2XI1qeIjlRY6iZAhOZx0IPA==
X-Google-Smtp-Source: AHgI3IbOmF30zcYxfvnKHxX7y4hl1Y6X5E1g8TDd08IZrCmyuqitFDY4iu74upFHRvGhc/tqff1B9Q==
X-Received: by 2002:a7b:c08b:: with SMTP id r11mr11485872wmh.29.1549264150719;
        Sun, 03 Feb 2019 23:09:10 -0800 (PST)
Received: from localhost.localdomain ([213.145.108.55])
        by smtp.gmail.com with ESMTPSA id w12sm13222378wrr.23.2019.02.03.23.09.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Feb 2019 23:09:10 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, slavomir.kaslev@gmail.com,
        tstoyanov@vmware.com, ykaradzhov@vmware.com
Subject: [PATCH 7/8] trace-cmd: Add tracecmd_msg_wait_close function
Date:   Mon,  4 Feb 2019 09:08:54 +0200
Message-Id: <20190204070855.8921-8-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190204070855.8921-1-kaslevs@vmware.com>
References: <20190204070855.8921-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add tracecmd_msg_wait_close function that waits for MSG_CLOSE and logs any
invalid messages it receives.

Also switch tracecmd_msg_collect_data to use the new function while at it.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 include/trace-cmd/trace-cmd.h |  1 +
 tracecmd/trace-msg.c          | 35 +++++++++++++++--------------------
 2 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 0ab23f6..ca4452b 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -319,6 +319,7 @@ int tracecmd_msg_data_send(struct tracecmd_msg_handle *msg_handle,
 			       const char *buf, int size);
 int tracecmd_msg_finish_sending_data(struct tracecmd_msg_handle *msg_handle);
 int tracecmd_msg_send_close_msg(struct tracecmd_msg_handle *msg_handle);
+int tracecmd_msg_wait_close(struct tracecmd_msg_handle *msg_handle);
 
 /* for server */
 int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle);
diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
index c24424b..5079d43 100644
--- a/tracecmd/trace-msg.c
+++ b/tracecmd/trace-msg.c
@@ -659,39 +659,34 @@ error:
 
 int tracecmd_msg_collect_data(struct tracecmd_msg_handle *msg_handle, int ofd)
 {
-	struct tracecmd_msg msg;
-	u32 cmd;
 	int ret;
 
 	ret = tracecmd_msg_read_data(msg_handle, ofd);
 	if (ret)
-		goto error;
+		return ret;
+
+	return tracecmd_msg_wait_close(msg_handle);
+}
 
-	/* check the finish message of the client */
+int tracecmd_msg_wait_close(struct tracecmd_msg_handle *msg_handle)
+{
+	struct tracecmd_msg msg;
+	int ret = -1;
+
+	memset(&msg, 0, sizeof(msg));
 	while (!tracecmd_msg_done(msg_handle)) {
 		ret = tracecmd_msg_recv(msg_handle->fd, &msg);
-		if (ret < 0) {
-			warning("reading client");
-			return ret;
-		}
-
-		cmd = ntohl(msg.hdr.cmd);
-		if (cmd == MSG_CLOSE)
-			/* Finish this connection */
-			break;
-		else {
-			warning("Not accept the message %d", ntohl(msg.hdr.cmd));
-			ret = -EINVAL;
+		if (ret < 0)
 			goto error;
-		}
 
+		if (ntohl(msg.hdr.cmd) == MSG_CLOSE)
+			return 0;
+
+		error_operation(&msg);
 		msg_free(&msg);
 	}
 
-	return 0;
-
 error:
-	error_operation(&msg);
 	msg_free(&msg);
 	return ret;
 }
-- 
2.19.1

