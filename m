Return-Path: <SRS0=h6jj=SV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48FE9C282DF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 20:19:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A4D220821
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 20:19:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbfDSUTA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Apr 2019 16:19:00 -0400
Received: from mail-ed1-f54.google.com ([209.85.208.54]:38587 "EHLO
        mail-ed1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbfDSUTA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Apr 2019 16:19:00 -0400
Received: by mail-ed1-f54.google.com with SMTP id d13so5248858edr.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 19 Apr 2019 13:18:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+JFqCw91JAPPrzvRGPb/+EPBs5Pj0EM9LP1zSNiH6II=;
        b=hbOuoYJUHV1F8q1lp1GawXe5kfIpE4xqI2mIPHrrkhPgoSsvQaRjd81RgtxPokEXp9
         rlIkdQZGdAQnA9nPLqFGSQi4Jt1lKWLo8gjmYRZoz1DnE4FHAPkEDCYHQdlq7eV/yVzx
         tyYbKqcAwkeHhdLR2dzsIq9T5HBtfHut6k5yG6AOXHHG5ya6g4DuC3y+b1OmE1M7ZhD5
         aaoMgkBezEbRuRJwKHGjppFu8pnwrLNFf9ZJDSRMJTvVfhwaRr8KJNxDZRtfIMD/8cjO
         fu5CipPOfvsgYwDqPFWp/VmI0I24h3R2JlCJ7YnULisXoskWVSR9uAcxvr684/wywne/
         J1Gg==
X-Gm-Message-State: APjAAAVgXDSLk/nwcQOeG6VwzvsJKpLVn4yf0w2Acs84WygA6D56V6WE
        Bqs2TxnHhlwmYYiJfvw0JAnvw+pb
X-Google-Smtp-Source: APXvYqz9HulIo769/oZdJR+TqOKL/o5v8xBXYaC4lQZBuAtah4hMFPxOqZWQYitBIqFnfNzFbSABfA==
X-Received: by 2002:a50:c44d:: with SMTP id w13mr1677702edf.50.1555662603969;
        Fri, 19 Apr 2019 01:30:03 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id cg22sm779467ejb.2.2019.04.19.01.30.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Apr 2019 01:30:03 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Load trace-cmd plugins from build folder, if exists
Date:   Fri, 19 Apr 2019 11:30:02 +0300
Message-Id: <20190419083002.17909-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When a development version of trace-cmd is built and run on the machine,
by default it loads all plugins from predefined drierctories :
  (install_preffix)/lib/traceevent/plugins
  ~/.traceevent/plugins
  the path specified in TRACEEVENT_PLUGIN_DIR environment variable.
In case there is a legacy trace-cmd version already installed, there will be
a collision with the development version. Wrong, incompatible plugins will be
loaded. To simplify the development process, a new logic is added:
  On trace-cmd build stage, the full build path is stored in the
  trace-cmd binary. When the application is started, it checks if this build
  directory exists and loads only plugins from it.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 Makefile                   |  2 ++
 lib/trace-cmd/trace-util.c | 10 ++++++++++
 2 files changed, 12 insertions(+)

diff --git a/Makefile b/Makefile
index cde45f8..534d882 100644
--- a/Makefile
+++ b/Makefile
@@ -207,6 +207,8 @@ LDFLAGS ?=
 export CFLAGS
 export INCLUDES
 
+override CFLAGS += -DBUILD_PLUGIN_PATH="\"$(shell $(shell which pwd))/plugins"\"
+
 # Required CFLAGS
 override CFLAGS += -D_GNU_SOURCE
 
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 8d21fb2..ea4f430 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -1374,11 +1374,21 @@ int trace_util_load_plugins(struct tep_handle *pevent, const char *suffix,
 	char *home;
 	char *path;
 	char *envdir;
+	struct stat sb;
 	int ret;
 
 	if (tracecmd_disable_plugins)
 		return -EBUSY;
 
+#ifdef BUILD_PLUGIN_PATH
+	if (stat(BUILD_PLUGIN_PATH, &sb) == 0 && S_ISDIR(sb.st_mode)) {
+		trace_util_load_plugins_dir(pevent, suffix, BUILD_PLUGIN_PATH,
+					    load_plugin, data);
+		return 0;
+	}
+#endif
+
+
 /* If a system plugin directory was defined, check that first */
 #ifdef PLUGIN_DIR
 	if (!tracecmd_disable_sys_plugins)
-- 
2.20.1

