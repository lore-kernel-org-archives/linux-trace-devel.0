Return-Path: <SRS0=rw6q=Q5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C30AC4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 18:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E30D2075C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 18:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfBVSFv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Feb 2019 13:05:51 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38423 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727718AbfBVSFu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Feb 2019 13:05:50 -0500
Received: by mail-wm1-f65.google.com with SMTP id v26so2776361wmh.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Feb 2019 10:05:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iu4Fyc42UQyrYE5Tk++BlWaRY8br2iwqhsYk9tm7HOQ=;
        b=Ekv/+pnUfyOvJIcaJ0MjCT/TRilLHLko16xKIMZKEfB9waBxQk69TNL+0TvfGEuRpZ
         9Ti8MHlxfBtmFXlU4JAWMBCnTTtD1U2O/XpFlnZg/8j/u8aDbhPwpQBWnmacNLrUuzJl
         jIwk1LaQqASXXSdxjLychBZa51IyR7lIqnWGWsVQDctRMHOwkOZeVxscU+ZGaJPduXuq
         vR2Svjt8LglQhaXQFFdJEW4x+t5v1/SKbUknnENbers1LTdcrPKF3BGIR9DgaFLuOU2u
         FmVcbjGd1wdlP6F1ora6XcXclFc5rMgpz2AbzJi/ZGq+LXnKsTCUcSTkTMDdwVyUFs5K
         l2+w==
X-Gm-Message-State: AHQUAuaZtK42jX1Zr8Q7Cvv2bkuay00B37RB7d5y3v+8d/gxUYlHAzq0
        Z1DzRJ9RXVM2qorZq1CfDYkweX0=
X-Google-Smtp-Source: AHgI3IZ+8rqWTTgksk4TUWfB1WnlmV+Cz2YFzkvMGCaE4719EXuomVdu7IIGG4wi3eKdY4CmiDkNeg==
X-Received: by 2002:a05:600c:2144:: with SMTP id v4mr3205909wml.4.1550858748382;
        Fri, 22 Feb 2019 10:05:48 -0800 (PST)
Received: from localhost.localdomain ([146.247.46.6])
        by smtp.gmail.com with ESMTPSA id c18sm1320678wre.32.2019.02.22.10.05.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Feb 2019 10:05:47 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v8 02/13] trace-cmd: Minor cleanup in print_stat()
Date:   Fri, 22 Feb 2019 20:05:28 +0200
Message-Id: <20190222180539.27439-3-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190222180539.27439-1-kaslevs@vmware.com>
References: <20190222180539.27439-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Do an early out in print_stat() when `quiet` is set instead of rechecking it on
each loop iteration.

No changes in behavior intended.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-record.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 8beefab..88b4a55 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3106,13 +3106,14 @@ static void print_stat(struct buffer_instance *instance)
 {
 	int cpu;
 
+	if (quiet)
+		return;
+
 	if (!is_top_instance(instance))
-		if (!quiet)
-			printf("\nBuffer: %s\n\n", instance->name);
+		printf("\nBuffer: %s\n\n", instance->name);
 
 	for (cpu = 0; cpu < instance->cpu_count; cpu++)
-		if (!quiet)
-			trace_seq_do_printf(&instance->s_print[cpu]);
+		trace_seq_do_printf(&instance->s_print[cpu]);
 }
 
 enum {
-- 
2.19.1

