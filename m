Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C135C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:23:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C6BA610E6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:23:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbhINNZA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbhINNZA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:25:00 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E7EC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:23:43 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id c22so18483939edn.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7/tzADKHCs+G6aHZyQMgF666aPdEc8iV9Wpqr5trpyE=;
        b=R3gVnQ9nmdRezn+L2dJTAv0kGBOF1YMW0cvpG7GfEYi7+BoBma3vLBsuT8jwLhczFb
         QDZWe0pkQ6nV4BbWZSA3W4yeIJBFGa+XOScJacsyTP+fbc4l5CmKTKrzzVbIIWUyi9CK
         fuaQ4Yg0IgggH7pxy2hLwl5X8VAFmQhLdQcXCt/xcdgufDMOhFCB6lfp6z3FpvGvHVND
         wSqmy08tabEDjRJvxK12jfQmVO8qRbe7Hg+5KhXlQQxiqLr1FLiYbxLAzoTRVoG5W2Hc
         qvrFyNzGwHv7BnFN2NXuuEbqZG5pYkahLHxqLRIz1vzkdl14qpn9FhhMXJLLVmnhswVI
         p2aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7/tzADKHCs+G6aHZyQMgF666aPdEc8iV9Wpqr5trpyE=;
        b=Job0P8KHaK0EYtXM6SnydFGoYVcmaoXOcwgIrEYnlDGXyj+e7A1ciRs7TOQvL19/Zd
         mJSmzOpw4xZ1iod7ixu0HFJqAIo3sdRqrN3viTTdnOgI6p5Gh/3qVRzq6+jjzvt0ym39
         p96QYsYZzVMUy3/VMv1UYoKLWxOOHEeDuA8fCi039K6oHzJJxKdkjVVkfYqno2Io9soi
         97wZ5zY0cIGTSEn8HCCKwdZ/qZdWuw1Yi2u4/nkPPBnw+rwOp0q6tly/pnEcO1U2ELEN
         RRqpq1xemUrvi6sQOC8ALO4trtdU7VTz48GJ983LMaDgAgLgrCt3MmjTJTuWPPfbyjCP
         sv5A==
X-Gm-Message-State: AOAM5322pirAg7aDYnv0VlYHwA4gPnenrWSlvNJp5fbvPQucYFRa+MS3
        Ik2BmmWYzQZK8NWGG0v/eb4x/lZKdYM=
X-Google-Smtp-Source: ABdhPJwQJZ5i6H5Bc0Inja2LkC7u84xXuMX1kwtqSRL4jxMjMSLTzxG62UKVGBtEz6cSPQivGVldsQ==
X-Received: by 2002:a05:6402:5188:: with SMTP id q8mr18750771edd.138.1631625821796;
        Tue, 14 Sep 2021 06:23:41 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h10sm5689970edf.85.2021.09.14.06.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:23:41 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 3/4] tarce-cmd: Update record man page
Date:   Tue, 14 Sep 2021 16:23:36 +0300
Message-Id: <20210914132337.3969125-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914132337.3969125-1-tz.stoyanov@gmail.com>
References: <20210914132337.3969125-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documented new arguments of the "trace-cmd record" subcommand:
 --compression
 --file-version

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd/trace-cmd-record.1.txt | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/trace-cmd/trace-cmd-record.1.txt b/Documentation/trace-cmd/trace-cmd-record.1.txt
index 96c27108..b3620474 100644
--- a/Documentation/trace-cmd/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-record.1.txt
@@ -377,6 +377,19 @@ OPTIONS
 
       trace-cmd record --verbose=warning
 
+*--file-version*::
+    Desired version of the output file. Supported versions are 6 or 7.
+
+*--compression*::
+    Compression of the trace output file, one of these strings can be passed:
+
+    'any'  - auto select the best available compression algorithm
+
+    'none' - do not compress the trace file
+
+    'name' - the name of the desired compression algorithms. Available algorithms can be listed with
+    trace-cmd list -c
+
 EXAMPLES
 --------
 
-- 
2.31.1

