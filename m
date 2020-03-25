Return-Path: <SRS0=JHVT=5K=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3510C43331
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Mar 2020 14:08:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB2E82076A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Mar 2020 14:08:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C8y4WiMp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbgCYOIh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 25 Mar 2020 10:08:37 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41936 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727674AbgCYOIh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 25 Mar 2020 10:08:37 -0400
Received: by mail-lj1-f195.google.com with SMTP id n17so2572124lji.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Mar 2020 07:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bx2vhLd9A10pPdSpJQawLLkRnk4zgAdWmR1tl4J7pcc=;
        b=C8y4WiMpJcp0RMRkaQ4LrZqPmZiEgpGyHw0npbbRv4yyC7BvXHfWrpQUK/GD6gZZDd
         yLX3XUDJUvp2voAbv4N3guthoBayJO+r7tzsY9cy93UT6a/q518Nmdj36kvj2hafBUTn
         nxsTsEOhQbklnXk6VxjMHD+EnoNn0o33K88eDjuAK1lft/Mkp9H5aww7laTjsz7ShQxv
         suTvcOiIgiKh16bkAYB2zXrzLI94VhFgdIPgCV+EfWP/IJwqpGlODkUTB/ouSQH9bTSW
         Z3vMjvR3BkA9YPi3eHm+xovWuUUDl/A7eQtTAa+S0qlST9jcQ10hw26nFH0fZt6DLxJ9
         obyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bx2vhLd9A10pPdSpJQawLLkRnk4zgAdWmR1tl4J7pcc=;
        b=aBUfo13B3oDUtlpX2wcMRzunN9/JNZgFd9IAXSfly1Llnw8ru0xx+wLn3X8ioce+O1
         QyWjZqzDr4nl1njC7qCurLxxuhXYHratEh/BcdIRNIfTLKGOj/mA3+djWzB4IMIruM0X
         8/qmov7pzu9PR1RQjmbhIcZBEKfpXLyfIqfJGwIrkdbesEr91Js9eNnvfE0LyfqCpqKz
         Mv+9VelUYe8a/uNiqKvyScTXz2GoBp/yDn7oMXAk3k+wXlswUBD9rP49Hm0WxP8TLNuD
         Jabj2e7JRexT79iEFRm3ewtBkRpSGBMZ14W06cLFo7viJ5SLE7Y2/v239N4ofgv48ee7
         8Ecg==
X-Gm-Message-State: AGi0PublvQSYoTy+yaIvxPlyzOIPsnTflaSPJmx9crRRI4PRUkDv1So1
        swaQqvCExgACj+b9ED4J4S8=
X-Google-Smtp-Source: APiQypL8bnEjIwUxwq2MQBS40WBCtVKci0+rAmWtqMJO5SGhPiRKDF1yepX5qX/L5iN6SPBWLs0pRw==
X-Received: by 2002:a2e:9bd1:: with SMTP id w17mr2030939ljj.283.1585145314865;
        Wed, 25 Mar 2020 07:08:34 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v9sm12017301ljv.82.2020.03.25.07.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 07:08:34 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/3] trace-cmd: Fix double free error when triggers are configured on multiple events
Date:   Wed, 25 Mar 2020 16:08:28 +0200
Message-Id: <20200325140829.184651-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200325140829.184651-1-tz.stoyanov@gmail.com>
References: <20200325140829.184651-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When using trace-cmd "-e sched:* -R ..." command to set triggers to the all events
of given subsystem, trace-cmd fails with a double free error.
The problem is in create_event() function, where the config is expanded to the all
events. The same "event->trigger" pointer is copied to all events. Later, when the
trigger is applied, the update_event() frees this pointer multiple times.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index ec3bcae9..7dbf599a 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -2702,7 +2702,8 @@ create_event(struct buffer_instance *instance, char *path, struct event_list *ol
 	else
 		free(p);
 
-	if (event->trigger) {
+	if (old_event->trigger) {
+		event->trigger = strdup(old_event->trigger);
 		ret = asprintf(&p, "%s/trigger", path_dirname);
 		if (ret < 0)
 			die("Failed to allocate trigger path for %s", path);
@@ -2883,6 +2884,7 @@ static void expand_event_instance(struct buffer_instance *instance)
 		event = compressed_list;
 		compressed_list = event->next;
 		expand_event(instance, event);
+		free(event->trigger);
 		free(event);
 	}
 }
-- 
2.25.1

