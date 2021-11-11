Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ADFEC4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ACB361268
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbhKKPQK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233945AbhKKPQK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:16:10 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5C3C061767
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:13:20 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id z21so25428591edb.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:13:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CyGhK1rKr7dRVG5bk87ua4bXrNSMqVKfo5ItuyT1ffc=;
        b=bnM6RKVhUzwMr02C2vf2AOOMLFtds4tEmQeJNUoHiyj4xpcaYfRvVBNmLnNEuSSyac
         kq6v4a61c/WFeGvNJTJ/VKLk593D4SWrCma0cjuub21po7Z5LnE7pxGKFwHZ2pUInn3e
         2ecbOMZlBHLmEjWwgwqVBSJeMkVwRR1+S3byhT8XJsB/bnANj7UzWou5NUorU9I8s3sh
         Vjko9Gnm1n78ChVYi5/hebAUBBDD0T3NguAieZlYFT+51UpxO3zFAqBExj8jYepkXAEz
         uYzT19X7hnjMZ656NCKeJiYkI4IJDnDFJYgHj31J9LE/W0TGRpjMpJ60TrdrLYsUQyk+
         7taQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CyGhK1rKr7dRVG5bk87ua4bXrNSMqVKfo5ItuyT1ffc=;
        b=BxRUj8Htj0l8g4fDTy6iDtJKcvcs2yOVEcVYaTt9glneYw7GDLS16RHgYkLOQL/cBK
         7Zko2jpDSauqlLXA+yYeApMTHU7VEof1Jrjp9FXe+lff6DnYf389IGYUnO6nb8Uzi8xy
         MMMLvPWe7f80l3HMI1kjGttCQN6XzzuIZyBz/gPfNJMxiylf8nfQ+idoTGVdEHzpDi3h
         Q/UKq4SWYywJ1qNMajMb/MU61lukdrZf22edrQghUZ91KDNo25jgVB0p/DNK7KoFnanp
         3/wo+6M86ZZxe3rbf5uYeZNL1pb42sanAQjANDQWVC7qhrz6phe2oP4l6tZ/KdbWRf5Z
         ujHw==
X-Gm-Message-State: AOAM530UcCKa2Rzpy35aQvnZkF7E0TsiDRHTGHS1bu2wPd9YwWsMmB3O
        Z+t7oLnvB+cCz1Kgul4vUTMvvpmk9eowpQ==
X-Google-Smtp-Source: ABdhPJzhKK8eBiPlBqTDg49Ff+LCzL6XQJy06Y09Rtb9z4eX0A+Zykh3+WOycJs6xi1kQ70oHFJzDA==
X-Received: by 2002:a17:906:3a0e:: with SMTP id z14mr10419373eje.55.1636643599415;
        Thu, 11 Nov 2021 07:13:19 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gb3sm1545093ejc.81.2021.11.11.07.13.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:13:18 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 3/4] tarce-cmd: Update record man page
Date:   Thu, 11 Nov 2021 17:13:13 +0200
Message-Id: <20211111151314.87148-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151314.87148-1-tz.stoyanov@gmail.com>
References: <20211111151314.87148-1-tz.stoyanov@gmail.com>
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
2.33.1

