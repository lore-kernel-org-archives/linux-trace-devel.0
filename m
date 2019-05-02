Return-Path: <SRS0=5+qO=TC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43C75C43219
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 12:52:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AA652085A
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 May 2019 12:52:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfEBMwH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 May 2019 08:52:07 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54911 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfEBMwH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 May 2019 08:52:07 -0400
Received: by mail-wm1-f65.google.com with SMTP id b10so2661537wmj.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 May 2019 05:52:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nTy5Y2kSz9IHvXQ4mq/bAJQGbvvBqCYGHhj4u5aHRTw=;
        b=UbAoupc2iAinCXBNCqRuEg0UbSLVAXx4XSsGkH8wvtNPcLMxZAYV2Qqvzp2vtuL3w+
         3d2513Z8PVXjAFpUFM+pUgJrwUrAB1C3h6B+asrPeIwmaaeoMnnCRa3J9oVcQ8CKKLWS
         nl7uYzyqvWacnvOSWZYAAWr7kAI/mgV3NXgFrVzPhCm1PUHVlG5EGSBeGlujwpknR6AA
         K+hd2Ss4TWynlTTdc6XU2tRivXo+INyEm1LzIFx7r+GLGo0sIm/o30LIHZngOVFe9T0O
         mJ2PpJfzkKGUy4kQd6w/6H2b4Jm1w+HC29ien1VGQ0/raJtRnNiwAXXQkf3iPwvou9K7
         tF6Q==
X-Gm-Message-State: APjAAAVI6w0QAIcIyws5T/E2F0K+dT/7N+kNjOpzp6A1iIzqHhf+lV1L
        J0OpuXNqXWR0fl3T49UUxXaQfTHM
X-Google-Smtp-Source: APXvYqx66FjqiPjhkPjumxtCEot1sjGZSZC2G8d2P+drREgbvZeBBdB9XKJPgILwZTVkqbUEWBwQlw==
X-Received: by 2002:a1c:7008:: with SMTP id l8mr2150835wmc.49.1556800836408;
        Thu, 02 May 2019 05:40:36 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d11sm7511008wmb.39.2019.05.02.05.40.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 05:40:36 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        troyengel@gmail.com, Yordan Karadzhov <ykaradzhov@vmware.com>,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: [PATCH v2 4/8] kernel-shark: Remove the definition of KS_DIR
Date:   Thu,  2 May 2019 15:40:05 +0300
Message-Id: <20190502124009.32208-5-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190502124009.32208-1-ykaradzhov@vmware.com>
References: <20190502124009.32208-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

KS_DIR is no longer used, so we do not need to define it in the
Cmake-generated header file.

Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/build/deff.h.cmake | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel-shark/build/deff.h.cmake b/kernel-shark/build/deff.h.cmake
index ba211f4..1cf8a80 100644
--- a/kernel-shark/build/deff.h.cmake
+++ b/kernel-shark/build/deff.h.cmake
@@ -11,9 +11,6 @@
 /** KernelShark Version number. */
 #cmakedefine KS_VERSION_STRING "@KS_VERSION_STRING@"
 
-/** KernelShark source code path. */
-#cmakedefine KS_DIR "@KS_DIR@"
-
 /** KernelShark installation prefix path. */
 #cmakedefine _INSTALL_PREFIX "@_INSTALL_PREFIX@"
 
-- 
2.20.1

