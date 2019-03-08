Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3517C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:44:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A587520661
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbfCHNoM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:44:12 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46132 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbfCHNoM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:44:12 -0500
Received: by mail-wr1-f68.google.com with SMTP id i16so21398575wrs.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 05:44:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HjgYILSVk6MYR5w1Q9TxlsvwEb/cp6vZNW3Z/pHTu9g=;
        b=SS6IGPb7B40RDYRNj7Pr4BHhrklY+ZDZemk0rj4iQiR5P50DpGjmWo89JRQzFLE8+m
         KT4SpZ19YN8kl+I1t/EdNFTbMo8EogKSuZgy7Dg+CrcWpNcqfPlnV9tvQuM2iJwJxU4R
         VuFqhV1/l1g0kfWeP9MQe46mX5e1H+plGKTjkC8KnowJXHGDbK8WFr+I84v/10dQVtI+
         VooEIU59nPVrrEM3vdJXnzvSYZNNVjwnNY3hfAZLNAuEbxTSHZ9C+A49yP83HreDn/ty
         TqFN4OPicgH+FkfHw6dr1XSyDG9XxrouOSUH9fR0YnPMFhFdeBoTWN+3nucS1EYOIU+d
         fA2A==
X-Gm-Message-State: APjAAAXIT1Kyab0on1d7ffHl+nxf9/ZEZntul3iFXOqFid/bkGX7HCH7
        t+nAacuYhJGoiCyruFo1+Rg=
X-Google-Smtp-Source: APXvYqyGTYmTOBwsECP61LSTSceMoIOnZbpb0xqdmiHeXA9AzCNHhFQseSgs5Z8IpR8CGNs5fJVKGQ==
X-Received: by 2002:adf:f88f:: with SMTP id u15mr4358645wrp.117.1552052650608;
        Fri, 08 Mar 2019 05:44:10 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t16sm5650943wmj.47.2019.03.08.05.44.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 05:44:09 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 3/6] trace-cmd: Fix "trace-cmd reset" command to restore default clock
Date:   Fri,  8 Mar 2019 15:44:02 +0200
Message-Id: <20190308134405.21921-4-tstoyanov@vmware.com>
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

