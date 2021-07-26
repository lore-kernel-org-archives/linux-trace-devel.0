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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F29C6C4320A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Jul 2021 09:41:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCE6160F11
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Jul 2021 09:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbhGZJB2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Jul 2021 05:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232990AbhGZJB1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Jul 2021 05:01:27 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7EA3C061757
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Jul 2021 02:41:55 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id j34-20020a05600c1c22b029024e75084404so4872844wms.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Jul 2021 02:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zt8ACM71iF1Ztho/s/aa5Zag4o01Oq2fBmPXyHqlKSk=;
        b=dI8msvurCfVvKg1vSBR0vF1z35v+pI38t7vRXT5v12n8R/suQdPgANIEE/lTkbBiOf
         Eltn5UBTs96wcBF/OOvEpr73He4uaBZ3XZT0kv96vl1SBxm+CXa5X+dwihwODW8cRJXr
         JbE6ksIJ3XUWPX9k/VSDS1JnfKb20EFIB6L9ndf1oLjLumuJbRWGRnN2bAE7QPNdefI1
         FKZ5W0whgTjfNp/aDTfjDYCmf/K403MiapMEyY2FSL+uD/I6iLmRTsP0btFIyMGjRBip
         q0gVnAGTp8UUG27pALMOC0QT7GITQUsKmvRfffa/9ol96XuvHj0qT/nhDYZ5j8NPuoXQ
         gDXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zt8ACM71iF1Ztho/s/aa5Zag4o01Oq2fBmPXyHqlKSk=;
        b=cp31tqD328DwTgxK2TleboVGR2/EGQisotGTLGiQZDQr6WOK9k6wA9W1d+AdjyOxyi
         YS2jxb1js0Ei+kpBpfTZAD1VLsBhn6Td2Nfc35U7D1SCrOlQXMR0kzW2bSp1LuYAvclv
         18hXscLJJm8ySut3GH20SCulpZLkHLwYgq4w9bbzcSg2Hw9GhiSxvn0tYt67AzFPmTq5
         rUw58YDJo8jtimQpkJd8S5MilLTIeCkQ8avO5RkCg6g+SGjtQFIZGm32UqsLotGd8kIM
         8aTHNhYlbV4BWDRiWvFmwgLCOvC/bjwzsofcLVsRV1sfdxa7CquMCvgasDQgw42wFO88
         ZBfg==
X-Gm-Message-State: AOAM531t6/bmB9Gc6mVsKUIv4B3nzJ40eXBlsEPQBexWtGzFtUIZX3lg
        IZgC0NdCt81rhy8J+6LPtHmVdpUsxNE=
X-Google-Smtp-Source: ABdhPJzyBjzoArI9X6spgEczcnnPbJ7WNWHSVQHOuOyOYC9zwiXzG8W5cuP3Ta4HMR+bWbhoFwd40g==
X-Received: by 2002:a1c:26c4:: with SMTP id m187mr6472561wmm.71.1627292514190;
        Mon, 26 Jul 2021 02:41:54 -0700 (PDT)
Received: from localhost.localdomain ([146.247.46.131])
        by smtp.gmail.com with ESMTPSA id t6sm42005030wru.75.2021.07.26.02.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 02:41:53 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/2] kernel-shark: Cleanup in CMakeLists.txt
Date:   Mon, 26 Jul 2021 12:41:40 +0300
Message-Id: <20210726094141.191579-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The CMake variable TRACE CMD INCLUDE_DIR is a leftover from previous
versions of the build system. This variable is no longer set, hance
its usage has no effect.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 CMakeLists.txt | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index f3449a5..67dfb81 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -132,8 +132,7 @@ else (CMAKE_BUILD_TYPE MATCHES Package)
 endif (CMAKE_BUILD_TYPE MATCHES Package)
 
 include_directories(${KS_DIR}/src/
-                    ${KS_DIR}/build/src/
-                    ${TRACECMD_INCLUDE_DIR})
+                    ${KS_DIR}/build/src/)
 
 message("")
 message(STATUS "C flags      : " ${CMAKE_C_FLAGS})
-- 
2.27.0

