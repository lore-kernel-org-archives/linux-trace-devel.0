Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40D80EB64D7
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Jun 2023 09:20:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjFZJUQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Jun 2023 05:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjFZJTe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Jun 2023 05:19:34 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F8A2D77
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Jun 2023 02:16:58 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-987341238aeso364183866b.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Jun 2023 02:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687771016; x=1690363016;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=43aJdWgXMNMLJqR8pernzt03otstqW01zHTf041szd8=;
        b=ZWtQjA+XiVaiw8LwY5XLxpTUgjl9mJtZ4Epwdvke02ZqQcMU+RhqfS5Xv9r7UplPyV
         P9fWn9iCXcTT+r3YMo8R8Ea7GTYRjC5ARBWI3kfCWZBDeyKr7FxSuDm87nftcLcXZepY
         i13A5icUe7Id/bjr452WMcbZt5h6Q9JGbxvQfwCL9tV5Xt/QMdPNh/8acUy5cr6jtKkh
         7LyNImIpUmLR3qbPAMMqQsuRk15n5ynamv7gOG7ZzTkC2eqUvL4EnVs4NqN41IKwzWn5
         q09bcPYwzF4h19cgDooG1EcrpV/OcRoiOZiIWffGZEiaXcegsDue7IggTzC6UlxLSf0B
         X2Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687771016; x=1690363016;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=43aJdWgXMNMLJqR8pernzt03otstqW01zHTf041szd8=;
        b=FhOXaIyJo0JYl3ol6nn4E0vhQHs5ZLDXYCLQJstMWDlkUt0RIjyJ9prLiy/XAytXeo
         aaxGS2iBI9hrti67QexALM6awc2tIwPsnYZv9j7UA6ASMiJThVD6Dlso9TWsXtvKn393
         +OkrHhckX09i68iyZtsewMmTOTRe9G72zzm8Jl+XOz+OBA1U4ONOVLDI5K2MsqEIOY5J
         B7JsRs8/mAVyL5Y+Qxe308VhQTZftZsSiYK3jUHG3ZR+SmgHq8k5/tOEuCvjyt0Fb0v8
         ucwbPsFYjTpCPbX/3sjQy/RYOhkybmMZhiqB5QgL94d6mNNqmaD5wUiJ1xZVsqrRzGdP
         Z1aw==
X-Gm-Message-State: AC+VfDxzWgrQa3f2w7UX9rDPTwKG+Cj6XBT+VUTufWZ7AAMCDnIph1sK
        VcRvoUELVa+VPg3tr6qXazTX6JXmyEi7vQ==
X-Google-Smtp-Source: ACHHUZ4NXaiCwerbuwywLhtpc3CzIMRtlHZ79UvjZkJJ4bIReo+Tk6dZQnY3UasK63Y+Al9dptNQuQ==
X-Received: by 2002:a17:907:72c3:b0:988:cb57:f741 with SMTP id du3-20020a17090772c300b00988cb57f741mr16765134ejc.54.1687771016464;
        Mon, 26 Jun 2023 02:16:56 -0700 (PDT)
Received: from dante731.cslcs.technion.ac.il ([132.68.206.91])
        by smtp.gmail.com with ESMTPSA id lc1-20020a170906f90100b00988e953a586sm3061414ejb.61.2023.06.26.02.16.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jun 2023 02:16:56 -0700 (PDT)
From:   avidanborisov@gmail.com
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, avidanborisov@gmail.com
Subject: [PATCH v2 2/4] trace-cmd: export pidfile functions from trace-listen.c
Date:   Mon, 26 Jun 2023 12:16:33 +0300
Message-Id: <20230626091635.3002827-3-avidanborisov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230626091635.3002827-1-avidanborisov@gmail.com>
References: <20230530045119.30c8d973@rorschach.local.home>
 <20230626091635.3002827-1-avidanborisov@gmail.com>
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
index 8f18f6d..33397b1 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -461,4 +461,8 @@ static inline bool is_digits(const char *s)
 
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

