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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 622A1C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Sep 2021 07:48:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4552861164
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Sep 2021 07:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbhIQHti (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Sep 2021 03:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbhIQHth (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Sep 2021 03:49:37 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017E5C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Sep 2021 00:48:15 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id j13so26682311edv.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Sep 2021 00:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ExfQx4rHemKhZKzMn0O/JEicIY2LPrOiNNjn1vecA/g=;
        b=F2F2uSUwhMC4ip20xx1XyPW2s973EenF/GzVOIkotcvGMTT8CGPw00bwo+VEaQAxFX
         C6RL67SfTN1GBU9X+Dee0bMS/oSw8NwCXCE/0vieYAf5Mx5UVGpMBAYz6/2Jv+ku1VPQ
         tFwiWoeXGl39X/1Rf+hZTGOIe8Kj4OyGzXTuyJI9ankKjNWijifwFXXouj61L589bCyF
         24nGxc5L26zmfgWyAndB6URpqoBSENdzIXPgqzdYH7N3tjPHyy/PZsidSvJc+ZWmqFXW
         Ml8WnP/H/a9cb2X8IM5b51a12e8ugi7Fc1YnCBdrKFZwlm0wLjCWDo9WvvSho5/njw2V
         ETgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ExfQx4rHemKhZKzMn0O/JEicIY2LPrOiNNjn1vecA/g=;
        b=f8TkKl3u2v6S8KXEOertmbNxfwQGNegU+B8TrIpZhFttQgRM8BxUcyW2hD3YYVmkhZ
         Yy7RLTW7w0dIkq9w8YCibzAiBMUeRtVSCQ1abj0jSIWPfmrpaOCCT/NxJhCybEJpyqn/
         bRnAVCU2lhphOsqv2riHIFE+x+7olEKNOndHNdhrVSsfdL42HLcDX80wXrsvdfLxLyAW
         d5XLPEmf9gglfSVFZCROdSPKnGY8SmSrPSuZHxridc2bODJZNYPqmMMR00Cjqb/UG4TI
         byKdwObiJd0XJ+dLJ2G0vcuqJS3QihGnLkJTcE1dd00GJgAS5xo40Ltl43wdWJ5Yu3px
         TR1Q==
X-Gm-Message-State: AOAM531/69MYJyEkz94nGNJgX/DYHtI4CpDqNn2IRwAZaNhZEmwh9h1T
        hinhbgslogMOC9pXT9xMc0svkYPHo9E=
X-Google-Smtp-Source: ABdhPJydg9kseA+VxGDeqkvpoD5ra7ROhZFVLCohTfxYd3p9n0bvsVievHn8t9FSq3KMmZAiESqpCQ==
X-Received: by 2002:aa7:cf93:: with SMTP id z19mr11023670edx.202.1631864894166;
        Fri, 17 Sep 2021 00:48:14 -0700 (PDT)
Received: from crow.. ([95.87.199.246])
        by smtp.gmail.com with ESMTPSA id o15sm1996979ejj.10.2021.09.17.00.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 00:48:13 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] trace-cruncher: Fix PyFtrace_set_event_filter()
Date:   Fri, 17 Sep 2021 10:48:01 +0300
Message-Id: <20210917074801.550429-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The Python method requires 4 arguments, however the format
descriptor of the arguments describes only 3.

Fixes: 38bdaec (trace-cruncher: Refactor the way libtracefs instances are handled)
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index bddc4fc..302fffc 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -1316,7 +1316,7 @@ PyObject *PyFtrace_set_event_filter(PyObject *self, PyObject *args,
 	static char *kwlist[] = {"system", "event", "filter", "instance", NULL};
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
-					 "ssO|)",
+					 "sss|O)",
 					 kwlist,
 					 &system,
 					 &event,
-- 
2.30.2

