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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1CBDC4320A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9900560EC0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236639AbhG1NdF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236603AbhG1NdC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:02 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5435BC06179C
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:32:59 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id h8so3254745ede.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fyPS4oNDtmiof/a3Ya2bE1YM21rC8zATkNEOg2c8d8Y=;
        b=qX6UNPa3tAYWCqkSXJ0RpEbc6fvNOPBJnGXypSdqE2aS4Hc1TnS2z1J3Q9dTF/blDR
         g+VUmVL16wu6VoUudumoq2BTxw+wdrCCBvDW+MuEh9OTRuKxY331//cjhFUr8NhAzDZO
         4/R3lDm6IPBeakvQxex55lhy/TbwbpsaX9wt2pJYjl1XAKrgvcK5i96JvxUweDl8Bme7
         8KexuXANESJClmUPmUtJInZ4LGBUmnp3kTU+bcxEu2RIOPyuM3tcWBOCP7ISwu1uT+nM
         2jiohklX9bQbcLr4nLWo7zDurjPGUOFL314wGy5ZNTjzRRDtVP46LehwJmzq2q6pYc9W
         AkXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fyPS4oNDtmiof/a3Ya2bE1YM21rC8zATkNEOg2c8d8Y=;
        b=HWPpABEpT037AFmBraJDuR/CdaWMtgl8RWb73xcVKD2rIZ8tdxqeMdbG1y7HaV47NK
         C1sNvlGCzHTtHgTxo1HMpw6ViFZQfJD8KPdLSXeLuZ7mdLBBPVBvVQuiiaVSZxUdXtLg
         KFAMhDlmcqh58CRURCFj8BQKtwII4eKPMJd725q8HE2alKOQCeR86E8aFjv5qsTzBr1B
         LGJIvHZeGsvGI/VGhO8bmdJO7PeE054TZOW7QTIDmWneDQMaFdkHHqFWFrmdBa+cxNV1
         AbQ/XFVxP2yGpzr5mPaUnVn8jQL0KanGzuiqZrkmQD3WqbMNS00lP0i5v3F2L3v9O71s
         xBHg==
X-Gm-Message-State: AOAM532BScP1PUF0MH4GqrzoyOMFFsK9UKU0YoMSLIdl+BcKhdTmzO53
        hUSv2GmpuLdWSeITtBm8Dw8=
X-Google-Smtp-Source: ABdhPJzYT1GIHqvX2+++7vVnqpLdNkuHEwR1fgDAeyvh/0ReG/EsREr5P3kY0tyo/GxSC7EdkE1Rcw==
X-Received: by 2002:a05:6402:2788:: with SMTP id b8mr34151221ede.244.1627479177981;
        Wed, 28 Jul 2021 06:32:57 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:32:57 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 06/87] trace-cmd library: Add constructor and destructor
Date:   Wed, 28 Jul 2021 16:31:29 +0300
Message-Id: <20210728133250.234140-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added empty constructor and destructor routines of the trace-cmd
library. They will be used to initialize and free compression context of
the library.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-util.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index b0c98c72..90e0155e 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -624,3 +624,14 @@ bool tracecmd_is_version_supported(unsigned int version)
 		return true;
 	return false;
 }
+
+static void __attribute__ ((constructor)) tracecmd_lib_init(void)
+{
+
+}
+
+static void __attribute__((destructor)) tracecmd_lib_free(void)
+{
+
+}
+
-- 
2.31.1

