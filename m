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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22D00C43460
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 14:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F26546108D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 14:59:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239873AbhEQPAR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 May 2021 11:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239913AbhEQO6E (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 May 2021 10:58:04 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0BCC08E876
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 07:21:53 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id et19so2417358ejc.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 07:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H8H19MfKEzKlMMeMpUQNLaugzc0L7lI2BG6f2PIOKyc=;
        b=h8Pfy7aOuixW/K/T3I+eWP3CaQDm76UjZP4xmvCN5UdeukQWx9k0zzHjiIiZFUA8+b
         pX+9piRS3fBQQ8TeG2CHal43A9wZ7nBPL8WZad5bxF2nYIsdcjTtzPr3BhOqmifW0XvX
         Pv9Q67fZ50q9ARmeHUOrItga3I7lHllp7oSfgvVOmhb5ZrD2hemr+d+hViC1BTk20TR3
         8vX3f0Z6jAv+lp8rYWn01g/RJJrHK1PFLVtEf/W+CjI8slGlXamXFjwsBVtT1P6A9BbD
         IVoJ/nLheYA6G+4+0Yx29KdEQ4AyMjI3Zqs82EboOBo5u9SLfHqbOJR9tKOJ2lKpjLRA
         XZ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H8H19MfKEzKlMMeMpUQNLaugzc0L7lI2BG6f2PIOKyc=;
        b=cVjtg21rO2+0wM17axbFIjL3uT4c6XY6Kr47kqddtOHtRwlBu19CaCFDwLdIBCGFbF
         A+BuWGa9CgLKMNxYZnxaYDN0q5Q7sM6Nyr/GtWeEWElkx/RadcrR4MB1rrczTvYQbb+Y
         RVX1orO3X3NY5wQa68W/BJpf7t4l3Helx3cOVd4th1MM15oaV4Pj30KqXKzUZeNmOKlK
         wKf3vE084oX1LKKqOIBXdfCvNCxHfxSNwLNOjSheiRiiVxD/9lqyysMyK8xYUU6LuPT4
         M8wo9g3WKdztjrCyJFewDZ0XnNFwjaoY2A21IgRSzJD+khk9kRxMjtenvWBKHnrC9/D2
         1zbg==
X-Gm-Message-State: AOAM5330jQX/+CGz2/5u3fBKz+tIyeDHJV8IT1GdnByuJxsxklutvnIr
        TzVHN6KXuVqDJ4Vzg5Uw1dZYlWkEyEE=
X-Google-Smtp-Source: ABdhPJxo4bBpofEtt6yklQSlgOvZU9UXdZpjUYFcQQa7qaIlRyqsHBsjHnWUvH6K+FvtON4hEjgGcQ==
X-Received: by 2002:a17:906:8591:: with SMTP id v17mr173662ejx.378.1621261311927;
        Mon, 17 May 2021 07:21:51 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.151])
        by smtp.gmail.com with ESMTPSA id t2sm8484849edd.58.2021.05.17.07.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 07:21:51 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 3/7] kernel-shark: Clear before loading new session
Date:   Mon, 17 May 2021 17:21:36 +0300
Message-Id: <20210517142140.286153-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210517142140.286153-1-y.karadz@gmail.com>
References: <20210517142140.286153-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Make sure that all already loaded Data streams are properly closed,
before loading a new configuration from session description file.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsSession.cpp | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/KsSession.cpp b/src/KsSession.cpp
index 1e19a5f..b9edb3a 100644
--- a/src/KsSession.cpp
+++ b/src/KsSession.cpp
@@ -128,6 +128,7 @@ void KsSession::loadDataStreams(kshark_context *kshark_ctx,
 
 	data->unregisterCPUCollections();
 
+	kshark_close_all(kshark_ctx);
 	dataSize = kshark_import_all_dstreams(kshark_ctx,
 					      _config,
 					      data->rows_r());
-- 
2.27.0

