Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9982BC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 843E0603E9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234010AbhKKPPG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233991AbhKKPPF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:15:05 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C212C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:16 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id m14so25744355edd.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0vF4/kyI9N2FIR8o+/109ZpzkBALfqAJzj8PQ0/ofkw=;
        b=fQuMNzVI4YLcCCb83XJB9spVHaJh7M68i3qCR+OU8w03n71RhFuvOucbnB6pqoopdk
         TGP0JfqASPnVkmLnYOhqur/7KTDIu2zr5uaYt2dd9A9GyRrzaSQf5JWS8sDqtbYHcg9g
         HKOta12P1tRbnAOAL2yTx82qIWshXXYaZ0ftu24xx6ultZNDlhn1KJovEdurZUciGcAJ
         oEBCW2wQA2c4caqWpOzH1Nbqu4t/CSpr25ZG+MswZJKuJgDdms01HHVe2FXaI5CSVDIy
         Ps1yEleLXbnerZMVPzxfkpuzjgrQOHt5XvYd0dn9Yr1VkpSz/p0OWQPRkdAiNSf7eHBr
         dCQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0vF4/kyI9N2FIR8o+/109ZpzkBALfqAJzj8PQ0/ofkw=;
        b=RpgXsMgpa17k53jd/upBsnq+hgThSez0O8f5b4v+javAK+Oke9d9PWvYvqdQQMWETP
         0iu5kr/kDz+jLt+I00Kb6mhliIBNo43xnQuEovhq2rkDe+K27tglHOpUvZ08Oax0Gkp4
         2MZ6SkQOwXwpLlxholA8H14v69UGPZWshXa7ws2cIfkWyZ6N9QwrrT3UlbOrDrnzNy5W
         tsEEcIQxYMe1nwSzyfmX9zz/ATTBjkMShSbRhP9UlCSu40eg4f9nJ6FbCyRCeYyW/CbY
         V3FDg/YTX4kveQ92kZiJeZtC4OycccykQjYhtVe79Cj6taCHS/SDRLrP22dluiX3upDM
         Vymw==
X-Gm-Message-State: AOAM533sG7YCCkILsqfO7q0qpFLIKvjjR9O3pkhqDazmehkNQ643wtVv
        SgMEy2ygiFa8BdUG/sEZ7dh4/WvKRyADDQ==
X-Google-Smtp-Source: ABdhPJyn4nSyRnpfE27IYIChKwAoXqKSV9cPtmpE9I75M7QzgnUS4COobqrz9/xKJRg4S0Ipaj0Vkw==
X-Received: by 2002:aa7:cb92:: with SMTP id r18mr10880541edt.282.1636643534866;
        Thu, 11 Nov 2021 07:12:14 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id qf9sm1479509ejc.18.2021.11.11.07.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:12:14 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 18/20] trace-cmd list: Show supported compression algorithms
Date:   Thu, 11 Nov 2021 17:11:51 +0200
Message-Id: <20211111151153.86855-19-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151153.86855-1-tz.stoyanov@gmail.com>
References: <20211111151153.86855-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add new parameter "trace-cmd list -c" to show supported compression
algorithms.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd/trace-cmd-list.1.txt |  3 +++
 tracecmd/trace-list.c                        | 26 ++++++++++++++++++++
 tracecmd/trace-usage.c                       |  1 +
 3 files changed, 30 insertions(+)

diff --git a/Documentation/trace-cmd/trace-cmd-list.1.txt b/Documentation/trace-cmd/trace-cmd-list.1.txt
index a5c6b16c..b77e3460 100644
--- a/Documentation/trace-cmd/trace-cmd-list.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-list.1.txt
@@ -71,6 +71,9 @@ OPTIONS
     List defined clocks that can be used with trace-cmd record -C.
     The one in brackets ([]) is the active clock.
 
+*-c*::
+    List the available trace file compression algorithms.
+
 SEE ALSO
 --------
 trace-cmd(1), trace-cmd-record(1), trace-cmd-report(1), trace-cmd-start(1),
diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index d060c810..900da73b 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -549,6 +549,24 @@ static void show_plugins(void)
 	tep_free(pevent);
 }
 
+static void show_compression(void)
+{
+	char **versions, **names;
+	int c, i;
+
+	c = tracecmd_compress_protos_get(&names, &versions);
+	if (c <= 0) {
+		printf("No compression algorithms are supported\n");
+		return;
+	}
+	printf("Supported compression algorithms:\n");
+	for (i = 0; i < c; i++)
+		printf("\t%s, %s\n", names[i], versions[i]);
+
+	free(names);
+	free(versions);
+}
+
 void trace_list(int argc, char **argv)
 {
 	int events = 0;
@@ -562,6 +580,7 @@ void trace_list(int argc, char **argv)
 	int flags = 0;
 	int systems = 0;
 	int show_all = 1;
+	int compression = 0;
 	int i;
 	const char *arg;
 	const char *funcre = NULL;
@@ -626,6 +645,10 @@ void trace_list(int argc, char **argv)
 				systems = 1;
 				show_all = 0;
 				break;
+			case 'c':
+				compression = 1;
+				show_all = 0;
+				break;
 			case '-':
 				if (strcmp(argv[i], "--debug") == 0) {
 					tracecmd_set_debug(true);
@@ -670,6 +693,8 @@ void trace_list(int argc, char **argv)
 		show_clocks();
 	if (systems)
 		show_systems();
+	if (compression)
+		show_compression();
 	if (show_all) {
 		printf("event systems:\n");
 		show_systems();
@@ -679,6 +704,7 @@ void trace_list(int argc, char **argv)
 		show_tracers();
 		printf("\noptions:\n");
 		show_options();
+		show_compression();
 	}
 
 	return;
diff --git a/tracecmd/trace-usage.c b/tracecmd/trace-usage.c
index ac12b066..34c6cc35 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -348,6 +348,7 @@ static struct usage_help usage_help[] = {
 		"          -O list plugin options\n"
 		"          -B list defined buffer instances\n"
 		"          -C list the defined clocks (and active one)\n"
+		"          -c list the supported trace file compression algorithms\n"
 	},
 	{
 		"restore",
-- 
2.33.1

