Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4390BC4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 11:07:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbhLJLKz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:10:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbhLJLKy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:10:54 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1324C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:07:19 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id o20so29072101eds.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CyGhK1rKr7dRVG5bk87ua4bXrNSMqVKfo5ItuyT1ffc=;
        b=q4zia7IV7r7NjtEDdVcP5pJE/I7O/i/aiuURSmGThDo7ElMA7W7PZ0U6X8SXe9Wl6K
         zny86T+RgQ6awev7YqOTISajxAywqoQumz4h0ky5GV/+/WqvIMU/tzbMQL7Bq/iHTeF4
         +KlY1vGQB+ZKczLBXezszy7Iw5J3VPYn8Ule3FDx5KZtn8MaYiRS5ujuNzRso+qZ++YR
         Ak88NjYfDk3Xq5OdfCM1m8JFAQVNEBWgcCr4Uz0NWcMuLBC0Rwsb2RXikpTsdbfnC/2v
         4Ge+iam7Y8bdQCO2LJaTCCqTIj9QL8q26KGnv/mvoY9ajBe9oUPCsPKcXbk21aq7FYAu
         cjDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CyGhK1rKr7dRVG5bk87ua4bXrNSMqVKfo5ItuyT1ffc=;
        b=3uyskNkasTXWwEdiqEruoZwuM6jL8e+ckQd2wlEbWtWdicXzi5EcdaNhAVGN22LBKS
         gmBlyz4BnnUlSXkRY2kXkMOAwzyGo3ZbHe/UsBM5NrxnhD4n6n7WSaTKkEJ3gYgcZ1Tv
         p09OlbLg+0WsIZoETqcIHU2pHfel6ahaFHI9kyxFC3OTwb3jpZeK9u8IliB1KnzN07Pc
         UYtRB/kRqBbA6h9n6kBSxM/i4y4u2+pprujji9G/iGwCC1p2vKHjVTVRLy4u0eH7p+Hf
         Oj2GGIIPaRQLNlCM7wAWWSlX7agCNdvY4/GJ/872AOGXE7ur9YyKhXCMtmGKkfuIrr7z
         ITGw==
X-Gm-Message-State: AOAM532aBLKSbq4wxmHO5NLUISVxVDHIPsKjZNPbxYxMRLJYNgqw1ESw
        CTgNrHQ1N+W0r433S0clBqqvE5u6pfk=
X-Google-Smtp-Source: ABdhPJxstCprOPeO/It4aMhuYbb2NkSxvg/c6HC/hEyfc2g2i8ddw/TwsNqWihSAOuhwPbPrMmhFLg==
X-Received: by 2002:a05:6402:354e:: with SMTP id f14mr37158926edd.245.1639134438432;
        Fri, 10 Dec 2021 03:07:18 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w5sm1299236edc.58.2021.12.10.03.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 03:07:18 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 3/4] tarce-cmd: Update record man page
Date:   Fri, 10 Dec 2021 13:07:13 +0200
Message-Id: <20211210110714.99067-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210110714.99067-1-tz.stoyanov@gmail.com>
References: <20211210110714.99067-1-tz.stoyanov@gmail.com>
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

