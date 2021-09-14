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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22560C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:17:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DCC7610E6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:17:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbhINNS2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233113AbhINNSZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:18:25 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943B6C061762
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:17:07 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id s24so9228496wmh.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cGVmGD9Qf7kvIF9D5l30TnsDDlX1yRgwYMIHptNl3Bo=;
        b=oXtpLjTiWXbn35JVk50LIfxlFqFgTcshU4lyACBZp7Lhh7w86qK6N3qu1jzsQPqNMh
         Y2q6GSwOk75d28cEuGf79kIqS0spUqOt82KARuBOmSzomQFATEdXNKqBUvacXnw/l/Av
         8V78ikP1WtlLgX3fbPR2SNheWOvqI81nbb1OWRsMviDsLxqB6ih1ha5jNlOYY+3AGxT+
         H+HUc9Q7DT2iqFSNzANqNXc1KSKgrRn7uzUAhNJms8zyYHtW0PwDiF2XPxG7CRSgGIfj
         SL4sqfhvsmqDRy8R+j3ISe+xazKmljxti17KRUqQ5xugOm2qtnfpZtshBVZPxATNKoZ1
         IfWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cGVmGD9Qf7kvIF9D5l30TnsDDlX1yRgwYMIHptNl3Bo=;
        b=Bfqh9jPWdWkdavpxzjAqEGVc+senpW5Ga3+CKb2ICskoMYiu9QHOOGNitVCGcYtYb5
         +FaVhGLHYEiWchRGUYDOfYMiG8x4w8Q3lLfgS2xREZULaWDAhcD5C2Y4dPVpA3xtn85n
         eDtHjDJWUNHEiWPlS60EL0sSxwA4vZh+uMm7H8UXQikZ57X84V+kGlhLUuxHslRvFnhx
         gB1gsQfdaqAB5GEII1FY/+QGh7HpcTqwm454CPzthel9LJE1NVjWUUBf/0k1vb4tKawy
         QZL12gEzcbZa45Em0Gw9naSjy2lbh7wNVA9T0bbcHm7aKkH6Nwnjp9JXFExyXWUSNX+b
         y2hA==
X-Gm-Message-State: AOAM533J8AFHViR32lCIrsgSUfnQDg2bSEDNjecI77dlVpuuGLCpVARS
        /Vt8Vo/SMR292HfriswJjjCUbkCQp8s=
X-Google-Smtp-Source: ABdhPJzcUBjIKRQH+nvcbCh3gwjWLaPJcZggiqYzUXam6W9ezHM9VUw7vEpuySoJQITabXy9h1cNeA==
X-Received: by 2002:a7b:c18c:: with SMTP id y12mr2166698wmi.3.1631625426209;
        Tue, 14 Sep 2021 06:17:06 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q10sm1119624wmq.12.2021.09.14.06.17.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:17:05 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 18/20] trace-cmd list: Show supported compression algorithms
Date:   Tue, 14 Sep 2021 16:16:43 +0300
Message-Id: <20210914131645.3966308-19-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
References: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
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
2.31.1

