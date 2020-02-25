Return-Path: <SRS0=gJb8=4N=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95522C35E04
	for <linux-trace-devel@archiver.kernel.org>; Tue, 25 Feb 2020 18:07:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71FF821927
	for <linux-trace-devel@archiver.kernel.org>; Tue, 25 Feb 2020 18:07:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jP3swYL5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbgBYSHp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 25 Feb 2020 13:07:45 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44154 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730799AbgBYSHp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 25 Feb 2020 13:07:45 -0500
Received: by mail-lj1-f194.google.com with SMTP id q8so15041306ljj.11
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Feb 2020 10:07:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ioRTEZtW+2sz68dFd4pkQC4PCzG+F8u2ONRPmBzwiLE=;
        b=jP3swYL5af6iDDp/AZ3CxNHWADQOqIBDDOdj12V16xd43wrs8VHqfPi3JJbAcVYJbT
         v2sFpiKtpUz6Td8ZB0E0wB0M3lGzBB81V2EYI1Wdc3hmoFx0fBfjnyQmmac1EBAglQpu
         tMObU+ZdLUYIM64/e87gp7Xy2oK9QPY10B3vI8ZIGGVJ7SysqJYsLc60ac6JV5HtuDhz
         adfPrun/mDEnvsXHGxc+56D0bFVt8mQJ4OAWRgmWSM4BzcWx1kn33cE0oQrDQ+cfOUne
         s9jaFHtpSWX6oPPUKOGqnG3wkHTVF6X6ijcrribLOzs+ZZCsMFeySeYFXnmxPmgv/QEd
         ajWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ioRTEZtW+2sz68dFd4pkQC4PCzG+F8u2ONRPmBzwiLE=;
        b=O9ZEmnFCBtmDZddwtWs4FzbZvpkDWhy4vXlxWxFhVB9l9JSHgI4dwKRwBj3eA93r9C
         tnpl7uNrFHGFNpEdoglhmBDgkzK0fPoTsym56Bz+78sWHSjgoDw+rPn65o/J3KQMmHPL
         ErZN00tNERxKl/OO7pqNW1aoUPTM4egPAwsPLEFwy1BQp1/Wjw7f9pttDQ5izhzpZzfU
         l6qiSfHutacPE//00X3z7ulRn2HHtpTyJnzEBJi/XxxJKfi/6uqOoHxcph/Yz24Mqjn9
         ahzxiq9H5ZUe6TCXcS6J4GIBYwQZ1XKfvt2Z5G5mNmtF8LoMxLBe7MjcNsSzDFSZ06DI
         F77Q==
X-Gm-Message-State: ANhLgQ1WJBBic1xRvNFATv2vw+IIZ3T5V5IE2H88Zgdz3lb+RsnJT/xf
        pVgkg0ABgnXz7Q7OP4fn71c2YRQjcLA=
X-Google-Smtp-Source: APXvYqxlG85eac9a2hRHE/OP+MrGUjNx9qpuaeNmWp865aPgcgPsSgvvwY/su1N21ZktkpdA3U/Gaw==
X-Received: by 2002:a2e:95c4:: with SMTP id y4mr193618ljh.38.1582654062408;
        Tue, 25 Feb 2020 10:07:42 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v15sm4141438lfg.51.2020.02.25.10.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 10:07:41 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 3/4] trace-cmd: Clear synthetic events on reset subcommand
Date:   Tue, 25 Feb 2020 20:07:32 +0200
Message-Id: <20200225180733.89344-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200225180733.89344-1-tz.stoyanov@gmail.com>
References: <20200225180733.89344-1-tz.stoyanov@gmail.com>
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
v3: remove the warning in case there are no configured synthetic events
v2: remove the patch from "SQL-like syntax for ftrace histograms configuration" patch set
---
 tracecmd/trace-record.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 4a49b640..7c76ffa8 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4638,6 +4638,43 @@ static void clear_triggers(void)
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
+	if (!tracefs_file_exist(NULL, "synthetic_events"))
+		return;
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
@@ -5344,6 +5381,7 @@ void trace_reset(int argc, char **argv)
 	set_buffer_size();
 	clear_filters();
 	clear_triggers();
+	clear_all_synth_events();
 	/* set clock to "local" */
 	reset_clock();
 	reset_event_pid();
-- 
2.24.1

