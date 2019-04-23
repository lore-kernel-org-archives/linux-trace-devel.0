Return-Path: <SRS0=onCu=SZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69A24C10F14
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Apr 2019 09:57:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DA3920843
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Apr 2019 09:57:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbfDWJ5C (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 05:57:02 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42543 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfDWJ5C (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 05:57:02 -0400
Received: by mail-wr1-f66.google.com with SMTP id g3so19360651wrx.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Apr 2019 02:57:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0EP+IguqQ+hwAoW5qIZCWolMuAYEgRl6GSORffp3TTs=;
        b=mQBtEh5sd7/5fPPncy4oH3Q1PkYnXS+otiM8RM9D7Gask6Nt51q2Gk0ngHhYtH8Ce2
         MomJJjAmzsZf7kOCtEylXEgXE4yReDpiZQE6F0a5Fr+EngWuISIMl6Fght8YUT0SQs+r
         buiO89z3geVZOV2jH/JoF7CeIoNleuTSO1KywFXfU5rsLdSSBPuUkHOdqnI+xvZkT5PT
         MIhBiQN/nETvZ3OHEoguosewS9xAHdETXDwx8fuvicY3d26mNbfelb5S3oO2xqogeAya
         8X7AT35fQqrrvPzNbfOBFmH7zdYCWGorBL4xOeo6p3KbI0bqb1GHQ3NZRpR2UvdBOpZ3
         T5lw==
X-Gm-Message-State: APjAAAWQ3ChYyxp8V2cEGFipcNg9LPtFnP30c3uHn90p6R2r8+wL2+d7
        uIWB3sf7JWv/6v8FN4gMUoq26IQf
X-Google-Smtp-Source: APXvYqyvKiHbD+WsgU5KgSsRaxufAA4cSEH/Y8+Q0tOmaKcCgeaGC4GX/ll9hRFeOUaczeKGyH+S3w==
X-Received: by 2002:adf:e6c6:: with SMTP id y6mr16219257wrm.225.1556013420786;
        Tue, 23 Apr 2019 02:57:00 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id c11sm7383920wrs.86.2019.04.23.02.56.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Apr 2019 02:57:00 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] trace-cmd: Load trace-cmd plugins from build folder, if exists
Date:   Tue, 23 Apr 2019 12:56:58 +0300
Message-Id: <20190423095658.3907-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

[
 v2 changes:
  - Removed the logic looking for plugins in the build path.
  - Added logic which gets the full path of the running trace-cmd
    binary and loads plugins from "plugins" directory around it, if exist.
]

When a development version of trace-cmd is built and run on the machine,
by default it loads all plugins from predefined drierctories :
  (install_preffix)/lib/traceevent/plugins
  ~/.traceevent/plugins
  the path specified in TRACEEVENT_PLUGIN_DIR environment variable.
Thus, the development plugins will not be loaded. To simplify the development
process, a new logic is added:
  At plugins load time, check the location of trace-cmd application and look
  for "plugins" directory around it. If found, load plugins from it. Those
  pluigins will be loaded last, so in case of duplication the "development"
  plugins win.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 lib/trace-cmd/trace-util.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 8d21fb2..98402a0 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -1364,6 +1364,34 @@ static int add_plugin_file(struct tep_handle *pevent, const char *path,
 	return -ENOMEM;
 }
 
+static char *trace_util_get_source_plugins_dir(void)
+{
+	char *plugins = "/plugins";
+	char path[PATH_MAX+1];
+	int slash = 0;
+	int ret;
+
+	ret = readlink("/proc/self/exe", path, PATH_MAX);
+	if (ret > PATH_MAX || ret < 0)
+		return NULL;
+
+	while (ret) {
+		if ('/' == path[ret--])
+			slash++;
+		if (slash == 2) {
+			path[ret+1] = 0;
+			if (strlen(path) + strlen(plugins) > PATH_MAX)
+				break;
+			strcat(path, plugins);
+			return strdup(path);
+		}
+	}
+
+	return NULL;
+
+}
+
+
 int trace_util_load_plugins(struct tep_handle *pevent, const char *suffix,
 			    int (*load_plugin)(struct tep_handle *pevent,
 					       const char *path,
@@ -1404,6 +1432,12 @@ int trace_util_load_plugins(struct tep_handle *pevent, const char *suffix,
 	trace_util_load_plugins_dir(pevent, suffix, path, load_plugin, data);
 
 	free(path);
+
+	path = trace_util_get_source_plugins_dir();
+	if (path) {
+		trace_util_load_plugins_dir(pevent, suffix, path, load_plugin, data);
+		free(path);
+	}
 	return 0;
 }
 
-- 
2.20.1

