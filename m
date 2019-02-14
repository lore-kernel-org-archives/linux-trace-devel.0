Return-Path: <SRS0=y1VY=QV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33365C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 14:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 088C02229F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Feb 2019 14:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729495AbfBNOHf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Feb 2019 09:07:35 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53819 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728665AbfBNOHf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Feb 2019 09:07:35 -0500
Received: by mail-wm1-f67.google.com with SMTP id d15so6436027wmb.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Feb 2019 06:07:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HPqJ5rNjIKd+FxBAsm6BSpI/Zvpwo027NhQLS4+wkzw=;
        b=bLlhteLmDazBnlaTZe/nzA5+pad+OGSIO+U+8az8SwgvHn9N0TwvdFS60nrhMsBWCR
         2FH2q1odKOMDMe7c1lSTLGzxxq6ic/XCcSs9RynHnPoousdYTOgJZwQiap/H0xGupyYe
         RQvObxWRVx5bD2LBVedpybYqUPrnmYuJ4eli7Zn/ajP6pv1wW3UpcxXVKvdiYqeWQ4OZ
         l8KXPIdqfFQpJBKe89xga2M6vPI8YlM3Hs/GTQ0uueQIyqP7ol8CRFOVLiRDonnHMYEh
         YSTvmcWkfhSM59sO9de+4tkGRv6+GUMM3bgR6BRQ1BIFKtUIGD3meYvStU3FsYfLYs3e
         BHDw==
X-Gm-Message-State: AHQUAua7DZikFlGI8oXk5nHywiLIfr6coLSBmf2jUDL6ErNkYNFdv5gI
        jpLzxy+a3OY5hjH5OaKoOg==
X-Google-Smtp-Source: AHgI3IZV1g8RqyDa2RN5zQaBHXR4NPOEpVtzak4Sv9QAaNCW0do4XpKknnJkFN7EsoD3OruMKKivfw==
X-Received: by 2002:a1c:2082:: with SMTP id g124mr2722650wmg.59.1550153253721;
        Thu, 14 Feb 2019 06:07:33 -0800 (PST)
Received: from localhost.localdomain ([213.145.108.55])
        by smtp.gmail.com with ESMTPSA id c9sm2067220wrs.84.2019.02.14.06.07.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 06:07:31 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [PATCH 1/3] trace-cmd: Fix tracecmd_recorder leaking file descriptors
Date:   Thu, 14 Feb 2019 16:07:21 +0200
Message-Id: <20190214140723.27804-1-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

tracecmd_recorder is leaking brass pipe() file descriptors it creates for
splice()-ing. Fix this.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 lib/trace-cmd/trace-recorder.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index 5331925..b941cdc 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -88,6 +88,12 @@ void tracecmd_free_recorder(struct tracecmd_recorder *recorder)
 		append_file(recorder->page_size, recorder->fd1, recorder->fd2);
 	}
  close:
+	if (recorder->brass[0] >= 0)
+		close(recorder->brass[0]);
+
+	if (recorder->brass[1] >= 0)
+		close(recorder->brass[1]);
+
 	if (recorder->trace_fd >= 0)
 		close(recorder->trace_fd);
 
-- 
2.19.1

