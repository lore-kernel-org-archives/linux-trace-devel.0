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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D20DCC43462
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 14:59:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEF34601FC
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 14:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239741AbhEQPAP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 May 2021 11:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240065AbhEQO6D (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 May 2021 10:58:03 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB9DC06123A
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 07:21:51 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id k14so5992443eji.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 07:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KztrVVn3EIMYdDMvJzGCzItRMyVQFSqBgkxfy+ofgeU=;
        b=Cg0HLzf7CXwTfspFtu+a3UBD8mt4peltm7aNxermSHpBsgx00ShOXHHPWXIhPBTDBv
         RzMGXlepYGdiXOQIsQ7kFf8o/Yug6dxJiHZSKTBHS+aDOsvDelH8zNalOqbvIcfit2rM
         kNEH1OfycKZrMP0JzULw4FVU5WwetnlAs0GY7vxULCeI0kCRVXiyEy/agJwMyH7gWyQ6
         sPoBI17yohECkYCp3VbJh3PUmiEKEn4z5T//kaRZTLTQi1DIWP4Wop7QyjjQ3pleYcdF
         3T2vY0jpccZCNlGqVOrzpPn3f/8aoavPDSePCmitco2Onn27hM4SMVL6a/SIf2Rs88JI
         hSXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KztrVVn3EIMYdDMvJzGCzItRMyVQFSqBgkxfy+ofgeU=;
        b=X9y3ZdL0PjXz5hEFLHQh0wxnjlksEADYGZvkKDkQG73djVKd7j5xkV8DbMEp6JrCS4
         GMR7D6TuvTYGtusi6OTEyPTQwBYoZrGjxBRbfJUv4EU7kiiQxcz5IFqasPH00MuxLQj4
         VoTpHzWoS4JNrRQfBA0bEddvfs8h1BqrgGLwe1TgZZx9YOAwYuacIvvWUjOqJxQBcWz4
         ugZ/Zn9SocGW6j4dCXv3lNV7dRLglVpQtb4aSsWPUWzBX7WV0i/3TTOpLHSPHVtXDbcy
         0xO898Nkx317IduDuzkRcxgizyYpvItkOlOZos1+nmYTde2AWs5b0LP9nio91DcPWyJa
         Hw7A==
X-Gm-Message-State: AOAM5304EEzoxtl7ZLh/eqYVHQQ4Ju+J1e28vJ5MjTPQzGtTA7hcgpLT
        8X6nWXd+QgWuDTdpIalVwna7z96/foM=
X-Google-Smtp-Source: ABdhPJwsC3+jeefnbX+Jnt2WsadOlWRX1jpi/yvrcVMX5b42z/iAtYOSucsutMULpX6TXvvUQbws1w==
X-Received: by 2002:a17:907:62a7:: with SMTP id nd39mr165435ejc.502.1621261310112;
        Mon, 17 May 2021 07:21:50 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.151])
        by smtp.gmail.com with ESMTPSA id t2sm8484849edd.58.2021.05.17.07.21.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 07:21:49 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 1/7] kernel-shark: Preserve markers when appending data
Date:   Mon, 17 May 2021 17:21:34 +0300
Message-Id: <20210517142140.286153-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210517142140.286153-1-y.karadz@gmail.com>
References: <20210517142140.286153-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When an entry is selected in the KernelShark GUI (using marker A and
marker B) we only keep track the index of this entry inside the array
of entries loaded at the moment of selecting. However, then a data
file is appended, the new entries are merged to this array and the
array is sorted. As a result the index of the marker can/will point
to completely different entry.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsDualMarker.hpp |  6 ++++++
 src/KsMainWindow.cpp | 24 ++++++++++++++++++++++--
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/src/KsDualMarker.hpp b/src/KsDualMarker.hpp
index 0dcaf93..39c0ce2 100644
--- a/src/KsDualMarker.hpp
+++ b/src/KsDualMarker.hpp
@@ -154,6 +154,12 @@ public:
 
 	void updateLabels();
 
+	/** Get the index inside the data array marker A points to. */
+	ssize_t markerAPos() {return markerA()._isSet ? markerA()._pos : -1;}
+
+	/** Get the index inside the data array marker B points to. */
+	ssize_t markerBPos() {return markerB()._isSet ? markerB()._pos : -1;}
+
 signals:
 	/**
 	 * This signal is emitted when the Table View has to switch the color
diff --git a/src/KsMainWindow.cpp b/src/KsMainWindow.cpp
index d0a434a..fa893ce 100644
--- a/src/KsMainWindow.cpp
+++ b/src/KsMainWindow.cpp
@@ -571,8 +571,15 @@ void KsMainWindow::markEntry(ssize_t row, DualMarkerState st)
 /** Select given kshark_entry with a given maker. */
 void KsMainWindow::markEntry(const kshark_entry *e, DualMarkerState st)
 {
-	ssize_t row = kshark_find_entry_by_time(e->ts, _data.rows(),
-						0, _data.size() - 1);
+	ssize_t row;
+
+	if (!e) {
+		_mState.getMarker(st).reset();
+		return;
+	}
+
+	row = kshark_find_entry_by_time(e->ts, _data.rows(),
+					0, _data.size() - 1);
 
 	markEntry(row, st);
 }
@@ -1341,7 +1348,20 @@ void KsMainWindow::loadDataFile(const QString& fileName)
 /** Append trace data for file. */
 void KsMainWindow::appendDataFile(const QString& fileName)
 {
+	kshark_entry *eMarkA(nullptr), *eMarkB(nullptr);
+	int rowA = _mState.markerAPos();
+	int rowB = _mState.markerBPos();
+
+	if (rowA >= 0)
+		eMarkA = _data.rows()[rowA];
+
+	if (rowB >= 0)
+		eMarkB = _data.rows()[rowB];
+
 	_load(fileName, true);
+
+	markEntry(eMarkA, DualMarkerState::A);
+	markEntry(eMarkB, DualMarkerState::B);
 }
 
 void KsMainWindow::_error(const QString &mesg,
-- 
2.27.0

