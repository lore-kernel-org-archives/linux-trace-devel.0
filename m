Return-Path: <SRS0=T0vY=QL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73AB4C282C4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 07:09:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F4102081B
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 07:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbfBDHJI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Feb 2019 02:09:08 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38603 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727419AbfBDHJH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Feb 2019 02:09:07 -0500
Received: by mail-wr1-f68.google.com with SMTP id v13so13161975wrw.5
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 Feb 2019 23:09:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oV05t1QuadAEL0lR4eYABfRWKFyq2SdBKAoisivU/Vg=;
        b=inzSrJaZdYtxTl8TMSacxAuy7jyVlZmQAOmeYpYxwEaFm0qdPT4EYytCdLckcbUem3
         VQ09imOhv7TxhGjV7vSD2Zy3C/DvI3GaHVz6gYK5STu8sMELsgxmvINs3yPZP3q2ulWb
         qRhDDbJo8luyEopDshnrx1FkrITxTQ/YA80IMN1hTsZ98FBwH5r58y1v/91tO8LTWITJ
         ARegPEW866NNRZ1BgtmAT6UVqAZeDg19JKbqKnq61AS4zO1qw35cqyID7or868NbWf8O
         jS0b+gHmEJ5GmEJ/RpFpU0ECnBFpUKXmcreH+J7N7Gax0reVts4mHfaPI8DbqN0cq6xA
         b9mg==
X-Gm-Message-State: AHQUAubTyRQjjx2di9dTupBNyALmBZkwAf2MXsTv3Xm+xHpoQcDwfJbe
        ISrjzhEWHsiTmm/riIirjYxOBdLcUw==
X-Google-Smtp-Source: AHgI3IbBE9GFGwMwJki54tlStYze5oH8/IIfJSgVoHozmM2HHK++FHU32Cokf1CxjepHyDfd5oXwLA==
X-Received: by 2002:adf:fd0a:: with SMTP id e10mr700615wrr.190.1549264145750;
        Sun, 03 Feb 2019 23:09:05 -0800 (PST)
Received: from localhost.localdomain ([213.145.108.55])
        by smtp.gmail.com with ESMTPSA id w12sm13222378wrr.23.2019.02.03.23.09.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Feb 2019 23:09:05 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, slavomir.kaslev@gmail.com,
        tstoyanov@vmware.com, ykaradzhov@vmware.com
Subject: [PATCH 3/8] trace-cmd: Remove tracecmd_msg_handle/tracecmd_msg_server distinction
Date:   Mon,  4 Feb 2019 09:08:50 +0200
Message-Id: <20190204070855.8921-4-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190204070855.8921-1-kaslevs@vmware.com>
References: <20190204070855.8921-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The difference between tracecmd_msg_handle and tracecmd_msg_server is a single
bool and the tracecmd_msg_set_done/tracecmd_msg_done functions are also useful
on the client side in the context of the tracing VMs over vsockets work.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 include/trace-cmd/trace-cmd.h | 11 ++---------
 tracecmd/trace-listen.c       |  2 +-
 tracecmd/trace-msg.c          | 31 +++----------------------------
 tracecmd/trace-record.c       |  2 +-
 4 files changed, 7 insertions(+), 39 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 86b9b53..33f352b 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -293,16 +293,8 @@ void tracecmd_disable_all_tracing(int disable_tracer);
 void tracecmd_disable_tracing(void);
 void tracecmd_enable_tracing(void);
 
-enum tracecmd_msg_bits {
-	TRACECMD_MSG_BIT_CLIENT		= 0,
-	TRACECMD_MSG_BIT_SERVER		= 1,
-	TRACECMD_MSG_BIT_USE_TCP	= 2,
-};
-
 enum tracecmd_msg_flags {
-	TRACECMD_MSG_FL_CLIENT		= (1 << TRACECMD_MSG_BIT_CLIENT),
-	TRACECMD_MSG_FL_SERVER		= (1 << TRACECMD_MSG_BIT_SERVER),
-	TRACECMD_MSG_FL_USE_TCP		= (1 << TRACECMD_MSG_BIT_USE_TCP),
+	TRACECMD_MSG_FL_USE_TCP		= 1 << 0,
 };
 
 /* for both client and server */
@@ -311,6 +303,7 @@ struct tracecmd_msg_handle {
 	short			cpu_count;
 	short			version;	/* Current protocol version */
 	unsigned long		flags;
+	bool			done;
 };
 
 struct tracecmd_msg_handle *
diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 9b50147..8bd7bad 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -748,7 +748,7 @@ static int do_connection(int cfd, struct sockaddr_storage *peer_addr,
 	if (ret)
 		return ret;
 
-	msg_handle = tracecmd_msg_handle_alloc(cfd, TRACECMD_MSG_FL_SERVER);
+	msg_handle = tracecmd_msg_handle_alloc(cfd, 0);
 
 	s = getnameinfo((struct sockaddr *)peer_addr, peer_addr_len,
 			host, NI_MAXHOST,
diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
index ffebce7..ef2a6d8 100644
--- a/tracecmd/trace-msg.c
+++ b/tracecmd/trace-msg.c
@@ -49,21 +49,6 @@ static inline void dprint(const char *fmt, ...)
 
 unsigned int page_size;
 
-struct tracecmd_msg_server {
-	struct tracecmd_msg_handle handle;
-	int			done;
-};
-
-static struct tracecmd_msg_server *
-make_server(struct tracecmd_msg_handle *msg_handle)
-{
-	if (!(msg_handle->flags & TRACECMD_MSG_FL_SERVER)) {
-		plog("Message handle not of type server\n");
-		return NULL;
-	}
-	return (struct tracecmd_msg_server *)msg_handle;
-}
-
 struct tracecmd_msg_opt {
 	be32 size;
 	be32 opt_cmd;
@@ -333,16 +318,12 @@ static int msg_wait_to = MSG_WAIT_MSEC;
 
 bool tracecmd_msg_done(struct tracecmd_msg_handle *msg_handle)
 {
-	struct tracecmd_msg_server *msg_server = make_server(msg_handle);
-
-	return (volatile int)msg_server->done;
+	return (volatile int)msg_handle->done;
 }
 
 void tracecmd_msg_set_done(struct tracecmd_msg_handle *msg_handle)
 {
-	struct tracecmd_msg_server *msg_server = make_server(msg_handle);
-
-	msg_server->done = true;
+	msg_handle->done = true;
 }
 
 static void error_operation(struct tracecmd_msg *msg)
@@ -442,14 +423,8 @@ struct tracecmd_msg_handle *
 tracecmd_msg_handle_alloc(int fd, unsigned long flags)
 {
 	struct tracecmd_msg_handle *handle;
-	int size;
-
-	if (flags == TRACECMD_MSG_FL_SERVER)
-		size = sizeof(struct tracecmd_msg_server);
-	else
-		size = sizeof(struct tracecmd_msg_handle);
 
-	handle = calloc(1, size);
+	handle = calloc(1, sizeof(struct tracecmd_msg_handle));
 	if (!handle)
 		return NULL;
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 3034a4b..8beefab 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2883,7 +2883,7 @@ again:
 	if (msg_handle) {
 		msg_handle->fd = sfd;
 	} else {
-		msg_handle = tracecmd_msg_handle_alloc(sfd, TRACECMD_MSG_FL_CLIENT);
+		msg_handle = tracecmd_msg_handle_alloc(sfd, 0);
 		if (!msg_handle)
 			die("Failed to allocate message handle");
 
-- 
2.19.1

