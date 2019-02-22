Return-Path: <SRS0=rw6q=Q5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE7EC4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 14:28:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 948F12075A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 14:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfBVO2q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Feb 2019 09:28:46 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34978 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbfBVO2p (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Feb 2019 09:28:45 -0500
Received: by mail-wm1-f68.google.com with SMTP id y15so2166519wma.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Feb 2019 06:28:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mb1yPU2Gft4CefjzzqFAfr3+pf5vHg6DCvfBVtFI6IM=;
        b=iyLyrk0EFzQQHocxTF4cb96RwlzyLX3qLcmDrE78Rc+O57+ZwamPTeCzl//Vtp6ENA
         WMHQkIo1fPXstCEjDyOsmU+5/Wn/BIzb8dKx6JnWkEYOZsnfK7iMmt4BhWOp0MSKE7/E
         PRyFWBNnKpaSN4fXiWl0Al1YxJssSTlDF/zd5QoUoOQCSyspf37iczGPEeW8UIGnc6mR
         PjBie7rb3ES+qPa5pvQTUYFPoQP/ODHODxiggBxThVeG2k6EnF1efJQmo6sKXuQT7Qtc
         e4BcaKyD11h9k9Lo/Lo3WMo4akq8ekuI+4PWqmZSJcMHiJYLqFR0chmkcYUu7He5nI1J
         ykAQ==
X-Gm-Message-State: AHQUAuZAtnkSBdjjkSoQNtYWAAMgGXx6pg/TBbkUvuGUwsIHxTIBftji
        do5dv0vlO31ga56Xxxd3Jio=
X-Google-Smtp-Source: AHgI3IZj2l74nBxPbpKGtI6rfYMl7i/S2mYBhy78Xoq85A2pgDEUdwy6YGKVsCTbLZur8+umbBYrMA==
X-Received: by 2002:a1c:5546:: with SMTP id j67mr2564980wmb.95.1550845722487;
        Fri, 22 Feb 2019 06:28:42 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id q9sm848987wrv.26.2019.02.22.06.28.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Feb 2019 06:28:41 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 5/7] trace-cmd: Refactored make_instances() and tracecmd_remove_instances()
Date:   Fri, 22 Feb 2019 16:28:34 +0200
Message-Id: <20190222142836.12596-6-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190222142836.12596-1-tstoyanov@vmware.com>
References: <20190222142836.12596-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In order to reuse the code which creates / deletes tracing instances,
these two functions are refactotred. A new ones are implemented:
make_instance() and tracecmd_remove_instance().

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/trace-record.c | 54 +++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 23 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index ef6319f..c57ed6b 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4316,49 +4316,57 @@ static void clear_func_filters(void)
 	}
 }
 
-static void make_instances(void)
+static void make_instance(struct buffer_instance *instance)
 {
-	struct buffer_instance *instance;
 	struct stat st;
 	char *path;
 	int ret;
 
+	path = get_instance_dir(instance);
+	ret = stat(path, &st);
+	if (ret < 0) {
+		ret = mkdir(path, 0777);
+		if (ret < 0)
+			die("mkdir %s", path);
+	} else
+		/* Don't delete instances that already exist */
+		instance->flags |= BUFFER_FL_KEEP;
+	tracecmd_put_tracing_file(path);
+
+}
+
+static void make_instances(void)
+{
+	struct buffer_instance *instance;
+
 	for_each_instance(instance) {
 		if (is_guest(instance))
 			continue;
+		make_instance(instance);
+	}
+}
 
-		path = get_instance_dir(instance);
-		ret = stat(path, &st);
-		if (ret < 0) {
-			ret = mkdir(path, 0777);
-			if (ret < 0)
-				die("mkdir %s", path);
-		} else
-			/* Don't delete instances that already exist */
-			instance->flags |= BUFFER_FL_KEEP;
-		tracecmd_put_tracing_file(path);
+static void tracecmd_remove_instance(struct buffer_instance *instance)
+{
+	char *path;
+
+	if (instance->tracing_on_fd > 0) {
+		close(instance->tracing_on_fd);
+		instance->tracing_on_fd = 0;
 	}
+	path = get_instance_dir(instance);
+	tracecmd_put_tracing_file(path);
 }
 
 void tracecmd_remove_instances(void)
 {
 	struct buffer_instance *instance;
-	char *path;
-	int ret;
 
 	for_each_instance(instance) {
 		/* Only delete what we created */
 		if (is_guest(instance) || (instance->flags & BUFFER_FL_KEEP))
 			continue;
-		if (instance->tracing_on_fd > 0) {
-			close(instance->tracing_on_fd);
-			instance->tracing_on_fd = 0;
-		}
-		path = get_instance_dir(instance);
-		ret = rmdir(path);
-		if (ret < 0)
-			die("rmdir %s", path);
-		tracecmd_put_tracing_file(path);
+		tracecmd_remove_instance(instance);
 	}
 }
 
-- 
2.20.1

