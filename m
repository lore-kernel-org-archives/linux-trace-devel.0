Return-Path: <SRS0=qXaB=4H=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACE97C34047
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Feb 2020 13:13:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80B3021D56
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Feb 2020 13:13:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="twGbsT3J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbgBSNNz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Feb 2020 08:13:55 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37482 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbgBSNNz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Feb 2020 08:13:55 -0500
Received: by mail-lj1-f195.google.com with SMTP id q23so326306ljm.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Feb 2020 05:13:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XALjszUorVIUWU95ZazshjwcQisTPrgztPryJixvQzQ=;
        b=twGbsT3J54wqI4ho+he4sJ3hFYILIw8H+Lo5unmw045LJFJpw/ROFN66akobiMr2c4
         ywiGGKZD8uMA7B9XvCxX3ZDPNmGDx9Q71cFCneuNlw5iW3vBCfhJ6I6iXwWDPXWGw3DC
         D/5Q8EZZPQdCfKdkqZJ/6N/K48lJ8t0HeXaFb+XaXgJiBMSnCGMoKQjcGA0FP0GqYwag
         C0HmcGn44L9t9AwK/9xSTEpcA9kNgHYxaQDW5T1ORuatQ6doIiyGhUeTdeRkS/3aDkey
         RIBVp1lyNAn2BLc1tQO2sLHQtUA1iihE43JZgVPEVYNf7coWSiduLHSOcAqVHfw7qxl3
         np2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XALjszUorVIUWU95ZazshjwcQisTPrgztPryJixvQzQ=;
        b=Vs0dx5DwN9kzv8I5LTEPQ1aBFU6vvcYYkYELQWRIrafkUeiaZ4YO28/Vlmud3OKTsX
         yLYfQsmUWokI3Q1ihasrPM9UeXAv21iWiSCwczfhpPPC2LbeUVhAzMbfGUm3WDZySKQo
         1TDvkKY5xGFiO9h0U+DKZqRkaVdOXvu+915WYdzCzO0rN+P5/ZmvHCobCxYlFNp8Nq/Q
         +XHDlJegvCjfrJyfsBZsfPEIZkt1nthIis02MqKe7B3SCxkwP52FKSRXdoodCGk9aWGx
         B9D2GcQLSUptGEzYWr9gwo5JtdqtV5Ww0laxG1KSw1A6DO3VG6R4F1vE2kGiEy/Js8B0
         oqTQ==
X-Gm-Message-State: APjAAAVmTcpgZeC7q7tspSewb7rz3C0Vm/oH8kbkfGQPN8L9Q+ytRTIu
        uv+P1b/qOfE7ReP9sTmPSTN9VI/m
X-Google-Smtp-Source: APXvYqx3MOW4jYMxm/uVBylaLIboFIMO/oDTX+atSYfYUIzYvynv4UT9DcR80IAca0ofWO59K8guNA==
X-Received: by 2002:a2e:81c3:: with SMTP id s3mr15502018ljg.168.1582118030197;
        Wed, 19 Feb 2020 05:13:50 -0800 (PST)
Received: from localhost.localdomain ([151.251.253.122])
        by smtp.gmail.com with ESMTPSA id e20sm1191949ljl.59.2020.02.19.05.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 05:13:49 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/2] trace-cmd: Clear synthetic events on reset subcommand
Date:   Wed, 19 Feb 2020 15:13:46 +0200
Message-Id: <20200219131346.447021-1-tz.stoyanov@gmail.com>
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

