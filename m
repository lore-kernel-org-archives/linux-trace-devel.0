Return-Path: <SRS0=blm6=QP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FA2AC169C4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Feb 2019 13:49:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCE0920869
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Feb 2019 13:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfBHNta (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Feb 2019 08:49:30 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40522 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbfBHNta (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Feb 2019 08:49:30 -0500
Received: by mail-wr1-f65.google.com with SMTP id q1so3637737wrp.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Feb 2019 05:49:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pTsiWDAOKvqnLwbsac5+AclL/oZqnxbJevEQ+gZms9M=;
        b=VCD5oP3Xkrv6/IVrNPJC6PuZhcpbq4QA0Fc60uAL2h2FpsqHmZZ3OWTRgFl1PQK4/I
         RyqJzvSy+OR5ChvEI4Df0ZezUHmw5tMLoHhvHhc5Y+o2FlI/pKtnEQMPd9Te/4lCb1C6
         1yeETxnyYXWdQdL5vHp5KLGj5OuBIclHEvQ7UVEQzNmM8YTNIQH7vK13FEczHnCQUE0u
         np8i0BxzZ0xGSlh69VgkJE6pTOIeSrsP0polPBWvcz2GqrJhTghHiKRyyXCidgO7kbeP
         Bd8cSeacbvycWu1Y3b8nz+z0dw+Chv3azN0XmzsRlQNRyLBsJkGw19clyhDt+NAX+OPA
         6GxA==
X-Gm-Message-State: AHQUAublpootRgTRLL1xmfDEVwqWIIL/R0UFBdgFxk3x+CJxCvFxDcjP
        oSg+bFKdTZBGscBc8i6MAwQTxPzS
X-Google-Smtp-Source: AHgI3IY4KyeTueDcKn0fmMZWWf59MKvdpvLqFVac/Td9OuxjIcuUPgBjmVhCpkutUBJThSsR/XOATA==
X-Received: by 2002:adf:e34b:: with SMTP id n11mr15864807wrj.91.1549633768887;
        Fri, 08 Feb 2019 05:49:28 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a184sm2534796wmh.37.2019.02.08.05.49.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Feb 2019 05:49:27 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 5/7] trace-cmd: Refactored make_instances() and tracecmd_remove_instances()
Date:   Fri,  8 Feb 2019 15:49:16 +0200
Message-Id: <20190208134918.5618-6-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190208134918.5618-1-tstoyanov@vmware.com>
References: <20190208134918.5618-1-tstoyanov@vmware.com>
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
index 01b360a..e1ad797 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4304,49 +4304,57 @@ static void clear_func_filters(void)
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

