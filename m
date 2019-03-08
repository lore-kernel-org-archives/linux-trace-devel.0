Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 419F1C10F09
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 14:31:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13D6C2085A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 14:31:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfCHObc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 09:31:32 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41938 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbfCHObc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 09:31:32 -0500
Received: by mail-wr1-f65.google.com with SMTP id n2so21587627wrw.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 06:31:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HjgYILSVk6MYR5w1Q9TxlsvwEb/cp6vZNW3Z/pHTu9g=;
        b=MMOzKWX6JnI6Rrv6pipUrbH9bMQSm+TaBRnkhmXAkK7NY9/Sy4HKGrjP01veHrnB7y
         UVuYrwWFJmk/P3ucPvMAJNhxwzBW2Qe37NykuTGszT9p5W0w7Sj7SvR2w1hRGRt0tlzF
         nQYhZwSumIRUcxbjtrEpQrVkXb/fdr/jg41eb9p63zh3IrkhzMaNWKcZ/meoMcdp/hJN
         LpRhoYc18Vh5PX5pEULCLOFSMfWsPXyS+IjKX1Ew5YIqbsp9zxsRHacV5vfvAkXgfcbt
         O7kQbv49MnUTzjXgvP5tMlstM67e/8BohPKuZZCvvoadmb2UDNczE8b6w6yOY4qiRxnM
         Nxag==
X-Gm-Message-State: APjAAAUh8Ys2QtDG9Bp2B7XjDpOna0WLtNedNVAC8HY+g2IoKIm0ODQB
        kC57Xns+CJ4/Wb+RxHamfJA=
X-Google-Smtp-Source: APXvYqx5JZjILDPE9iOJ6/mGOfVOhckJbCFsnIewOA2LdgVFaXI/eZ5gIGDbcCOwBY0g75f+xvSNiQ==
X-Received: by 2002:adf:fc87:: with SMTP id g7mr10936943wrr.136.1552055491076;
        Fri, 08 Mar 2019 06:31:31 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t3sm13495654wmc.20.2019.03.08.06.31.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 06:31:30 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 4/7] trace-cmd: Fix "trace-cmd reset" command to restore default clock
Date:   Fri,  8 Mar 2019 16:31:22 +0200
Message-Id: <20190308143125.31168-5-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308143125.31168-1-tstoyanov@vmware.com>
References: <20190308143125.31168-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The "trace-cmd reset" command should restore ftrace to its default state.
This patch sets "tracing/trace_clock" to its default value "local",
when the "trace-cmd reset" command is executed.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/trace-record.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index d7267fe..6972b9f 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3793,6 +3793,14 @@ static void clear_filters(void)
 		clear_instance_filters(instance);
 }
 
+static void reset_clock(void)
+{
+	struct buffer_instance *instance;
+
+	for_all_instances(instance)
+		write_instance_file(instance, "trace_clock", "local", "clock");
+}
+
 static void clear_triggers(void)
 {
 	struct buffer_instance *instance;
@@ -4494,6 +4502,8 @@ void trace_reset(int argc, char **argv)
 	set_buffer_size();
 	clear_filters();
 	clear_triggers();
+	/* set clock to "local" */
+	reset_clock();
 	tracecmd_remove_instances();
 	clear_func_filters();
 	/* restore tracing_on to 1 */
-- 
2.20.1

