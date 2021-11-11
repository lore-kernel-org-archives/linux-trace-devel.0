Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C3C8C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:06:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 109B761038
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbhKKPI7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbhKKPI6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:08:58 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC93C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:06:09 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id g14so25408054edz.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:06:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GFaftIMYHkExjqepWhbxWTn85mHgpiA3J55AMBFPiMw=;
        b=dHqzqYI/KCkWZLpKy+osAMlkuAqJvhyfwQjuYCWSrN/itpdlqbbGtgffDXxUcyDqzp
         jt27lBSwsBdbtHFBLes0kIy/OWR9xSJATb2eWbRgb/D8JIHuK5jXDhCQbJx8mdzhT7Wa
         3YpFMBf7D74hhRRltZj3PZPSWv/1fEKc5gKhSUQbOh3Kr83nfhu6s84JSKIBmBGw2m5Q
         dyu31dW49UsJV++EMvtEgwC69lpi2yOvbQ9plPcsoFFNTL5k88Y7W/hL6+96vr7fUSlM
         mygAiqqJaq8FdpJFKapTfHE0hbdlt47eqtxpIDQzCD+30KveI3/hJl7YrCS9bPDAd2cT
         9F6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GFaftIMYHkExjqepWhbxWTn85mHgpiA3J55AMBFPiMw=;
        b=Nrf+U4z1RdRBbcqUlYNJPegC25TicvB4Q0DUirXHe2+gxuGc0eu60tIIbfP1yusKpj
         9K0T2lYP7f1q+oA1ooOr96UVrW3q1hRgkxQTWs3omilaqN5fyNIsWGFJhk6iniQ7rGwA
         OMyML6eD/gSD3ni88bI6Yo1k5LfWCIKos+KQ+PRZEUgl0lsImN2sExFl3Ht01rI3k/C8
         uE7xkzW8C3Ua2L9HjDkw2Jna6DFdqmKqu2YxngZxpOTdltfz7OawjvUWLReK4DSBN3F9
         H2b75JIlB6C7EAlDEP1XtU5C/kclkLhCeb///AD/KCjVDFSDEE4wlb5JBH4aUQg3tWBA
         4e3w==
X-Gm-Message-State: AOAM533siHz5K48RS5AGwfXTojUqYs+oQ6w37yxcyrEm0Etxy4PipIqp
        NscQCNAu63DMzuVq6SXrJMq2gdGN9X33/A==
X-Google-Smtp-Source: ABdhPJzvlgnsc0ZhBblGWFVXCPzyQAsDz7MZESzd3vXQrEhjF1TXGTpk+4NBr/V9vxOUx5BFzxlh/w==
X-Received: by 2002:a05:6402:2815:: with SMTP id h21mr10825160ede.288.1636643167763;
        Thu, 11 Nov 2021 07:06:07 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g1sm1465136eje.105.2021.11.11.07.06.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:06:07 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 6/6] trace-cmd library: Set the correct file state when reading file with no ftrace printk data
Date:   Thu, 11 Nov 2021 17:06:06 +0200
Message-Id: <20211111150606.86143-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The ftrace printk section of the trace file can contain no data, this is
valid use case. When such file is read and parsed by read_ftrace_printk,
the file state should be set to TRACECMD_FILE_PRINTK in that case.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index f02d7e31..31e5e674 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -783,8 +783,10 @@ static int read_ftrace_printk(struct tracecmd_input *handle)
 
 	if (read4(handle, &size) < 0)
 		return -1;
-	if (!size)
+	if (!size) {
+		handle->file_state = TRACECMD_FILE_PRINTK;
 		return 0; /* OK? */
+	}
 
 	buf = malloc(size + 1);
 	if (!buf)
-- 
2.33.1

