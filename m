Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1A37C43217
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:27:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352477AbiASI1m (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352478AbiASI1g (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:27:36 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E50BDC061746
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:35 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id f21so7483629eds.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v4D+2uCZ7+pjLxy4nudPTs1AVxRDbpF5rZR3iadjTKE=;
        b=l5AGYkTOcNSySrknDOLwy4D0Cgaq/CotYoCvG4qWyaj7O6DAvq1rpvEQbQotVmbHFB
         DOt1pFwaqq1Nil2kmbz80LdGYMBwXdYQLVsbKt1Sye2mtGgDMc9S2c+qv4yXvsOk0lME
         XJ+pN86xKmGo+GN8WAk7Zsu1MesAdESOLyRvdVwgHoCABr5T9jnxn/cjcTzmAjbCJHMV
         v2Jj2oTlA+Bnp1ylz7sg2wtaFqn4XhY/ECPpr9lNJbe2a9oWEdXxsO84mgz7H98gZ2+i
         DfAYg6C6mOhSCi2gPARnx36B3Q2qRwxxapFJ2DgvkKxDnjR9V3w4TETt6k6c5g4guS5v
         5KhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v4D+2uCZ7+pjLxy4nudPTs1AVxRDbpF5rZR3iadjTKE=;
        b=KieR/3GdBnvlbnCV5tyeIGj5bK28PsOiUQjky3+bDaOUHnzWCWgfq/9Gd03sjlLZFh
         sZv39HF/Ct86DkxQpWBR8mPeI8ZGum9qWAazFto/zvj+tUbOumdjBXdE6N98rm/+Zugg
         EhuaY3vRAkpRRj+INyx60T275y3HHE5r6B3+UJkOCDwayHOI4FwrEGc8EY9C6EWxcuNV
         5fcBhr2NABoRqMnf/GfZfPkjs2ia8qXV9SKy8itzKKPXMstIQYAlL0b8rkP1nxIznkr3
         XmehJK2JeDvfN62s9mNX5VEhH5OBWmq2sfe1cfh2JbWPU8ICpCASVeWjpsNKX2o/LyLq
         Q6ZQ==
X-Gm-Message-State: AOAM5311dzETeQ/wQzpLukdByR/92130oHpvoK6D3J/fcj/jIy/Udb58
        pj3IlIF4LqxoRgI8O7VbprIioaVzL2I=
X-Google-Smtp-Source: ABdhPJym+UPodiT+eghjzaSxze9HzyEn3NHdL1RrvC+AhTgi0cxM9dy2NXtbqVnB5IrOZu8j27KrFg==
X-Received: by 2002:a17:906:66cb:: with SMTP id k11mr3265149ejp.85.1642580854562;
        Wed, 19 Jan 2022 00:27:34 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d14sm848703edu.57.2022.01.19.00.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:27:34 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 18/20] trace-cmd list: Show supported compression algorithms
Date:   Wed, 19 Jan 2022 10:27:13 +0200
Message-Id: <20220119082715.245846-19-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082715.245846-1-tz.stoyanov@gmail.com>
References: <20220119082715.245846-1-tz.stoyanov@gmail.com>
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
2.34.1

