Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE83FC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Jan 2022 14:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348738AbiA1OJ7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 28 Jan 2022 09:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347943AbiA1OJy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 28 Jan 2022 09:09:54 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DB8C061714
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jan 2022 06:09:54 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id a13so11111057wrh.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jan 2022 06:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2ayNyuFrYitAzLIv5U71n7HVQBzObpZHRVlMoyhqWPo=;
        b=BHHFZsc7LhVXLUnDI7J0JAEcMH6ok22/hOxPffm51n7esbsbB1yxr/R3cY+8wEZGC9
         qEPASVhihNYmgLIvZnaVQZS4ohuZ6zYpNO4d91rJ3RlabGFHK7xXhYCmSz5PGeQ+BPUr
         kCT/QBD82wUZWfZjqs1pMvyM5OwqH3khxaDWZUAV3UQ/35EwMfnGNzKwotxQ7+DeejZf
         q4kBZB2fwqPFhQ2KlM7L81e4ojUq9kZiJSbMM2RWKBQA+uKQTk5p+8lCOYfsupeTWiqU
         SxH3GUGQDrBQUYjWYZmWKQvIjUF6hCLjcXp4Ae9JLSIF9EeHJNd4nLA0wmvtCdCjD9T6
         jNlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2ayNyuFrYitAzLIv5U71n7HVQBzObpZHRVlMoyhqWPo=;
        b=Gj4iaxYFDPEOR4qfYHbZ/cGMk1lCSX3ldPoOYu67Ua3TqkuW2Uw8DHN60I6wyM5m8g
         raaEYSFft04E/q9qNeUI0dyGWJO1B1qMD8rGR1HZ73rvmkhsiuxbmDf70xz7QloMzDhG
         253WSf6Ou/N5vkjSrAYVQ1rnxeyHxrqQ5LsH63zl8pEM4L0lKLk8PGA4awFWAnyMz2Qx
         +6aVT+jYOSZH980D/BjA4XsjGZW5JA6APt7QVF+gHkbNcip+Z2VB8O5D9bJwo/vjeVx7
         LTW8A4sYZVYXtBuoJkaNaSxnFljucaud6XW4fgbHJVTBCgQygLxMKbbYEQwUl7hjn/R+
         IFGA==
X-Gm-Message-State: AOAM532Vp7tEvAquJZSmFfzbO69MYlBwtYDF5ukdQXW/cC1+PcRzVYW4
        WEnCcQNZ1VfPSErnfyQDmhI=
X-Google-Smtp-Source: ABdhPJzHNT5E3DLf/+wHVgdhe3UGG77s7fJAaR8I4w9PThfwIQCF5iZKHmvzJRu1ynHJaTCFTPr2mw==
X-Received: by 2002:adf:fb0f:: with SMTP id c15mr7558256wrr.42.1643378992882;
        Fri, 28 Jan 2022 06:09:52 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h18sm5742461wro.9.2022.01.28.06.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 06:09:52 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] trace-cruncher: Add a .gitignore file
Date:   Fri, 28 Jan 2022 16:09:50 +0200
Message-Id: <20220128140950.86562-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some files are generated during trace-cruncher compilation,
testing and development process. These files should be ignored by git.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .gitignore | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/.gitignore b/.gitignore
index e69de29..9fb86e5 100644
--- a/.gitignore
+++ b/.gitignore
@@ -0,0 +1,11 @@
+*.so
+*.a
+.*.d
+*~
+*.pyc
+*.swp
+build/
+tracecruncher.egg-info/
+dist/
+src/npdatawrapper.c
+install_manifest.txt
-- 
2.34.1

