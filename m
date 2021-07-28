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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9185AC4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A46D60FED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236279AbhG1NdJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236608AbhG1NdE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:04 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65703C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:02 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id f13so3182624edq.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fv+FJkb2Lkjik897xvnzRSMdiYDW4XmLvXrISE7YIac=;
        b=MOI5vbKpsMFxwqMi9Ki5fcr0BsVLfVnr4DC1QGdrb/lKCPSZE+Tj9pOfYdzEF3Z6P0
         WnfwHfXazvCp7jcaYAqIabkRbJycVaXuI6zWGivQ8LhtGXOQyZxGDkzJdn7DJFHcYkag
         BfY9wEXyAmanWUlgeTQ+uTXFWxBbBgyzT+kW5e5ctJ/KCQ9xwEDQRYXHDdIBOx6Xvw+F
         hHMAA9TabGiJHpje/GskmgdFvVr4cx3DsEpmu2YLonH5GwlKJTmFdgzJj7vqFydtlQ/B
         dv5kSuY3eT26XCHq0KvB0KdjKzlaImoKCpjvkjim71pcGFfCjMSlObuqEWjZIdHdEqT9
         UThA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fv+FJkb2Lkjik897xvnzRSMdiYDW4XmLvXrISE7YIac=;
        b=KWYYeD2PO0mBRxI6gyITkWTzVsUtFnixM3wjGlTG24NDtea3yq87KLMupM2vKEvQqJ
         BNL01W4AGepAK1CzoUTsRO+pOjDuEe3nE0P7oc4PFhP/WEEt/YYmDVxoIXdZ2EzI+PLx
         QhbDj4o7l2tVbxhLiz9HPoogLNyhZodlf5Wvz4fgXcPfFYWxI/h2Clf6a95/9nJzyhEg
         1DRuov7khFYKDVH1lbKV2fuS3Mcgu7zYKeNi+xiHh/32r7YBO0glze/g4EFuH5twTJ09
         zRDWW/mB7tf8yT8S8fe8sOgGO2PmE4eEQ4x88nEDLCezBfl4UJKIq65ICITNHB5QHcvP
         8mfA==
X-Gm-Message-State: AOAM530Yq7NTfzsobhzUJBzuqnwFLeWnxEpQeq9AlXgj3o2xevhQIUzl
        DBBYC0H2sV+8/wX15uYRIcUaD39oPTjPIQ==
X-Google-Smtp-Source: ABdhPJyr3d9idcYZZf32IrukaTVOswr0o/3TGCDhcFlse5YxXVDP+xPqeqTs9gXP2I3WcQJxapXzug==
X-Received: by 2002:a50:954c:: with SMTP id v12mr34184059eda.313.1627479180975;
        Wed, 28 Jul 2021 06:33:00 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:00 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 09/87] trace-cmd list: Show supported compression algorithms
Date:   Wed, 28 Jul 2021 16:31:32 +0300
Message-Id: <20210728133250.234140-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
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
index 32b38bfd..f463465a 100644
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

