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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94919C4363F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 14:59:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77B4960E0C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 14:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240292AbhEQPAT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 May 2021 11:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241238AbhEQO6H (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 May 2021 10:58:07 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2646C08E886
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 07:21:53 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id i13so7115694edb.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 07:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pxEhxlhjqSNlLDjkxyRGJ+PZ8OO1QwbqKOC2GyErYZQ=;
        b=op3Q9ffeD6F6IOl9LSBeDHJy6Vw+BO/P3nOZcro9OCNcpnjrS+Z/hrCTurS3U/S216
         xaqs12k0C1R74d/4eVgkSpsI8I/Kxn+SHsbjxu0lWUk5v2Iz6R8bwmL1oWsYJ3AOAZSp
         jEqBWrvgeva5BpwVeMC7fIvv7sR/uOeQ6UPnnousTV5PwlUT92HOTNTm+iL5wD1aTOWi
         QyW2h76XdHpzsz+3lokp0Mp/4Ga8gMWi60chKdTgBS2LUvNEhZBZ473/q7ZCWwTMLjwX
         lKH5HWOdlJcsCKY6SuuPFX1qtFHHOjZjn8vAtoFuDKVJVDA9ZOXfIFExwIdS5qJ4YA/E
         qZlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pxEhxlhjqSNlLDjkxyRGJ+PZ8OO1QwbqKOC2GyErYZQ=;
        b=TPBBhS4Ynzp+v/xJ6ew2hCllw81afWxtcR2YGZc0C+LSyE3N87fo6nfeG975T0wTkX
         3ynThmX3G+23gwlERlpCKx+7gKjSfBjjluQffMdta8Pbb485HtyOkqPEy5bbFYPm5uYg
         F33YP0OmA0/KIuWLJgQoQxasV75xT15LRtqyPCHL9tksQMeFyZURJtWA+8vz6nQJDgTW
         pS4krziSvz+f35Blk/D0TiIFkc6pe5CCXKTg6tU04REYTnTxZgZi//e52iDGwUbNH5TN
         xeCT+C5WLYFtGtcQPhufa0I0W7HMq66YY24d417dkNGrksDZDueX829p9GBxKov8KPvT
         PqeA==
X-Gm-Message-State: AOAM5326KLIbfvMIV5052Igup5efqLMWtqc1U/EAlKNGuXj2N0wTa4if
        AW8a7DYTh2spfSB3ZUmvVv3mfZ+Hzi8=
X-Google-Smtp-Source: ABdhPJxbAoJNQmEqvRnM75Ji8TsF79w34C73EdIj9AFdhAXBaI1JuO2r8uhDicwTJtRF78LWfWOzTA==
X-Received: by 2002:a50:d54c:: with SMTP id f12mr269943edj.301.1621261312610;
        Mon, 17 May 2021 07:21:52 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.151])
        by smtp.gmail.com with ESMTPSA id t2sm8484849edd.58.2021.05.17.07.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 07:21:52 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 4/7] kernel-shark: Better handling of plugins when appending data file
Date:   Mon, 17 May 2021 17:21:37 +0300
Message-Id: <20210517142140.286153-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210517142140.286153-1-y.karadz@gmail.com>
References: <20210517142140.286153-1-y.karadz@gmail.com>
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

