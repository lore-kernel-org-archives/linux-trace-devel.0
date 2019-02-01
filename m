Return-Path: <SRS0=aEXj=QI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E9A9C282D8
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Feb 2019 13:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 070952084C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Feb 2019 13:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbfBANpo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 Feb 2019 08:45:44 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40371 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729506AbfBANpo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 1 Feb 2019 08:45:44 -0500
Received: by mail-wr1-f67.google.com with SMTP id p4so7136397wrt.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 01 Feb 2019 05:45:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bvcR0JidEW1GXqLErSuBSAUIWJxtH1uY9vOmR5nFGqE=;
        b=sBlfVlXFeNm6VVkPpbQbwSG9GKxR2RusP31IRR/MbK132u3atGoIwtnj3QF3iVFPh9
         LgS0St9x0mDvtWyOJmztD79lK6yIix3pnbDhMb8i9e9HLiqr1dRI0mxIbIQxPo19ekDq
         +0mb5qv/11YPbcO0tJw80bRM14fOGQowlrtEf5DmYSGC2rZyGIbxd44GNGpcj8fEdV/R
         cJ/7HkfDEm7E34eObVDj2RfesebhnZJq4nmJDmfc3wH8BI3DeRpEhLg2k2H7ZkBeWI4b
         ueyIAjelDRcjyVT5geSJHDk9KL/VK4P2bz0NTejNkKZ5tnrcuB1I7caUGNSBnUvl8sdW
         LnPw==
X-Gm-Message-State: AJcUukc/Q8K/nxhFKgMhYoswnHraqx5I8nicJ4Pp0THnmtkfRaqY0lVF
        6XJY3lrIW/K/iYoaAv74OJ0=
X-Google-Smtp-Source: ALg8bN7FqZo1HDY1hWTDR5yhTuLvw1kA71+iBrRJ15hEFguaFTsDekzrTiafxzImqwbwGhJek7bXPg==
X-Received: by 2002:a5d:4b8b:: with SMTP id b11mr38775226wrt.180.1549028742846;
        Fri, 01 Feb 2019 05:45:42 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v26sm1468732wrv.78.2019.02.01.05.45.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 Feb 2019 05:45:42 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 5/6] trace-cmd: Refactored make_instances() and tracecmd_remove_instances()
Date:   Fri,  1 Feb 2019 15:45:34 +0200
Message-Id: <20190201134535.2979-6-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190201134535.2979-1-tstoyanov@vmware.com>
References: <20190201134535.2979-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In order to reuse the code which creates / deletes tracing instances,
these two functions are refactotred. A new ones are implemented:
make_one_instances() and tracecmd_remove_one_instance().

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/trace-record.c | 54 +++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 23 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 5b763ad..6d67858 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4256,49 +4256,57 @@ static void clear_func_filters(void)
 	}
 }
 
-static void make_instances(void)
+static void make_one_instance(struct buffer_instance *instance)
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
 		if (instance->flags & BUFFER_FL_GUEST)
 			continue;
+		make_one_instance(instance);
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
+static void tracecmd_remove_one_instance(struct buffer_instance *instance)
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
 		if (instance->flags & (BUFFER_FL_KEEP | BUFFER_FL_GUEST))
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
+		tracecmd_remove_one_instance(instance);
 	}
 }
 
-- 
2.20.1

