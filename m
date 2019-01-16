Return-Path: <SRS0=fS1d=PY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F319DC43387
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 19:18:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D025920868
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 19:18:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730683AbfAPTSs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Jan 2019 14:18:48 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35303 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730803AbfAPTSs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Jan 2019 14:18:48 -0500
Received: by mail-wm1-f67.google.com with SMTP id t200so3278786wmt.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Jan 2019 11:18:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P4md0Hbd2K8zcQqaBCspqrsk6++sm8ZHmAlUqrqlhTw=;
        b=gB0t7ijqmSjt2s227qYBHOZGke85mlov46+y7OGx3xn6CGxOrYxxfQvEwo2K4dMMAe
         AB7Z5PbDEkYYBETxDd6pZfSItnqEzSZpxPyAOQbAyoUwuIJ9T2eORk9UHXp8uMsVjr64
         hC+3QwFsPFDx5/cNYrGjtgdhYkJGu6Qpc2FH6nEB3XY7hgaSDRpn/boQ2xs4J24bNz4o
         kbKiU46wdWeRnPpAbD8g36HtXas6M44QFYT7pVGOrPodEO3D859ZbFA8+3eAcKlkisq8
         qX1DkOEISOJqwSaO1esZl8zVmnkhCR1w/lE0x5HwOX3L46QZFF4maO8+yt1i9/9KMk/X
         NK7w==
X-Gm-Message-State: AJcUukexO6ncwrGi1PUZxWOR7d0sFcWN6ocYv6cX1UOQMB+GLLvPd9Ws
        VKBDoZSmn1/4rVhVVg2CdvOHzS8n
X-Google-Smtp-Source: ALg8bN7+PZnHNSVaC6N9FP05JEhYSBhqR577gDy7BLTMyDIrAIPTXOPHdEgt8s9sk03qepIfA/x+yw==
X-Received: by 2002:a7b:c951:: with SMTP id i17mr9238875wml.70.1547666326760;
        Wed, 16 Jan 2019 11:18:46 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p6sm98393345wrx.50.2019.01.16.11.18.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Jan 2019 11:18:46 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 6/7] trace-cmd: Refactored make_instances() and tracecmd_remove_instances()
Date:   Wed, 16 Jan 2019 21:18:37 +0200
Message-Id: <20190116191838.32127-7-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190116191838.32127-1-tstoyanov@vmware.com>
References: <20190116191838.32127-1-tstoyanov@vmware.com>
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
index 900d0d4..4c3df3d 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4260,49 +4260,57 @@ static void clear_func_filters(void)
 	}
 }
 
-static void make_instances(void)
+static void make_one_instances(struct buffer_instance *instance)
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
+		make_one_instances(instance);
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

