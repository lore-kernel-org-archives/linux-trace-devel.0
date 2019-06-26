Return-Path: <SRS0=TDtF=UZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52EC4C48BD8
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jun 2019 10:52:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E43020656
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jun 2019 10:52:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gF0BKpjQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfFZKw0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 06:52:26 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33613 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbfFZKw0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 06:52:26 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so2213886wru.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jun 2019 03:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kVA4Q0CyTBoekHPVkMr2SUHDqfdG3DNJO2bBj35g6Pc=;
        b=gF0BKpjQKgSUnpXD0ELWnFaiyxK63eYcxd6r+/UQmegx3ZgiRioemXPaJ5RkN4izvW
         7loMiZsJcOVAR5erMW9AvAOBB4zM7sZMpyVnechfMIcuzWT0BGIYDmV24EG8h5fF3k8o
         GzvD4Yn+zQDYB3SZ6MisFrNCTcejz/lLEMcHqWDP2WBQPF7JPp03YB9Wxz7cSIPeNPER
         HWsv4VSxZ1ktHsgRSdlPkBvMWQmSgkTHu0PXLrmCpplV0LFaTWaXyk6xQffxs92iKJSt
         6F4ozj7Abc53dbge8GBJfUZNjTuX0xL7hXSfIXJEKlihAAqZ4yKKu7LAn3qBlOOu9uQf
         1J7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kVA4Q0CyTBoekHPVkMr2SUHDqfdG3DNJO2bBj35g6Pc=;
        b=QLkDWVZbSm4ctx5jAFq9VKn/GA0e24zcbJNGs1fOBQT9ccoY2PpaFr+G7bLhqrpFov
         Vy6fZDuennZa8fVrcgDi6RBZY6fXKgTd+C78IfpMGmIFr5C6vT2XQgDx7E0oQ7dIiIVT
         fyVU+3ZG4ysgZT5gpd7p55P6ubaybxpyU3CnBzVLHicbir1WAOYTJ+PHldvyi5SahyPU
         v+n7BlLwyxcx19k2/2diqxIAmBO2jyOM7V3kGhpOlZCiRajA8Fewv0VWk8Q/G5cjvJ9X
         gReZbveu0Q4/j+pbmyeRn+G9RdWCgdSpfSQJGKyFjlE0ztM+/m7qPssIUtDvcxzzFUDy
         4pXQ==
X-Gm-Message-State: APjAAAVyvlrZsskxvc+MYbEE7UgxqEx/TbaExVlXODUxKukr9HR6hYDx
        H3nU0zzcSGlK9/dA2Foh/UUkv8R3+A==
X-Google-Smtp-Source: APXvYqylHFia1+UznPPiSZnRuxkQMEyLKPgdfoe9k5nEZtYkbVJBbHMjpnjyOCARB20/XnrMv3ihZA==
X-Received: by 2002:adf:de8e:: with SMTP id w14mr3372302wrl.130.1561546345153;
        Wed, 26 Jun 2019 03:52:25 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id s10sm15456929wrt.49.2019.06.26.03.52.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 03:52:24 -0700 (PDT)
From:   "Slavomir Kaslev (VMware)" <slavomir.kaslev@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v13 08/13] trace-cmd: Switch stop recording signal to SIGUSR1
Date:   Wed, 26 Jun 2019 13:52:04 +0300
Message-Id: <20190626105209.13200-9-slavomir.kaslev@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626105209.13200-1-slavomir.kaslev@gmail.com>
References: <20190626105209.13200-1-slavomir.kaslev@gmail.com>
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
index 130eab7..da63aef 100644
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

