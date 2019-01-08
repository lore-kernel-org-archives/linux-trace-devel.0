Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44388 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727678AbfAHPAY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Jan 2019 10:00:24 -0500
Received: by mail-pf1-f194.google.com with SMTP id u6so2036536pfh.11
        for <linux-trace-devel@vger.kernel.org>; Tue, 08 Jan 2019 07:00:24 -0800 (PST)
From: Slavomir Kaslev <kaslevs@vmware.com>
To: linux-trace-devel@vger.kernel.org
Cc: rostedt@goodmis.org, ykaradzhov@vmware.com, tstoyanov@vmware.com
Subject: [PATCH v2 1/6] trace-cmd: Fix indentation
Date: Tue,  8 Jan 2019 17:00:10 +0200
Message-Id: <20190108150015.21327-2-kaslevs@vmware.com>
In-Reply-To: <20190108150015.21327-1-kaslevs@vmware.com>
References: <20190108150015.21327-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

No functional changes in this patch.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 lib/trace-cmd/trace-input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index d70c110..7a8cbde 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2603,7 +2603,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd)
 {
 	struct tracecmd_input *handle;
 	char test[] = { 23, 8, 68 };
-    unsigned int page_size;
+	unsigned int page_size;
 	char *version;
 	char buf[BUFSIZ];
 
-- 
2.19.1
