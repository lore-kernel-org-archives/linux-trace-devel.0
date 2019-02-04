Return-Path: <SRS0=T0vY=QL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B75B6C282C4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 07:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 908FD2081B
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 07:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbfBDHJK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Feb 2019 02:09:10 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38605 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbfBDHJK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Feb 2019 02:09:10 -0500
Received: by mail-wr1-f68.google.com with SMTP id v13so13162049wrw.5
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 Feb 2019 23:09:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vZpMB4fptM6Qsw9SK6xj0wpQBQFqPgxBtRx5xm0gHEw=;
        b=E0UcQG6DAbL+LQX0nAiw2CCtzTK9z2FyYbklayo3sz6vLuggTrH/eKV67Id+vKQgZj
         76VKA3I2fFfrUPW3yUxoqtHN5oIhCmaCG3TQtD53MFamSb5vAvl5Ec3xGv97bBwP0DKc
         kMqkFtBgCb6kTHL931XycjN/pXj7S8Yt7S3twa9Hyig09SM6oBP0UhHrlkL/McTNYhU8
         v++sfudoktC7UEZuqihslE2BwQqoBLf2l984OwQ9PIeLOMahVcP/qb9m9y45/Mze1FA6
         kezoaq+l2HQ/Wj2ne6DgYgmLxw9IpQCmKRKNF+peGmMOxI1Vo9tgKQVGOuPIOah2xcUP
         plEQ==
X-Gm-Message-State: AHQUAuYTDmZ5i2+8VT7BTrwWY48jwclATwwm4PWWo5/QGDBrBQN3FUW1
        wTg7jMsMLSZeZ/gkQZyMtk5PoLBfHw==
X-Google-Smtp-Source: AHgI3Ib2QFnxmlI/ZXqpkD4dhSux4WhT4vGjy7RXILOXwkSjWviJe29Su+RyM+42fbLwBYsvseP51Q==
X-Received: by 2002:a5d:690d:: with SMTP id t13mr10621975wru.195.1549264148191;
        Sun, 03 Feb 2019 23:09:08 -0800 (PST)
Received: from localhost.localdomain ([213.145.108.55])
        by smtp.gmail.com with ESMTPSA id w12sm13222378wrr.23.2019.02.03.23.09.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Feb 2019 23:09:07 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, slavomir.kaslev@gmail.com,
        tstoyanov@vmware.com, ykaradzhov@vmware.com
Subject: [PATCH 5/8] trace-cmd: Fix a memory leak in tracecmd_msg_send_init_data
Date:   Mon,  4 Feb 2019 09:08:52 +0200
Message-Id: <20190204070855.8921-6-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190204070855.8921-1-kaslevs@vmware.com>
References: <20190204070855.8921-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fix tracecmd_msg_send_init_data leaking memory for the messages it receives.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-msg.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
index f7ce863..b4b58d4 100644
--- a/tracecmd/trace-msg.c
+++ b/tracecmd/trace-msg.c
@@ -373,8 +373,7 @@ static int tracecmd_msg_wait_for_msg(int fd, struct tracecmd_msg *msg)
 int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
 				unsigned int **client_ports)
 {
-	struct tracecmd_msg send_msg;
-	struct tracecmd_msg recv_msg;
+	struct tracecmd_msg msg;
 	int fd = msg_handle->fd;
 	unsigned int *ports;
 	int i, cpus;
@@ -382,30 +381,41 @@ int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
 
 	*client_ports = NULL;
 
-	tracecmd_msg_init(MSG_TINIT, &send_msg);
-	ret = make_tinit(msg_handle, &send_msg);
+	tracecmd_msg_init(MSG_TINIT, &msg);
+	ret = make_tinit(msg_handle, &msg);
 	if (ret < 0)
-		return ret;
+		goto out;
 
-	ret = tracecmd_msg_send(fd, &send_msg);
+	ret = tracecmd_msg_send(fd, &msg);
 	if (ret < 0)
-		return ret;
+		goto out;
+
+	msg_free(&msg);
 
-	ret = tracecmd_msg_wait_for_msg(fd, &recv_msg);
+	ret = tracecmd_msg_wait_for_msg(fd, &msg);
 	if (ret < 0)
-		return ret;
+		goto out;
 
-	if (ntohl(recv_msg.hdr.cmd) != MSG_RINIT)
-		return -EINVAL;
+	if (ntohl(msg.hdr.cmd) != MSG_RINIT) {
+		ret = -EINVAL;
+		goto error;
+	}
 
-	cpus = ntohl(recv_msg.rinit.cpus);
+	cpus = ntohl(msg.rinit.cpus);
 	ports = malloc_or_die(sizeof(*ports) * cpus);
 	for (i = 0; i < cpus; i++)
-		ports[i] = ntohl(recv_msg.port_array[i]);
+		ports[i] = ntohl(msg.port_array[i]);
 
 	*client_ports = ports;
 
+	msg_free(&msg);
 	return 0;
+
+error:
+	error_operation(&msg);
+out:
+	msg_free(&msg);
+	return ret;
 }
 
 static bool process_option(struct tracecmd_msg_handle *msg_handle,
-- 
2.19.1

