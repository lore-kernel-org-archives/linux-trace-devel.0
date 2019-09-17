Return-Path: <SRS0=9KLN=XM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78D2CC4CECE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Sep 2019 13:15:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 598E62171F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Sep 2019 13:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727724AbfIQNP4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Sep 2019 09:15:56 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51100 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727711AbfIQNP4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Sep 2019 09:15:56 -0400
Received: by mail-wm1-f65.google.com with SMTP id 5so3410022wmg.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 17 Sep 2019 06:15:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YUHFKnXyGkMaoJ8MUXRllgrYrMwJssMAjwSEKvU3LFA=;
        b=HpUHRQJkUuNiZ8ZoeV/uKdx5Jb4xneU//WI0Z411SG6zPYmLHdZnU6a7U9emEn7bNA
         pIKC64tVClZoCSoSd41NoXMSK8fGPeX4x7PYul/TGL83GpqSKU5tj0k3FT/AbgOws/F/
         vp7fqldOv8EAu/hwNrrfawcJmDzbvHB7D2AJMcg9UIt7+ukcdXuQ7dAYsoLWztLt2E4X
         miA7HGL1pE3cuZYeQ6hzP8FcwfFAZssrinUAsoxI98X3epcf8AHOW4Whgb0CO8AWnl6p
         tNBZE+a9+ZTZgkjfKeNKD1EKVSrQYvnPpf6cbi0/PcGfZiUKTy45nedwK3p8r8FXtDmH
         wKAQ==
X-Gm-Message-State: APjAAAXTRfGs8XpDwBvdw2eOsmSHFrcb9AlFROLw0pfJXv4pvUXIR5Pm
        I5KeQ9YqmYZTdEOXd01vPPn1q5L2bA==
X-Google-Smtp-Source: APXvYqzI6vLaKOBSz0nTXb+7KSoJdiiCgeCIOhZxVIgeq/vvyhOEzCsUXMVZyDEhpWL4AXj6AMNWHw==
X-Received: by 2002:a7b:cb4e:: with SMTP id v14mr3513518wmj.159.1568726154084;
        Tue, 17 Sep 2019 06:15:54 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d22sm1667265wmb.44.2019.09.17.06.15.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Sep 2019 06:15:53 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v14 08/13] trace-cmd: Switch stop recording signal to SIGUSR1
Date:   Tue, 17 Sep 2019 16:15:33 +0300
Message-Id: <20190917131538.31926-9-kaslevs@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190917131538.31926-1-kaslevs@vmware.com>
References: <20190917131538.31926-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Slavomir Kaslev (VMware)" <slavomir.kaslev@gmail.com>

Using Ctrl-C to stop trace-cmd recording from the command line delivers SIGINT
to all its child processes. Switch internal recording stop notification to
SIGUSR1 so that notifying recording child processes can be delayed in order to
do proper flushing when doing remote VM tracing.

Also remove the flush() function, which is only used by trace-cmd listen, and
use finish() instead without changing listener's behavior.

Signed-off-by: Slavomir Kaslev (VMware) <slavomir.kaslev@gmail.com>
Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-record.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 94d01c5..4880f50 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -676,7 +676,7 @@ static void stop_threads(enum trace_type type)
 	/* Tell all threads to finish up */
 	for (i = 0; i < recorder_threads; i++) {
 		if (pids[i].pid > 0) {
-			kill(pids[i].pid, SIGINT);
+			kill(pids[i].pid, SIGUSR1);
 		}
 	}
 
@@ -2656,12 +2656,6 @@ static void finish(int sig)
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
@@ -3015,7 +3009,6 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 	pid_t pid;
 
 	if (type != TRACE_TYPE_EXTRACT) {
-		signal(SIGUSR1, flush);
 
 		pid = fork();
 		if (pid < 0)
@@ -3024,6 +3017,9 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 		if (pid)
 			return pid;
 
+		signal(SIGINT, SIG_IGN);
+		signal(SIGUSR1, finish);
+
 		if (rt_prio)
 			set_prio(rt_prio);
 
-- 
2.20.1

