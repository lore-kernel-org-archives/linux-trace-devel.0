Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92BEAC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 Jan 2022 12:35:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238879AbiAFMfq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 6 Jan 2022 07:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238831AbiAFMfp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 6 Jan 2022 07:35:45 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D170CC061245
        for <linux-trace-devel@vger.kernel.org>; Thu,  6 Jan 2022 04:35:44 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id j6so8754733edw.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 06 Jan 2022 04:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FFnWcgVT0ZDTlLEguQV/q5w9OGe0mnVr1upoJFJLu1A=;
        b=Qs3XDFDySyuMWTnasBdFDsSQYQFNzCKvmjRVIONYg4At+1SRkXKPlXfg5Og90mPvvh
         LIS78RyRNcATKhTQW1/DzcsI4kuTlICebj4KM+kRuhNx3Bm+CrSuwP2lIKJxh/Qxr4c9
         44UA3pPKMby708ZK4C2nMFNTNnuTFX/blJ1AXfab0aBB/hx+A7jYvByvSnrHNmFYq8de
         VcRHDioONqwcMFXHOOqSqK4UUZiyWt3gcjI5b4n6MDeTHgj0jRf2VK3/KV28hSv1//Iu
         3ww7XDOiCiEjJ/zduPlf0PRKud957vJ3Tm9HYBo+1KvGtOlbvR+klQ+M4U+8BGao6sMn
         j4EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FFnWcgVT0ZDTlLEguQV/q5w9OGe0mnVr1upoJFJLu1A=;
        b=NhWCtezNY+tv7twwdd3qD69KFPxo2yspXl6j86Tpx3RuL9Oxh7W0m/WLEEXnIOye6i
         6QfcVZSIccULycfnyHKtqHr4h7uzAaUA+EMLxW6W1QI/EzdZMFDTOp+Swuqbl4XDwmxB
         WzUWBcr4uaPpPxURjsKB1a9pORFOB+jPltreKg0qAhFK806LMze0Gej5I5/Tk1ZGXZ5K
         c6ScecWXpKmo6goyxrn31HPlbj1BJr+d0FqaRaRGr277Dm5O2yO1/h+uhCVZWRq/Wbik
         COn4jt7a2RSDbokwxAQhtg/gpFHN4cbm71LOfmTVP9dFf0+gKpWRBWlBL9xbJaxPKenI
         zsyg==
X-Gm-Message-State: AOAM530c1lIbJkFgtTjF6Pn1O47eOMy0Ej15F/7vYHibLpdQfSxpqL31
        W4s9JFA3QcPgF7kZcsKFSQCVOD3HhVo=
X-Google-Smtp-Source: ABdhPJwa6FfnI4mIOtyx8d1papI7Hjd98Vy0Rx7Len53FcV1tnAnGefqLKrnnr+FQk+7jrhwpmAR+g==
X-Received: by 2002:a05:6402:8d9:: with SMTP id d25mr56770117edz.283.1641472543298;
        Thu, 06 Jan 2022 04:35:43 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id 10sm468680ejy.174.2022.01.06.04.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 04:35:43 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/2] trace-cruncher: Fix error message typo
Date:   Thu,  6 Jan 2022 14:35:05 +0200
Message-Id: <20220106123505.164550-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220106123505.164550-1-y.karadz@gmail.com>
References: <20220106123505.164550-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 tracecruncher/ft_utils.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecruncher/ft_utils.py b/tracecruncher/ft_utils.py
index b5f031a..cae54b0 100644
--- a/tracecruncher/ft_utils.py
+++ b/tracecruncher/ft_utils.py
@@ -47,7 +47,7 @@ class event:
         if static:
             self.evt_id = find_event_id(system, name)
             if self.evt_id < 0:
-                raise ValueError('Faild to find event {0}/{1}'.format(system, name))
+                raise ValueError('Failed to find event {0}/{1}'.format(system, name))
         else:
             self.evt_id = -1
 
-- 
2.32.0

