Return-Path: <SRS0=1fLi=ZU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A9A2C43215
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 08:54:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55C2D21787
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 08:54:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pBSFXy/P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbfK1IyR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Nov 2019 03:54:17 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:33558 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbfK1IyR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Nov 2019 03:54:17 -0500
Received: by mail-lf1-f68.google.com with SMTP id d6so19454592lfc.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Nov 2019 00:54:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xcPmnM5x0UQ4YKDSV2MogiGotivYJlB+VWUCe41AAqY=;
        b=pBSFXy/PYAQzL4sNLUpF6KsPYaACDQnO/0Whfo0t7zfgb26X9LXunGE9fYQv4InNpJ
         p+0MZvKDfHud7GmAi+OX1RO561ic3OO8OVP0QqraI3fN5iZxxGYEUMjuqK106HX6Q+4G
         7w8DvBsPCKSpZ3qnMtUHnQErWoLdxmksUx0prm2qQa922CoXjm3G8/etSPB5ITlFLUzj
         130yhQq5R6LbsFfaMIrjJXsTslA28HHmtLlVUaYVZKMUGofkod1AQOWE2RWEObTfCgit
         py1H8ksSB7Vk/uZ0t0iokbaw/192X+mcsW3+RjEpP7fnz1YOc9xqYsC3GV4gyBW4EKEi
         GeTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xcPmnM5x0UQ4YKDSV2MogiGotivYJlB+VWUCe41AAqY=;
        b=ciuiMtNjd3BD8n9G7o4W3ufMUtfDsT05fYw5Djj86YSTs4sV5S5C8h3mwLIg4ElUhl
         0BW647tVWw6EB2Z5gs5IVaL9yFwBYOh6bwrj6hvJQwectVwcyfQ1pWSnxD9TfjVcyxTh
         PArdy9OKEuECW0J2sNK2N8sQmzmqgTEvU5zc0mRtluXNaqkB7blqehSnUSTOGwLwf1QR
         WHFIquHWfbYoKXnHyjZw2iDchX8+cTxDdx1/Z+zhDyUo9WgSOatzZLXCsg13phgtS9SD
         N8IrXbDgCbdIRNXK1TKu1AZE2DRCXr9pfO4DL//z1XdivWpK3T9DdbMeTlO8WlCGcEf6
         w2Mw==
X-Gm-Message-State: APjAAAVbTuqNgYe8lay7HvIdkFLMZx2rECk/OZ8dSAlDwgosyKJf6CM6
        1gnrwknIAqlnvm+5TbtEs2tb1c6UT4Q=
X-Google-Smtp-Source: APXvYqyyMUfpdhsc0WtEWMrhJI8oGZzdXClYp96sPVt1O6GWHgtEMHE+hf7tRQC2Tis5kBpCxYr3GQ==
X-Received: by 2002:ac2:5930:: with SMTP id v16mr17218846lfi.34.1574931255588;
        Thu, 28 Nov 2019 00:54:15 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id z19sm8253735ljk.66.2019.11.28.00.54.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 00:54:15 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v15 03/18] trace-cmd: Add implementations of htonll() and ntohll()
Date:   Thu, 28 Nov 2019 10:53:54 +0200
Message-Id: <20191128085409.289684-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191128085409.289684-1-tz.stoyanov@gmail.com>
References: <20191128085409.289684-1-tz.stoyanov@gmail.com>
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

