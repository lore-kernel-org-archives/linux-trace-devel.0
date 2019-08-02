Return-Path: <SRS0=4i+i=V6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07AEBC32753
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Aug 2019 11:01:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D334E206A3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Aug 2019 11:01:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="slDxmT7w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729711AbfHBLBN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Aug 2019 07:01:13 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43545 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729716AbfHBLBN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Aug 2019 07:01:13 -0400
Received: by mail-wr1-f65.google.com with SMTP id p13so2172695wru.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 02 Aug 2019 04:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+B9UTj4Rq9A1L6ibkh9D44VJbCpjHBqzTOu1+x/JlwU=;
        b=slDxmT7wCmBq5omeiQueZerT2qQRhPwv4BdEOrNJaDBB/F1i2xgWG7DHPbmbhMkf3J
         ulXQxPKk1F/aWkQfp20bQwJy96iszFOfmLBJ03nRUrEbx4thdh6caVw3piUCzKNHa3aA
         OjFhFaBX8g26PEfFV7+x0kFZT7oqTs/oxS1ohrCsnU3ZK0iNdOQsJX0lqzCW0u7hhn1+
         jvBFtR4oxcu1ZOAdNGMErCRWopHSweHJusuMPToyP/uRMd83lTKMXTSgfjPE+roKCo6v
         jC5e1H/rtEytcPa+kuE/xvyhRlNza2PCbVg5HbqJNqGuivZDli3HZ7/6XqJQK1PCsU4Z
         WbTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+B9UTj4Rq9A1L6ibkh9D44VJbCpjHBqzTOu1+x/JlwU=;
        b=GCafiZZN/X35/qQlJL947qA88jhLaaUqFsJTLHHY/UomTAx7IubL9J+Ey6J2LyVAVi
         gZ0tYbh+axUDoTiVRq9/McDc1heouq97VLHdU/zhqKz1GOUEsauaW0ytD1RphEbKxtv5
         6WsgZa9WEtcO98TkfdCnOXxSk/BJR+Kx4pNAGUSdRLufpOakWnmdtvf76zAKUId8rFKS
         kjdjKpTEq0p1RX3KrPaOAqAdrH3JgxZkar/T25TOFxaVDvCJmwUMCzmVDW9oJgU6TJA4
         8bsjnuhINJi9DHenwJ68TFEJRdjq34imrT33nIvJbc5BMSWHvM5CCXdDsgdRas5JITTS
         11rQ==
X-Gm-Message-State: APjAAAWFUrqJhHJaqvyqR9w6e2YfW/IXMzWpUihyJ38HY6znNZXkgTDf
        kRaiuJIOg1omNDZdLu5FFZYtoeI+s9k=
X-Google-Smtp-Source: APXvYqyLWnZeI2JVePmIu3WQTb+b2hnpDFmrh9emWnIlIFFlSmFMMFIqclDowkBPXTlS+IySYxdTLg==
X-Received: by 2002:a5d:4cc5:: with SMTP id c5mr92395147wrt.278.1564743671121;
        Fri, 02 Aug 2019 04:01:11 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id r15sm79511433wrj.68.2019.08.02.04.01.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 04:01:10 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 5/6] trace-cmd: Load libtraceevent plugins from build folder, if exists.
Date:   Fri,  2 Aug 2019 14:01:00 +0300
Message-Id: <20190802110101.14759-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190802110101.14759-1-tz.stoyanov@gmail.com>
References: <20190802110101.14759-1-tz.stoyanov@gmail.com>
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
index bc10205..fdaadba 100644
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
+	strcpy(p, "/plugins/traceevent");
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

