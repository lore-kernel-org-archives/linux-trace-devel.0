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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C01AFC43600
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 13:47:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F74661158
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 13:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239912AbhD1Nse (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 09:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239914AbhD1Nsc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 09:48:32 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9D6C061345
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 06:47:46 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id z5so37804534edr.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 06:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wDoYhbKqi7r7+XeFLpvtcL7WyvNxB0XsH3vwGXpVVCs=;
        b=NjQtJP8g1yPK74GrD1PzObxBZsx/h5n6EyLXdTIm5t/2vCdq5m0BurH9P3B5sNZDiM
         sSNrLdblnw7IuDS1yLncj/+SuvFxLtD4wxDANM8A7H7vzElu+8FH76k7ewEQvuwG6DRV
         3Usophpl5WvlJPgNqwVLlVOxde1C1t00MhZQEr/fVMYew15720u5qm7Tg3pWJbKWT56R
         PoMHykWgMyJNWTrv9GtRog/NboSlKLkKl6tCLi8fnMsGO/DGvHLLnXfSOMEz/jmDiGLc
         ZrcGrai9k8OW3f29Nux1fp9GgE24MHyS9yGdTMDGxfN4q4d1dZF3E7ygzxdMUTT3M2K5
         w5Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wDoYhbKqi7r7+XeFLpvtcL7WyvNxB0XsH3vwGXpVVCs=;
        b=B8/7W7kpWXBvz4yocm+eCGH5fbnS3ZV4poj7KdwCMMQe5D3TqwRlcW1ochyHZjEe4o
         LQIeEohSWYdxhTecVUiTyn/tivUeaQmyPt1DlkWdugoycONU2evi2luou1FrNhkgCanT
         iVATo42ExAMStZCGkv/WzChZ/whvtaFVu/WMzNEPhad5buRmfwN5bR+G0T/MXj1PTzMW
         TiqNIxLD8bl182K0a9JyR5dnWx4cX8XsLVlhPZl1eqgAQPesluPJ/29OERVoTtT1suFs
         bJqgKcYDWiztTu9pejqF+XYNafzG8c/gy5Q3XdGVwvrcKWjkx+UPvtPrMtQ9Hqi+Pw6i
         sebg==
X-Gm-Message-State: AOAM5313Ntybbf6Ttde9SnGo0bUGEBb2wHPqDkprgNI/vSyt2wQxATCy
        LUooGKbqmKXyPzdOdtHNZ0FpeUP2vH0=
X-Google-Smtp-Source: ABdhPJz5iKK9mQHGryfB/6hfUeZ/lQCNrAhcDpAnKWn8s1N1G1nfW4G+qdpHh0N/JjHPL3g6GMFO8g==
X-Received: by 2002:aa7:d705:: with SMTP id t5mr3258349edq.141.1619617665181;
        Wed, 28 Apr 2021 06:47:45 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id y6sm4755952edc.26.2021.04.28.06.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 06:47:44 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 6/9] kernel-shark: Disable the pop-up offset dialog
Date:   Wed, 28 Apr 2021 16:47:27 +0300
Message-Id: <20210428134730.187533-7-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210428134730.187533-1-y.karadz@gmail.com>
References: <20210428134730.187533-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The pop-up dialog that asks for the time offset, when a trace data
file is appended, is a legacy from the time when we have been doing
the calculation of the offset by hand. It still can be useful in some
specific cases, but the user can do the same from the "Tools" menu.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsMainWindow.cpp | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/src/KsMainWindow.cpp b/src/KsMainWindow.cpp
index e830c5e..d0a434a 100644
--- a/src/KsMainWindow.cpp
+++ b/src/KsMainWindow.cpp
@@ -1248,7 +1248,7 @@ void KsMainWindow::_load(const QString& fileName, bool append)
 	QString pbLabel("Loading    ");
 	bool loadDone = false;
 	struct stat st;
-	double shift;
+	double shift(.0);
 	int ret, sd;
 
 	ret = stat(fileName.toStdString().c_str(), &st);
@@ -1264,15 +1264,6 @@ void KsMainWindow::_load(const QString& fileName, bool append)
 
 	qInfo() << "Loading " << fileName;
 
-	if (append) {
-		bool ok;
-		shift = KsTimeOffsetDialog::getValueNanoSec(fileName, &ok);
-		if (ok)
-			shift *= 1000.;
-		else
-			shift = 0.;
-	}
-
 	if (fileName.size() < 40) {
 		pbLabel += fileName;
 	} else {
-- 
2.27.0

