Return-Path: <SRS0=b+cV=4I=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D170C11D04
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 Feb 2020 09:43:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 404EB24672
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 Feb 2020 09:43:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O0fFS8mX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgBTJnT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 20 Feb 2020 04:43:19 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37013 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbgBTJnT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 20 Feb 2020 04:43:19 -0500
Received: by mail-lj1-f194.google.com with SMTP id q23so3516971ljm.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 20 Feb 2020 01:43:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ibRHGLUXaVOzYWWQtziG654FEzW/c2Xw73ebhX/4a/0=;
        b=O0fFS8mXEQzbunK8n0q49DxO/0ByOoQAICKF7nEITWhE26G0YoHvIgZsUSCPV30+mM
         nH6HfwkLKmVJJcA9TL+CzYGO+4Kqbph7FKj+pZ6tibgcEFrgUdfBvLeFwtFAqX0A+n2v
         hkGHibViA4AZYXSQyjmNzJ2+mJ/D6EQHG6dXlwKLuk+TGozrHgcdQQkg6jqQgBDosgP9
         sk5jtNikI4jluEnmQrBQR82D6kPJPLrqvzI/VQv1L8CdxtQOiJ35s7D0uL0sxiMuKwU2
         /pE0rJKqUPrjetW/F9ZU3skXq8Jl2AOem5uAWTGz2/y1yIVs/cQwZ0WPfkz/RboiuPl9
         XLmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ibRHGLUXaVOzYWWQtziG654FEzW/c2Xw73ebhX/4a/0=;
        b=XCB7xBAVM9r7zH02g9DeFl4ol6hEZMgy381fD5P9eY26mkZIgMeS6iR1gPsixTmz3z
         rEL/KqOeAvtcjre1b76tgq7YGKaKFNGcopPmCi1S0pnba5+p2KZJ+acd8vUufeMquUVK
         M64TT2ejBqJOcPEkrNiDFlEpTh8G2joNKNWvdmvSyb9ih22smmaFXIeNZ9uRLltfmOAX
         TP37jbG/sxy84tUsPk9vQS/pBQSCZjt4NChwMRPKD5g3v4MdX6wh/10K6lmFe2C7W69C
         gAVkLswiI+M/ljq7vitz64vKB74R6li6DzHISVOZRuG/Ywfq1ksg0CMeeqEqqRuj80BP
         cV+A==
X-Gm-Message-State: APjAAAVVHlab1e/zoksFvDXYZ6aSVZXrEMYPtWixVxY8MRalL3FGf5mp
        7lbU7h0Y2p8oZr9iJ5Hqv6ONfgQ/
X-Google-Smtp-Source: APXvYqwAKhTtngwA3JH6g7brUmJheHKWTGAmhqsNkUyvXX+2/DLA7q+UvWYJileFZN5sz6Tw2EXPxg==
X-Received: by 2002:a2e:b5a5:: with SMTP id f5mr18200897ljn.162.1582191797482;
        Thu, 20 Feb 2020 01:43:17 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id h24sm1412382ljc.84.2020.02.20.01.43.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 01:43:16 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] trace-cmd: Clear synthetic events on reset subcommand
Date:   Thu, 20 Feb 2020 11:43:15 +0200
Message-Id: <20200220094315.467649-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The "trace-cmd reset" command is supposed to set the ftrace state to default.
However, the synthetic events are not reseted.
A logic is added to delete all entries from "synthetic_events" files.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>

---
v2: remove the warning in case there are no configured synthetic events
---
 tracecmd/trace-record.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 4a49b640..881efe44 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4638,6 +4638,41 @@ static void clear_triggers(void)
 		clear_instance_triggers(instance);
 }
 
+static void clear_all_synth_events(void)
+{
+	char sevent[BUFSIZ];
+	char *save = NULL;
+	char *line;
+	char *file;
+	char *buf;
+	int len;
+
+	file = tracefs_instance_get_file(NULL, "synthetic_events");
+	if (!file)
+		return;
+
+	buf = read_file(file);
+	if (!buf)
+		goto out;
+
+	sevent[0] = '!';
+
+	for (line = strtok_r(buf, "\n", &save); line; line = strtok_r(NULL, "\n", &save)) {
+		len = strlen(line);
+		if (len > BUFSIZ - 2)
+			len = BUFSIZ - 2;
+		strncpy(sevent + 1, line, len);
+		sevent[len + 1] = '\0';
+		write_file(file, sevent);
+	}
+out:
+	free(buf);
+	tracefs_put_tracing_file(file);
+
+}
+
+
+
 static void clear_func_filters(void)
 {
 	struct buffer_instance *instance;
@@ -5344,6 +5379,7 @@ void trace_reset(int argc, char **argv)
 	set_buffer_size();
 	clear_filters();
 	clear_triggers();
+	clear_all_synth_events();
 	/* set clock to "local" */
 	reset_clock();
 	reset_event_pid();
-- 
2.24.1

