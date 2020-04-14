Return-Path: <SRS0=o21U=56=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3399C3815B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Apr 2020 15:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1E8D20732
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Apr 2020 15:56:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jRUT3dRf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730955AbgDNP4S (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Apr 2020 11:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732242AbgDNP4N (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Apr 2020 11:56:13 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80417C061A0C
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Apr 2020 08:56:13 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id u15so351677ljd.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Apr 2020 08:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C77Zgg0BszCIcISIGI3/oODyUG/U9WvlBBERqtSXzRg=;
        b=jRUT3dRfjvR+J8a9JW9R7o+yjQHe7HJYzud07psTwcO/g5cZgiCFKyvqC4nzOKvS2k
         I+mN4yuVnZdIPiCIdSdB0bMwS2Y4Vr6twbP/mEOcISfD9ITUpX7b31mH9M4oDc9q1ZbS
         QIGU2Wu04h9lE9GqTgJ3UqK/e64KKNDk7U2XGmaklEzJKX+ZnOOUh3znCYaJ0VJP5lRV
         h+/yrMePg4xIcQjHqV6HeC41egjGSx6L9XSWg8FllBns3xHkyQb+XAy+xR5Lye7YOW7U
         BDNyJ/nRnsjgwSywspev7fwn5uBbOv0aWnLZJXxHkJIqZX03+FY7sQ3NyFXzvTJQm/4i
         HnYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C77Zgg0BszCIcISIGI3/oODyUG/U9WvlBBERqtSXzRg=;
        b=WrdK6+pmDJuQWcokXYX19rpYT39RTK2Jt+UgA9oCVJx77Wcc5b5fGcy1O5dohwXKn0
         L7e5P9p0gXkeXfKcqUvrdQ/VLgwflsY1PQSn5mJ6pQiv+69rMSaQysG1iEQ7qcHSEA0L
         SmeFFsplkz96TjJwsmGOoCIo9+UqQbnDqiR+2tBSeEzmiF/VYolc87X92hFT5ohjbFF8
         4I+++e51xcopJMzPjTOdQd5wmvukdYYrtOG1ZNtFJe+eO5GO3UKhjL2CdI2URLejFmR/
         zyXMFzFm5bCAGZeanhSflwAkqMgjjJjtOOODRHilVqjHXFUNvXkkI3VAZ90TIPn1wkbF
         Olww==
X-Gm-Message-State: AGi0PuYGvUD4wiwFu/BMghwqY+xF39fIU/07d3EyQcS/X4oGIgFFHmD7
        xSnvIDM8Y+08XqybXliKMeQ=
X-Google-Smtp-Source: APiQypJhFsWTJ5ufAmmMBPlQdZidZY8MOH7uFOlmxBMP4kzJb911vj0peDNRvG8GWFK8GY0PgvNcVg==
X-Received: by 2002:a05:651c:3c6:: with SMTP id f6mr485131ljp.229.1586879771949;
        Tue, 14 Apr 2020 08:56:11 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b2sm11408534ljp.63.2020.04.14.08.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 08:56:11 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 3/3] trace-cmd: Clear error log on reset subcommand
Date:   Tue, 14 Apr 2020 18:56:04 +0300
Message-Id: <20200414155604.31401-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200414155604.31401-1-tz.stoyanov@gmail.com>
References: <20200414155604.31401-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The "trace-cmd reset" command is supposed to set the ftrace state to default.
However, the ftrace error logs are not reseted.
A logic is added to delete the content of "error_log" file when "trace-cmd reset" is executed.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 1b3f403f..349a5596 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4820,6 +4820,28 @@ static void clear_triggers(void)
 		clear_instance_triggers(instance);
 }
 
+static void clear_instance_error_log(struct buffer_instance *instance)
+{
+	char *file;
+
+	if (!tracefs_file_exist(instance->tracefs, "error_log"))
+		return;
+
+	file = tracefs_instance_get_file(instance->tracefs, "error_log");
+	if (!file)
+		return;
+	write_file(file, " ");
+	tracefs_put_tracing_file(file);
+}
+
+static void clear_error_log(void)
+{
+	struct buffer_instance *instance;
+
+	for_all_instances(instance)
+		clear_instance_error_log(instance);
+}
+
 static void clear_all_synth_events(void)
 {
 	char sevent[BUFSIZ];
@@ -5564,6 +5586,7 @@ void trace_reset(int argc, char **argv)
 	clear_filters();
 	clear_triggers();
 	clear_all_synth_events();
+	clear_error_log();
 	/* set clock to "local" */
 	reset_clock();
 	reset_event_pid();
-- 
2.25.1

