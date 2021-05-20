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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A811C433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B6AC611AB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhETDVe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 May 2021 23:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbhETDVd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 May 2021 23:21:33 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14098C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:13 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id i7so5122398ejc.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L4cIrri7H50G2QgorkNc4Lv9OxhhIH4oM+gSM061M5w=;
        b=dwilI5zfe+DRCahxffccEXZ63u3XCRnUVbs5aiL6vrh8prH3m3rRhkTmITD1LYEyw7
         HOTwniOMR0zAliKuzqCNybS22frgNznbyN+E8VdUgsgdXK4Fk0yQapyNRBW/XlbMa71V
         idX47P6MFv20mOJPsqLIMBjZC3YriWccUyvtQ4ov1+C6EK+7T1AeA9QOiV9eRjeBNpv9
         PuxDwbgimPhIUCpRop3xuAUOccaRi67VdmPyHuh+tcDQRG3BVBbMuyLWqjyCFSgYvTOr
         yds+0vOWLZJBGr78MG6SOy9Vlw69mK+gVryh0Wzhh8GSFQbtxFwUDx834/t9rubPosbq
         hW7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L4cIrri7H50G2QgorkNc4Lv9OxhhIH4oM+gSM061M5w=;
        b=YuzdIEw886r2v2ZlRJMG/qqf5M+08n/fZF4QXqi/KterikrJ9L/NrA/b0VVfx56Sry
         8sWWJoO4DpF/Wsx7VtWTRCVAdv1xL8LjDYFovLUxHjjlVZsyCPC6AY+A5yO5G5t0vsaq
         KNJNiLbCK0KIHgw/Cv+Uqtki/rNgD6r9X/D4JPfuS/2mufLdaffFzYcy1lXqJJHyKyaE
         k895iyB8ZPzj76Xsoc0o51q4WUIFwh4Ty9Qz+HbI2v3FvxXNnis1yVQhVpZhlGLJTlaO
         L3dylZhiyPVLGVIehWmGMITP6gOF825qr1cMQvVPh3CNSsW/xHoS7/MOM8Dn+lRS88A0
         H+TA==
X-Gm-Message-State: AOAM532UOr9jLhWypRm2qJx18M6ajtpXKkbqcaWMBQRJFCVAlFvdmXTb
        KXtraudL/d6ZF/GRbJH47Y0=
X-Google-Smtp-Source: ABdhPJyYp1m2Hayn9M94CH379YdlJkLpg6XvOnDIH6mPRvyJdndoB+gDp0doN8rbMr5B+YXZz60ENA==
X-Received: by 2002:a17:907:105e:: with SMTP id oy30mr2441566ejb.258.1621480811653;
        Wed, 19 May 2021 20:20:11 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f5sm763280eds.55.2021.05.19.20.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 20:20:10 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 08/29] trace-cmd list: Show supported compression algorithms
Date:   Thu, 20 May 2021 06:19:38 +0300
Message-Id: <20210520031959.346165-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520031959.346165-1-tz.stoyanov@gmail.com>
References: <20210520031959.346165-1-tz.stoyanov@gmail.com>
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

