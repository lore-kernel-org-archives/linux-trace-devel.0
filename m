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
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED966C48BE5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9D7A61407
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbhFJLhg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:37:36 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:36488 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbhFJLhd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:37:33 -0400
Received: by mail-wr1-f52.google.com with SMTP id e11so1926592wrg.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3KFLzzFKc9m2UFTOpsVh7cbeeh2hvHNTp1bJlNMgn90=;
        b=IfXUuzeMNAroZ4dTXClLoMygDvMlZnwlkh/WlToZdviFhdElw38iTPRNBIEyzFEoSR
         kUZ8ukG8lE6/RFPihTmrQrXTAhI4et+/GEsQwO0FNLu/NSpGNZMI+9cLkO1omZps7Aan
         3zSMgW0e8mTPF0iyySeeQLqXv1RhBjIB7CM3RR3Tem3gfxFFb95/PAxOvP0sTJr3AUOX
         SwRGosq09HKu2OzvmE2OOMzzyIf1KauBKFTPq5BkwQATxWIfnMTMVzJdoq9Qx1b+ed8W
         LBlbHzx/d1BLEJ/qLWRoZovPpdY7noIh7ZlVs0+bsAuCDMBc3DhUCUR6CkESOsXqWfDU
         YLBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3KFLzzFKc9m2UFTOpsVh7cbeeh2hvHNTp1bJlNMgn90=;
        b=HooGA80CsOR0AuxflkP+qxCxcqQP4m4on2ZLlFXd1TJpNuAYNmpAhOdSE8iLQnpwjh
         Xn/p1en6Cp9HpVt7kp4LW1PqqBtUvTLcdZJbmXjM88zAeeJz8R17/5P0xhGpW1dSniTp
         VsAtit3w2N2V/vMuA/UUCVhmKwDHtTFSUy4t7WsGoxfrLTIkEx3CXaFv5wajkeKHhkbZ
         Ec6nSZCJ/zFu6Lh86IYkUObwLDiSkRZhdEzqTv6P67xlyZ1MQTsCiYjMK+dIHfwZE+1/
         WC4Aef/KklBj+mZu4BZgjUhlUASSh6gtlAbk+52DalzetZEY1TTC4iMzIbEOnztUgtGA
         JXUg==
X-Gm-Message-State: AOAM532uJ0E1QhlmJVBeKXqvqxaqBcCZ2UqfjYjd3qjmAp9cE2YGBoHa
        jghpcfhk8oXQzKtsV5j//kgdq7nodj+rHQ==
X-Google-Smtp-Source: ABdhPJwQsfCUWsWa+ygExLm9yqsvc7p3JcNdIqpB4oOYDMf2d5E2V/ygP9cvr0fGQ0xNcabsCUyfJw==
X-Received: by 2002:a05:6000:2ce:: with SMTP id o14mr5000448wry.145.1623324876548;
        Thu, 10 Jun 2021 04:34:36 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:34:36 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 08/40] trace-cmd list: Show supported compression algorithms
Date:   Thu, 10 Jun 2021 14:33:54 +0300
Message-Id: <20210610113426.257931-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
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

