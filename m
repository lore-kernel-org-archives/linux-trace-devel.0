Return-Path: <SRS0=q7JI=ZT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EBDCC43215
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Nov 2019 14:02:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06AAF206F0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Nov 2019 14:02:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oLukeEr5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfK0OCz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Nov 2019 09:02:55 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:33821 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbfK0OCy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Nov 2019 09:02:54 -0500
Received: by mail-lf1-f65.google.com with SMTP id l28so17300238lfj.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 27 Nov 2019 06:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xcPmnM5x0UQ4YKDSV2MogiGotivYJlB+VWUCe41AAqY=;
        b=oLukeEr5R57LjFufV0FaI4zgibvG6Xj61+P7T41ZN+IdFQlWK8ywO0B/a1QuA3S4aH
         ROkW9kQ35Ek6Mx94cW12/5ECQ3uRK2vUba8g80vlNhvMeIC2tAB6ZYuuU2YSq5Do5YJU
         JhjY5slVNg6QWnE0rD6UjgsSyljopSVpXSwhnV32DF5YIQbVWcHPMb9VG9UK8GbpxtNJ
         fArelUZedcthmt7NopwGPVm3zos4hokLAbJwHoSWErGehF3TcxzEGQRWBMIoXL1djXxk
         YGnEC/Bu6Rg79kCMBixdW6wCtzgzRFQmc0NprN1xHUbRl0b6gVflHjQQ9CPKDaBobYsn
         c+7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xcPmnM5x0UQ4YKDSV2MogiGotivYJlB+VWUCe41AAqY=;
        b=PWe6AWYLmt7NOqPO+eSdznqkrrxmwhWlDQyj8FXal7Zc37f35s8qwWyjAolozXyqo2
         NkVS94tGS8yS/Obbpoe8cZigAXvY8y0vW9M7LSOTKlmRxRqxbr7D0DV/dgRe4sPbaEQR
         I9frC8DG8vWe26WtwH5xtvMcLGwAGGEKM14XHVAzYx8xE57ieShQ2l13RQyqujkN55t6
         0c/5o3xwetYqasds+NcQeUsYSD3iidJV17xzQwZ15Pb/KI12539obSqj4GFKtnQmR7BI
         rioHn/Gw5g98KlJMZlFPH87/fNX/TnlCbfhRgWvlJw5HiOJvRJI2flBFjSZChUzlzzCI
         DmcA==
X-Gm-Message-State: APjAAAXOjSkGQblWI1zybHuWGFhCxu1UiIhemxqOnPfTP+uxes7mYtLC
        mxIEnaDlPpJNKRHWUVAskR1Q5gkpICA=
X-Google-Smtp-Source: APXvYqzmAZnsaJsk6m8wWym1ZVFsmjfB4hZ5sxRMgF9svKG9eEW+tfQ2RUWacsdLP2KHp+ZbfIQhIA==
X-Received: by 2002:ac2:5dfa:: with SMTP id z26mr1246161lfq.103.1574863372981;
        Wed, 27 Nov 2019 06:02:52 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y18sm7268660lja.12.2019.11.27.06.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 06:02:52 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v14 03/19] trace-cmd: Add implementations of htonll() and ntohll()
Date:   Wed, 27 Nov 2019 16:02:31 +0200
Message-Id: <20191127140247.258766-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191127140247.258766-1-tz.stoyanov@gmail.com>
References: <20191127140247.258766-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

Implementations of htonll() and ntohll() are added as
macros, if they are not already defined.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 include/trace-cmd/trace-msg.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/trace-cmd/trace-msg.h b/include/trace-cmd/trace-msg.h
index aab8a69..654ca43 100644
--- a/include/trace-cmd/trace-msg.h
+++ b/include/trace-cmd/trace-msg.h
@@ -12,4 +12,14 @@
 
 extern unsigned int page_size;
 
+#ifndef htonll
+# if __BYTE_ORDER == __LITTLE_ENDIAN
+#define htonll(x) __bswap_64(x)
+#define ntohll(x) __bswap_64(x)
+#else
+#define htonll(x) (x)
+#define ntohll(x) (x)
+#endif
+#endif
+
 #endif /* _TRACE_MSG_H_ */
-- 
2.23.0

