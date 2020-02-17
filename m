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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58D44C34022
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Feb 2020 17:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32E1F20725
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 Feb 2020 17:40:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W8iKmwFm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729331AbgBQRkK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Feb 2020 12:40:10 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41950 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbgBQRkJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Feb 2020 12:40:09 -0500
Received: by mail-lf1-f68.google.com with SMTP id m30so12454504lfp.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Feb 2020 09:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xMitNcptm8evXgZbVR7z8Uz24VrIh48Mnh6jK7793Dk=;
        b=W8iKmwFmtf63rtAa/h8ZrCCLKf/KUtLwt8x3tyl6M82+LqEGHFP174Y73veYwiqcX8
         /CL2CK2AByfZQs+HDHLVzFhA9IDA34aCR2NmzdMTcofBSzXRYotgcvwzr8DTWrhPDWN6
         32M6vprjlQb61aWVoKq1Ej/1XXpkxfAznZykErYtbb7c/VulZZ8VUDR+ckY8kGT7XCeO
         Alw0LO0L6Qxl3tA+W2CpPoP50yCjHkdiLB/w+dtCnpB3V0bnUvoJoZIikCwLSfIusg0X
         YBujs0ZipVsD7PmhB87d68wYspppgJcotNqbRanKevUMjsORLObJZC0CaWs7VYenRDuI
         bH2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xMitNcptm8evXgZbVR7z8Uz24VrIh48Mnh6jK7793Dk=;
        b=nz9lXN0yl5CpRx92m6cC4ZPnhmUhNY0Mvr/jzWN1cHDQWquOUNV/eErqGkMDABvyCr
         d4tpkxPnZNtQ+MQc3WD65VQ9U/shyfXeiOLBqR30+q/GlUVfJCPBl8Q4gfqC6aJCRKlW
         HGy1qFIbEl5vQ0p+D8OHjfeoOUdSnhzL/Q6anP0+BOO1sHtkvzZSHGwUAwiKWTRWSfVV
         4TUoDhED4338TQSi2dOl9IOfVlHx0eYvEWU5JrOhZbg2J3VSZUmEi4szoqW6Ef06d5LZ
         wMWatnKgxwv5JJzBbO+pbwxYKlYGou1ewNoH5xMUksslRbNDzPrXMBVP/fZxGcm7f3UU
         b/1Q==
X-Gm-Message-State: APjAAAWyUgao4MEX2D96Fvgj5868wj6P/DmjYNhCQ/TQjmg4lW48o0+T
        ZaK7Cl+swpjRvDjvuSEsKazcTh/N8PM=
X-Google-Smtp-Source: APXvYqyXZuWy7ttsZ7NOiNv91ybNiT2hVFtMgPwC3oboz0O3XQDY6IppOPxIl/ZB3GZsMzvj/cuK4A==
X-Received: by 2002:ac2:523c:: with SMTP id i28mr8467740lfl.104.1581961207588;
        Mon, 17 Feb 2020 09:40:07 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e8sm933508ljb.45.2020.02.17.09.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 09:40:07 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/4] trace-cmd: Clear error log on reset subcommand
Date:   Mon, 17 Feb 2020 19:39:58 +0200
Message-Id: <20200217173959.385278-4-tz.stoyanov@gmail.com>
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
However, the ftrace error logs are not reseted.
A logic is added to delete the content of "error_log" file when "trace-cmd reset" is executed.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index b6a412e..3e0d066 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4638,6 +4638,25 @@ static void clear_triggers(void)
 		clear_instance_triggers(instance);
 }
 
+static void clear_instance_error_log(struct buffer_instance *instance)
+{
+	char *file;
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
@@ -5382,6 +5401,7 @@ void trace_reset(int argc, char **argv)
 	clear_filters();
 	clear_triggers();
 	clear_all_synth_events();
+	clear_error_log();
 	/* set clock to "local" */
 	reset_clock();
 	reset_event_pid();
-- 
2.24.1

