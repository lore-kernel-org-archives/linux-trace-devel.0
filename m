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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33143C43461
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Apr 2021 16:26:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F04BD613EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Apr 2021 16:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237542AbhD0Q1G (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 27 Apr 2021 12:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238973AbhD0Q0G (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Apr 2021 12:26:06 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E932C06135F
        for <linux-trace-devel@vger.kernel.org>; Tue, 27 Apr 2021 09:24:30 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id l4so90322526ejc.10
        for <linux-trace-devel@vger.kernel.org>; Tue, 27 Apr 2021 09:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=da/1BDPs8qFHRz9rAFAjhMeP/98KJF/PClKzxL8bK9g=;
        b=qKT9Y+yiG1gJSFcR1VSGbaOKjB5KKWgjRyfORGwsfBTJS/cn40ftjBlHqBOK4Zzais
         hB9bkX8EJsEKDz1HkD4d5ff4UjpZ+o13f9SQP4t9FfUeqAaBEQnaRYN8ctFgo3ars9xP
         LlZdrLxO1wqUK0YGkUpTcTDO6iWbfRe5xEg+CYzJ7FSG1E8s1ljDPEfR3vhtoEmwF4Cm
         +Vq3+OJwLwkQVx5b+SdR/xNQOZt9dMxkkHH2a1FvK4MiQ42dYj4n42UDvFJ8byPTdBus
         wcM6K0rBezjloJIo9Wx3MzVQXbAS/NdVckcVTRnucTBw2fUwlWtie+FsnW0ys+z/za0N
         uSmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=da/1BDPs8qFHRz9rAFAjhMeP/98KJF/PClKzxL8bK9g=;
        b=OSQx/miq0gmQfSoOgQ065YB6cJqlPIMGnAUW4advhPkciChm48qKwIDTjJrm9Of6UF
         XOSbn6ZGTdVSmC+9ltJaZYQoqGKBUGeh/Anv+lUtYsdBTZtT43qvkp6iuFG8OC3pOVOf
         f1UyEPoHjnQZSw9IUJmT6nOfsME7IOJTlM5zDya5dmVGN2gspxdhfbcPIuFMla29lfA3
         W58D0irSyUAssr+d1QaNAGpdcG70tzgB0OdpQHFl6drNUP/TIQcooOU9oikdF8pat5Ze
         qoPhrnl1O0SVyajmgemMAggShl2VZf3uXuTyiDmOqu3C0R2ABGS6wrIclTJdltMqXI2b
         qgmg==
X-Gm-Message-State: AOAM531PjdB4AZsSFXmRN6ZCPWKf2EJP8TW4ua5360uTCZLdRKJ+uc0A
        2HF8bG9V02LRE5hRvwgFC0jw0NI70EQ=
X-Google-Smtp-Source: ABdhPJytBSVS4yK/iVj5PABFgnMQFCiCWJaIOagAT4kBfSiPg9NcdVEuMEV/eowxOYQIyIa56/85/w==
X-Received: by 2002:a17:906:b315:: with SMTP id n21mr8252261ejz.219.1619540669007;
        Tue, 27 Apr 2021 09:24:29 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id d15sm2740284edu.86.2021.04.27.09.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 09:24:28 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 7/7] kernel-shark: Remove kvm_combo from the list of default plugins
Date:   Tue, 27 Apr 2021 19:24:08 +0300
Message-Id: <20210427162408.134001-8-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210427162408.134001-1-y.karadz@gmail.com>
References: <20210427162408.134001-1-y.karadz@gmail.com>
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

