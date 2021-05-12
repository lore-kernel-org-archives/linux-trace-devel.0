Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7350C433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90A5F613BA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbhELGjp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 May 2021 02:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbhELGjo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 May 2021 02:39:44 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DDFFC0613ED
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:34 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id t4so33379570ejo.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L4cIrri7H50G2QgorkNc4Lv9OxhhIH4oM+gSM061M5w=;
        b=eYWSRnquTBWx/aPXFpdR6b74vv1lV0ak4ogCfYTrfWCyXFtuegwmkRQNe3HDEtiwCF
         kOrroY4kJ36ItyRUHyUnaDeTbWECj4rOFzXLVhIK0/O4zQo/wTYgd8b4V5Sc+i7FEY7R
         M1oljOu6wPKEOZ3qW9L6CQrFEqhoLeuSn4OYc2x8jrdPyBaFyEagbkEiB8KdIbMh+/R/
         OrmI/ob9GFVDrsNoLuZdeSbuTf5n3Bm6pXK8CJtovyJpY47FxN9SijMvabmXX3GmPKWS
         ZXfB1ew3diyXHej8QcYi9AoZ3tTGgsAyz1DONc0hp7izmlFoRfv7SmaEqMjj6VkAYHZ6
         urww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L4cIrri7H50G2QgorkNc4Lv9OxhhIH4oM+gSM061M5w=;
        b=VbKFuRfeuhgKAk/Jo8xIFDjKqK1I8sSUb2FmRl7ikFGcHoPNBcoRWxi//J3D+44/xT
         aFUf7jJauMa8lcPQ0QdAGIHGh1BA7JVF70yV9YBke/tEH7mL+wR16VVKx8rdcDDvxqXW
         J3jmqBTL4I+SpcWLQkbApcfnE4ELx9yTdTJ0SGtwStKlxPP8sR1Kvh230QHLOg4xKvrM
         Hi7z3tsnTH3fjnYEJOHgaSUbSCh1lkOaRWdHJQsuzxEBIgHSIr2WZ0fH1jTG+uQOZHKs
         e58gpgFLtWQN6yg7A7/mPv5w3brGxZ59UCL7LcwQa+ux3WrdjV5sochdIQaZL0KjFtsp
         RONw==
X-Gm-Message-State: AOAM533mIthrzm8nHepOjCKhgwX/n1ogcs0skQaU9ejb8K4t6kJMIewD
        /ytqwmz8wNHg79fRfNgn0oQ=
X-Google-Smtp-Source: ABdhPJw9FMF4eYVXDrd8APEyiNk3+sctmb6gUbrNzDlsBnfjMwNXDzEQ2VMHGfLSdPjzpd+mTSZL3w==
X-Received: by 2002:a17:906:d159:: with SMTP id br25mr8593953ejb.248.1620801513391;
        Tue, 11 May 2021 23:38:33 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h23sm13387723ejx.90.2021.05.11.23.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 23:38:32 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 08/25] trace-cmd list: Show supported compression algorithms
Date:   Wed, 12 May 2021 09:38:06 +0300
Message-Id: <20210512063823.324610-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512063823.324610-1-tz.stoyanov@gmail.com>
References: <20210512063823.324610-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add new parameter "trace-cmd list -c" to show supported compression
algorithms.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-list.c  | 26 ++++++++++++++++++++++++++
 tracecmd/trace-usage.c |  1 +
 2 files changed, 27 insertions(+)

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
index 998f5a24..c388eccd 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -330,6 +330,7 @@ static struct usage_help usage_help[] = {
 		"          -O list plugin options\n"
 		"          -B list defined buffer instances\n"
 		"          -C list the defined clocks (and active one)\n"
+		"          -c list the supported trace file compression algorithms\n"
 	},
 	{
 		"restore",
-- 
2.31.1

