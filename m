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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FE2CC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1886560FC0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:42:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240009AbhIMMnj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239992AbhIMMni (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:43:38 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D824C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:42:22 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id m9so14501516wrb.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cGVmGD9Qf7kvIF9D5l30TnsDDlX1yRgwYMIHptNl3Bo=;
        b=nGq71YQ2Gpgv88+qbEVM6uj7kxpDaV3N7NTiuied0/zwe7N4nljtFC6MSoT/XpQe1M
         zIUo2HtVsGklEW313HJ5nyCxryPj3AtdAXsp7yIn+a+s3JIDPXN9b8W1rBvnOGMAegqa
         JsBGKll6mawjAM34A9cNCYytltmfpJ348yLkdWo3FaL5b98zVEUPG0XoGdb3V+eGbEbB
         ulORWPi48bujDYAGbDIxCTpXZDmw1aBlA+P2lDTPfOzCUkWmf5iEuFCyrzCzLFeqNZlk
         30WLMkMVdBUixssjHxtq+BzZv8Bsp4nBt685zDMfa52cJo+q8NTDyrWWfpT/CEibbCwN
         ACRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cGVmGD9Qf7kvIF9D5l30TnsDDlX1yRgwYMIHptNl3Bo=;
        b=XUo3WaI+ZXYuxbGCEsDnnsDYgvieKZ5mW4x2l8HKBAy5Mma8VloJtNL6HQtQd6WAnc
         94W4RD9CvdNnFsaLK4eIwpQ6VgOywv9JvUSFOvKATbY04Ps0VodYuOrXUIuVUu8oLd7j
         XZano71u8OAWP0wI2OubmaZXhsQHCJWrxXwZz1hFqt5uGb7OhUV6DDFhaDRPZIoVEbzZ
         DV/R1gV4VAH1bDyFeXCr1OhOAkYcGWI9dpQZUNnnAdNAdcrx4V02xghv11KHilp6gZ+f
         3bWKo4lvgjJHfKrxGmy9TYdGDe6i/l5dYVh6PSK0eCBVqgPg16+n55ti1EhY5SpCIQNF
         aoMA==
X-Gm-Message-State: AOAM532xthhaQLhCSlCaMxnQxr7RA5LacpMKv2PaGl1To/6nuS8D9T4z
        iaiYs8OswBO3GTPMAkYVDccnae0axNA=
X-Google-Smtp-Source: ABdhPJyT/sgR4If5u0Ebhx59TyhgIGIXxTkVuIE9Gv4D21mYa4tCGLk3Ds0lFJu49ZsqRQyjsPZbrg==
X-Received: by 2002:adf:80eb:: with SMTP id 98mr12353567wrl.370.1631536940996;
        Mon, 13 Sep 2021 05:42:20 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u13sm7244290wrt.41.2021.09.13.05.42.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:42:20 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 18/20] trace-cmd list: Show supported compression algorithms
Date:   Mon, 13 Sep 2021 15:42:01 +0300
Message-Id: <20210913124203.3677760-19-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913124203.3677760-1-tz.stoyanov@gmail.com>
References: <20210913124203.3677760-1-tz.stoyanov@gmail.com>
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

