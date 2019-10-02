Return-Path: <SRS0=PpJY=X3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F056CC352AA
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Oct 2019 11:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B876721920
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Oct 2019 11:42:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MWjZMahG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbfJBLmA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Oct 2019 07:42:00 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37382 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfJBLmA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Oct 2019 07:42:00 -0400
Received: by mail-wm1-f65.google.com with SMTP id f22so6638325wmc.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 02 Oct 2019 04:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3h3krUjeDjO3mByQYSfh8zes6w1Xi4ZjEF/nwHcJZ3k=;
        b=MWjZMahGSZFbz9G48Hi60FkoVQOqvIrm+g6CwzXNK+0CyuFINq0tvn4sFF6StkGcsW
         LvHC9pgJPvGWdbK8AWYIhQlHAWT9i2gerJOZDuRkNq4VI1Mw9hA8EIvHbAUfxzAG63Xi
         7WbkpOpwHbGKYn+XKEeoZBLI1ej7OTN89mOTDvVfbEJfCt9ynco83leclZgA/oCFj6oT
         0IPyrAyS4AEIj/AynEuB+N8ln0eC2Vcd/wLdS0LHNwLKBZXF5svR6BQ85XK/NAqkXoQl
         BYvIHuJdgzGJFIfDuxzYcRZmW6ZAtJDWu4Hy93W+z3IpqyOZ+VBJqdUO/wQ9FrRgogl1
         zpPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3h3krUjeDjO3mByQYSfh8zes6w1Xi4ZjEF/nwHcJZ3k=;
        b=dBAdKrmFI43N2u3L2zrqxD21IeP/bwLSKb+Dlc6NtrJ0mkVqrFTsfGsiU6t85ZPXuy
         3vgi7+rMHk/tWYrg26oLxnFmdt5nXVqBOUn0ZRXM7mFPgfp3ImrSUo5JikzvheFWvwLr
         VwDSb6nWwXLPvkY/WuCEIfiTP3sOBY3m2UYuL+rfkuZu75JRa7S+mstDtkOtHCOuz50U
         0ifwth5ngZzIeDr6I9lsvN55ogAkb0vXByG6N9In0EFn9Bd6pbbsytIf6tMpTca4aNAA
         mzdnjEjUtGt0fGUjaBAGKIcgPDgEoq7cpjwQgxJFzuO4vpb6VPL6XZ75HJ7GxZ/yOQ0a
         0I1Q==
X-Gm-Message-State: APjAAAW81/m6cFqNSaREwg89/RbYarA4DQDqWf27h2Rm9eO+MjZgcfXU
        0Z50nZk6eJ5NNv+LjxKX9d8=
X-Google-Smtp-Source: APXvYqwHx+H5B7L2NFeG93HcUgkyP3KtYFmsDWV/AeW2xPGcamF1ISneiRkmd1R4UXo5+t9pvxm9/w==
X-Received: by 2002:a1c:b745:: with SMTP id h66mr2437083wmf.70.1570016518124;
        Wed, 02 Oct 2019 04:41:58 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id l4sm3004658wrw.6.2019.10.02.04.41.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 04:41:57 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 3/5] trace-cmd: Load libtraceevent plugins from build folder, if exists.
Date:   Wed,  2 Oct 2019 14:41:50 +0300
Message-Id: <20191002114152.30048-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191002114152.30048-1-tz.stoyanov@gmail.com>
References: <20191002114152.30048-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When a development version of trace-cmd is built and run on the machine,
by default it loads only installed plugins, from system drierctories.
Thus, the development plugins will not be loaded. To simplify the development
process, a new logic is added:
  At plugins load time, check the location of trace-cmd application and look
  for "plugins" directory around it. If found, load plugins from it. Those
  pluigins will be loaded last, so in case of duplication the "development"
  plugins win.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/traceevent/event-plugin.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index bc10205..4fc4ee3 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -14,6 +14,7 @@
 #include <unistd.h>
 #include <dirent.h>
 #include <errno.h>
+#include <libgen.h>
 #include "event-parse.h"
 #include "event-parse-local.h"
 #include "event-utils.h"
@@ -538,6 +539,27 @@ load_plugins_dir(struct tep_handle *tep, const char *suffix,
 	closedir(dir);
 }
 
+static char *get_source_plugins_dir(void)
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
+	strcpy(p, "/lib/traceevent/plugins");
+	return strdup(path);
+}
+
 void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
 			   void (*load_plugin)(struct tep_handle *tep,
 					       const char *path,
@@ -588,6 +610,12 @@ void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
 	load_plugins_dir(tep, suffix, path, load_plugin, data);
 
 	free(path);
+
+	path = get_source_plugins_dir();
+	if (path) {
+		load_plugins_dir(tep, suffix, path, load_plugin, data);
+		free(path);
+	}
 }
 
 struct tep_plugin_list*
-- 
2.21.0

