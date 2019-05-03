Return-Path: <SRS0=scwk=TD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48227C43219
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 14:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 252BA205ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 14:35:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbfECOfm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 May 2019 10:35:42 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39601 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728110AbfECOfm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 May 2019 10:35:42 -0400
Received: by mail-wm1-f66.google.com with SMTP id n25so6997481wmk.4;
        Fri, 03 May 2019 07:35:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ag5YD56R8iiokalY4V0lLd6QHIYD8KrtwfvDQho44QQ=;
        b=PyUYuZOfgS++DS4stzme8YOpP5O5YBApfAjUu78jJJuaIbfc2xwUbrDSP++8qcUY3V
         LEw5vGL7ukjhfXc5NAjYOAl12E+0iZ7gMSSHbS5OIbHJeNiGvje/qzi1I03x/GdstKc1
         8Ubrt4SLAkQZAM7H3aqE2s/qucpPA3Vx+/V+PN4oUdcGoGy08khvEpcp0Kcdh9ucjozw
         CuKnX7k1UwDXmQKc8bIb6h+Yb+Avy2onbbH3MMGFK9DWZ/HgSOFIzblcG/nHciKsfiGv
         xlNp4fMGoofrlbVVBwMkIWUd+gFTGgQeyE01PcUdN3bemy42zrtZ1h18P2pOLnJQmLnh
         LvyA==
X-Gm-Message-State: APjAAAXvF2i4CBGu3Li9DKleQlKjpsY/ESsnWJnrbCSNQiTarjM3aVDZ
        PF407n5mRwFrj3zYU0D06Gg=
X-Google-Smtp-Source: APXvYqzOroMEFBNSxsl/6EhyGicchl4mYuecrlQk1FXZjn6xNu5fsWIg+QcX0K8oFvR6BD9QoHhEmA==
X-Received: by 2002:a05:600c:24f:: with SMTP id 15mr6232702wmj.48.1556894139828;
        Fri, 03 May 2019 07:35:39 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id h131sm3990676wmh.44.2019.05.03.07.35.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 May 2019 07:35:38 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com
Subject: [PATCH] Documentation/trace: Add clarification how histogram onmatch works
Date:   Fri,  3 May 2019 17:35:37 +0300
Message-Id: <20190503143537.19752-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
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
 Documentation/trace/histogram.txt | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/Documentation/trace/histogram.txt b/Documentation/trace/histogram.txt
index 7ffea6aa22e3..b75a75cfab8c 100644
--- a/Documentation/trace/histogram.txt
+++ b/Documentation/trace/histogram.txt
@@ -1863,7 +1863,10 @@ hist trigger specification.
 
     The 'matching.event' specification is simply the fully qualified
     event name of the event that matches the target event for the
-    onmatch() functionality, in the form 'system.event_name'.
+    onmatch() functionality, in the form 'system.event_name'. Histogram
+    keys of both events are compared to find if events match. In case
+    multiple histogram keys are used, they all must match in the specified
+    order.
 
     Finally, the number and type of variables/fields in the 'param
     list' must match the number and types of the fields in the
@@ -1920,9 +1923,9 @@ hist trigger specification.
 	    /sys/kernel/debug/tracing/events/sched/sched_waking/trigger
 
     Then, when the corresponding thread is actually scheduled onto the
-    CPU by a sched_switch event, calculate the latency and use that
-    along with another variable and an event field to generate a
-    wakeup_latency synthetic event:
+    CPU by a sched_switch event (saved_pid matches next_pid), calculate
+    the latency and use that along with another variable and an event field
+    to generate a wakeup_latency synthetic event:
 
     # echo 'hist:keys=next_pid:wakeup_lat=common_timestamp.usecs-$ts0:\
             onmatch(sched.sched_waking).wakeup_latency($wakeup_lat,\
-- 
2.20.1

