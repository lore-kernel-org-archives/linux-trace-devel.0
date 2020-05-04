Return-Path: <SRS0=47nt=6S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D55ACC3A5A9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 08:07:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B389C21655
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 08:07:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ay4MxUsF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgEDIHB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 May 2020 04:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728037AbgEDIHB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 May 2020 04:07:01 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559CDC061A0E
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 May 2020 01:06:59 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id y4so8709994ljn.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 May 2020 01:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=54kqlyiEHU3saXdXJWDUYlIeqajHtDZEJ7PXfnW9Atc=;
        b=ay4MxUsFiXODjEngfiOuF3KAmq1m9pfhNBQ9z0Ljs0AqN7/FVtY4qNpT64JoUWsZ/h
         cNrbYpbvs8aBl2aTpCMbmdLZPHUv+HwlfH9UrwsJocVJkRKDaxHd8R+7cVDBAD4hNgOy
         1+I1lEFaCltf+1Wc8GM83mOWOPOo3dZ64UZ9elcWuHGdQmQYfMsGuO3ZJHKZIbJViaP4
         Y2p583Ry5d4j2xyI2O3EOJNQ8iPAjGTzakkhnGfesOU4ZPUrpKrHE3+6JhWHIr5SwE9n
         vVQzByQ25h4OkzMsQS4zYTzhUCQKZjCDI+b6zyNuiyy4RawlNTXKThRusj2H2uwOPwKx
         vu1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=54kqlyiEHU3saXdXJWDUYlIeqajHtDZEJ7PXfnW9Atc=;
        b=Ciod4wowNiugv/RSJXKXjZJEWNFmyc71Kvl3qFZqJ/b8Mm2/ZoQqi4iQdPxX0dkooS
         tA5sovfbbwFoomE/3p4LJ/Ft7Xxczp5+oWCcp7HqjNvfCl1eKJYxq36xDhxVzRMXeRqk
         vo+sJwBJNUYsKCd7Jh9FRJRN4C1AdcWqxa4sKToKCoiJE8jnUpR4Yxy5tW57PQ7JG/kE
         rW1sgwCS3p8LwvqNus3oyhr4gM41AyQg3vaqa0x8GA0B6oqLdbHhr+EGbh5CwwtjsHr8
         G0hCCLn1g34wYhASRQkyews1iAodPM6In6qT0eSEl4JWqam+2BaGlzn7dB1OHdTda0Q7
         53pQ==
X-Gm-Message-State: AGi0PuZ8cCW73ubVXJTbTkQcM6boztSjDaHsbro88AdXkytECoRfoRMy
        YifP0l2e8FIxC010B/vDlHNGBEhm0Qg=
X-Google-Smtp-Source: APiQypL71srQ6ip3ZeYTHiLS6/kcOs7y/xWrVUbDjmWqXHvg0aiagbaaAnTRs1dar3SZdWluGAJTCg==
X-Received: by 2002:a2e:6a08:: with SMTP id f8mr10021904ljc.8.1588579617830;
        Mon, 04 May 2020 01:06:57 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r20sm7580115ljj.44.2020.05.04.01.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 01:06:57 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Add option "-s" to list subcommand, to display available event systems
Date:   Mon,  4 May 2020 11:06:55 +0300
Message-Id: <20200504080655.115448-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Extend "trace-cmd list" command to show available event systems. Printing
the systems is triggered by the "-s" flag, or if no flags are
specified (part of "show all" output).

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=207485
Reported-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-list.c | 47 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index f046304d..c9abcd73 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -5,6 +5,7 @@
  */
 
 #include <stdlib.h>
+#include <sys/stat.h>
 
 #include "tracefs.h"
 #include "trace-local.h"
@@ -306,6 +307,42 @@ static void show_buffers(void)
 }
 
 
+static void show_systems(void)
+{
+	struct dirent *dent;
+	char *path;
+	DIR *dir;
+
+	path = tracefs_get_tracing_file("events");
+	dir = opendir(path);
+
+	if (!dir)
+		die("Can not read events directory");
+
+	while ((dent = readdir(dir))) {
+		const char *name = dent->d_name;
+		struct stat st;
+		char *spath;
+		int ret;
+
+		if (strcmp(name, ".") == 0 ||
+		    strcmp(name, "..") == 0)
+			continue;
+
+		if (asprintf(&spath, "%s/%s", path, name) < 0)
+			continue;
+		ret = stat(spath, &st);
+		if (!ret && S_ISDIR(st.st_mode))
+			printf("%s\n", name);
+
+		free(spath);
+	}
+
+	printf("\n");
+	closedir(dir);
+	tracefs_put_tracing_file(path);
+}
+
 static void show_plugin_options(void)
 {
 	struct tep_handle *pevent;
@@ -366,6 +403,7 @@ void trace_list(int argc, char **argv)
 	int plug = 0;
 	int plug_op = 0;
 	int flags = 0;
+	int systems = 0;
 	int show_all = 1;
 	int i;
 	const char *arg;
@@ -427,6 +465,10 @@ void trace_list(int argc, char **argv)
 				funcre = arg;
 				show_all = 0;
 				break;
+			case 's':
+				systems = 1;
+				show_all = 0;
+				break;
 			case '-':
 				if (strcmp(argv[i], "--debug") == 0) {
 					tracecmd_set_debug(true);
@@ -465,8 +507,11 @@ void trace_list(int argc, char **argv)
 
 	if (clocks)
 		show_clocks();
-
+	if (systems)
+		show_systems();
 	if (show_all) {
+		printf("event systems:\n");
+		show_systems();
 		printf("events:\n");
 		show_events(NULL, 0);
 		printf("\ntracers:\n");
-- 
2.26.2

