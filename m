Return-Path: <SRS0=0lml=RS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23BBDC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 15:33:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC20E218A1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 15:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfCOPdi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Mar 2019 11:33:38 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53002 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727793AbfCOPdi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Mar 2019 11:33:38 -0400
Received: by mail-wm1-f67.google.com with SMTP id f65so6930931wma.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Mar 2019 08:33:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dRmHv0G3YmNofJQkPM9zVlg/qQ5IHNPisswzJwg1NIg=;
        b=Df4jvjSJjHzve0RKF+YrryGrWUfGrjhqezhc4hLaNM54qrnGR4jbUntZeqo8OT61zQ
         icHpbskN+QGCl00fIj72lqbgvOK578vfZgIO2EG6eQCsik95yUkPt1PQLlxqSFaW/GrD
         n5MnFTVQhahVHx1zNDMB68oSu3sTw0FsdiSAismFO/4N2Di24EMjOOSPQonKGA5SfrkH
         +0Xs0cB3tdshcGCU//2dEPdD4mEgk8FteRDDfQG9gxjeKi6F3AkwwXe4LuzUPkLZ3nRM
         Pf83jYYd2p+hnuWM8uidEe3QDEsKzihxFcn0V4//bhPGxNVFvJcZC8bMX03Um1AjhBJv
         7g8Q==
X-Gm-Message-State: APjAAAXboVxi5YnX6LgI+nPp8BgDeJ5+XUnTHVzZGPzVYRzRThQhYEFk
        wxtBhPpPeSWAqIxI8FJdRs1Xk3I=
X-Google-Smtp-Source: APXvYqztqQ3cg0XrzVmSngXQYDuEXkT/NyjQhX8+AoP1II2ob0QqpnN9chu22jd/Aa3My5cUHuB8Ng==
X-Received: by 2002:a1c:6506:: with SMTP id z6mr2481041wmb.153.1552664016711;
        Fri, 15 Mar 2019 08:33:36 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a204sm2654221wmf.12.2019.03.15.08.33.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Mar 2019 08:33:36 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [PATCH 3/3] trace-cmd: Add msg_buf_len() function
Date:   Fri, 15 Mar 2019 17:33:26 +0200
Message-Id: <20190315153326.5602-4-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190315153326.5602-1-kaslevs@vmware.com>
References: <20190315153326.5602-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Factor out common code computing message buffer length in a function.

No changes in behavior intended.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-msg.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
index 48f1eac..a91b211 100644
--- a/tracecmd/trace-msg.c
+++ b/tracecmd/trace-msg.c
@@ -107,6 +107,11 @@ struct tracecmd_msg {
 	void					*buf;
 } __attribute__((packed));
 
+static int msg_buf_len(struct tracecmd_msg *msg)
+{
+	return ntohl(msg->hdr.size) - MSG_HDR_LEN - ntohl(msg->hdr.cmd_size);
+}
+
 static int msg_write(int fd, struct tracecmd_msg *msg)
 {
 	int cmd = ntohl(msg->hdr.cmd);
@@ -425,7 +430,7 @@ int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
 		goto error;
 	}
 
-	buf_len = ntohl(msg.hdr.size) - MSG_HDR_LEN - ntohl(msg.hdr.cmd_size);
+	buf_len = msg_buf_len(&msg);
 	if (buf_len <= 0) {
 		ret = -EINVAL;
 		goto error;
@@ -541,7 +546,7 @@ int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle)
 		goto error;
 	}
 
-	buf_len = ntohl(msg.hdr.size) - MSG_HDR_LEN - ntohl(msg.hdr.cmd_size);
+	buf_len = msg_buf_len(&msg);
 	if (buf_len < 0) {
 		ret = -EINVAL;
 		goto error;
@@ -685,7 +690,7 @@ int tracecmd_msg_read_data(struct tracecmd_msg_handle *msg_handle, int ofd)
 			goto next;
 		}
 
-		n = ntohl(msg.hdr.size) - MSG_HDR_LEN - ntohl(msg.hdr.cmd_size);
+		n = msg_buf_len(&msg);
 		t = n;
 		s = 0;
 		while (t > 0) {
-- 
2.19.1

