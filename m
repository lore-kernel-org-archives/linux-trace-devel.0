Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1472FC77B73
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 May 2023 20:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbjEAUcJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 May 2023 16:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232579AbjEAUcI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 May 2023 16:32:08 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E1A1FFD
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 May 2023 13:32:06 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-94f6c285d22so616002566b.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 May 2023 13:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682973125; x=1685565125;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uu4++7Xe7wTeAu/1Ko96Y99YyVYN3adXsS8XZc485Do=;
        b=lJXFlJTIMA3a8f6PKT/ogrn1EYxgrsCdSf7zqa0mq5aeySf2TFMwB/eF9YvbE48jT8
         kJ2Rl1Fqie6VgT8hLBNImjQlnt7obwFo9aKELINwZ6WiyxoGkBGDGQ2aw5dsrX1+jKDt
         FD8fxDgOVSVOmOFpomuxkwJrUE7EtunLmyCCTNMjRCOdFAZte9WB5C0U5FCkQXZWKD0t
         GBYeJojX1EubfhA8cKyiwGAnwoIzTcmlZ7iF7Zz6kv/2gnsxHP2Je7WedWK1FXBsnCh3
         gV+Y+Y2BjLSRnkKsTACJMk8f3FwoVc7+V9/LdlPaDpFxXYAcUChiWiXiI17ZCQ5eKDUZ
         zu5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682973125; x=1685565125;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uu4++7Xe7wTeAu/1Ko96Y99YyVYN3adXsS8XZc485Do=;
        b=VgQgEJUfL5rjSt1lhIvWcCvDXgIuRGMhBLofflGJHLvTxux1UC0VGuQ0eb8YblOsmj
         C+6WOl60YKBy36JHfRNkbR+C06Nl44/7CNM5Ju1ij3kD8Jq2x3i3nJSEfRW6Nb50M5xr
         VPyjy1lCpbQORMUSztJ0jFOkB7TFLbakr3P+D9T40Xew2bERJxYTV57AJ3+0RuwQLEZd
         sodsbnJHh5PKGdAkg5bVgs3DwVT78gn9zBanNGHrZnfzdGj/8bTrBN3VIh+lLG2esXDT
         T0pyM5cp2iFTJvZdltUCHkruSvr8yCn53WWm3QBxVU3zRsU4aXO3/9asUFEQ8W09HCCW
         CXEQ==
X-Gm-Message-State: AC+VfDyqM40GMfYtzMiWUu1+ZzCckViw0qzChsX4EC1oYGgBK/t8i0r0
        66wkQz72eOeeuArRJzgTh56ZajBLtkU=
X-Google-Smtp-Source: ACHHUZ4YtnFU4NqSy6oUbfxF8zSc9EBOtRSklpW9SyhwoVbkpHhkIUflBxLr8itMN2bEBEVROKNKHA==
X-Received: by 2002:a17:907:3d94:b0:947:72bd:f72a with SMTP id he20-20020a1709073d9400b0094772bdf72amr16224971ejc.72.1682973125208;
        Mon, 01 May 2023 13:32:05 -0700 (PDT)
Received: from dante731.cslcs.technion.ac.il ([132.68.206.91])
        by smtp.gmail.com with ESMTPSA id i25-20020a170906851900b0094f1b8901e1sm15233933ejx.68.2023.05.01.13.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 May 2023 13:32:05 -0700 (PDT)
From:   avidanborisov@gmail.com
To:     linux-trace-devel@vger.kernel.org
Cc:     Avidan Borisov <avidanborisov@gmail.com>
Subject: [PATCH 2/3] trace-cmd: export pidfile functions from trace-listen.c
Date:   Mon,  1 May 2023 23:31:17 +0300
Message-Id: <20230501203118.3105605-3-avidanborisov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230501203118.3105605-1-avidanborisov@gmail.com>
References: <20230501203118.3105605-1-avidanborisov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Avidan Borisov <avidanborisov@gmail.com>

trace-listen.c has some utility functions for creating and removing
pidfiles, to avoid code duplication we make those functions generic
and export them to the rest of the codebase.

Signed-off-by: Avidan Borisov <avidanborisov@gmail.com>
---
 tracecmd/include/trace-local.h |  4 ++++
 tracecmd/trace-listen.c        | 32 ++++++++++++++------------------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index ae208fb..73e93dc 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -457,4 +457,8 @@ static inline bool is_digits(const char *s)
 
 bool trace_tsc2nsec_is_supported(void);
 
+void make_pid_name(char *buf, const char *pidfile_basename);
+void remove_pid_file(const char *pidfile_basename);
+void make_pid_file(const char *pidfile_basename);
+
 #endif /* __TRACE_LOCAL_H */
diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index e95c571..5894a92 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -34,6 +34,8 @@
 
 #define VAR_RUN_DIR		VAR_DIR_Q(VAR_DIR) "/run"
 
+#define LISTEN_PIDFILE		"trace-cmd-net.pid"
+
 static char *default_output_dir = ".";
 static char *output_dir;
 static char *default_output_file = "trace";
@@ -52,7 +54,8 @@ static bool done;
 #define pdie(fmt, ...)					\
 	do {						\
 		tracecmd_plog_error(fmt, ##__VA_ARGS__);\
-		remove_pid_file();			\
+		if (do_daemon)				\
+			remove_pid_file(LISTEN_PIDFILE);\
 		exit(-1);				\
 	} while (0)
 
@@ -126,21 +129,16 @@ static void finish(int sig)
 	done = true;
 }
 
-static void make_pid_name(int mode, char *buf)
+void make_pid_name(char *buf, const char *pidfile_basename)
 {
-	snprintf(buf, PATH_MAX, VAR_RUN_DIR "/trace-cmd-net.pid");
+	snprintf(buf, PATH_MAX, VAR_RUN_DIR "/%s", pidfile_basename);
 }
 
-static void remove_pid_file(void)
+void remove_pid_file(const char *pidfile_basename)
 {
 	char buf[PATH_MAX];
-	int mode = do_daemon;
-
-	if (!do_daemon)
-		return;
-
-	make_pid_name(mode, buf);
 
+	make_pid_name(buf, pidfile_basename);
 	unlink(buf);
 }
 
@@ -991,16 +989,12 @@ static void do_accept_loop(int sfd)
 	clean_up();
 }
 
-static void make_pid_file(void)
+void make_pid_file(const char *pidfile_basename)
 {
 	char buf[PATH_MAX];
-	int mode = do_daemon;
 	int fd;
 
-	if (!do_daemon)
-		return;
-
-	make_pid_name(mode, buf);
+	make_pid_name(buf, pidfile_basename);
 
 	fd = open(buf, O_WRONLY | O_CREAT | O_TRUNC, 0644);
 	if (fd < 0) {
@@ -1075,7 +1069,8 @@ static void do_listen(char *port)
 	if (!tracecmd_get_debug())
 		signal_setup(SIGCHLD, sigstub);
 
-	make_pid_file();
+	if (do_daemon)
+		make_pid_file(LISTEN_PIDFILE);
 
 	if (use_vsock)
 		sfd = get_vsock(port);
@@ -1090,7 +1085,8 @@ static void do_listen(char *port)
 
 	kill_clients();
 
-	remove_pid_file();
+	if (do_daemon)
+		remove_pid_file(LISTEN_PIDFILE);
 }
 
 static void start_daemon(void)
-- 
2.25.1

