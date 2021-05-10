Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 764EEC433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:16:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CA9661155
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:16:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhEJGRw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 May 2021 02:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhEJGRw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 May 2021 02:17:52 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D60EC061573
        for <linux-trace-devel@vger.kernel.org>; Sun,  9 May 2021 23:16:47 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id b25so22695851eju.5
        for <linux-trace-devel@vger.kernel.org>; Sun, 09 May 2021 23:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L4cIrri7H50G2QgorkNc4Lv9OxhhIH4oM+gSM061M5w=;
        b=AAvD7oqV7gRwi2RVwA2KV+OkEiLKiFgH2mawtWxuQRcPvxnONQIcteIhsv69iPl9z5
         dDnAMRvoKEDM1lWiniHYW94ZFDNUBYTue6IuuBRd5xhLtLh7c8sHETVnxLni9uGZEhBA
         xEyI4fYBJJ0TMRf50Yey2ZhMZfiY6u+XujbPUjh/QbpRgacEYir6FnjwxK2g84WVOZQB
         I4ARJZh9nRLekeWUBiNH2Mg0JZPewW5eU75+UEt1Z9xNNrS+g9QvPdMxxRKKJwzVW3BL
         AWW5V5qFkrA802aZzcRpAn53IJB7LrFaH/bBqMJTpx1s+Fkw/SLfKPVhjOnv8kYZrKYY
         DIOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L4cIrri7H50G2QgorkNc4Lv9OxhhIH4oM+gSM061M5w=;
        b=dsCYXri1GyKVR6U5K4xjZloX9U+fQMac9FY8wEbauH0ze4jXcMKcHEHUFhmGJnCCFh
         veGEy1Zayf9JwJWVyE1LZd3h1n0vO9CXuHGS2IUe8LkyefN+OAgro7vRDUYLYXGDTUqa
         KMwW+15Q7NbJbm9g7xX9fx4Q/L/NqfrSqGMpDNzKFOKflEWOAimIULKO0xLPar3k98Dv
         wZKIvFxQOKuBGi7pVatPy09VwKmH6cROc5GzVbj6WevXrzliO3MAxSnHh4BBB94F+4Td
         Z+K+zTdZC+4DPc0sCJcY7eeGJi6gSEx9zvWwhRDbZyYY9ZBAQnrB5LZu7FHdIypaz8HA
         cBGw==
X-Gm-Message-State: AOAM5313RICrLs+ekNY/T8EI3s5aNeQ55nEvzxA8tKrfGfSKgr3CEXxf
        ytN0ox/XgZlaqWbtYnOSRIJhdd8thNvNZA==
X-Google-Smtp-Source: ABdhPJy83O360XtPzATzZLUYFBVH8UMu21kdxJCSHpBp9PVwgmBz+5u0AkEw4gvZDcmMjKKero29lw==
X-Received: by 2002:a17:906:3b13:: with SMTP id g19mr24062733ejf.238.1620627406193;
        Sun, 09 May 2021 23:16:46 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u3sm5055205eja.25.2021.05.09.23.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 23:16:45 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 08/21] trace-cmd list: Show supported compression algorithms
Date:   Mon, 10 May 2021 09:16:23 +0300
Message-Id: <20210510061636.1794357-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510061636.1794357-1-tz.stoyanov@gmail.com>
References: <20210510061636.1794357-1-tz.stoyanov@gmail.com>
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

