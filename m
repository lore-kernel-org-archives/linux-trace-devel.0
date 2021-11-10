Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54065C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Nov 2021 14:38:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 340796124D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Nov 2021 14:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232193AbhKJOlD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Nov 2021 09:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232186AbhKJOlC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Nov 2021 09:41:02 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF83EC061764
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Nov 2021 06:38:14 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id w1so11364038edd.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Nov 2021 06:38:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s9gSWyGuItWBGshXoLLpqDKJdEMACqx8O1xsTMATnqY=;
        b=C9/ysoDAiaknluqgT5rllR3UAJOuijsbzXgH7aONJZEIyWk7Ip2kLHu8eVyMFxis1N
         wjfYMFDb6zdFoH8izcQBNz6ofcrNw4VhKpY6+JKsHOE3E7wDKjv1ACf35NAmt6Imuftt
         1ezWGGJF/UCaE8A5UDffvJXRBos7bGRpYW7Zu7Xw+Jab3LlFof78LpTvAP199UZMXj+U
         Bc4v425wnsEKnd22gBKagy7RwzN9analm0pfWVBdF99CKPStU/jMkEB5QTtHKRnAw/Lu
         Bkdo8EeQ2rybXmCFMUTw6K3WeZig0zAun9e78UMbrPTAE97Nn6F2Ud3rtZwz/cGEM8TR
         EaFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s9gSWyGuItWBGshXoLLpqDKJdEMACqx8O1xsTMATnqY=;
        b=I2vYGD/3z6yOfqiJnc/aY6UPTQtWNuQXhsNYmvNkFt/vQpPp6wX4QOMlQNyPy3rHPL
         ImEdKWASTig81b2w5VuF62VMK4c0aDVFpfC2Wly1R3eAf5MgmRHjP2aoitSxyXeneUTX
         /vnNj6wqOy3EehE3Y+K20AItoKbjeSYnfg19uSXIfrnUCq1zKlP0oGg4tMeccSAr7Sl+
         Q4P8Rz3U6DXoDwZJe2gMlNwv3d9F6Lu+U+15EXMyP0CM/zGjiCKA/8MZA8RrK4ttPSB9
         SDgHK/CZFYgvcNvmJX2VHChEmkVZ4zZSIuuWo69qEo/EX9IymEu/D1JgV6kYAqpvoiEf
         ywqw==
X-Gm-Message-State: AOAM530HdIsw6DRXXA3A350NvjQD7IlrbV1FaNC6ysUih21ks+vxYVm3
        I9FOF/IjOXBUaMg+PNx3gWwwGAqZKwQ=
X-Google-Smtp-Source: ABdhPJw2xkNruos5W//w/QcvbNG9gon+pakKpZJEi2buE+09VP/9Dl64dWFk8t658xH+OLbJOmA57w==
X-Received: by 2002:a50:e0c9:: with SMTP id j9mr86074edl.336.1636555092353;
        Wed, 10 Nov 2021 06:38:12 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id hc10sm11477039ejc.99.2021.11.10.06.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 06:38:12 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 5/5] kernel-shark: Always run 'ldconfig' after installing libkshark
Date:   Wed, 10 Nov 2021 16:37:47 +0200
Message-Id: <20211110143747.32833-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211110143747.32833-1-y.karadz@gmail.com>
References: <20211110143747.32833-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This way we make sure that the run-time bindings of the linker are
properly configured and have the necessary cache to find the library.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/CMakeLists.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index f3c4e0a..babb9c1 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -46,6 +46,11 @@ install(FILES "${KS_DIR}/libkshark.pc"
         DESTINATION ${PKG_CONGIG_DIR}
             COMPONENT                 libkshark-devel)
 
+install(CODE "message(\"-- Executing: ldconfig ${_LIBDIR}\")
+              execute_process(COMMAND bash \"-c\" \"ldconfig ${_INSTALL_PREFIX}\"
+                              ECHO_ERROR_VARIABLE)"
+        COMPONENT libkshark-devel)
+
 if (OPENGL_FOUND)
 
     message(STATUS "libkshark-plot")
-- 
2.33.1

