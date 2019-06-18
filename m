Return-Path: <SRS0=s7zG=UR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF182C31E5B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:45:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4D7B20B1F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:45:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mKcfw0EW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbfFROpM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 10:45:12 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38432 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729102AbfFROpM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 10:45:12 -0400
Received: by mail-wr1-f65.google.com with SMTP id d18so14319331wrs.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Jun 2019 07:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RUcBoUQNQrgcKDeseDcABNoAkO9CRuGl+8Gvj7tg0ew=;
        b=mKcfw0EWKhW7iShH3dV+dtumi9LfgXTFPP7eXjSPwG2bMgt93hosvTuLDPgSeOZTVx
         5Bk1/8RldUGEOZU6ph9EJhPMoIBTgtwUnSAS0QyZ0SjxDQTUQm0wszSgIJ8/+nkUoLAG
         +mVopWxZUCLQDPZ4Bh/Lu2/RrjaPnVxFjSCMD/zrHufbLO9LgMRUwGGRabwj5nODkulB
         rSF6WtCIxlecMHqCW4FvmuSfZaYd/yCLy6KH9ENdeIszLXCMJVcHwWOXlGtwARl70pcm
         PxhTfylHndFvCv/C662L+eVATse5z9VIhLKgk2URrkdoWyAqDw5Izv+4McH6C9nwqs3S
         uXrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RUcBoUQNQrgcKDeseDcABNoAkO9CRuGl+8Gvj7tg0ew=;
        b=RPnQIjSI0nyNVPWoTRWvSvQCBFtkNbB+tM+7Xw4x6quVlVcl0uSG2uyGWeE4TGTDxr
         lV109t/cS33r/7NPt7fhOaXOmOYqgP1NXqZsqDn+HZwL+Ua1ovMr8jCaGapFFiKh3Mr/
         Efb0F8pusZA11XHPdn/CBEYk1hDOw28+JVIZOLQoe1AwGWcHXbK7VVToZirMeVJgxM4+
         jREcwq10WjudxJVwschg2NtDQzIOMBxLeo4hLO/wZcPRbdcR1dYTSSvOFjhhePpbKP3n
         EVcPX+hNSfVdvudelzELOsCjge9QPN/+K2ZcW9kcJlDls1EVZW6gzm+vWbh752VzVe4l
         lrYg==
X-Gm-Message-State: APjAAAV3xgUC/h9DSV/eLx9q9iVL/7BdAY06bC1hbi1Vle/HtrpkeN2T
        POa0cufwZ8poDmyptTzzlA==
X-Google-Smtp-Source: APXvYqwJxfrV2wQwH+zMgOlETGCtrJK3zLpSGASTAUh+RB6q2YqACg9lkLbMppU6+pQSjbRyBKqk2A==
X-Received: by 2002:adf:fc91:: with SMTP id g17mr29955817wrr.194.1560869110114;
        Tue, 18 Jun 2019 07:45:10 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id r3sm17686071wrr.61.2019.06.18.07.45.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 07:45:09 -0700 (PDT)
From:   "Slavomir Kaslev (VMware)" <slavomir.kaslev@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v12 08/13] trace-cmd: Switch stop recording signal to SIGUSR1
Date:   Tue, 18 Jun 2019 17:44:50 +0300
Message-Id: <20190618144455.3954-9-slavomir.kaslev@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618144455.3954-1-slavomir.kaslev@gmail.com>
References: <20190618144455.3954-1-slavomir.kaslev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Using Ctrl-C to stop trace-cmd recording from the command line delivers SIGINT
to all its child processes. Switch internal recording stop notification to
SIGUSR1 so that notifying recording child processes can be delayed in order to
do proper flushing when doing remote VM tracing.

Also remove the flush() function, which is only used by trace-cmd listen, and
use finish() instead without changing listener's behavior.

Signed-off-by: Slavomir Kaslev (VMware) <slavomir.kaslev@gmail.com>
---
 tracecmd/trace-record.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index f6e5c7e..d98cd39 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -673,7 +673,7 @@ static void stop_threads(enum trace_type type)
 	/* Tell all threads to finish up */
 	for (i = 0; i < recorder_threads; i++) {
 		if (pids[i].pid > 0) {
-			kill(pids[i].pid, SIGINT);
+			kill(pids[i].pid, SIGUSR1);
 		}
 	}
 
@@ -2653,12 +2653,6 @@ static void finish(int sig)
 	finished = 1;
 }
 
-static void flush(int sig)
-{
-	if (recorder)
-		tracecmd_stop_recording(recorder);
-}
-
 static int connect_port(const char *host, unsigned int port)
 {
 	struct addrinfo hints;
@@ -3013,7 +3007,6 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 	pid_t pid;
 
 	if (type != TRACE_TYPE_EXTRACT) {
-		signal(SIGUSR1, flush);
 
 		pid = fork();
 		if (pid < 0)
@@ -3022,6 +3015,9 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 		if (pid)
 			return pid;
 
+		signal(SIGINT, SIG_DFL);
+		signal(SIGUSR1, finish);
+
 		if (rt_prio)
 			set_prio(rt_prio);
 
-- 
2.20.1

