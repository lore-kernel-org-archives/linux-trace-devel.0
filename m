Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F5F7C77B73
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 May 2023 20:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbjEAUcO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 May 2023 16:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232627AbjEAUcN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 May 2023 16:32:13 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2DE32693
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 May 2023 13:32:11 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-95369921f8eso480754366b.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 May 2023 13:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682973130; x=1685565130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TbsPqu0NmMx050DBeWWzLXTJFATKv4SINn0Iil4PKTg=;
        b=OL18do9ILd+I7romC3Q9hUTN9OfDxb+5RgZRfG5CUJCg8N4523JlG5GTTE1Lr5xoVz
         WiKTA5aMeVwrQsEl4ToIMwpwDaxO52ops7GaOoM0RDgmluO41/dztetoRZEaEX9cjcBo
         4s/rns3Uou82VB4qPnZCJ0cqhk1mSZiNm9qvMSo6lLUs/00SRoTjpaF1l2Jd4yIrGSNF
         GE8d1Xj623g10i1SFT7TD/HNapHuEf4O9i/t7Y2SjJn4mdaMEEVmQW5xquuLIhvoZSwl
         Tv8L38vqG16RTRyYzK28ruHvNkUz7mLXvGTI+ZW99oeg5ewLd3X1/+WkVnjmO1+DHNP2
         9Xeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682973130; x=1685565130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TbsPqu0NmMx050DBeWWzLXTJFATKv4SINn0Iil4PKTg=;
        b=Ma6I7DT8GB6tkGBUFuL2TI/L4ZERqfOQzckPx0Vz2FbnXmeFTv/FG8gRryl/QrZolL
         F0dFwylndmNkPP41OEo5EwDonBnk6vL0hIhYq+oPXxGh9/UTgmlCacATMUucrJDMNJKA
         89qgDr1YJ8k+d2EY7tIxNAOWX4RrkWaFhrF5PfnNGK/DVnRR9qX/MhedLdpsk/pR+YJ2
         92WsZGvtw6tx6R4hJYeRqJBNJwxYNitWMwQdHn83P+lJNHis5uoz7ev8Dnp3lFCiIfpN
         c/B3SofmYVLa7FV5f5SuJecb1qSAc7axQ5sx8nd+eEcA+uxivOJCNr0JQMB9kKiulrDF
         Jg1g==
X-Gm-Message-State: AC+VfDyn64l+FqvDj7wNo/0+Hk6lQoznorDEBgQg8oYssbPHk7q8qgxU
        UK4bCE/9JxbE4KtPzLSqIZg08SxvV+U=
X-Google-Smtp-Source: ACHHUZ68A2UqXDFA1ZWud2MRt3ue9zBQ0MQIaN8wL3zzdFt54VCjcG1VfWt135N+hl/BTbzfaM0xEA==
X-Received: by 2002:a17:907:9688:b0:94f:61f5:9ef7 with SMTP id hd8-20020a170907968800b0094f61f59ef7mr14540187ejc.44.1682973129761;
        Mon, 01 May 2023 13:32:09 -0700 (PDT)
Received: from dante731.cslcs.technion.ac.il ([132.68.206.91])
        by smtp.gmail.com with ESMTPSA id i25-20020a170906851900b0094f1b8901e1sm15233933ejx.68.2023.05.01.13.32.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 May 2023 13:32:09 -0700 (PDT)
From:   avidanborisov@gmail.com
To:     linux-trace-devel@vger.kernel.org
Cc:     Avidan Borisov <avidanborisov@gmail.com>
Subject: [PATCH 3/3] trace-cmd record: Create a pidfile when using --daemonize
Date:   Mon,  1 May 2023 23:31:18 +0300
Message-Id: <20230501203118.3105605-4-avidanborisov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230501203118.3105605-1-avidanborisov@gmail.com>
References: <20230501203118.3105605-1-avidanborisov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Avidan Borisov <avidanborisov@gmail.com>

When used with --daemonize, create a pidfile at
/var/run/trace-cmd-record.pid during the duration
of the recording, and delete it after we're done.

Signed-off-by: Avidan Borisov <avidanborisov@gmail.com>
---
 Documentation/trace-cmd/trace-cmd-record.1.txt |  1 +
 tracecmd/trace-record.c                        | 13 +++++++++++++
 tracecmd/trace-usage.c                         |  4 +++-
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/Documentation/trace-cmd/trace-cmd-record.1.txt b/Documentation/trace-cmd/trace-cmd-record.1.txt
index 366ab46..0c9a914 100644
--- a/Documentation/trace-cmd/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-record.1.txt
@@ -420,6 +420,7 @@ OPTIONS
 
 *--daemonize*
     Run trace-cmd in the background as a daemon after recording has started.
+    Creates a pidfile at /var/run/trace-cmd-record.pid with the pid of trace-cmd during the recording.
 
 EXAMPLES
 --------
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 0eee8dd..85ad808 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -46,6 +46,8 @@
 #define _STR(x) #x
 #define STR(x) _STR(x)
 
+#define RECORD_PIDFILE	"trace-cmd-record.pid"
+
 #define TRACE_CTRL	"tracing_on"
 #define TRACE		"trace"
 #define AVAILABLE	"available_tracers"
@@ -93,6 +95,8 @@ static bool fork_process;
 
 static bool do_daemonize;
 
+static bool created_pidfile;
+
 /* Max size to let a per cpu file get */
 static int max_kb;
 
@@ -648,6 +652,9 @@ void die(const char *fmt, ...)
 	else
 		ret = -1;
 
+	if (created_pidfile)
+		remove_pid_file(RECORD_PIDFILE);
+
 	kill_threads();
 	va_start(ap, fmt);
 	fprintf(stderr, "  ");
@@ -1739,6 +1746,9 @@ static void daemonize_finish(void)
 
 	if (kill(getppid(), SIGRTMIN) == -1)
 		die("daemonize: kill");
+
+	make_pid_file(RECORD_PIDFILE);
+	created_pidfile = true;
 }
 
 static void trace_or_sleep(enum trace_type type, bool pwait)
@@ -7190,6 +7200,9 @@ static void record_trace(int argc, char **argv,
 
 	destroy_stats();
 	finalize_record_trace(ctx);
+
+	if (created_pidfile)
+		remove_pid_file(RECORD_PIDFILE);
 }
 
 /*
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index 0630e8e..2e5d861 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -81,7 +81,9 @@ static struct usage_help usage_help[] = {
 		"                        available algorithms can be listed with trace-cmd list -c\n"
 		"          --proxy vsocket to reach the agent. Acts the same as -A (for an agent)\n"
 		"              but will send the proxy connection to the agent.\n"
-		"          --daemonize run trace-cmd in the background as a daemon after recording has started\n"
+		"          --daemonize run trace-cmd in the background as a daemon after recording has started.\n"
+		"                      creates a pidfile at /var/run/trace-cmd-record.pid with the pid of trace-cmd\n"
+		"                      during the recording.\n"
 	},
 	{
 		"set",
-- 
2.25.1

