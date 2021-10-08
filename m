Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AE8EC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:29:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F25BC61073
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:29:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhJHEbL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233764AbhJHEbK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:31:10 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10445C061755
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:29:16 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id y12so18045042eda.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7/tzADKHCs+G6aHZyQMgF666aPdEc8iV9Wpqr5trpyE=;
        b=dC0iJfd73MM17VMRubGGRtR1pr+oHm00lsGtTzfetNjIGXpgEMnOJ1bJcpZR2Lf6Mu
         VMap4Vrx8H85pRLov28g1uWgUe+rpc8q3Ymv6g5SEj2zCHbh7NISiCNn18W//kGUDJGB
         /gPRG5sIEpli9cWdnbXzu+R7xxt+VTVfMRLsAnUFbK9vo0u67pOLWMrA9xpCkDsT0jky
         R5Mjx6MdtM2bevR5YtjVp//YiQl/o8X2xgo6rdsMnxJeqNe1yOIhyvSkUy2O7C8xh6H2
         Av5YwaoFWyfxVKOgdGQdV6OFgvBkJ6x0rwkQddRIEzmnMcsZ0s8/uTrWBxgS/RS/GPAD
         vnpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7/tzADKHCs+G6aHZyQMgF666aPdEc8iV9Wpqr5trpyE=;
        b=h0nJCCZjrBGkzb7kVoppWK0DP+iDnR85hj1bUQuBWxiNtExEj/1eLdMV3VgdJu0KWY
         oPaVrD9Gu8K/npoANMQWxSQ93pQhesczV6zMVowCA3scWQjuqqKF5vDx/thjJRsZuZ6t
         SB8l86BsF96EHxUBDa9TCzO1U79TfYtyLXdWaSchW+k+gQZmJ53dyR5bWPttPyavdtVc
         1I5ovfZrTMnZ2CyJowAIyYPkXGx0bMAejZpEC5PrAlpSft57qhAptiyCURvbBdFopfxO
         oHz+/80FAN3TFCtR505XiPcRw1LTqxhCvXtiab1VOUaCB1Y3t2g6/Z9mxj6dD4/BdtOJ
         8jgg==
X-Gm-Message-State: AOAM531zh2Z5uc58OQ9Lumwd7b/nUPayfTTTxatn6K6Gr1OQjLwrMJqu
        GiiI4PWVmpaFP1lPrj+nlce7g1xmZYLg9w==
X-Google-Smtp-Source: ABdhPJzn3oybuEp4I/0dYdGK1nfPYiOixNsrmB026xveMh225MUpHBk9DAA80MKIr4mgEWsp6utw/Q==
X-Received: by 2002:a17:906:9601:: with SMTP id s1mr1402580ejx.68.1633667354661;
        Thu, 07 Oct 2021 21:29:14 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j11sm456662ejt.114.2021.10.07.21.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:29:14 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 3/4] tarce-cmd: Update record man page
Date:   Fri,  8 Oct 2021 07:29:08 +0300
Message-Id: <20211008042909.979877-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042909.979877-1-tz.stoyanov@gmail.com>
References: <20211008042909.979877-1-tz.stoyanov@gmail.com>
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

