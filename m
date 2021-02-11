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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FFB5C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:36:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA5F164E6F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhBKKfe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 05:35:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbhBKKdI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 05:33:08 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF759C06178A
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:25 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id s5so6379452edw.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XmVcXJgUz0miHehNivT+tRvOfOrwtVKDeNmjrBnSb5g=;
        b=n33J0nfmLFozr/ic4L3eXn5y2pVx8QSzNJe0ZNkGMdk4aaRRkWg7YncC3+EU3+2A5A
         /QyN6NSvYg5Tz9qiRnbso6tloMaj5a12PgeXuuINrhiksUI1LZgI/UiVqzKR0eItGYBZ
         z2/selfybcQRfC5druuDBRENNXMtsvEpM0eCIYFxkpqLmNqpRkjluaOhiD5Bm/fGMhgk
         Y0Cotu8qmlBM/KKDGzKHxkac+bxKsAw0Y15BQ7OduUuNGqHq7+9WXAkxAqPo62PoehNq
         wcgZQwucV2QP0HNcjW7Cm/kJEbKqFxawejNXmu6kojxxs49HQVkCNU3dOzERNAWEmxSh
         vfTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XmVcXJgUz0miHehNivT+tRvOfOrwtVKDeNmjrBnSb5g=;
        b=KljtA0TZ4fPAIZkF/HMW6PsX5JbK7COyoioCsPrIgM5BKVR1fA4H6yz9qKidceGbFu
         eYtKqKbe8DnLS9XIJZs7CnQUl0T+jdNOFu+xvcH5y7En8VHNq1W4oPixUaFuHICc3Ng1
         DBoe3DFzhvf0BMfQHu9AcNK/6Iqrv1bAo08kekXCKTD2inru1yRE0NZ5oSwlzJkicsfm
         SQhfiO3DGhPSPnz6AUenDOlOiMTWcsgLTI1Bxq8l0n+Y7iXEwnAjg9W3o1jrnZOYqy/0
         VwxOXVQzk15i52ucRrVYeBeQS0lJP6+3UmQJCqlbrl7t2/S0VLLcseFN8qOd6b2I/kuv
         wYmA==
X-Gm-Message-State: AOAM5319f8UiANpKheSdJjXkVDxsLhkRBN5iZJtMSfK7RLyriVXboPMv
        5zUK1zQoBo836snHK+7PY8457VN6FtA=
X-Google-Smtp-Source: ABdhPJzNfqRdxE59jMXMILyfvr8e+kH69piYuUwtJe+faN3S+PgPiQdoNX+hitFkJnUlin3RtjdThA==
X-Received: by 2002:a05:6402:1484:: with SMTP id e4mr7924400edv.104.1613039544677;
        Thu, 11 Feb 2021 02:32:24 -0800 (PST)
Received: from localhost.localdomain (212-39-89-223.ip.btc-net.bg. [212.39.89.223])
        by smtp.gmail.com with ESMTPSA id bd27sm3514031edb.37.2021.02.11.02.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:32:24 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 04/27] kernel-shark: Fix a misleading comment
Date:   Thu, 11 Feb 2021 12:31:42 +0200
Message-Id: <20210211103205.418588-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211103205.418588-1-y.karadz@gmail.com>
References: <20210211103205.418588-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark-plugin.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/libkshark-plugin.c b/src/libkshark-plugin.c
index b85d0e9..bc68186 100644
--- a/src/libkshark-plugin.c
+++ b/src/libkshark-plugin.c
@@ -577,7 +577,8 @@ kshark_register_plugin_to_stream(struct kshark_data_stream *stream,
 			 * The plugin has been registered already. Check if it
 			 * is initialized and if this is the case, close the
 			 * existing initialization. This way we guarantee a
-			 * clean new initialization from.
+			 * clean new initialization from kshark_handle_dpi()
+			 * or kshark_handle_all_dpis().
 			 */
 			if (plugin_list->status & KSHARK_PLUGIN_LOADED)
 				kshark_handle_dpi(stream, plugin_list,
-- 
2.25.1

