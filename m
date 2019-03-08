Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F340AC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:44:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C021720661
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:44:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbfCHNoK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:44:10 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37289 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbfCHNoK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:44:10 -0500
Received: by mail-wm1-f66.google.com with SMTP id x10so12365386wmg.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:44:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B0LSgheigQKYDNu87C/yhSfypvVN6mgElsvHHKqMVDU=;
        b=sghwDJlzgCMyoePs85Y/xvpChkUrOMerL2EHCBPk8b/Q2axH6o34Ewqp8WOAzaN3Hk
         qXVi4sl+dVrpOEQ7ZMVc9lJxqg+xZu+riIYqbnkTKCw2AnEM6MR4SYgboysrMlbpydMQ
         Ase4evS8UCCbTTKlIUlmaj/kL2HH/BofLPwDeOxL9C4CjGNRvTYOE7ZCR7iaeLGaN0K7
         fUaXDe4PZxiU6VOrs9rUT4ma40ZTeUphx/J+az0PXyMOQDrGa+0TKBllwDW5I//Ks0Np
         EhJCwjxOVJKedtdbdoXerydQSe+ZZnOa9Bpuu+QgCKq+tcVMmShyl7IGG93ZkImIXLFi
         rLmQ==
X-Gm-Message-State: APjAAAWHEY7/tZO5Slku4/wWD2F5t7iK/wnXckB2Y4TPXHpxQs6leA41
        otpPx1PqaSOyxVrQLjpVVQ4=
X-Google-Smtp-Source: APXvYqy6lFi9nJ4r6VBxa8PgXOsTfrH/VOERUQP2ywOVvATsa55L4sxMqSz4egaahkLm0EgAmbBUwQ==
X-Received: by 2002:a1c:1a86:: with SMTP id a128mr9277243wma.67.1552052648590;
        Fri, 08 Mar 2019 05:44:08 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t16sm5650943wmj.47.2019.03.08.05.44.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:44:08 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/6] trace-cmd: Fix "trace-cmd reset" command to restore "tracng_on"
Date:   Fri,  8 Mar 2019 15:44:00 +0200
Message-Id: <20190308134405.21921-2-tstoyanov@vmware.com>
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
By default, "tracing/current_tracer" is "nop" and "tracing/tracing_on" is "1".
This patch sets "tracing/tracing_on" to 1, when the command "trace-cmd reset"
is executed.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/trace-record.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 8beefab..fc658b2 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4496,6 +4496,8 @@ void trace_reset(int argc, char **argv)
 	clear_triggers();
 	tracecmd_remove_instances();
 	clear_func_filters();
+	/* restore tracing_on to 1 */
+	tracecmd_enable_tracing();
 	exit(0);
 }
 
-- 
2.20.1

