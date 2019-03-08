Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90BA4C4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:44:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60860208E4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:44:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbfCHNoO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:44:14 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54446 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbfCHNoO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:44:14 -0500
Received: by mail-wm1-f65.google.com with SMTP id f3so12692217wmj.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:44:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hx45oLWm3cO7y7qj3wq6+r7jPLgvW5RIhXHj5w/9PtQ=;
        b=r+8VGTrULlAW9uFJYxLhuTDbDu/aTp3n3Dp2gc5NRCC7xEKMeMZzL0UX+8cUEi2WMX
         UVXp8XY/317nSdPvJP/2KwFhVMwasIsyCdJmqs1Osx38DGk4zxcDalmYhtJQVhJbIuTl
         +oaIW/fTRsfNiRJsMs+h85te4HV/kTEMQpdhdBabQ0yqB4RUx6yNHpov3J+0eWYa1Ej5
         dUn/p1sodyG0Hz0r+b6L2FCsaCNSrVjP2PrukG9sXt4RHl+ATzm2lR0vy+c/TrXHEV14
         tWIZQfmypWl1ymVOlV3MR1gJLft//SRKk7l8Pdmhh+XCyXzU+mQeuKzrGbvTXuJwn1aw
         MeFQ==
X-Gm-Message-State: APjAAAXwg455lFjPWlOT65BNICxSSAYUQs0IoQ5uDu1JsTRSwHWbB27g
        euacVC5U/h7A0QiprUYXyfSewQ4a
X-Google-Smtp-Source: APXvYqyhYsB2ox9xVegsT9lRm4GukPe0cBhAc0YTd5YXayGVfgTuhV4hb4XJZQ6DIywyy+NycYtx+Q==
X-Received: by 2002:a1c:67c2:: with SMTP id b185mr9363444wmc.68.1552052652351;
        Fri, 08 Mar 2019 05:44:12 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t16sm5650943wmj.47.2019.03.08.05.44.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:44:11 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 5/6] trace-cmd: Fix "trace-cmd reset" command to restore the default value of set_event_pid
Date:   Fri,  8 Mar 2019 15:44:04 +0200
Message-Id: <20190308134405.21921-6-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308134405.21921-1-tstoyanov@vmware.com>
References: <20190308134405.21921-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The "trace-cmd reset" command should restore ftrace to its default state.
This patch sets "tracing/set_event_pid" to an empty string,
when the "trace-cmd reset" command is executed.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/trace-record.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index a398723..bdf0c02 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3796,6 +3796,12 @@ static void reset_clock(void)
 		write_instance_file(instance, "trace_clock", "local", "clock");
 }
 
+static void reset_event_pid(void)
+{
+	add_event_pid("");
+}
+
+
 static void clear_triggers(void)
 {
 	struct buffer_instance *instance;
@@ -4499,6 +4505,7 @@ void trace_reset(int argc, char **argv)
 	clear_triggers();
 	/* set clock to "local" */
 	reset_clock();
+	reset_event_pid();
 	tracecmd_remove_instances();
 	clear_func_filters();
 	/* restore tracing_on to 1 */
-- 
2.20.1

