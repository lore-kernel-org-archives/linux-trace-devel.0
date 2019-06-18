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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39F03C31E5B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12DE920B1F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jun 2019 14:40:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YnmPlaeA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729157AbfFROkR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 10:40:17 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39137 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728572AbfFROkR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 10:40:17 -0400
Received: by mail-wr1-f66.google.com with SMTP id x4so14288242wrt.6
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Jun 2019 07:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RUcBoUQNQrgcKDeseDcABNoAkO9CRuGl+8Gvj7tg0ew=;
        b=YnmPlaeADoYLE3JJykLbpdi0NDlM9Yuo1qy/WrfUGlqvHEio/b6bmSOY8XS3FYP0UH
         eILO2uj/xQzqX+oySRlF6gTtXrzZoF6rwgtcLfYpiWUqqyI7vKPz5Fd4ZA+ZbXZVnMr6
         kED43+NEU/5sC1Yj0BIPAT4GM/q5BOtzKb8462oZrLFRD3wDxNXZ0uFBJfeO4S6E3Tlx
         qluw7yHO4qODn6XALI1VI+lF/IwNXI6GGhNU+6qpgKzXyz0SYE4rFPhWD8HOf5K6aKRt
         /zlZrGfOvAyoqCzJeBEHZyAvEO27hV6cNewo3L2y3PGgMUzq13J9OyEXxS/Zv2iwYg/c
         VNhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RUcBoUQNQrgcKDeseDcABNoAkO9CRuGl+8Gvj7tg0ew=;
        b=fNVe+HzaTuRmducQMdC+cany1zdI8lf60brGZ/x/h8Wx2+IiyXzDf939dca7OZs7RM
         sV6OTqVeEXBbnzCGqZk4sBbKLpVitPBtiCV6fXXKkJrboSRjdTuEfV9tK6AtYMm7cSwl
         ridtHBC6+DI/BB/0Kl1XhTkq1027zPUv0Q+d1bSpcTCyN6LlCt2dw4EtXcpKTIBBWqB9
         LYPHqsxtpIZCskada8KNVFdpisI4RZWNY7DfiJyZknl2Ca97aAJhpkWjUIVXub8qDq64
         j/nI0NlMGGoAE05K7EKEKCbhhXIVj/C13GyFYucrCVa41wJ4ErsH7++ZQl5BXaIPuGPx
         xLZA==
X-Gm-Message-State: APjAAAWjb7l6SkC3ZPdqaTk5hBIEZpxaZFwrB/5RvdcaSmY6rTVYynl0
        6+MXiu0pC+0CDBNf7Pm3olN1jM8=
X-Google-Smtp-Source: APXvYqzfGL5Pb7gUYgoGsch7UzjNcLOwyMdIrSndndzkksOXcPrrrqyTM1Hw5l7stPxga5ZvVl0hgw==
X-Received: by 2002:adf:fb47:: with SMTP id c7mr45303868wrs.116.1560868815290;
        Tue, 18 Jun 2019 07:40:15 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y1sm2411808wma.32.2019.06.18.07.40.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 07:40:14 -0700 (PDT)
From:   "Slavomir Kaslev (VMware)" <slavomir.kaslev@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v11 08/13] trace-cmd: Switch stop recording signal to SIGUSR1
Date:   Tue, 18 Jun 2019 17:39:53 +0300
Message-Id: <20190618143958.2865-9-slavomir.kaslev@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618143958.2865-1-slavomir.kaslev@gmail.com>
References: <20190618143958.2865-1-slavomir.kaslev@gmail.com>
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

