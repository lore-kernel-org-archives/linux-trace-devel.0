Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6244C2BA4C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239425AbiAZJzj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239417AbiAZJzi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:55:38 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216A2C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:55:38 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id me13so37860303ejb.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pk2Jdd+0pV2MRmI4hP30SWHmhN1KGy5w659LlLasgEc=;
        b=JTWUftGoa+k0fL+6PFbuWSk7DQ8QiJhTYwAE5czA8zbty85CvQaQzzZy7dB6iJeXDa
         6xne85gIC1kVbmKi5gKS92H/ruepr6aIXBinsBKhqDvneI0QJX982+y039zc+4ToThun
         1QHvKrO635O1sJUoGd6D6lAlg57RW0iUX9u9evc+9M534qkcVqxpr1+5uZW0cX1wm2wl
         9QR1oy6g2G0Io1J2sS6h4OmkLiT/Eb+9AKR9MbDdyTMo3nwEGTlLC4M5bRJwiZlb4cXG
         FH0XvXzDyD+/Sefpy8T5BZT97TMEaVhrI/vlzaRCaTOyww7sbvatWzYepK1+yaQ8THAu
         1Plg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pk2Jdd+0pV2MRmI4hP30SWHmhN1KGy5w659LlLasgEc=;
        b=aIk346yRpIwMOmNvqr6v+8mzpNkjHujLAppeelN2WKxR7OYVMuDk9FZep6OWnzwIJ1
         QGUV/xH3smIAhZeo9EHStrWF5MWszmpBm2wmB7S72XlKQOwmz+mzYHJ5b7KDTU2/5ElW
         r6xQg1V25q7ng8S7U/gk478rYgWSTJNqVV/NzJvBJPoxX+cZr7/Kwyu4HgriqGG3Saxe
         gUQZZdxziGm6aLfzaMw/9Tr7wpPLaJWOMZbJC6Ikb2asC4XM5jJrVrm5cWo3ArK5gMMC
         23VoYeAZg3wJMNfvlcxR1yVb54t/BUpPAe9QT7PUMOwAGVeLy8wHImaqccjv8u0ZjVs4
         KJeQ==
X-Gm-Message-State: AOAM533Wwf+x/XRG3aJpKSj/7z1tk1N38n8RGTcx3ycK1G74oGDFlp3w
        t0/5WZ12rXUYMFlpBxxoEOREVVTznJc=
X-Google-Smtp-Source: ABdhPJxQG2kqs43ZxgkqDMHAkGVnltwmlX+1PjexV/DSTMzNiyHvonhF2r/5xl2yZ58rTeLV0fDPLw==
X-Received: by 2002:a17:906:4945:: with SMTP id f5mr19255453ejt.429.1643190936766;
        Wed, 26 Jan 2022 01:55:36 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id z25sm9563070edm.60.2022.01.26.01.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:55:36 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 3/4] tarce-cmd: Update record man page
Date:   Wed, 26 Jan 2022 11:55:29 +0200
Message-Id: <20220126095530.571035-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126095530.571035-1-tz.stoyanov@gmail.com>
References: <20220126095530.571035-1-tz.stoyanov@gmail.com>
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
2.34.1

