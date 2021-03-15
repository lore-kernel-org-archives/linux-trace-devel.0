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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36E21C43619
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:19:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16DCF60240
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:19:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbhCOGS7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Mar 2021 02:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbhCOGSo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Mar 2021 02:18:44 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C45C061574
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:18:44 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id e19so64292063ejt.3
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gUyvPCagh4Vt6i8rfn0r1Yh65oM97Xk+G2v/+Ya9ufY=;
        b=D6oYyM+VChofY+LYwfSa1frjjW63bm/v3KgJvNnnvTYIe7yCm0zkAHl2GI+BR/daDm
         aME57wPx90HDu2EbrJNHpss5hy0rJoiOnwZBgscdf/cyaaRiUTIN8sly0BX5hPg05cyB
         nFFkAS4AI4xCbjJ9c7CueCNpYtybbS8R76yEyYJdQgY6A0t9ON9uzSLbyM0wbAYyRzPo
         ubwRi5/TskLuNuT7HsTP9uVP8Lfu3ThOE/IWOvJpG8Re5f3DMjcRwmqw9UaIJLh3H4qB
         h08IxPslvicMdPx1xN12eyHKM+SUqCXwM4ucWW2q7RECumhT/guBLer2eI9DkWqwhmdu
         fZ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gUyvPCagh4Vt6i8rfn0r1Yh65oM97Xk+G2v/+Ya9ufY=;
        b=UaUkbTi05mgqFSnsxBh2ehKgzxVqD5ILQ7SqIsumhQOrKS6OdRql8f3IfOKrqlLZct
         1cDX9fu4r9vsHK1FZ03cbVgV6Mzecdvl2NhhYAkVz6pksMl7Xqs8knfa5lrf7FirT4OU
         2+NpZn3BIWjr6Mu2NO93h/Iwi9LzQaonbPOXhhS2TDb6t0v4muIG3qFJOBx+KLddDx0n
         SN6uviQ3xj/pESosRtbsGGV2RXWljotZDU1vlrrzir0LhR/FJCHgQjNWmRcaJ/VAA/ma
         2f8P0TRS82mnJy9WRTBdMxGaFleg1brA6vjP9/kB0zmviFEp4yXUa71kvR5qxTdEwPnl
         Z8ug==
X-Gm-Message-State: AOAM533ir/ade386lhPFXtnnom57lCm3CLfE4de3J7In/lW2UwpVdfXq
        QxxM7Bi3hP6lMKNjv5JQZvM=
X-Google-Smtp-Source: ABdhPJwGmhC2jvmFV9ITZ29Us5WYIKEy7xYsnLkJpmLvYDx9ozNuiwdNPWet8OynPVAEtsRkarX8Qg==
X-Received: by 2002:a17:906:ad4:: with SMTP id z20mr21234376ejf.496.1615789122924;
        Sun, 14 Mar 2021 23:18:42 -0700 (PDT)
Received: from localhost.localdomain ([130.185.229.134])
        by smtp.gmail.com with ESMTPSA id t6sm7468478edq.48.2021.03.14.23.18.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 23:18:42 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 07/12] trace-cmd: Remove unneeded multiply in events timestamp reading
Date:   Mon, 15 Mar 2021 08:18:27 +0200
Message-Id: <20210315061832.168495-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210315061832.168495-1-tz.stoyanov@gmail.com>
References: <20210315061832.168495-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When the event timestamp is converted to seconds, the local variable
that holds this timestamp is converted to seconds also. As this
variable is not used in the function later, this conversion in not
needed.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 1e925f45..5384ad90 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1932,10 +1932,8 @@ read_again:
 
 	handle->cpu_data[cpu].timestamp = timestamp_correct(ts, handle);
 
-	if (handle->ts2secs) {
+	if (handle->ts2secs)
 		handle->cpu_data[cpu].timestamp *= handle->ts2secs;
-		ts *= handle->ts2secs;
-	}
 
 	index = kbuffer_curr_offset(kbuf);
 
-- 
2.29.2

