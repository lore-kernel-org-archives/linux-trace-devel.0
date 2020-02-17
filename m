Return-Path: <SRS0=ULQB=4F=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A8FC34022
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Feb 2020 17:40:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D436620725
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Feb 2020 17:40:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DvHmRH3f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729371AbgBQRkI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Feb 2020 12:40:08 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33774 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729331AbgBQRkI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Feb 2020 12:40:08 -0500
Received: by mail-lj1-f193.google.com with SMTP id y6so19810632lji.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Feb 2020 09:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XALjszUorVIUWU95ZazshjwcQisTPrgztPryJixvQzQ=;
        b=DvHmRH3fZLpmhGlS/OqpslbNy8g0vwE2JOo2a9cC7i/PqeIeiBQwjOzgPnWHZV5ADv
         C4yiDcIhYR8Pd9KTwbffqn6aWksJTLyKUzYcaLUJJ9i3qdOf8pjAeHXSPs4HjOGTEsFt
         8GfErBaatvsovUg6ljfLclGNiQA0GbHBfWFWdgAm8LUr041v++Y71rb5sDRWycKWlFRW
         i1A4U1/JL0diaQ8A7w7kO6zYxYAUGQu8k3KsB/QnJTXPxFcY6STKkknowvUwB24OmQG9
         AnyciO257E5sXnfIE6/+HpGWuLRJvTOXfSuwXOOAedgxMmBDzwVqGfh3JkzvhzI97yG0
         9tmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XALjszUorVIUWU95ZazshjwcQisTPrgztPryJixvQzQ=;
        b=m+5tm9Tl75zafwbiwHaCI4NGlzfORtJtOezA7R6ULJ9ntnBWQshJVge3QxzuyM6VcU
         hJw0PV3N7s9rC30Via1muHXqDS8L7MvjLOSU7fODrIWi3wFRVn8BsgVS3s+oHi5Z4wtU
         zufZDNjk2qPVE+ls4D7OF0xVm5IL7JP4dmvS8YfrS3XUH/dP/oE7GTsQ/SXvOnqYD+CB
         NLbPp6+lMBUZYlq0QnCO6PecjEj6pFcTzQhJmCzJ6kV7f8R2CACVb1MSSEdnRO/SdEku
         o/8/cPQY+4JIUmy+dc6u1h4pOz3+6Wsn6Gl1VWHCz3x6qYDbipi6r1StJa06wK5jf4dW
         J7nQ==
X-Gm-Message-State: APjAAAWRH/VcrIoIcjsGshHdWA92SiUSarlKSLpsCj7a8MbKYw1KfmCT
        q4cfhSD4p7jDxnYO2lZXg1M=
X-Google-Smtp-Source: APXvYqzuoJHIiCfFLhlFtXxiZ8FAoPWFR4nQlvMcMZ4d5fE0+Sc+I8PRhsVcyvKWs2X3xdcqN/WNkw==
X-Received: by 2002:a2e:8197:: with SMTP id e23mr9927027ljg.250.1581961206407;
        Mon, 17 Feb 2020 09:40:06 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e8sm933508ljb.45.2020.02.17.09.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 09:40:05 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/4] trace-cmd: Clear synthetic events on reset subcommand
Date:   Mon, 17 Feb 2020 19:39:57 +0200
Message-Id: <20200217173959.385278-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200217173959.385278-1-tz.stoyanov@gmail.com>
References: <20200217173959.385278-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-record.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 4a49b64..b6a412e 100644
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
+	file = tracefs_instance_get_file(NULL, "synthetic_events");
+	if (!file)
+		return;
+
+	buf = read_file(file);
+	if (!buf) {
+		perror(file);
+		goto out;
+	}
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

