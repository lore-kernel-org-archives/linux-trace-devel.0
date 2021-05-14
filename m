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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EE59C43462
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 12:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FC286145E
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 12:18:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbhENMT5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 May 2021 08:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232963AbhENMTy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 May 2021 08:19:54 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E91C06175F
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 05:18:41 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id t4so44462068ejo.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 05:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pxEhxlhjqSNlLDjkxyRGJ+PZ8OO1QwbqKOC2GyErYZQ=;
        b=fBgs47Vm/6AiTf49t6Z7A3yxz7r1LFpqnsXi4fBWT/UgcQg1UCyMQ4YEyNZtViAP49
         lzyKm1zPBHUpMTSQBmCbotPc5cm2v4L2dV1LrBNEBlktmnuB+L7is7OkiX/SS87Phw2e
         mBzZdIITko5D9fnefiATWH7xVSLYLoYbr6MaF+Sm7ofcGXb+rSWrQ9Vynq3OhAX0AMrx
         owsRl9O33Xq7KLlxtLPASlkZdB2Xg78RmoSZw+z7LNZMMxlSgMTgOD2OMxbfzDumAWOF
         VVNinpb+GqutMuALQPoD/SP5BrP+Onv9dI8mN1YlmraH306E/uupYxXPyywKgrae5KQ6
         ygOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pxEhxlhjqSNlLDjkxyRGJ+PZ8OO1QwbqKOC2GyErYZQ=;
        b=PF9JqLYJ/ZM/pM2mA6+y9wAqNYVim+y9EEubmzax2RekeAdmMfLJrRjBBLyne71uk3
         lF8Fd7St/MKRTU5vZKBDqgWAP7ovdPbq+gcndazxg+IByNcO6AmfzCfJERJ5Ij88T9BC
         hEKI7RLLXS8pr4P7fUrG6PO/Ophb45UdHufAMHySpvnJ2eUeH1ySxbQQ7dmpQHl5K4Fe
         jZMVMkTMYiZ78aFjVBiDLec11+nadlQKDwxVhhM/xsYFXQxEAVu4GZUm/75uRC/Gnpoz
         WC4TSxY5Asx4scVN68LZiKZ3x5m9+JkczStBC3V/ur189Nxh//IGcOQTXYZ27CuKMrAF
         ZZ6w==
X-Gm-Message-State: AOAM531//XQpolcwbCaBDoPeEUvYRsStxUzNlbC+BQzXOHyiMc16Mrcq
        0Fy66l1lUnb9SEq+FmYUHjs9l5TKjLY=
X-Google-Smtp-Source: ABdhPJxOf0dIoFCHuAMCRHZExNtnwFXf0Z+fI4IYZzTqONhurCcuxBw2jQb5d1F+ZjdjpHhW/yoJyA==
X-Received: by 2002:a17:906:58d6:: with SMTP id e22mr48685139ejs.216.1620994720502;
        Fri, 14 May 2021 05:18:40 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id cr21sm3435157ejc.2.2021.05.14.05.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 05:18:40 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 4/7] kernel-shark: Better handling of plugins when appending data file
Date:   Fri, 14 May 2021 15:18:23 +0300
Message-Id: <20210514121826.161749-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210514121826.161749-1-y.karadz@gmail.com>
References: <20210514121826.161749-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

It may sound like a good idea to reinitialize all plugins for all
existing Data streams after a new stream is appended, but it isn't.
Such reset will re-initialize all Data containers open by the
plugins, hence it requires to do a complete reload of all previously
loaded data. Currently we reset the plugins but do not reload the
data, which is a bug. Because, reloading the data can be slow on
large data sets, I prefer to fix the bug, by eliminating the reload
of the plugins.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsUtils.cpp | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/src/KsUtils.cpp b/src/KsUtils.cpp
index 757f49c..3db8951 100644
--- a/src/KsUtils.cpp
+++ b/src/KsUtils.cpp
@@ -677,8 +677,7 @@ int KsDataStore::_openDataFile(kshark_context *kshark_ctx,
 
 	if (kshark_is_tep(kshark_ctx->stream[sd])) {
 		kshark_tep_init_all_buffers(kshark_ctx, sd);
-		for (int i = 0; i < kshark_ctx->n_streams; ++i)
-			kshark_tep_handle_plugins(kshark_ctx, i);
+		kshark_tep_handle_plugins(kshark_ctx, sd);
 	}
 
 	return sd;
-- 
2.27.0

