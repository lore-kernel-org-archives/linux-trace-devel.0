Return-Path: <SRS0=onCu=SZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B5B0C10F14
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Apr 2019 14:33:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 439BD21738
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Apr 2019 14:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbfDWOdt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 10:33:49 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:32842 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbfDWOdt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 10:33:49 -0400
Received: by mail-wr1-f67.google.com with SMTP id a3so10900049wrx.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Apr 2019 07:33:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kSrPGCzDmFhDgxVZvjBfzgrzxbQEk5NAzph5K/jc9nI=;
        b=lCysxaSTe1vA4u9GVIBoNr7lE02z33s9ak0Th8glb+dBVqWtQog4Dmyb8e9gnjWPV5
         nSAisVheuzWxYLScx0iLOjEVoWcpGpuDO2qdG4FjmmhEi2GpSy14XyThnSTftOs3oPs5
         IbXptlywl3pLwYBwgSDmi+PYGJ7g3qjUv96tSuX2W3tRjHtfE5Pv0QqNJNUpPWa6Lo5F
         jAeOM6uIsXX4HPW2QdPJ8IrNAk781Vel8OdXp+F3QP8Wug3QhcvBSgNTeNBHOWLyINN5
         7lRd42tGx8WjMDM9Lvn7sN9Vs+59qEJQmWdsRrHczEuhr0UKOtKJx0QqBqoue3pB6Q/2
         DKiQ==
X-Gm-Message-State: APjAAAW1oLgsr692GUSHTLbcN6rh0Uyte9BoNyvfDgm3Za5Lh6EDgTVm
        tnuJrnvF6bSwV31oA9AnatdLect2
X-Google-Smtp-Source: APXvYqzOuR6VR/ORMdbvGmof6OA14Wmats2W9aiEDDVOnRmp6vszSQ/ibYSDRwbg+ZVGIAP1LXA9Gg==
X-Received: by 2002:adf:fcc8:: with SMTP id f8mr4290283wrs.250.1556030027348;
        Tue, 23 Apr 2019 07:33:47 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z7sm12083637wml.40.2019.04.23.07.33.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 23 Apr 2019 07:33:46 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3] trace-cmd: Load trace-cmd plugins from build folder, if exists
Date:   Tue, 23 Apr 2019 17:33:44 +0300
Message-Id: <20190423143344.30645-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

[
 v3 changes:
  - Simplified the logic, using standard library functions.
  - Added check to ensure the binary is inside the source tree.
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
 lib/trace-cmd/trace-util.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 8d21fb2..190cf74 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -14,6 +14,7 @@
 #include <unistd.h>
 #include <ctype.h>
 #include <limits.h>
+#include <libgen.h>
 #include <sys/mount.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -1364,6 +1365,28 @@ static int add_plugin_file(struct tep_handle *pevent, const char *path,
 	return -ENOMEM;
 }
 
+static char *trace_util_get_source_plugins_dir(void)
+{
+	char *p, path[PATH_MAX+1];
+	int ret;
+
+	ret = readlink("/proc/self/exe", path, PATH_MAX);
+	if (ret > PATH_MAX || ret < 0)
+		return NULL;
+
+	dirname(path);
+	p = strrchr(path, '/');
+	if (!p)
+		return NULL;
+	/* Check if we are in the the source tree */
+	if (strcmp(p, "/tracecmd") != 0)
+		return NULL;
+
+	strcpy(p, "/plugins");
+	return strdup(path);
+}
+
+
 int trace_util_load_plugins(struct tep_handle *pevent, const char *suffix,
 			    int (*load_plugin)(struct tep_handle *pevent,
 					       const char *path,
@@ -1404,6 +1427,12 @@ int trace_util_load_plugins(struct tep_handle *pevent, const char *suffix,
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

