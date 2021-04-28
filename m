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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60853C43462
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 13:47:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3703F61444
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 13:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239909AbhD1Nse (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 09:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239903AbhD1Nsc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 09:48:32 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C875C06138A
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 06:47:47 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id j28so10290415edy.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 06:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=da/1BDPs8qFHRz9rAFAjhMeP/98KJF/PClKzxL8bK9g=;
        b=ruoAXmvgM9h5z+W3T58loi97Q28jHWKMvrrVd7NyfNjg+lkwb8ep8jpSUZyzO/P0n2
         hxUp2pViS9JEG2AauizDUutbUO8762vJrQaRWjN1QQXZ1AedMtTaicwHOO5uyIs2E41f
         KlqHyPVZt9oUTVfvGg+l3pBEOHRQPqJy0CS21IWbXNvJq47FRGqrT4JX+Ffn7awGZsiQ
         5Gfbdwea1WdcDfxvk0PeIpYnHcTytzNYTD/b7UauAIRNYynQxgDpE8no/HdEobGxT9xe
         bhWmgC0Sv7RAmGP5yKIioUJ6vaoZpKPYUms/J6d3YFZemt383TAd1GvcyxALlQqUEogM
         YoQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=da/1BDPs8qFHRz9rAFAjhMeP/98KJF/PClKzxL8bK9g=;
        b=TwZDRv2w2F6KKA/jeoGCpkydiukBiZLswCK42UKFfiqE1aUkvlWItbl4Cb+ej9aU9C
         wBS5h3sDnEhfyV/yECGcxYpfTDnEqqXfRDMXRH4R6R+QlZXgiZux3AesebKrFKI7It39
         v85lCDhRzvgeeUFUpTtHpr91DU4Aa6dWj8a4s8fxnf9kRDEdHl9jpEmf9DCmOo2uIzNo
         e2BPbLo4ulEFTgLU2UbJSBAkKMmE+SO1/KifdxvxPmXGS4uNDdxLgxXBUC/qGpYBeoqD
         om+V8c3PPNDvxLYxw6isaqLU+bGoR7Oj9EqViBxNFWndIDunB7YSrhxWLviaYBCGalFB
         jfxQ==
X-Gm-Message-State: AOAM532xh5ipp5sP2qjwSVjxfh3FpDmTVoBvwKk9yj/wxw9wsTp8jnLu
        TZVJrkN0VLd7Xcqb4OwzdLZnoiEorq4=
X-Google-Smtp-Source: ABdhPJzmk78xDRj+gtVSydxneNO6dJbX8ihquJLYtgCF+oZjOigN1/bVUFfXB5EKHvSt14pWMwE9QA==
X-Received: by 2002:a05:6402:37a:: with SMTP id s26mr11500166edw.159.1619617666166;
        Wed, 28 Apr 2021 06:47:46 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id y6sm4755952edc.26.2021.04.28.06.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 06:47:45 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 7/9] kernel-shark: Remove kvm_combo from the list of default plugins
Date:   Wed, 28 Apr 2021 16:47:28 +0300
Message-Id: <20210428134730.187533-8-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210428134730.187533-1-y.karadz@gmail.com>
References: <20210428134730.187533-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The "kvm_combo" plugin is still under tests and is yet to be added to
KernelShark. For the moment we remove it from the list of default
plugins for "tep" data, so that no warning message is being printed.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark-tepdata.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index bc5babb..f7cd083 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -1210,7 +1210,6 @@ static void kshark_tep_init_methods(struct kshark_generic_stream_interface *inte
 const char *tep_plugin_names[] = {
 	"sched_events",
 	"missed_events",
-	"kvm_combo",
 };
 
 /**
-- 
2.27.0

