Return-Path: <SRS0=D6y3=CL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D5DC433E7
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Sep 2020 16:12:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B6482072A
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Sep 2020 16:12:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BsscbVEx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgIBQMc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Sep 2020 12:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728400AbgIBQLY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Sep 2020 12:11:24 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7C1C061244
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Sep 2020 09:11:24 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id u18so4966768wmc.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 02 Sep 2020 09:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2uRy2nceF5l5ASXAf6QKwB+JajiOqT7PPYRAL2ZFqYI=;
        b=BsscbVExIJzOVeTgKXTnVLGVdLWYgQz3k7gi2dZ1GB+9xjtaJFVCgLoghHvXSBg6Vx
         gCSHGWAvS/qyMCVcOIVyRHoSXnweCFeZy1LXhAeHhxJ+ftmm/2tMhyQwk3y6BZe7zCq+
         ZjelUw157skgYL2DSLokjAb2uQxZCZLsJqEnHHcaHpr4uA/0ae4DrL26Nqsy5sKHMkiY
         ZJ9NQp0D1VXAK4pFnKJwuopybDxvj5nmpgWf3/5TrDX7VXmNpbeM2fUKGWMpUo0w8w7X
         vEakgBvwi8gx5/kdcFrMxIk1oEK5Q6FHT2Zb4wv5Lt8V2/fHc2c6ku4Oi8Rkp5nouyNo
         8ROg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2uRy2nceF5l5ASXAf6QKwB+JajiOqT7PPYRAL2ZFqYI=;
        b=dkJX5AigtFrwxA6D89dNP6KUiME3+4bJsb6U3M2fjZy2NcjFVjDKCbJc9ybJxLcs2O
         VYwCtfM9W3bmMmgbMo7HoyTVvg72+RORZXwbZnJgCeeLUZykwkxOVDTziqZxPH4BGWgz
         lGG36EExKLHCfZVjT3jNONAw8dMZeD4OeSr/sLmkehNOVYV5lqXVrxZWHL+l+UbNKqpp
         twyyv2ywJMrdoYXgIpohAL0jS8yp+4IsjB+vesRvqyPgtQD9j/8sCEHilxcnCSZkIHgB
         9v5CCVJtZTEyon04DqZXSy42uR0itWx+likg46ArYC8146DYNNM7sCpEkOGVAT04VrF7
         NBhw==
X-Gm-Message-State: AOAM531mztPYO8Q2lxvvwjuW+AGdcdHX6S+22rTfkQmcJLra9+wBwIvw
        Fxscf9hABcnU/meXZopkWhvl8ilaNBwqnw==
X-Google-Smtp-Source: ABdhPJysdp2WMxnxAZ+C3/oZgTKhOV+OnS1qTDMRzULTBOYLokMrLKYp9F3SvAsj1/zVg/lf31J4kg==
X-Received: by 2002:a1c:7912:: with SMTP id l18mr1394264wme.124.1599063082773;
        Wed, 02 Sep 2020 09:11:22 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p22sm167506wmc.38.2020.09.02.09.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 09:11:20 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] KernelShark: Add guest's stream ID to the combobox item.
Date:   Wed,  2 Sep 2020 19:11:18 +0300
Message-Id: <20200902161118.46163-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>

When a new stream is added to the list of guest streams in the ComboBox
plugin, attach the stream ID to the entry as well. Later, when the
stream is selected from the list, this ID is used to get information of
the stream.

Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
---
 src/plugins/KVMCombo.cpp | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/plugins/KVMCombo.cpp b/src/plugins/KVMCombo.cpp
index 4ca33d4..bc3c6b0 100644
--- a/src/plugins/KVMCombo.cpp
+++ b/src/plugins/KVMCombo.cpp
@@ -269,7 +269,7 @@ void KsComboPlotDialog::update()
 			continue;
 
 		streamName = KsUtils::streamDescription(kshark_ctx->stream[sd]);
-		_guestStreamComboBox.addItem(streamName);
+		_guestStreamComboBox.addItem(streamName, sd);
 		color << colTable[sd];
 		_guestStreamComboBox.setItemData(i, QBrush(color),
 						    Qt::BackgroundRole);
-- 
2.26.2

