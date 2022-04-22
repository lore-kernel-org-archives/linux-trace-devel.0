Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BC06C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Apr 2022 11:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447130AbiDVLqs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Apr 2022 07:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447127AbiDVLqq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Apr 2022 07:46:46 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12175546B5
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Apr 2022 04:43:54 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id u15so6892694ple.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Apr 2022 04:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DkXfE0V0XY6tIACSrb9SAknPWWFQnIed3Gh1/Wlfpxo=;
        b=KVxIWioqFMkxXKj/aOSE4h+6hKkJRj1NTkFHBsUZrHtKkC1ojdS1RRxX5ggq0jJqe6
         XhCZWdZsS13keNNFmgkzCoTbVTe+o4MjKqzXAwu1tFejjgUG0SBPSd84eHr3j/+D401v
         0cwzItbxkXH5fBobHLY3rkzy0ymNXKB5mWikZkTf+ZFxbWHSKrzQp8MAjjbcl6DhnPGD
         imxHsG6XqQqOdXWHKWXZH7HdeERSpKVRQr12pQrKhyxCqNZ0K8w3P8h1ezD5IFMhLra6
         qxIh10+BMtWgxK4AYXVeatG4hr4BP8r65TG56PO/XUJ7sBtMrpo0WR2fAm2ORPltmotz
         cK5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DkXfE0V0XY6tIACSrb9SAknPWWFQnIed3Gh1/Wlfpxo=;
        b=q8dcSKNpZULwU10c4VZC+1c1/mmHWH4Hc16WjJUT6C01j0YMvDgXrnGkKsc34ZOYQi
         iw+6o8DK5WNt1S5jkMF9JlvPOg/7vrqXD+2pLkZUm9P+RXBhlPTYCaxbm+Gn3idDyNik
         fBEShn3XsIXbI7O8PEvSry6H4NQGrNvJ8UkWBvjMtYVr85inDJkW0oa0JLEfkceCIfEG
         fw2wSPzviltaPh577NGGtX3zkLdeb0SgZ3b4wvcrm+19HQ/rIFwvblTGffvilacomv6L
         9UzqffBoddofHV2qQ31O99TSo82VC4H4Pbw/tew1DsVW/bZTrBagg/FRoh4FLxvBhZXd
         w7bA==
X-Gm-Message-State: AOAM533VVJDcEt6tIs3JZAcx+teyE/w98y/Ifuhk29HNOyAtVwmxUjkY
        MfG/S24q2rMRNyTQc9SkGT8=
X-Google-Smtp-Source: ABdhPJxCdClDG4/hxGY7oDBxi2+EZxc0yAtZ/ld7gIvxVd3NpjqHtKav32vVsU68gi6+KzSJXLE8sA==
X-Received: by 2002:a17:90b:3ecc:b0:1d2:c238:d92e with SMTP id rm12-20020a17090b3ecc00b001d2c238d92emr4924433pjb.79.1650627833460;
        Fri, 22 Apr 2022 04:43:53 -0700 (PDT)
Received: from localhost.localdomain ([14.100.36.163])
        by smtp.gmail.com with ESMTPSA id p4-20020a637404000000b00375948e63d6sm1947470pgc.91.2022.04.22.04.43.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 04:43:53 -0700 (PDT)
From:   Solomon Tan <wjsota@gmail.com>
To:     y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] kernel-shark: Modify FreeSans warning msg for GUI
Date:   Fri, 22 Apr 2022 19:43:00 +0800
Message-Id: <20220422114259.4162-1-wjsota@gmail.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Make the warning point out that the FreeSans font is required for the
kernelshark GUI. This is to alert the user that the GUI will not be made
when cmake does not detect FreeSans.

Signed-off-by: Solomon Tan <wjsota@gmail.com>
---
 CMakeLists.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 9dd160e..390c7f5 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -69,7 +69,7 @@ if (TT_FONT_FILE)
 
 else (TT_FONT_FILE)
 
-  message(WARNING "\nCould not find font ${KS_FONT}!\n")
+  message(WARNING "\nCould not find font ${KS_FONT}! Kernelshark GUI requires font ${KS_FONT}!\n")
 
 endif (TT_FONT_FILE)
 
-- 
2.36.0

