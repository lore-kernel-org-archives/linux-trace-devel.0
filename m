Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E890C63682
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239390AbiAZJtg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:49:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239410AbiAZJte (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:49:34 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CCCC061749
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:34 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id me13so37822334ejb.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v4D+2uCZ7+pjLxy4nudPTs1AVxRDbpF5rZR3iadjTKE=;
        b=EUvkEE22rzqJqgaUqhcGBmWM70/UihUGYV/gxg8v1c6x7GxX/9RqB2QhgOsCPjlGjL
         auGiPdL954JLsgEXyo68Y7QOoZiORE2bg3RiN4kVgQpK889d15VZJylySAflnnCaydxm
         tj9DydI1SiyAbeXOnwR7KuSxzUSB1/vyW6CrkF4DMpfM2QKPApj3RzEK06b7R8lk+Bsz
         FNUzcamZFjxoegiwfSEReJy8toSSVjdQMo7FVnB5n4pR59f8mQ8/U+28vIHRbEXGMjaE
         WJ1Y/ryIrpBdgNZkJnrCLmjozJOSLTBTlnv21F4sgcjr8i96WqfQJTkotRk13U0zRpNk
         dfKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v4D+2uCZ7+pjLxy4nudPTs1AVxRDbpF5rZR3iadjTKE=;
        b=Y9tK93/LQD95up4J/txvzwmfnKiDNDDZ5rWVvp/tHgcMcr7dymS4o70LrvS4M5dW2v
         wUvh3iEzL49NlGGWciJriWNu9YxC4161L2TBB1vS8SDXW9w2rl1Tfsws9Z9h0+0dFSIl
         XVGgzwve2eX3LbwW15296Voqsj/+NNd1srMBSZlbF3un0wbAwuY9va/ROhWFgdN6yyd6
         m4eoulI6vI5EV1g4FCqjCjSW9JJFnv9dHRmtjfePqIFd2D/OchFLT7YORsHsNaxwe17x
         NczqZPJ8oP8fReTkR3VaYMRgFCCoQ/GY+4xSIyXmNnoIZAw4Q76tLngZyH1tFegpUSvW
         6m9w==
X-Gm-Message-State: AOAM530fYNU8LZ3L5AzKpZ6E29qGAhOPn1Qgeq/NisVRs5x/BV4tXpTd
        OHzGWs2cFcD87DqZFwUpcQGvl/wzwO4=
X-Google-Smtp-Source: ABdhPJw7pVLlafonT4v3noJCO7T3en59fiq92XFNGpFmmrfhpM/3vWWicq72a+4NIMKzTN2m47R2hg==
X-Received: by 2002:a17:906:3089:: with SMTP id 9mr19286036ejv.97.1643190573207;
        Wed, 26 Jan 2022 01:49:33 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id e17sm7119155eje.218.2022.01.26.01.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:49:32 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 18/20] trace-cmd list: Show supported compression algorithms
Date:   Wed, 26 Jan 2022 11:49:04 +0200
Message-Id: <20220126094906.570451-19-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126094906.570451-1-tz.stoyanov@gmail.com>
References: <20220126094906.570451-1-tz.stoyanov@gmail.com>
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

