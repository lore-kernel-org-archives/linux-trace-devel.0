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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CC87C35E0C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 25 Feb 2020 18:07:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BE17206E6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 25 Feb 2020 18:07:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ih5OHoFv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731218AbgBYSHq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 25 Feb 2020 13:07:46 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45869 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728762AbgBYSHq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 25 Feb 2020 13:07:46 -0500
Received: by mail-lj1-f193.google.com with SMTP id e18so15047334ljn.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 25 Feb 2020 10:07:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nEM+hVojXF6GdSMPcp02Gfgl0+hzn7rNbm8hqWQjEtg=;
        b=Ih5OHoFvJyp6cgOQ/X4dI7U+O0tra3JIvz6WHuXksqYBOx6nDcMYO9fYdSyszzmflb
         A7+2bJyJoAY2ukjRPl9vk07UZ9kmVcMAJS/BjYzfFpTaAdSn+yYa8Pqs/NIDm4THxV4S
         +Zl2C65T2JrZVKExHzzBMZrN6fqnc4eiMxKFBsU5Jc+nI8KyTaJRaHcpUsVI9VeQDcaS
         ZzbkFVBluTogs3dHY31Dtd5gU9QU19yOifjmv0uEyJiKJ2IphBbwIe9o7ze4fB05mYQo
         wb3N6WxUhSL+LiruLpc5yEw+sIptVryWgmcH76PKwOXo7GViNKK/GI/cBRLLVhAkPOEh
         vbfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nEM+hVojXF6GdSMPcp02Gfgl0+hzn7rNbm8hqWQjEtg=;
        b=ArJ2z9KCeutFsndSG7IVSR7LZKOt76u35q1fTHAfWVauqDKmcQkh3VgG0AUOmrPPlq
         7Qh/5Uy3GQPfgCH5T2BSN5v7h+h08Vr+pGiIRSCrbUPq38lNcugQX5P3/LArpWGP9Sw0
         oZBhIZLVzdhQjwX/Xkz38Ln0gpOVfEeWGzg1R72dtKyFAw5rKllFhuTL4VCdhy+6c0zk
         myEPhL6DO/agx890G76YLYD7osGULMVOmijU4zDDW7MbKcgIyZ8PhYHCd3d38hiEvJ89
         9NXT224X6/A3hTU193upsrshl/ZRkP1B/7B3CF20dTmiSjL2H3fAcH51o9yU4HQjHnwN
         yOCw==
X-Gm-Message-State: ANhLgQ05jbDD1+5ACo2XXoU4DzA+lr5+DW16zkcyBYAsTyiBpW0EEIvI
        vt7irmr+FQo6bY7olDWIVQE=
X-Google-Smtp-Source: APXvYqyFWxbFYwoGSPkZLXcSXpuvANK0p5USZ/g9abqe5kixVEpQqyY7XYQc/88LQk07nlM1dUyp0Q==
X-Received: by 2002:a2e:a402:: with SMTP id p2mr163508ljn.143.1582654063717;
        Tue, 25 Feb 2020 10:07:43 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v15sm4141438lfg.51.2020.02.25.10.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 10:07:43 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 4/4] trace-cmd: Clear error log on reset subcommand
Date:   Tue, 25 Feb 2020 20:07:33 +0200
Message-Id: <20200225180733.89344-5-tz.stoyanov@gmail.com>
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
However, the ftrace error logs are not reseted.
A logic is added to delete the content of "error_log" file when "trace-cmd reset" is executed.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 7c76ffa8..5c65a26f 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4638,6 +4638,28 @@ static void clear_triggers(void)
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
@@ -5382,6 +5404,7 @@ void trace_reset(int argc, char **argv)
 	clear_filters();
 	clear_triggers();
 	clear_all_synth_events();
+	clear_error_log();
 	/* set clock to "local" */
 	reset_clock();
 	reset_event_pid();
-- 
2.24.1

