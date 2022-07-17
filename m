Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B226C433EF
	for <linux-trace-devel@archiver.kernel.org>; Sun, 17 Jul 2022 15:11:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbiGQPLN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 17 Jul 2022 11:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233051AbiGQPLM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 17 Jul 2022 11:11:12 -0400
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8146513DF1
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Jul 2022 08:11:11 -0700 (PDT)
Received: by mail-pl1-f176.google.com with SMTP id l12so7033075plk.13
        for <linux-trace-devel@vger.kernel.org>; Sun, 17 Jul 2022 08:11:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9hvKI70aa1h+Z/QVsAcwH5lVSRctqGxHbWtZo+6uOgc=;
        b=wqgf+vYNcis3NpnHi979so/ZBn2rMCT1vFf3ZpyHiFconYskgsk0V4KdMuosTidhrW
         1so4HrTL3OFKsxIe38AZBvTD+FexxySyWKGfo1vI5lyWW7xsnzE1Yti05QMf+lc/WoS1
         dZzWwFHAAaduQMLSvuIrxn21zr69/lnXr/afUrMBlLu2ZISV308Ot3N/BHF3TKAV1YvR
         ujSIjLc/kDT56wX83TbaSvibsDrU4t9VltBhBsR/84rotvfyF4MRw2hiSNe0gB3GJVk6
         iZ2gR2kXn2yp6esioLnzcOy4dMd+WMAmmc7nQh7ab2CRsFPJDAXSQ9Gfe4hIx957iwBb
         ynsA==
X-Gm-Message-State: AJIora/2hlcL7dpB9q0+6i8XmrBwUmDJc06eYDLJZAat7obteu4hDdK2
        qC3VjZXfmqtP3iZwhje70rcN4zIGWKs=
X-Google-Smtp-Source: AGRyM1s0KqS4EvNHx0FKdqBaQCQAGuPIJpQQYB4TjrOdCI1s9gW9mFSAA4HDTRxPZJl6P2K3K50uPQ==
X-Received: by 2002:a17:902:da85:b0:16c:bf2e:fac7 with SMTP id j5-20020a170902da8500b0016cbf2efac7mr14929898plx.166.1658070670906;
        Sun, 17 Jul 2022 08:11:10 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id w5-20020a17090aaf8500b001ef8c81959dsm7364838pjq.16.2022.07.17.08.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jul 2022 08:11:09 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] tracing: Suppress sparse warnings triggered by is_signed_type()
Date:   Sun, 17 Jul 2022 08:10:47 -0700
Message-Id: <20220717151047.19220-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Using a __bitwise type in a tracing __field() definition triggers four
sparse warnings in stage 4 of expanding the TRACE_EVENT() macro. These
warnings are triggered by the is_signed_type() macro implementation.
Since there is no known way of checking signedness of a bitwise type
without triggering sparse warnings, disable signedness checking when
verifying code with sparse.

Note: work is in progress to improve sparse but has not yet landed. See
also "[PATCH 0/5] allow -1 and compares in bitwise types"
(https://lore.kernel.org/all/20220627190540.13358-1-luc.vanoostenryck@gmail.com/ ).

Suggested-by: Christoph Hellwig <hch@lst.de>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/linux/trace_events.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index e6e95a9f07a5..e43f0f37ef27 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -814,7 +814,19 @@ extern int trace_add_event_call(struct trace_event_call *call);
 extern int trace_remove_event_call(struct trace_event_call *call);
 extern int trace_event_get_offsets(struct trace_event_call *call);
 
+/*
+ * There is no known way to check signedness of __bitwise types without
+ * triggering a sparse warning. Hence the #ifdef __CHECKER__.
+ *
+ * Since there is another definition of is_signed_type() in <linux/overflow.h>,
+ * undefine is_signed_type() before redefining it.
+ */
+#undef is_signed_type
+#ifdef __CHECKER__
+#define is_signed_type(type)	0
+#else
 #define is_signed_type(type)	(((type)(-1)) < (type)1)
+#endif
 
 int ftrace_set_clr_event(struct trace_array *tr, char *buf, int set);
 int trace_set_clr_event(const char *system, const char *event, int set);
