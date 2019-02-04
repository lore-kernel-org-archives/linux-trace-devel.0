Return-Path: <SRS0=T0vY=QL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E37F8C282C4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 07:09:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE3722081B
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 07:09:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbfBDHJL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Feb 2019 02:09:11 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41135 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727572AbfBDHJL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Feb 2019 02:09:11 -0500
Received: by mail-wr1-f67.google.com with SMTP id x10so13175869wrs.8
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 Feb 2019 23:09:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NIl11p0gvuQj+I42VoK+mRQ8/W38c1uvgs2uUc+4YWQ=;
        b=eSaCxsXYLMvgTfPe0P2CQuBQw5cT1kNZ+eTf+acJWw0KGJ1C244tESKLKyxex2eQUw
         3Ywmu32qvM5J6gimM7ccqI/HVJjpgIIh9fjQfqIcx2gf4Rtc6a6w8cr5uYk22XMgbbmS
         ikjRGIDuwXvUCAgaGgLGVj5BlG793AVoe3ujRvdFg5TIqZNIdl3HoIe55vDWj7d1CRm5
         RDhwGcFNg/xAA3KUy6cpikMKhhh0pjea0p6y5b37HxP5pwnX3XV88f4Efq22irI3tMTa
         ZObRNafToBBKDV2qkL6J+7QhStzPlmILe+DWN2eky+XpD6NFWf4UhMrV6CrxJpIv0prr
         j1Ow==
X-Gm-Message-State: AHQUAuZDrRV9PETbhVRDAI8yt60HHwvy3S14NfbW0DwDdaBYzJm94VrL
        fXrlPFBtHZEhs9dWMhN8uYrwVws18g==
X-Google-Smtp-Source: AHgI3IboyGHK1Cm73FmK2WSX5rWijrUb8OfJc829k70DSWoH2O5bKJ/n0RWYi29Wr5PnkcNMHbEPZA==
X-Received: by 2002:adf:f30f:: with SMTP id i15mr553842wro.39.1549264149487;
        Sun, 03 Feb 2019 23:09:09 -0800 (PST)
Received: from localhost.localdomain ([213.145.108.55])
        by smtp.gmail.com with ESMTPSA id w12sm13222378wrr.23.2019.02.03.23.09.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Feb 2019 23:09:08 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, slavomir.kaslev@gmail.com,
        tstoyanov@vmware.com, ykaradzhov@vmware.com
Subject: [PATCH 6/8] trace-cmd: Make tracecmd_msg_send_close return error code if any
Date:   Mon,  4 Feb 2019 09:08:53 +0200
Message-Id: <20190204070855.8921-7-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190204070855.8921-1-kaslevs@vmware.com>
References: <20190204070855.8921-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 include/trace-cmd/trace-cmd.h | 2 +-
 tracecmd/trace-msg.c          | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 33f352b..0ab23f6 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -318,7 +318,7 @@ int tracecmd_msg_send_init_data(struct tracecmd_msg_handle *msg_handle,
 int tracecmd_msg_data_send(struct tracecmd_msg_handle *msg_handle,
 			       const char *buf, int size);
 int tracecmd_msg_finish_sending_data(struct tracecmd_msg_handle *msg_handle);
-void tracecmd_msg_send_close_msg(struct tracecmd_msg_handle *msg_handle);
+int tracecmd_msg_send_close_msg(struct tracecmd_msg_handle *msg_handle);
 
 /* for server */
 int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle);
diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
index b4b58d4..c24424b 100644
--- a/tracecmd/trace-msg.c
+++ b/tracecmd/trace-msg.c
@@ -549,12 +549,12 @@ int tracecmd_msg_send_port_array(struct tracecmd_msg_handle *msg_handle,
 	return 0;
 }
 
-void tracecmd_msg_send_close_msg(struct tracecmd_msg_handle *msg_handle)
+int tracecmd_msg_send_close_msg(struct tracecmd_msg_handle *msg_handle)
 {
 	struct tracecmd_msg msg;
 
 	tracecmd_msg_init(MSG_CLOSE, &msg);
-	tracecmd_msg_send(msg_handle->fd, &msg);
+	return tracecmd_msg_send(msg_handle->fd, &msg);
 }
 
 int tracecmd_msg_data_send(struct tracecmd_msg_handle *msg_handle,
-- 
2.19.1

