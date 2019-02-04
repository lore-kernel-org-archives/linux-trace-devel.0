Return-Path: <SRS0=T0vY=QL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F7D7C282D8
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 07:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 721D92081B
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 07:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbfBDHJF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Feb 2019 02:09:05 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39796 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727419AbfBDHJF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Feb 2019 02:09:05 -0500
Received: by mail-wr1-f67.google.com with SMTP id t27so13167221wra.6
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 Feb 2019 23:09:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qLImzubeS5THv7aK5BIvbc3ZBS3aCBFOnbv1zJZD+d8=;
        b=XRerLBYb8fqZA/uHlJnV7r6pGftkI5FJ5ITyWKVzGblUjvmq3Vj63MNGtlFNbV4dYd
         DZkwBw1TW3g2tGzlHSDyG4H06RjAqk4oqgs9WcVVaj6cYGVJLtrItuHnscp93Wjhyxfl
         j68V03m/5SwICJRQafxsTLPsHfNVn36cN3flejuCiZGTtZ0J+BUAjZ2nVLVKRNLeaA7b
         CJSp0wXxUc06XvYIVKv5c3tCH7ZdXAnoiN4QP9HDFki/jTw3xDvvkaIXGDrGbik+4Et9
         GKFr84dD09qeaJs2NTBt8WyHi9/IStDdpyJo+3JK4EeXB6LiD2vuUhMONhrIGC7c7S8o
         BRHw==
X-Gm-Message-State: AJcUukd4TP3/PZtWImQU1YeAptP8ccpXUHqVxxgZ791zcCUPsGBgUjmE
        UvnYIwlzb+ioa3Sr3Abr0Mx8MXsROA==
X-Google-Smtp-Source: ALg8bN51qCHl5E8YtopAW+awB1uVQtGKAk/4jisrG+bq9c7/WwwXKQaPiGKU10bhDRl4yTd4CkBCjQ==
X-Received: by 2002:adf:92c7:: with SMTP id 65mr45024844wrn.228.1549264143362;
        Sun, 03 Feb 2019 23:09:03 -0800 (PST)
Received: from localhost.localdomain ([213.145.108.55])
        by smtp.gmail.com with ESMTPSA id w12sm13222378wrr.23.2019.02.03.23.09.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Feb 2019 23:09:02 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, slavomir.kaslev@gmail.com,
        tstoyanov@vmware.com, ykaradzhov@vmware.com
Subject: [PATCH 1/8] trace-cmd: Remove unused global variable
Date:   Mon,  4 Feb 2019 09:08:48 +0200
Message-Id: <20190204070855.8921-2-kaslevs@vmware.com>
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
 tracecmd/trace-msg.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tracecmd/trace-msg.c b/tracecmd/trace-msg.c
index 529ae2a..418a22d 100644
--- a/tracecmd/trace-msg.c
+++ b/tracecmd/trace-msg.c
@@ -130,8 +130,6 @@ struct tracecmd_msg {
 	};
 } __attribute__((packed));
 
-struct tracecmd_msg *errmsg;
-
 static int msg_write(int fd, struct tracecmd_msg *msg)
 {
 	int cmd = ntohl(msg->hdr.cmd);
-- 
2.19.1

