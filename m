Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC720C43217
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235759AbhLBM2v (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:28:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236179AbhLBM2u (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:28:50 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A481C061757
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:25:27 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id e3so115373796edu.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0vF4/kyI9N2FIR8o+/109ZpzkBALfqAJzj8PQ0/ofkw=;
        b=I6dnLkN8VJnk12F+IXz2Bkoq4y5k3rt5be/pIGkAnhHTKw8Yrwr0S5tzc3kcYOFn1l
         +WkGjZkutNerF5ii+BXJcymZpoU9aVc080vDS3oS7IWaWhsJxhVs+zY8paU8E+mipVt0
         m0fjv1aIUuRqxnh30WB9oAi3evVnEq6jG0+j1nsCnpxBuAAXD2VS5t/klbPvaHHqW7jY
         8iIKrrobHqFo7pnU4tG7CveZTZe2XwKVbJC+k7er5Bt/SfjGKlB99U3Ot1yFYI4Lvfmb
         DhqJvTSny0uR7xecjweyBwNyu3eRhyQZBIMuGj7e6qf27+1D3s7bu1e+iUBuIw/ACnRi
         SddA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0vF4/kyI9N2FIR8o+/109ZpzkBALfqAJzj8PQ0/ofkw=;
        b=4Kk5D2CcQDpgbPFQd4Iy/aPXuikY3jWmqnSy6tq+TWw2xRuPq6PDebsXdNXc8OK5uE
         P1pJlH+ZmE83R2snw+DsLeBV3uIesuC3o4wpapbeKtc6mGRyH9FCTos9761+Y1lY6m56
         HtPXdlZmk9krnjiiALVc4L3fvBY7sVrmpyEe0FiGu/2CwUBazgwjosiw6j5LH1AzUUjL
         V9HDMfQBC/strPCENbmbwqvsfQjW9xNoKLYSOut0eaX5dKEew8BI0Vaq4BasS/EUM+ud
         YdkhIr0Ojga1QuO82eowrwUp8Q+eugzUfqZYLSzZmT3t4R1Anq9HVaJ2skItU2r0O9Oz
         HolQ==
X-Gm-Message-State: AOAM530yKfjir2wHoEEnNH7C2BOqEMYENHP/YfnAuBXKdPU0+mCZBrqb
        p04G0KWMkeQKL2+/dYqNFfuAMQW4Z40PjA==
X-Google-Smtp-Source: ABdhPJwZWpuH0YUEQIZZkvRQ56QMOb+xAjzOwMviNn4tZOGsc8COewrcca4oNeNyqGs/xrEzl8I3wg==
X-Received: by 2002:aa7:c406:: with SMTP id j6mr17883156edq.76.1638447926115;
        Thu, 02 Dec 2021 04:25:26 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id eg8sm1998507edb.75.2021.12.02.04.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:25:25 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 18/20] trace-cmd list: Show supported compression algorithms
Date:   Thu,  2 Dec 2021 14:25:05 +0200
Message-Id: <20211202122507.43572-19-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122507.43572-1-tz.stoyanov@gmail.com>
References: <20211202122507.43572-1-tz.stoyanov@gmail.com>
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

