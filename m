Return-Path: <SRS0=dlhe=RK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C346CC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 15:05:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 937B820449
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 15:05:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726172AbfCGPFk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Mar 2019 10:05:40 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40365 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbfCGPFk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Mar 2019 10:05:40 -0500
Received: by mail-wm1-f67.google.com with SMTP id g20so9487049wmh.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Mar 2019 07:05:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u2lo2WEDRuEdyIPOfJAVbLGdfhu/OMhY0/4TDFAALgs=;
        b=dgH89FRD6ZRSfkqe6Sy5UiKDPSlC9lSSGEhxek9+8hymXvtCYgvCVXQgaWcEVOgQp4
         U0RnJC9oU7esEpEF28e37NAEjjO0mPQY2XvQt/xeQ9Rin5p7XW8qzY7MWsQmytTO6m2Y
         8yoSt1p7snJRwU+/wijNE+MQxs+7rpg0/Q0qJQKgWchYRJSbIQ0wMxp172K3NP9IWdjS
         eF3tBKtozImeCToDTtq/ObJW9dUlY/mxBDiftIu8+KpbmJm21AWtAdDg09bipAV4RM8w
         WnCE/F9HJP9VmBwibxFqFwnQe3fpdvEa21ZkCNsNG+jWKIMA+XvUheZ9DOV9C2TjgdXf
         vkhQ==
X-Gm-Message-State: APjAAAVm9VjLr/k6Ra46ewvwZrDviCb7i5PxtU8uAtjwdXeCt4bRPUpV
        G4DTl6IdtNzWMOJmMwCWX/k0l2JZ/aA=
X-Google-Smtp-Source: APXvYqzCROTQEuPyLgTlC+pxsbZzmXxY99diZELMcUTikSACPm/CQ+Fnl3eTITIbv9PR+mrfUBGrZA==
X-Received: by 2002:a7b:cf27:: with SMTP id m7mr6018412wmg.80.1551971138429;
        Thu, 07 Mar 2019 07:05:38 -0800 (PST)
Received: from localhost.localdomain ([95.87.198.56])
        by smtp.gmail.com with ESMTPSA id d15sm10281274wrw.36.2019.03.07.07.05.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Mar 2019 07:05:38 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 1/4] kernel-shark: Specify the OpenGL interface used by KernelShark
Date:   Thu,  7 Mar 2019 17:05:08 +0200
Message-Id: <20190307150511.17246-2-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190307150511.17246-1-ykaradzhov@vmware.com>
References: <20190307150511.17246-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We instruct CMAKE to prefer using the legacy libGL library, if
available. Although this is the default choice, the latest versions
of CMAKE are printing a warning message in the case when no explicit
preference is provided.

Suggested-by: Slavomir Kaslev <kaslevs@vmware.com>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/CMakeLists.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
index 9460026..20ced14 100644
--- a/kernel-shark/CMakeLists.txt
+++ b/kernel-shark/CMakeLists.txt
@@ -22,6 +22,7 @@ include(${KS_DIR}/build/FindJSONC.cmake)
 
 find_package(Doxygen)
 
+set(OpenGL_GL_PREFERENCE LEGACY)
 find_package(OpenGL)
 find_package(GLUT)
 
-- 
2.19.1

