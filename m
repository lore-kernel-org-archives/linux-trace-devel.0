Return-Path: <SRS0=T0vY=QL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D80DAC282C4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 07:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2E7C2081B
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 07:09:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbfBDHJO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Feb 2019 02:09:14 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42160 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727645AbfBDHJO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Feb 2019 02:09:14 -0500
Received: by mail-wr1-f65.google.com with SMTP id q18so13144406wrx.9
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 Feb 2019 23:09:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E0egSwUuiWy2h7ku8TKcGlU2azsQVay5JvxvqsYVBx8=;
        b=oPFSysGAtIoC8jd3V7SdrPoHourPjAk2WOfz0/ghxUSI6Giqzi5AiU+Et3X7biECik
         1pBfRPgZyvOPCSRom1sh+FuO7458/t6uAnuHKUUF3nEf0HHO+dWqw11eEhKHSRr11Qz8
         zUCgIjK1XmsVL1PHw/Jg0z7ylMXH6TM/fbkJ7BgECFvZ+FasOQs+AnA1jJJFLq7dPYrT
         kXRXJRrmIeqFt4QTCBQo0zv7nZJEYE0aD1EdsMKESNSgWtRvSCZLKY/w1V5oUY94/Epl
         94BBJJZ/i/pLyQDyW/LB5fYk6oPOPo+OnRy+aeChGCw9C8PDzCErYyjVXYpESJNFdoev
         rgdw==
X-Gm-Message-State: AHQUAua6X3rJ4hVjkC+fGG6ERJnOKE3YRWrqd1cUFRi1YkO4pGfaZf8z
        DC4RDKusKjWL6PwrL56FP673ZFEtuw==
X-Google-Smtp-Source: AHgI3IY7YlORHkB9EN2IUW+IzAtwozzbXnHGb/nDmLKcpTfQn6NxacN/cTpWnm6MB1UejA6WBLAmPw==
X-Received: by 2002:adf:e746:: with SMTP id c6mr6146546wrn.218.1549264151976;
        Sun, 03 Feb 2019 23:09:11 -0800 (PST)
Received: from localhost.localdomain ([213.145.108.55])
        by smtp.gmail.com with ESMTPSA id w12sm13222378wrr.23.2019.02.03.23.09.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Feb 2019 23:09:11 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, slavomir.kaslev@gmail.com,
        tstoyanov@vmware.com, ykaradzhov@vmware.com
Subject: [PATCH 8/8] trace-cmd: Acknowledge unexpected protocol messages
Date:   Mon,  4 Feb 2019 09:08:55 +0200
Message-Id: <20190204070855.8921-9-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190204070855.8921-1-kaslevs@vmware.com>
References: <20190204070855.8921-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Send MSG_NOT_SUPP message back on unexpected incoming messages. This allows us
to add new commands in the future and be able to detect and handle if we're
talking with an older version of trace-cmd.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-msg.c | 49 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 41 insertions(+), 8 deletions(-)

diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
index 5079d43..51d0ac8 100644
--- a/tracecmd/trace-msg.c
+++ b/tracecmd/trace-msg.c
@@ -75,7 +75,8 @@ struct tracecmd_msg_header {
 	C(TINIT,	1,	sizeof(struct tracecmd_msg_tinit)),	\
 	C(RINIT,	2,	sizeof(struct tracecmd_msg_rinit)),	\
 	C(SEND_DATA,	3,	0),					\
-	C(FIN_DATA,	4,	0),
+	C(FIN_DATA,	4,	0),					\
+	C(NOT_SUPP,	5,	0),
 
 #undef C
 #define C(a,b,c)	MSG_##a = b
@@ -370,6 +371,25 @@ static int tracecmd_msg_wait_for_msg(int fd, struct tracecmd_msg *msg)
 	return 0;
 }
 
+static int tracecmd_msg_send_notsupp(struct tracecmd_msg_handle *msg_handle)
+{
+	struct tracecmd_msg msg;
+
+	tracecmd_msg_init(MSG_NOT_SUPP, &msg);
+	return tracecmd_msg_send(msg_handle->fd, &msg);
+}
+
+static int handle_unexpected_msg(struct tracecmd_msg_handle *msg_handle,
+				 struct tracecmd_msg *msg)
+{
+	/* Don't send MSG_NOT_SUPP back if we just received one */
+	if (ntohl(msg->hdr.cmd) == MSG_NOT_SUPP)
+		return 0;
+
+	return tracecmd_msg_send_notsupp(msg_handle);
+
+}
+
 int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
 				unsigned int **client_ports)
 {
@@ -397,7 +417,7 @@ int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
 		goto out;
 
 	if (ntohl(msg.hdr.cmd) != MSG_RINIT) {
-		ret = -EINVAL;
+		ret = -EOPNOTSUPP;
 		goto error;
 	}
 
@@ -413,6 +433,8 @@ int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
 
 error:
 	error_operation(&msg);
+	if (ret == -EOPNOTSUPP)
+		handle_unexpected_msg(msg_handle, &msg);
 out:
 	msg_free(&msg);
 	return ret;
@@ -461,7 +483,6 @@ int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle)
 	int ret;
 	int offset = 0;
 	u32 size;
-	u32 cmd;
 
 	ret = tracecmd_msg_recv_wait(msg_handle->fd, &msg);
 	if (ret < 0) {
@@ -470,9 +491,8 @@ int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle)
 		return ret;
 	}
 
-	cmd = ntohl(msg.hdr.cmd);
-	if (cmd != MSG_TINIT) {
-		ret = -EINVAL;
+	if (ntohl(msg.hdr.cmd) != MSG_TINIT) {
+		ret = -EOPNOTSUPP;
 		goto error;
 	}
 
@@ -524,10 +544,14 @@ int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle)
 		}
 	}
 
+	msg_free(&msg);
 	return pagesize;
 
 error:
 	error_operation(&msg);
+	if (ret == -EOPNOTSUPP)
+		handle_unexpected_msg(msg_handle, &msg);
+	msg_free(&msg);
 	return ret;
 }
 
@@ -627,8 +651,12 @@ int tracecmd_msg_read_data(struct tracecmd_msg_handle *msg_handle, int ofd)
 		if (cmd == MSG_FIN_DATA) {
 			/* Finish receiving data */
 			break;
-		} else if (cmd != MSG_SEND_DATA)
-			goto error;
+		} else if (cmd != MSG_SEND_DATA) {
+			ret = handle_unexpected_msg(msg_handle, &msg);
+			if (ret < 0)
+				goto error;
+			goto next;
+		}
 
 		n = ntohl(msg.hdr.size) - MSG_HDR_LEN - ntohl(msg.hdr.cmd_size);
 		t = n;
@@ -646,6 +674,7 @@ int tracecmd_msg_read_data(struct tracecmd_msg_handle *msg_handle, int ofd)
 			s = n - t;
 		}
 
+next:
 		msg_free(&msg);
 	}
 
@@ -683,6 +712,10 @@ int tracecmd_msg_wait_close(struct tracecmd_msg_handle *msg_handle)
 			return 0;
 
 		error_operation(&msg);
+		ret = handle_unexpected_msg(msg_handle, &msg);
+		if (ret < 0)
+			goto error;
+
 		msg_free(&msg);
 	}
 
-- 
2.19.1

