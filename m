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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF361C47082
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Jun 2021 13:56:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7F8D61351
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Jun 2021 13:56:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbhFHN6X (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Jun 2021 09:58:23 -0400
Received: from mail-wm1-f49.google.com ([209.85.128.49]:42644 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233017AbhFHN6W (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Jun 2021 09:58:22 -0400
Received: by mail-wm1-f49.google.com with SMTP id l7-20020a05600c1d07b02901b0e2ebd6deso1934836wms.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 08 Jun 2021 06:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=55oWRdipxyNAdejx6zL6X9rpYX6wUCaJnDfUsVrLRsE=;
        b=gAE1DyfNcoBi3YsZ2dG/jN3TMkeLmcFPzNEscn7d8zNbW9g5+7CcfpPhO9FkhG92+y
         aVHCbkNk1+kJalW7xCD7xVM8Ra4ZPBN7awyXlFxzHIH4HhOX3QG3w7Ds0nDbkU9Pa3r5
         MyMd08H7OqXgLN02Uw5078cXKiJ4rVee7g9+kZ8eHuYJaZxVo6Od7CHfNR9he8GcMJ5D
         2ESD1g45lQbFI2XZmqUl1qo2jDjI1UZf9kL9w2zrQsYQMSLJC7qQ8Y1mDHiVAfICC0+Q
         YTWLFBLAh108kDrug4F0hIDeIUOJD2utWXcBO4CYIHad/sH2VBdzdAYKKtSqnImAhTaz
         0VMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=55oWRdipxyNAdejx6zL6X9rpYX6wUCaJnDfUsVrLRsE=;
        b=IMBthfYSab7xagROdg3Dr5fYVx7RCjIRwOG5oqpvQC5IiqWHa8Fymwy6eXIIX1QLDV
         NT9x1UN0z3gDcsFVkDb4eFuSX5Tz8p34/4QKnVnCi3mAo4+1MqfNGHBwgprRgKoJOdMh
         H+6sJH1WJ410VNBh1uJotYSGpoc4xvwew1LyH/iutskn2CRLMTD+F11eY5TK7AquhJYH
         2eJTMONyf/VH0KLuCYYWDkWk4hjTzJ8sM+I2Bu+eYjlFH/J1BqxM8wNYp//iEMM4DfFf
         d2x6rkhXhzKNhScBGqzLOaZdA7p4CHv5j749dIFsudQ39mBebEF2NQHIQc+zSzv1CzfF
         GV1A==
X-Gm-Message-State: AOAM531U/62tXGFnka0OG846ZcOHlUlJqbAw5+zLyDdY9SmrsUf44Z97
        AfnWKllIB7uufJPXLtCBwgQ=
X-Google-Smtp-Source: ABdhPJw1gUc+9kG4DW11IvaE5qrWtT7lgCk0fa9dMU90usgQnloMrEQfcE/LVWkXQLKNv31DMSE41Q==
X-Received: by 2002:a05:600c:5122:: with SMTP id o34mr14200388wms.168.1623160516070;
        Tue, 08 Jun 2021 06:55:16 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.164])
        by smtp.gmail.com with ESMTPSA id w13sm6806973wmi.48.2021.06.08.06.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 06:55:15 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/4] libtracefs: Fix enable_disable_all() return value
Date:   Tue,  8 Jun 2021 16:55:00 +0300
Message-Id: <20210608135503.12135-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

enable_disable_all() is a static method used internally by the
tracefs_event_enable/disable() API. In some cases its return
value gets propagated as a return of the API function but this
value do not obey the description given in the documentation.

Fixes: fc94d1a (libtracefs: Add tracefs_event_enable/disable() API)
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/tracefs-events.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 55316c6..8b2d9ef 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -822,8 +822,10 @@ static int enable_disable_all(struct tracefs_instance *instance,
 			      bool enable)
 {
 	const char *str = enable ? "1" : "0";
+	int ret;
 
-	return tracefs_instance_file_write(instance, "events/enable", str);
+	ret = tracefs_instance_file_write(instance, "events/enable", str);
+	return ret < 0 ? ret : 0;
 }
 
 static int event_enable_disable(struct tracefs_instance *instance,
-- 
2.27.0

