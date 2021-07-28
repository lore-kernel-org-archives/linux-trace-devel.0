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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 807BFC4320A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B39B60FED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236676AbhG1Ndk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236689AbhG1Ndj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:39 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1607BC061764
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:38 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id x14so3196647edr.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OREUnBoRoR7VMp+Aqo8jjC2Lg6VH1b1+0w0rwiN0wh8=;
        b=hHpQYZD1+VvA1pTuowZnb2HUR8ieRgHfh/XnQ8ukCpSO2e4vXM5XsMuqLu4ofskoSx
         /w1LKUn4jwQz03OuMr2f3HRuiVakJKA0Q+bfuxZtvag5SMjNannTqmkcamj0ugaq/Xus
         D9fpX0Mon1b28w6hDU/vbjIHsQQfgeImpJVE5kJ6XQhSuXuxtaxBy5vly1WFmqfJPymJ
         Wm9DXT54RMdxSCBIkDzN7dtwIHomMfxLm5V3Ud4wQ5fnF2TfrHgkccDsV/0SOGGZn8JE
         rr4m34ev8dZ+SmTfUWhVRMtXNAH1q6HFueIe0/ufZIasspEQl2iQf13d92sBSCL0mEtq
         kMBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OREUnBoRoR7VMp+Aqo8jjC2Lg6VH1b1+0w0rwiN0wh8=;
        b=Iq0OPn9i3A2O3lIVcRyn2M8F2lKaEOYHF3bbaX7OfmWgTI+mrBHfJ9qsiS4p5M5Kcn
         u8CKTWtLnylUGjDMJGJircKJYBeN6XTStcQx9qOZgKLWgW3m6A6SGXsEXrbOgoOdNjDy
         AdAwJhMWqdxkYeB/sQGxDaUjViF0pR+NvylfNFjGdPvbD6w+ToVhdfpERcLR9NLuAlvV
         zHAegUCu0v1spiO4ivw7SUSdxVnBn8bIGBjj+yKit1M2hPSTvsI0SccKtSee9p+K+jZt
         NjRbZLlfkxk9uqTASnIxkYWRMLxTxCz8EDRcUy/mL8yU4wJVKaIWnrf/+0lWoAQRvLSr
         1CWA==
X-Gm-Message-State: AOAM532gC/1/Gmk/3OPTePT0k93WLPVVm29DlRfixL6xP3kBNveTd7Is
        VxVeYE3dxL+5gcbuQp3n/pU=
X-Google-Smtp-Source: ABdhPJyljlhzy0mow3RawEzSUn8Q2r6NS3laiyj8MOldBgGdUNRXZXzWiYTUyQc5S7ZTkF7SMyORgQ==
X-Received: by 2002:a50:ff03:: with SMTP id a3mr29520540edu.0.1627479216759;
        Wed, 28 Jul 2021 06:33:36 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:36 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 44/87] trace-cmd library: Set input handler default values in allocation function
Date:   Wed, 28 Jul 2021 16:32:07 +0300
Message-Id: <20210728133250.234140-45-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Set usecs flag by default when the input handler is allocated, it makes
more sense than setting it when options are handeled. This clean up is
needed for parsing version 7 trace files, where multiple options
sections may exist.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index b66436ab..2c626d37 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2795,8 +2795,6 @@ static int handle_options(struct tracecmd_input *handle)
 	int cpus;
 	int ret;
 
-	/* By default, use usecs, unless told otherwise */
-	handle->flags |= TRACECMD_FL_IN_USECS;
 	handle->options_start = lseek64(handle->fd, 0, SEEK_CUR);
 
 	for (;;) {
@@ -3448,6 +3446,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	handle->fd = fd;
 	handle->ref = 1;
 
+	/* By default, use usecs, unless told otherwise */
+	handle->flags |= TRACECMD_FL_IN_USECS;
+
 	if (do_read_check(handle, buf, 3))
 		goto failed_read;
 
-- 
2.31.1

