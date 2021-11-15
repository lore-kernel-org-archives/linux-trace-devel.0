Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6E65C433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Nov 2021 08:57:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81FC861040
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Nov 2021 08:57:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237186AbhKOI7T (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Nov 2021 03:59:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236527AbhKOI6e (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Nov 2021 03:58:34 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8E8C061200
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Nov 2021 00:55:33 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id m14so68810597edd.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Nov 2021 00:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vOenIcBTuG6w/IOqlxTqTWs2eQtXHOkSNsHPEL0nqTc=;
        b=XpzdFohAGojckSpO+hITmOvJjd8vPIZmSiMmMjs3wUYbMhxgp29Q9o2Vau1N/wvmbv
         QGMIHVbCtiAfszSPv49so3EDbILsltPlZ1zI39DhS7FfZVZNefiNPqxgs7G37fqAWX2d
         2k1pEaC0st/c6nGUL0yjnmTmmbCBDgGctuWnKMp+uBd53eGMPkOhWelHCncFLvQz+MpK
         Rx7RVszV3lpBZ5k+fYcQS8IT/Gl0ON9hUI4TVy8tPGEA2rykZFriKyGNUliAtw9/86/B
         iTMOWmkMXayEw1PLZ9121LsJbnrWCbifxAVZQ1EaCV24w0YvZCKEF+vXSJrK7qu3pEHW
         R0Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vOenIcBTuG6w/IOqlxTqTWs2eQtXHOkSNsHPEL0nqTc=;
        b=jS3AoDffgYgc1gchiKWVDbUxoSIoIyMaMzdx4RcITNWjee85hWOPFVdssNLndz2fd8
         XMTtPSpIkbUSKDImN+bYhGt60U7r7qRVwd7y5X+BRTrhW78B/uHLB7rrOyeINkcaZBF0
         fZv2u9AL0SIyWUMbFaEcbYNHNLUWmQ6EBowCiWbxGjmc1BUv11Qw5xlcO/DvZiDxVa4q
         QwuiDlPBxzk1yoq9rrC2aoZv6vJots71LzybwN5OneZxycW2zSB8QiHtsP5t4kZ04DEm
         qyZcEb/zUCjSl5Yjw7v5wyxanYx2wsk2PvR5IQ3ONhY/fa/w+LSsIAdH6HHJThYMqEXB
         Xnvg==
X-Gm-Message-State: AOAM532K43slCiQnjYGfTld/6iF3e6VYygnmdCTsrDXdHIPMHED3GJL5
        ya1mr/QMpQx3kDiMmhd6bKB2e5YY04A=
X-Google-Smtp-Source: ABdhPJyHx9pNWKwK+XPHD5j6Bmad6Fzdvfa+Mq49T0R5Jxq9RyI6KzOW0nbthSY56PQHYLJqr03f3Q==
X-Received: by 2002:a17:906:2749:: with SMTP id a9mr46351381ejd.471.1636966532317;
        Mon, 15 Nov 2021 00:55:32 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id f7sm7056709edl.33.2021.11.15.00.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 00:55:32 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/2] trace-cruncher: Make the tracing of a process stoppable
Date:   Mon, 15 Nov 2021 10:55:18 +0200
Message-Id: <20211115085518.204852-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211115085518.204852-1-y.karadz@gmail.com>
References: <20211115085518.204852-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Both 'trace_process()' and 'trace_shell_process()' can be stopped
from the callback function by calling 'sys.exit()' or by returning
non zero integer value.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 8e803ee..b5cdcee 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -2097,10 +2097,17 @@ static void iterate_raw_events_waitpid(struct tracefs_instance *instance,
 				       PyObject *py_func,
 				       pid_t pid)
 {
+	bool *callback_status = &callback_ctx.status;
+	int ret;
+
 	callback_ctx.py_callback = py_func;
+	(*(volatile bool *)callback_status) = true;
 	do {
-		tracefs_iterate_raw_events(tep, instance, NULL, 0,
-					   callback, &callback_ctx);
+		ret = tracefs_iterate_raw_events(tep, instance, NULL, 0,
+						 callback, &callback_ctx);
+
+		if (*(volatile bool *)callback_status == false || ret < 0)
+			break;
 	} while (waitpid(pid, NULL, WNOHANG) != pid);
 }
 
-- 
2.32.0

