Return-Path: <SRS0=RjDi=YB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F2E4ECE58E
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Oct 2019 08:15:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6F84206C2
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Oct 2019 08:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730503AbfJHIP4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Oct 2019 04:15:56 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55488 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730590AbfJHIPy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Oct 2019 04:15:54 -0400
Received: by mail-wm1-f67.google.com with SMTP id a6so2071055wma.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 08 Oct 2019 01:15:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CPlfQk4z/gmSb+4sskaEKwNay5eagBEkdt/os2d7jMY=;
        b=n4CXZwTPG+50Ii5Auci2xhj3UznbI7FcBXZKwIi1FUSj7GLYmtDHgOQsG0dsUfE/Hy
         fDsSTY6Fdlba7Vz0cqI9SF0RkviJ/6E8bWB+ZN+tIzdMX9KUiZnkfxgwdQ8W0f2+z0Ru
         e8M2SLYisuiWrkMBHa6hWTXLdRvAuTriE5D6eQOqKUMBbu+HXmOKHlBwAGSPBg961xIm
         bDisO6uAe8FQJuGkIq/+fjpgma2o2kHFxej0BDo3/RQ33FFR3Ub6apFd/BHgx3Xuoys5
         DYkck1dRqm6D6lG7ksaMcMQOWOIarCjBq0Okb9pywvGBK1RIOJvCtY4SFyvbR2x/SZ+J
         E7XA==
X-Gm-Message-State: APjAAAX9JcQGD7202u9XsEjCLY8DCovIsjCKEk+q64Bvn/7uQe0xEQmo
        73fjlzWtoi7LKYzWYI6oK5ZurDF2XQ==
X-Google-Smtp-Source: APXvYqzuJVWPlo2qgUyczJjDQrt0xHfyKKB8YxBBfDWSEg6LknqkCaDl0TiQV+PREBezDtHAIbubnw==
X-Received: by 2002:a1c:6a0b:: with SMTP id f11mr2917196wmc.78.1570522552146;
        Tue, 08 Oct 2019 01:15:52 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f13sm2201440wmj.17.2019.10.08.01.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 01:15:51 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v15 08/13] trace-cmd: Switch stop recording signal to SIGUSR1
Date:   Tue,  8 Oct 2019 11:15:32 +0300
Message-Id: <20191008081537.11536-9-kaslevs@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191008081537.11536-1-kaslevs@vmware.com>
References: <20191008081537.11536-1-kaslevs@vmware.com>
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

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-record.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index b974d09..94180c2 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -682,7 +682,7 @@ static void stop_threads(enum trace_type type)
 	/* Tell all threads to finish up */
 	for (i = 0; i < recorder_threads; i++) {
 		if (pids[i].pid > 0) {
-			kill(pids[i].pid, SIGINT);
+			kill(pids[i].pid, SIGUSR1);
 		}
 	}
 
@@ -2854,12 +2854,6 @@ static void finish(int sig)
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
@@ -3213,7 +3207,6 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 	pid_t pid;
 
 	if (type != TRACE_TYPE_EXTRACT) {
-		signal(SIGUSR1, flush);
 
 		pid = fork();
 		if (pid < 0)
@@ -3222,6 +3215,9 @@ static int create_recorder(struct buffer_instance *instance, int cpu,
 		if (pid)
 			return pid;
 
+		signal(SIGINT, SIG_IGN);
+		signal(SIGUSR1, finish);
+
 		if (rt_prio)
 			set_prio(rt_prio);
 
-- 
2.20.1

