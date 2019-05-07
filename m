Return-Path: <SRS0=osWp=TH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B0E8C004C9
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 May 2019 14:49:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7016720825
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 May 2019 14:49:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbfEGOtu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 May 2019 10:49:50 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33887 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbfEGOtt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 May 2019 10:49:49 -0400
Received: by mail-wr1-f68.google.com with SMTP id f7so12451883wrq.1;
        Tue, 07 May 2019 07:49:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HYpLsdPWfoBOLPoyyFo9Rla4dC8XU3P9MTPhnbUzRMo=;
        b=LDp9gPhD6blPTq81jKuLLCmuwocP0b66ePHxNX/ufkki53Bkb3zmQokSdfYZa3jCWS
         +3t6fcvTPLBn5vZLsDvxup2RKqNCXYacDGNngH0Qy7hktcYozwa3t8pXsG/fqZPFq8qn
         qdxQvAH2MqPrXlBFf8THiRSg1O8OzTEESmgE6sp8pXz8xbKE8gCGlTXcXmIUQ48OUr2Q
         cw1BT/jtODHepG39zrwBBxFJyO3Gp+837henAZBKiK26vkrDK7cSZ0gKMvB+uRD4Oblt
         fJlzcTkfF1OE3/VnyEGw4zj4Aybg96OEsf7qPRDrqMK5rPrx6tqXgsaVF6YU1RlcuV4e
         ZK7g==
X-Gm-Message-State: APjAAAXAs7sXXAJXwNOh7OKAOQ1W4CZP4GyDTYaJwBsGFcdlyRj1V6Sb
        47F7zKfpDI2SgX4Tv7rjQvJfZAU2
X-Google-Smtp-Source: APXvYqydDpwYAQDLUOu4ySTqyHRcELODhmE/VJzC+qrWhORcPrUcy6y3Lz308IlnBl79Wrhc06EYPw==
X-Received: by 2002:a5d:424a:: with SMTP id s10mr11462236wrr.327.1557240588310;
        Tue, 07 May 2019 07:49:48 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id v1sm13536800wrd.47.2019.05.07.07.49.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 May 2019 07:49:47 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com
Subject: [PATCH v2] Documentation/trace: Add clarification how histogram onmatch works
Date:   Tue,  7 May 2019 17:49:46 +0300
Message-Id: <20190507144946.7998-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The current trace documentation, the section describing histogram's "onmatch"
is not straightforward enough about how this action is applied. It is not
clear what criteria are used to "match" both events. A short note is added,
describing what exactly is compared in order to match the events.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 Documentation/trace/histogram.txt | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/Documentation/trace/histogram.txt b/Documentation/trace/histogram.txt
index 7ffea6aa22e3..d97f0530a731 100644
--- a/Documentation/trace/histogram.txt
+++ b/Documentation/trace/histogram.txt
@@ -1863,7 +1863,10 @@ hist trigger specification.
 
     The 'matching.event' specification is simply the fully qualified
     event name of the event that matches the target event for the
-    onmatch() functionality, in the form 'system.event_name'.
+    onmatch() functionality, in the form 'system.event_name'. Histogram
+    keys of both events are compared to find if events match. In the case
+    multiple histogram keys are used, both events must have the same
+    number of keys, and the keys must match in the same order.
 
     Finally, the number and type of variables/fields in the 'param
     list' must match the number and types of the fields in the
@@ -1920,9 +1923,10 @@ hist trigger specification.
 	    /sys/kernel/debug/tracing/events/sched/sched_waking/trigger
 
     Then, when the corresponding thread is actually scheduled onto the
-    CPU by a sched_switch event, calculate the latency and use that
-    along with another variable and an event field to generate a
-    wakeup_latency synthetic event:
+    CPU by a sched_switch event (where the sched_waking key	"saved_pid"
+    matches the sched_switch key "next_pid"), calculate the latency and
+    use that along with another variable and an event field to generate
+    a wakeup_latency synthetic event:
 
     # echo 'hist:keys=next_pid:wakeup_lat=common_timestamp.usecs-$ts0:\
             onmatch(sched.sched_waking).wakeup_latency($wakeup_lat,\
-- 
2.21.0

