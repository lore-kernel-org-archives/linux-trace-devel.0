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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D895C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A10661019
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233893AbhG2FKP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233790AbhG2FKP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:15 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F37C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:11 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id j2so6361555edp.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fv+FJkb2Lkjik897xvnzRSMdiYDW4XmLvXrISE7YIac=;
        b=pc5QrRZFwIEWVW1vh+5Gtp1IA0zMwFDUqqj0km3XEkq8AXAF6mdYwtn5JiCaVtmTA+
         l71nhQlmlHyxoVK5zu8JpuiMo8J3RMnr3R7wEyabbc/4SiKmTjrx5RT4ZTj9T0HXF2zP
         rsLCoJJ5PF04ZHvtOCzb5R5acRpzvb1VAbqqFctqbPyeKRFvWPh4tFVCi3twPnk1Xaxp
         MEe6IFe2gyOVb8/uvOhiC+zZcvnyCs60rjcfPYbxQdKTFmLNyc6v5uniJfOwHjlnv4G2
         vCE0hmvFprPJP8otACR9SwJnzTG8RFIHpRkRyfszBBtecW6r7Z/7TvIB8H7WZEmQCkrU
         kamQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fv+FJkb2Lkjik897xvnzRSMdiYDW4XmLvXrISE7YIac=;
        b=ZVLf63x8nJbgmi2HQNV4xLJVRzYHQXMfMjfracQs2xSwPwG4jimkyFOsfC7t4JNcB5
         9hFvlrX/KCO0Af3o5BJfNWPv7k2YhyIvgR7sKMrN30L3ehYghEfFj9jQY3uk37e5YGcY
         X5VySREf2z1zCUXQIfPchb+AgUNVJd14XJ/5s3IsHeLPBhD4o1m6AtgdRiowIJOMK6o0
         bDDZTyMDn53TXD/WHKMr7nwRrK6pXDyPjjKFSpD1a0TXt65X80TjexSBPr1mItqCGsis
         44ddLcbEWWptTRf4ryW73/bzckCrQKEQ61U0SUL/jAG+E9qpThBsOmLamlfAyk8LQLQ1
         mf4Q==
X-Gm-Message-State: AOAM533HmcOrlBLfTEnNXRYNedPxGb/9IIYLV5JgWYHsn0xglU5Z3fOI
        cXV7L8p1+ShDinVZue+J124=
X-Google-Smtp-Source: ABdhPJwPQwxqYhrQ+vuRMfs/VmfesxvrjTpTe1k5QPGQhglpL3G8wjDcRdUL0zTLOeBB9TccOPvvBw==
X-Received: by 2002:a05:6402:7da:: with SMTP id u26mr2408473edy.270.1627535410494;
        Wed, 28 Jul 2021 22:10:10 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:10 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 09/87] trace-cmd list: Show supported compression algorithms
Date:   Thu, 29 Jul 2021 08:08:41 +0300
Message-Id: <20210729050959.12263-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
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

