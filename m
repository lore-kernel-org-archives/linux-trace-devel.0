Return-Path: <SRS0=2N9E=BG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAE10C433EC
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Jul 2020 07:18:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BACE920792
	for <linux-trace-devel@archiver.kernel.org>; Mon, 27 Jul 2020 07:18:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RO6qjVNc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgG0HSb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 27 Jul 2020 03:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgG0HSb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 27 Jul 2020 03:18:31 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E8BC0619D2
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Jul 2020 00:18:30 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z18so10172952wrm.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 27 Jul 2020 00:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bYLkuNrXDKiXPijLaugrWX0mIr9Lg917hMvbMjuz0Jg=;
        b=RO6qjVNc9KA9rZojoSByVbD3dFnxiGnXLN2sPd5/3joU17jNNbINJ0aXKJDy6hbYbR
         q2sAyaYUjMqv5LanikTulyETz2fcD+gNJGd4oFMTLW/35Xh1SHrH1qyeXHDVjan1X8Kd
         LdwqBH7W3+6Kry/uGm5JLC+Cobaegru2ZEC33NRSQ/2ox0+CyxbfaHBzy1Zt5u8cbrE3
         DCCe3CIYv7xfWAkLLerzLhZiWoJudwkItahv6pmBCOTQTRriCrbp/Q9jVTapSt38aF18
         5AL42OR+3z4xL/y+cbRik+M2DfKEKNBQPdG+thrfU0f+r9bIyiJzP7p6TvHd64bF2ZKR
         RGRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bYLkuNrXDKiXPijLaugrWX0mIr9Lg917hMvbMjuz0Jg=;
        b=TAFIAnSfCb+3tbLIs65EP18AHA09S6S+5jbxyCraA5heYdw4U3SHov46/Wa4uOzDs+
         Fj6iVfYI14tXyXI5FJKcS5O7gvz1lb877TgmfbfJSg2BeenWJU2UZCjcsbgh+AE7os8q
         C6Yc6xGN6PuCTIOtEAzeo+NEuyMenk6lj2/zhTTNVyLCUeIwhnCnIOgFcbKoELb6ej7P
         noO2tZvGQKiP/gFBAyWuk+M4Scvthdwy1iabnHC5whmS9kFof9pWCzCLGDoplolf7kBQ
         8IRtf6TkxA3bXrWshyOqWalXBnouFwkoXbu3DDdiCoPCceGplxHZFTgYWg/Ij4V1LXIz
         ypdA==
X-Gm-Message-State: AOAM530cHsxcb0KuM3D56xgYez7997pUqeylvT7gYfWziYO7fG1kpMh4
        M0OK5T+jPk9XXRE4s18m8qo=
X-Google-Smtp-Source: ABdhPJxuyUfJcmaKn/Tky0dTBczH098OVGWtXo1NSL2qQlJir3+sWFWvlD8XGdW/4I3w4wNAbGn1sw==
X-Received: by 2002:a5d:514c:: with SMTP id u12mr19794076wrt.90.1595834309747;
        Mon, 27 Jul 2020 00:18:29 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j24sm12312162wrb.49.2020.07.27.00.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 00:18:29 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/5] KernelShark: Fix combo plot plugin crash in case of multiple streams
Date:   Mon, 27 Jul 2020 10:18:21 +0300
Message-Id: <20200727071823.169962-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200727071823.169962-1-tz.stoyanov@gmail.com>
References: <20200727071823.169962-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>

Added a check if there is a host-guest mapping in the loaded
multiple streams. If there is no such mapping, print an error and
exit the KsComboPlotDialog::update() function.

Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
---
 src/plugins/KVMCombo.cpp | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/plugins/KVMCombo.cpp b/src/plugins/KVMCombo.cpp
index ceb1f47..3ec36b6 100644
--- a/src/plugins/KVMCombo.cpp
+++ b/src/plugins/KVMCombo.cpp
@@ -246,7 +246,12 @@ void KsComboPlotDialog::update()
 	_guestMap = nullptr;
 	_guestMapCount = 0;
 	ret = kshark_tracecmd_get_hostguest_mapping(&_guestMap);
-	if (ret > 0)
+	if (ret <= 0) {
+		QString err("Cannot find host / guest tracing into the loaded streams");
+		QMessageBox msgBox;
+		msgBox.critical(nullptr, "Error", err);
+		return;
+	} else
 		_guestMapCount = ret;
 
 	KsUtils::setElidedText(&_hostFileLabel,
-- 
2.26.2

