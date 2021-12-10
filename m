Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE03C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 11:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240153AbhLJLDe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237285AbhLJLDb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:03:31 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A924FC061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:56 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id g14so27968725edb.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0vF4/kyI9N2FIR8o+/109ZpzkBALfqAJzj8PQ0/ofkw=;
        b=fyxqnbEGrNQrt+x4t99u5eleWrZpyMmtWorYBK92/UcinfbLp70pdtrNGwoSHyd3l+
         LdCVabI496q57DVFxGy72QoadyV20nODL6rlalkqoxE3pvuI/TqovRUk0DqUOQw9qksz
         bBLb2KO++MNGJKgq4ZQfdWrwueis7eG4PsTZTD4WQSBcFkkTzvg7N1brgsXnZL5YX0qF
         Jl8KRxArJov7p7mBNVlaitv68kMEEy/jDczSWL/2kOPAHq6WOacdT6oGKMOxbTu9LSXH
         FVyIDjbFkgGfYfdEaXyCgmVFzfE4g4BdyDS+ucoIrYOiQjlDJbGr5DSYgiVlDv7R2O0g
         dDkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0vF4/kyI9N2FIR8o+/109ZpzkBALfqAJzj8PQ0/ofkw=;
        b=oLQxwheAuacryk8zkXhOgIIqZeYd/rQxD4130fjXWp7v5QVL3k/cy9dIohWrchm+IA
         h/o3nBGGtrp2yKNhB2niEtQC8w+qppBcVTYDf3sjUGpZmSpWvBmZy98nsFxwkjNtIqSN
         nnJgkb2YnzXQBP/fleVMR5IvuUbgzVCnuXUhUPaMmzFcYvN6t7uuPgXxwOQZeONSZ7Wn
         zf5zsdGBCRBMAPaXqgTwOk2s37JPWQM1siYYOnNGibknUDkgoARvHgjbVHcU4KUQjdXz
         uPdEOoE/3kcixllBtJarH0TW6tXjxj/AvDU3sIcRa4pZqO5q0s0zjYbsRPGg4qXBT2WK
         pL/w==
X-Gm-Message-State: AOAM53333uaIpp1KW2zzcQIuQZB7WLN6OqOtfUor5j5k8iGe1OvlO7Dj
        Bw4o4coJJlGp72Hvu8pCSzhXnms0tRQ=
X-Google-Smtp-Source: ABdhPJxsEouga/CX+FRcq4EscL7aHGvvlOD7TmvSvbvoSqXwMvEvOmDNYI31RyvFtFZjcTaHP9sQbg==
X-Received: by 2002:a05:6402:2551:: with SMTP id l17mr38067339edb.142.1639133995187;
        Fri, 10 Dec 2021 02:59:55 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j17sm1320379edj.0.2021.12.10.02.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:59:54 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 18/20] trace-cmd list: Show supported compression algorithms
Date:   Fri, 10 Dec 2021 12:59:36 +0200
Message-Id: <20211210105938.98250-19-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105938.98250-1-tz.stoyanov@gmail.com>
References: <20211210105938.98250-1-tz.stoyanov@gmail.com>
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
2.33.1

