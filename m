Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71B88C10F0C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:44:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AE1820661
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:44:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbfCHNoP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:44:15 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52107 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfCHNoO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:44:14 -0500
Received: by mail-wm1-f66.google.com with SMTP id n19so12577210wmi.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:44:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k7RzuzhhDaG+aYWpS7qXWP855XoYR2nMC0Urv+Xlnno=;
        b=k/kmCdbK8G0M9Y2gY4t3ir+/EjmHTLiNQsOWNzQiG9XcGNpfXHfkKBMx6rq/JfbR/H
         ON6xHdjtWpiF/wPq9je/8zC/N5COqdWpY+vTvJhfLzOPdVoop2RjczNsT0fkgRWaKZm9
         ATvxYNHEGNgwYMXzKCtvgcCnzKER+N0m3fn4JEtoI+fKXctuJ86dUb8Z8TPtBHTHRW1B
         /IIX7T0k9kQa5ZgJqljvPkp0EWAjo1gve/zbXfk2Ey9KJJotkp8ii7q85BIOGV6Addq2
         zBY8wI9xJ0WT3xb7qTQeSRMs95r0ABYhz2+xnrqCiTHJ6ej8R9PsXuEZryo4QcFkhvc7
         cZuw==
X-Gm-Message-State: APjAAAVUOLdJYOMZ9JCb/eh0BYWKylcaB/gj9gt5ehh90rBdI6+nmQuA
        LPyeFe+MFn0d5nF2ugJBjNLRXRnm
X-Google-Smtp-Source: APXvYqyHDXgUGzVOUrepZUI2lFcufefIPKmWtMsz85mOqN3Bky8WSvDNTuClJsmYPJWk6XheCopu9Q==
X-Received: by 2002:a1c:2c4:: with SMTP id 187mr8976416wmc.77.1552052653231;
        Fri, 08 Mar 2019 05:44:13 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t16sm5650943wmj.47.2019.03.08.05.44.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:44:12 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 6/6] trace-cmd: Fix "trace-cmd reset" command to restore the default value of tracing_max_latency
Date:   Fri,  8 Mar 2019 15:44:05 +0200
Message-Id: <20190308134405.21921-7-tstoyanov@vmware.com>
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
This patch sets "tracing/tracing_max_latency" to 0,
when the "trace-cmd reset" command is executed.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tracecmd/trace-record.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index bdf0c02..f4dac2f 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3801,6 +3801,14 @@ static void reset_event_pid(void)
 	add_event_pid("");
 }
 
+static void reset_max_latency_instance(void)
+{
+	struct buffer_instance *instance;
+
+	for_all_instances(instance)
+		write_instance_file(instance,
+				    "tracing_max_latency", "0", "max_latency");
+}
 
 static void clear_triggers(void)
 {
@@ -4506,6 +4514,7 @@ void trace_reset(int argc, char **argv)
 	/* set clock to "local" */
 	reset_clock();
 	reset_event_pid();
+	reset_max_latency_instance();
 	tracecmd_remove_instances();
 	clear_func_filters();
 	/* restore tracing_on to 1 */
-- 
2.20.1

