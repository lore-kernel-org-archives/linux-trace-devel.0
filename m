Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28C8AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14CA9610CE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237743AbhJHEYc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbhJHEYb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:24:31 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4EBEC061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:22:36 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id d9so7380431edh.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cGVmGD9Qf7kvIF9D5l30TnsDDlX1yRgwYMIHptNl3Bo=;
        b=S9kNfKdEtFktYBRt7XYN2HCvseOpo0b2E9fjbHNGVRElxzn+QafoUlnwXlkCotsUmp
         5jTP51UasxrvMUI/jiYifV/7hEJCazJpcBW2lBX/rIMGbztgQhj1N0XQ/WWlYZ8BAMHK
         CJLTa3zJpC/frmHnH0glDmOk5+SnPYdtOetLtDsEfo2/xLl1ySAv/ZpF9/JOmUHm6g0y
         PdRRJCuAKoIojhT0pyFkwxb0IgEHx5XGFKO0wy3vYXeGmU9JBIhscgCaQ6fpiQETDckB
         mlxeVGketcNcNqQHOXdB764UI+Ni60ziyQjs41TFNiupMRoxfDcHt5Alkcbcfr/amFSI
         ea7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cGVmGD9Qf7kvIF9D5l30TnsDDlX1yRgwYMIHptNl3Bo=;
        b=J8NvGYIavmrN1+bw1ILeRetn2GUo4mkbW2vgsw47Nj4QvUxTIRZmEfGLUke7++Wioe
         tKHzriVG3z1+faEyZC7q1dyyZf6Z9bf8x+bREFK3Cs0MCSmr+SOOd4nNYHjt1PiDSQ7m
         /62hmB7qJqF3xXWl/wWPRAzkfgW433sGnTsbxtIowiH58+3JtE5wMsB7x8g/QV0eTlwo
         HM1QuZM+GbCrjyomvX/KFSqA3GEIhH42jZ8XzkKyBWeu1pwfOUmxpL/+piCKh09tTzCT
         3VXGgORkXHelQ//ET+BR7YBSTrbO+uKns+3BPP+i264ptoMT/OFBEdgFL56S12RsCi9W
         4FYA==
X-Gm-Message-State: AOAM531pWEaZ0EBeQcDywaIU7lHwy5k2bhxjHs+Icj9f5PflJSj2v7Sq
        z178G8qc9b2krMmeg9+Z5+lv/bkdF53uNg==
X-Google-Smtp-Source: ABdhPJy1G2Ma5dUxiNpdJ+u+fGEMCCu4f2bviPZiwTgV/7G3mWeiAlBVLw5Qd4qXlginGaAR1EA2IQ==
X-Received: by 2002:a17:906:16d0:: with SMTP id t16mr1268252ejd.199.1633666955492;
        Thu, 07 Oct 2021 21:22:35 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g23sm517429edt.1.2021.10.07.21.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:22:35 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 18/20] trace-cmd list: Show supported compression algorithms
Date:   Fri,  8 Oct 2021 07:22:12 +0300
Message-Id: <20211008042214.977193-19-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042214.977193-1-tz.stoyanov@gmail.com>
References: <20211008042214.977193-1-tz.stoyanov@gmail.com>
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

