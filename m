Return-Path: <SRS0=t4cO=RO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE685C10F0C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 08:33:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D7C82084D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 11 Mar 2019 08:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbfCKIds (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 04:33:48 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35998 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbfCKIds (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 04:33:48 -0400
Received: by mail-wm1-f67.google.com with SMTP id j125so3345701wmj.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 11 Mar 2019 01:33:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hx45oLWm3cO7y7qj3wq6+r7jPLgvW5RIhXHj5w/9PtQ=;
        b=JA1xu2IIaFDqOAMLElqsNFLBmGaIvMN+js91geUlvCvjB/MWCbd5vuVCEKbnc7ECG+
         CRXWRIS7Kof8EO9E+RapJ1f6SvZC0W5RZaY/Pc3Aa7Hkqh47c0u3jayBIZRvyFxs4avp
         5v3Pw9+qNKbJbo1fZLt78UaeMDlTflVIHIBrv93T+UkOGr+IVL+OwRqhFrrDAu21Zght
         bfGYMAx4M6iaSMiPlqmQ3jbdSMzZA3IcwGo6JWHzeZb118sgy20yGzIIgINKebSoIrQJ
         nW4gfcpZN4Swoo6R7H4Gl2k8QI2ozhXyj8U6stFTlstxVdK4FkRkvH4cd3bO0gMBbb5G
         377g==
X-Gm-Message-State: APjAAAU3t4qPWKnx6W8/PZblCpsw7Xrbq7bwhYdFdW+vkmc0FP3Ro27p
        Js1vvqLmG9uiwcc29NnDNMd6RbPR
X-Google-Smtp-Source: APXvYqw9NFwSu6WNbazfb2sxpnJsDnFo9CZlsCWdJpj+E3Ewqdq8u3n/DOmG/jAoY7huSMKTHMuT7g==
X-Received: by 2002:a1c:2097:: with SMTP id g145mr15823311wmg.81.1552293226356;
        Mon, 11 Mar 2019 01:33:46 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x17sm19683835wrd.95.2019.03.11.01.33.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Mar 2019 01:33:45 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 5/6] trace-cmd: Fix "trace-cmd reset" command to restore the default value of set_event_pid
Date:   Mon, 11 Mar 2019 10:33:38 +0200
Message-Id: <20190311083339.21581-6-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190311083339.21581-1-tstoyanov@vmware.com>
References: <20190311083339.21581-1-tstoyanov@vmware.com>
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

