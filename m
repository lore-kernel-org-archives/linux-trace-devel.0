Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F86DC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 28 Jan 2022 03:04:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbiA1DEH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Jan 2022 22:04:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbiA1DEH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Jan 2022 22:04:07 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15F6C061714
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Jan 2022 19:04:06 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id a13so8199099wrh.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Jan 2022 19:04:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2oROs3kQZqUzcbH3kO9ixLFeoGbxsEZRXat4Kfy+v7A=;
        b=MMVQ99O/bdzQ4kkedcc3cmPaFdUq9YVfcrv5azR6MvC+KO6RmZttlSny3d73FEL5Ra
         byfWwjQCiGxEO6XdPVS+GS1cixyTCxATLCd1RjE2zQaAgz7Z4nj0C90B0vdFSQ6jYJpT
         x+eM5pRg8XCaTtY7oeXclClWEYkmg3F2SWxuR2gkLKN/47ssXRiWSHtW7Kk2uFQA/Gun
         hRIw6B7MB7q0jgmbmoKXC5pmKwqH2bYAUivPpUajf7EdFB093O9V0ICEfcXk5NJLv7I9
         m8CVxOORfdfBDSiMbUW2sP+DJ31IxrY+yTZlLD2uM9w208CbESsau7C+6r0o7LMD1N56
         3bdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2oROs3kQZqUzcbH3kO9ixLFeoGbxsEZRXat4Kfy+v7A=;
        b=07wgC2CRCjAfAeEu166+L39b8efJfYsA6O9To/WNxuquMbgRjlRMqfciFMf8AY73Y8
         QYG/W550n/B7XfB0bGUx63k+GXOiDG2EWaSyH5lOM2rPxQvmAriY0iZNoovBf2PqLKDN
         FdXbjp8wpRsH3HuAr/aHzUiT0DoAX2jpjPuaFj5XeezUAcss+dnKtlaO5S61YpCdQR3a
         /+4vf66EidTII5Tru5DtmUYtUqdHLUzfOgcJn0RJwX6TsVV+uXRU88y7NRBAWwQgCEMi
         l8UEwxEEwe2hokLziZb+Fim3vqjqZ7FUOJip7g+BT5TwMN9oSa0sTaxt1CaW0B/7AUWB
         wxLg==
X-Gm-Message-State: AOAM531F0OMQnQzaPbbqhwnjfCPo7NSWNr8lbrp5icXSZry9L7lV9YKp
        tiQXc3jnNkEr9u9BIpeXA1F9Nwix60Q=
X-Google-Smtp-Source: ABdhPJykuxt1KHWdkM2pgBfYZe+gPku+GVAtvGFG/TXdLv/LkE8TrMF7rPAV2QGFEd0qgLd2w8OvGg==
X-Received: by 2002:adf:de83:: with SMTP id w3mr5239350wrl.181.1643339045390;
        Thu, 27 Jan 2022 19:04:05 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a9sm927394wmm.32.2022.01.27.19.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 19:04:04 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cruncher: Add a .gitignore file
Date:   Fri, 28 Jan 2022 05:04:03 +0200
Message-Id: <20220128030403.62209-1-tz.stoyanov@gmail.com>
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
 .gitignore | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/.gitignore b/.gitignore
index e69de29..cf7e532 100644
--- a/.gitignore
+++ b/.gitignore
@@ -0,0 +1,9 @@
+*.so
+*.a
+.*.d
+*~
+*.pyc
+*.swp
+build/
+tracecruncher.egg-info/
+dist/
-- 
2.34.1

