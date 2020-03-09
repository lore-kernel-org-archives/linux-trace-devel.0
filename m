Return-Path: <SRS0=4xj7=42=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47A73C10F27
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Mar 2020 11:48:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E33E20409
	for <linux-trace-devel@archiver.kernel.org>; Mon,  9 Mar 2020 11:48:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hjJtQRT+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725796AbgCILsR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 9 Mar 2020 07:48:17 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41407 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgCILsR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 9 Mar 2020 07:48:17 -0400
Received: by mail-lj1-f195.google.com with SMTP id o10so2829235ljc.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 09 Mar 2020 04:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hdjOlniPjpIL+UGU8z9lKV/Ye08KbZ52gAdjKPZfnV4=;
        b=hjJtQRT+nl1ZMOFiMo1nY8modobehIwCFOe9uMU34gCqpl5fjTDP2IAMcVfvgGhdoL
         1VFUPTNNb0ObLZcEXT75fmQXWnmvkBI/Z08+M5gsHXjamH7jj3Mny90e1kIheS80jRVg
         AiMvj3bRCsbMCn5xP5bD7C8OJQmqBefgSvGqUnfeIKag6fQCu9o0R606UfEk/XD+svq7
         SoitHSx5bfDiiMZLw6ZWAx1uOttHaukboWJcvc7cK2Y8cybQIdQm0M9ZPShFuQqWV0Vj
         iSdcHwu8UVrqmg+VWbfK8bhXHRSfr0fs2kbkccTyqUW68bympSJTAXh1WOrHOfIqT23B
         hbIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hdjOlniPjpIL+UGU8z9lKV/Ye08KbZ52gAdjKPZfnV4=;
        b=cni7lfGVsw+Fen2vzFCmSLZfx9TBVQnld3t6ChCd+m4v1YVHfjeURTXeaPqNJ/2HMH
         eRzK333rapCJs+E3Gz/JQ2vmTR/CM28m3BnDaRz21RBpcZAXHLZ80oF+kpHYHed7lg0a
         kyIISqfLSMGyZkDbUPyOHwZG45N6Ijfyjnx5bMkT5Qu856n0kWNfsYAh4EqLoGZm4OJz
         To3xsOKna2p1JmDGHjreDcgt0sDUHUgvNCZUraYmVNL2S/48EC5g7kudXWIpDnSFmJDK
         SK6HjEGCH+EvD6p8VPfaZfuzaznOD4qFBKr3SxuN6xG3kfoe/VgN/D7KyFxXoGtRsMFf
         6r4Q==
X-Gm-Message-State: ANhLgQ1/o5vcIUm4GP/Pvadet9ivKtuG+2NZnjZW3t9U7iXqwc+cssxj
        Svr/9jFooN/53EmRgzMwd+wEVNt/
X-Google-Smtp-Source: ADFU+vsBKZivVWRwvLh5zX68IWBRlrgYk5w3BD8eg1Bm6kUgjsd/3zq2iglG2xneACqZKx+GFCqc/g==
X-Received: by 2002:a2e:8654:: with SMTP id i20mr9577516ljj.248.1583754495583;
        Mon, 09 Mar 2020 04:48:15 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a5sm21579683lfl.4.2020.03.09.04.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 04:48:14 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Have trace-cmd stat show instances
Date:   Mon,  9 Mar 2020 13:48:13 +0200
Message-Id: <20200309114813.111486-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The "trace-cmd stat" command does not show what instances exist,
the only way to see it is to browse the instances directory manually.
It is useful to have such information in "stat" subcommand.

Reported-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=206773
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-stat.c | 47 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index 3a086a69..3f7b3493 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -122,6 +122,50 @@ static char *get_instance_file_content(struct buffer_instance *instance,
 	return str;
 }
 
+static void report_instances(void)
+{
+	struct dirent *dent;
+	bool first = true;
+	char *path = NULL;
+	DIR *dir = NULL;
+	struct stat st;
+	int ret;
+
+	path = tracefs_get_tracing_file("instances");
+	if (!path)
+		return;
+	ret = stat(path, &st);
+	if (ret < 0 || !S_ISDIR(st.st_mode))
+		goto out;
+
+	dir = opendir(path);
+	if (!dir)
+		goto out;
+
+	while ((dent = readdir(dir))) {
+		char *instance;
+
+		if (strcmp(dent->d_name, ".") == 0 ||
+		    strcmp(dent->d_name, "..") == 0)
+			continue;
+		instance = append_file(path, dent->d_name);
+		ret = stat(instance, &st);
+		free(instance);
+		if (ret < 0 || !S_ISDIR(st.st_mode))
+			continue;
+		if (first) {
+			first = false;
+			printf("\nInstances:\n");
+		}
+		printf(" %s\n", dent->d_name);
+	}
+
+out:
+	if (dir)
+		closedir(dir);
+	tracefs_put_tracing_file(path);
+}
+
 static void report_plugin(struct buffer_instance *instance)
 {
 	char *str;
@@ -860,7 +904,8 @@ static void stat_instance(struct buffer_instance *instance)
 			printf("---------------\n");
 		printf("Instance: %s\n",
 			tracefs_instance_get_name(instance->tracefs));
-	}
+	} else
+		report_instances();
 
 	report_plugin(instance);
 	report_events(instance);
-- 
2.24.1

