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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A03AC49360
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E2FC61352
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:50:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbhFNHwo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbhFNHwn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:52:43 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D4B9C061767
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:50:41 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id ce15so15023277ejb.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3KFLzzFKc9m2UFTOpsVh7cbeeh2hvHNTp1bJlNMgn90=;
        b=E2dFiMh6DNYbyVIK563rxIvBJU7uJtlOIKAkFi5brRsyrpeZadcVvOb24HtBqgpEW6
         fkd9sBgdYlzFk8m0uIb77XhelAwYJ+DuXf8qbqLYSQFOzs9eBlPyXPf6aUXZG2SyVPYI
         tMImgyrbM+Ir8BDk7CAbDa+gnXqqOaGOM2YwyGkhrwz5AMD1Cm6zzsjzbxcokOvzau3T
         Koourv1Cx0vvWyYxAt886LjA0REhLqSraKk9S1RDTO6NOeYo1L6ZHVJIhRs2e2NaAsyf
         QfRv+sVrPNId3A4iWX3EDlG4IqnPvYkWzxaLD9tqyHdU9indKOBanQ8FHhQApU4Vn8IW
         7nHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3KFLzzFKc9m2UFTOpsVh7cbeeh2hvHNTp1bJlNMgn90=;
        b=lep6P4uoBI3tQXAxczoJEqQ1385LSf0xmGv7OS6HOUe69l6IOBF8Xyi2GUMmMgEEyH
         7djXirtCFGpN/kSukBSPdD1T8JGbaVkUYny4+2fXLiIG66teA75UfqLq4g/sHeOUS25D
         pVLeCAbx1yQ6id1qsdEFC22dQ5k7n+H/PS10YmEWVNqa8AZrOgMBkWlfv9pCeql8T6n7
         ZCgc6t5facOcEqIWBxGwV/y4IS3IB/IrfQsNEJN5E41aeNvfJz4+WlkjVNxOevEeoceY
         BfPg/a7vg2Tp9zu3RoH1Jj0VqNCfdJjmItrIdcP3cSk4tqktfCLCCZ5DDaTA6/S39djw
         XsEA==
X-Gm-Message-State: AOAM533Nm5x+DBJ7iwG4ouFhRPDIUfzgaouWhMqXqgkw6ii2/l9dq2SA
        XDVzzuX6oZj3qQ51gYfGd5aUnF2Eo74kxQ==
X-Google-Smtp-Source: ABdhPJzThOnSkCcGBbKmjEVOHRBhOGQkjZtJLtJ7GJw6kZWpaJ4L2t2/XT5tDGq163jxBip40J5FDA==
X-Received: by 2002:a17:906:6dc3:: with SMTP id j3mr14265692ejt.448.1623657039817;
        Mon, 14 Jun 2021 00:50:39 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:50:39 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 08/45] trace-cmd list: Show supported compression algorithms
Date:   Mon, 14 Jun 2021 10:49:52 +0300
Message-Id: <20210614075029.598048-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
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
index c0033ce8..cd8ca391 100644
--- a/tracecmd/trace-usage.c
+++ b/tracecmd/trace-usage.c
@@ -331,6 +331,7 @@ static struct usage_help usage_help[] = {
 		"          -O list plugin options\n"
 		"          -B list defined buffer instances\n"
 		"          -C list the defined clocks (and active one)\n"
+		"          -c list the supported trace file compression algorithms\n"
 	},
 	{
 		"restore",
-- 
2.31.1

