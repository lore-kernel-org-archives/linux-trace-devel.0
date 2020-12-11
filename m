Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D949CC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2A9A20657
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406322AbgLKOqd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 09:46:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406331AbgLKOqE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 09:46:04 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225AAC0613D3
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 06:45:24 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id d3so7758693wmb.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 06:45:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ia0GlPxxrStrpPcBJScq8HAGyJAYHxheHA2Cbt8KU3M=;
        b=VoAyzMVKMNZv31gbaFiZIaaL8sD8XeRck6ZwlHg2S3VK8r8qOje7ANITw/VqwFnqdi
         lupIcSacfLCX/Q34j/yBHqFqwaxBLjnmk8VYmYnN6T8IEsKlL1DTCU5Wl81VSBQqDPfW
         HhBJ3V5wNHn/XIaQi0lfTmk68XN+agK+QTVb00GmPwMNNBmRaYCa4dvTzyOCcH5TxBWv
         E+a4ZO+nCoWSTHDyNhTttW4tUK7RU6CmQvaUim4n8ALExHCFeJtDTha9g8qR4U6HT8NK
         BRPnj7kK+tCRsmrQUb6LtLD8FSFBnLGMxxHno7Ge6QcmTeuM8LK4Y1rBqefpxLGWpy7c
         IaKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ia0GlPxxrStrpPcBJScq8HAGyJAYHxheHA2Cbt8KU3M=;
        b=bEqmK3is/Zol8MXjl8c19bpDMjLDAUaWiSPUKIjw6VfGKBb1fexNp95fWpwq0b5I2a
         Ew2DfVXkSzQsFfLPtnMwOZdOxHWPIoDjxPr+1WWLc6D+Yy9FnuABkUH4+URueK/bT+rI
         67LWi10TrgUredh9Ti/UqfcIU7Q05HFVj4thWQbSw8/4Pc7ooVX51Qk6wNqqSbDWhXt9
         QWuDkl1ru+pGRsmfAsIqPO+GpMYFN0s7PkJVTuDz1oE3snCgVauLJ+A2zErCkoHVapIR
         iJHC++X6D8kpJm3YSIA+WCq7MLy9Teqj+AdtBseZiv5QJk66hGFYrzQTVhBv33kgrhKU
         z0nw==
X-Gm-Message-State: AOAM5317ogi0rTz4CbL3nuxtq+INu8V3bKml1ia2SOqWOz4V996vx0Nk
        s33uJ3R7CBbKN4fEZhiCB28=
X-Google-Smtp-Source: ABdhPJxvRdzGqbsa9gyIDP1cDg/wsv54XpbXY94fcF5JtNC/IUFbPMBdrOxJD2iv/DKwEwCF6+xLtg==
X-Received: by 2002:a1c:9e0e:: with SMTP id h14mr13734257wme.63.1607697922970;
        Fri, 11 Dec 2020 06:45:22 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id y2sm14471471wma.6.2020.12.11.06.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 06:45:22 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        David Runge <dave@sleepmap.de>
Subject: [PATCH v7 02/32] kernel-shark: Change the CMake minimum version required
Date:   Fri, 11 Dec 2020 16:44:41 +0200
Message-Id: <20201211144511.575346-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211144511.575346-1-y.karadz@gmail.com>
References: <20201211144511.575346-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We use some CMake features that are available since version 3.1.2

Suggested-by: David Runge <dave@sleepmap.de>
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 CMakeLists.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index c95249e..e730398 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -1,5 +1,5 @@
 # Check if cmake has the required version
-cmake_minimum_required(VERSION 2.8.11 FATAL_ERROR)
+cmake_minimum_required(VERSION 3.1.2 FATAL_ERROR)
 
 # Set the name and version of the project
 project(kernel-shark)
-- 
2.25.1

