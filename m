Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F72C433E6
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Jan 2021 15:55:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6EE622BEF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Jan 2021 15:55:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbhAEPzt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 Jan 2021 10:55:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbhAEPzt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 Jan 2021 10:55:49 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF5AC061795
        for <linux-trace-devel@vger.kernel.org>; Tue,  5 Jan 2021 07:55:08 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id jx16so398431ejb.10
        for <linux-trace-devel@vger.kernel.org>; Tue, 05 Jan 2021 07:55:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E6i4k+fmu5D1EA86UitaEBftZMpwJQPBgH1+4VUiYCk=;
        b=oERo5bP6NBark/fv2nj6cp15/XdvldyBmkLlyCSRPJpQ8iCwRU20BPSGT7KBpV/q2Z
         HNGVpvZLFfpSCl0gb+k3RnsrcTlSHpUrFCjhTY4e51geIDvAD71WdhHRyHL52HeJHkyP
         96uhFllURIwl+SycZYiq1Fq2Irpex0EpyZGe30H9KUBRLHgWNNCJvmfEmySDJ//H6bPe
         YxkYJfh8FVs4g2w2HMr5Wsvq8Jnc8ZRvO7PV1tsXAL4B8AFTqp+a40xQ2U0DMVuGf+iQ
         8A5XIstkBVOl9YvYPyRmLWCOgOX7hH0lSbWti3x5/aKqpwIdiupODsDFEq+RHS7F56ET
         sPcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E6i4k+fmu5D1EA86UitaEBftZMpwJQPBgH1+4VUiYCk=;
        b=FmdyAr+b+iKA7oZ62nbnD1MviSjTxroOsIy0eRQKgi1R4Yq6B+A9H+0/OiiU5S9Yp+
         QGREM52wYOCOCfx8YBct3fhX0p7M1o9PMeXCp1IjSrJ8cdR5XuihkOqLMqd2d+XQrRDF
         YC8canuuXW/59peRtNPBNN2Tr6C2/xvFYd3iDjBK7uBTm99EQwtOmWJrfUwu/OHhgWk6
         YKEjqZFNHNIb/4uupjY7zH1L0hIkmH3zH/UEONrC5uS2IZQlQj46yemiR+UYOMXlPjhi
         shfq2z0fprjMgG9G0NIh5ZpS8SYtXFNJt1U9iVQbtEYcc5g9ns9iPa/Eh61MaxSRnaXs
         +SIA==
X-Gm-Message-State: AOAM5303v5yFGqmLLXxEtDHrlWp+GSk1i/ui6lc4d+o08+qjgWCssqFm
        PhQS+7WPSqxk3NlI3F646p4qFuXerQpwZw==
X-Google-Smtp-Source: ABdhPJw8oaD2tUln1o/eG9LZiNY1ybXvswDjjhoemuulXAMi9O5/hhl3zY1dhEGS/Zt80qE7Xj/ktQ==
X-Received: by 2002:a17:906:1955:: with SMTP id b21mr70813415eje.236.1609862107353;
        Tue, 05 Jan 2021 07:55:07 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id t12sm45367882edy.49.2021.01.05.07.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 07:55:06 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/5] kernel-shark: Add missing SPDX license identifiers
Date:   Tue,  5 Jan 2021 17:54:50 +0200
Message-Id: <20210105155453.41228-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210105155453.41228-1-y.karadz@gmail.com>
References: <20210105155453.41228-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 build/FindTraceEvent.cmake | 2 ++
 build/FindTraceFS.cmake    | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/build/FindTraceEvent.cmake b/build/FindTraceEvent.cmake
index f3feca9..ae391b6 100644
--- a/build/FindTraceEvent.cmake
+++ b/build/FindTraceEvent.cmake
@@ -1,3 +1,5 @@
+# SPDX-License-Identifier: LGPL-2.1
+
 #[=======================================================================[.rst:
 FindTraceevent
 -------
diff --git a/build/FindTraceFS.cmake b/build/FindTraceFS.cmake
index 2a5f7bd..82fa012 100644
--- a/build/FindTraceFS.cmake
+++ b/build/FindTraceFS.cmake
@@ -1,3 +1,5 @@
+# SPDX-License-Identifier: LGPL-2.1
+
 #[=======================================================================[.rst:
 FindTraceFS
 -------
-- 
2.25.1

