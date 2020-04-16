Return-Path: <SRS0=rfvd=6A=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07E07C352BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Apr 2020 16:01:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D723B214AF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Apr 2020 16:01:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k8foOUSz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636449AbgDPQBY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Apr 2020 12:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2636453AbgDPQAx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Apr 2020 12:00:53 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B876C061A10
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Apr 2020 09:00:52 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id u10so5978338lfo.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Apr 2020 09:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nABmTfUbCyU9kNO2bmfKjOVwTjnhkFAo2s5xCd797zI=;
        b=k8foOUSzeb6VH7QaII+x1b0OKPRBr0qscl3aKpLC9qs91julziMxqCFTPtpFjYT6Ay
         5cgAl6pgI1/5WzvJERt/dIGYunuDw4qL3+7jhnS/K9ExziNNf0hiF0MyAxH3AorSEphC
         U17QMlJs47pYsDztQp0cPFBxuUaPidqM699q8nAwMq7TECPZVdeHU849+kUzrDxWbuVv
         GAlvnXl8oGtoTNf742c1qAIjxaw2TH9AR4yW4xuVuWY+xyR7NG7N320EUz7qbQbZfEMO
         ZuqFz90X7k2wxQU6wQZAhTh852fr4jFAuGpY8iETroboOLKYEMdDDoolPFrXRBEkYkmF
         S9Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nABmTfUbCyU9kNO2bmfKjOVwTjnhkFAo2s5xCd797zI=;
        b=h8qDzM89tG315lFlpA3DLTQOAd52QvortAAI/gzhUZD3cTVandvUEem0+I5+Jui580
         dZTwR9siavi7FFxVaiT2asp2ASjRjcP3bvxLCEr1mr3KGLWd9OPrzYhnaYsQD6OKV8pm
         tWGk2MQQ27Et3Bxwjw6r4v2MxLZDaJ4ggXGnx0/X26c6OORoGlxlCF6yjKY9oN8E2dJa
         WVRFhks3ygVC23Y0MjiN5yV2/t656NnuY5A4uEI2AtCo2jjHqztgEHdWdj1WcTjaiWCK
         P5FpOsJOmYlUQN8+o3OQWguPdV4SotNPcZQFKWEuenglJlGyLc11DF7gKcdsrtXK5x7d
         uNwA==
X-Gm-Message-State: AGi0PubSfREYdNtX8+q+C4M7EMzW9E/KBOXzl5wnNlGABbbDVm9BMUu2
        In9RyeW0hg3yARBOLIFlFuM=
X-Google-Smtp-Source: APiQypJbjguuSp7eWgnJlrLz2QrVZF1rcXNqznWiC+XIZfrOTHRXS/3IzQGfqq1vAxhCvT7sAXsNpQ==
X-Received: by 2002:ac2:4a9d:: with SMTP id l29mr6085006lfp.4.1587052850672;
        Thu, 16 Apr 2020 09:00:50 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u2sm9030413lfk.67.2020.04.16.09.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 09:00:50 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 1/5] kernel-shark-2.alpha: Adjust the width of marker buttons
Date:   Thu, 16 Apr 2020 19:00:43 +0300
Message-Id: <20200416160047.77118-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200416160047.77118-1-tz.stoyanov@gmail.com>
References: <20200416160047.77118-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir (VMware) Stoyanov <tz.stoyanov@gmail.com>

Both "Marker A" and "Marker B" buttons were too tight to fit the button's label on them.
Add some extra space.

Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
---
 src/KsDualMarker.cpp | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/KsDualMarker.cpp b/src/KsDualMarker.cpp
index 3e0b462..e2b8ac1 100644
--- a/src/KsDualMarker.cpp
+++ b/src/KsDualMarker.cpp
@@ -145,8 +145,8 @@ KsDualMarkerSM::KsDualMarkerSM(QWidget *parent)
 {
 	QString styleSheetA, styleSheetB;
 
-	_buttonA.setFixedWidth(STRING_WIDTH(" Marker A "));
-	_buttonB.setFixedWidth(STRING_WIDTH(" Marker B "));
+	_buttonA.setFixedWidth(STRING_WIDTH(" Marker A ") + FONT_WIDTH);
+	_buttonB.setFixedWidth(STRING_WIDTH(" Marker B ") + FONT_WIDTH);
 
 	for (auto const &l: {&_labelMA, &_labelMB, &_labelDelta}) {
 		l->setFrameStyle(QFrame::Panel | QFrame::Sunken);
-- 
2.25.1

