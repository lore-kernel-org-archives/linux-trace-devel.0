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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19FBAC43460
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 12:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0C896145B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 12:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbhENMTz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 May 2021 08:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbhENMTx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 May 2021 08:19:53 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E56C6C06174A
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 05:18:39 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id s6so34405983edu.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 05:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KztrVVn3EIMYdDMvJzGCzItRMyVQFSqBgkxfy+ofgeU=;
        b=i2diZGQhgx214wiAS2gBna9GzO8pIwWPaZ6SmEAFsU4A3825edqDuJVxD1Ny9hl230
         QvS77x7iUBEab8apJ//IXZd9gz2kpmE9tZMWSg4G/RpAfn71FHobpIGZyZDooACRQFgX
         uVFl7u7mVQzDZBealxxi/qVacxPxtSd+ww611E8puDqXaaEY3d4bmQYgpnmti9CZIgQy
         cJ2Yk1l40CIYqh8S+Rxgk0k5G1dJkWmMz02CXIbSGD5XH5TKfvaF2+FdIxXgIGQ8MyMi
         paPBSl1VA3kRArmFTvW4XM3kp4N52rLMNC4aApqxRfZPe8Z7P4XTUdB87HnuGOnPZ6oE
         7MIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KztrVVn3EIMYdDMvJzGCzItRMyVQFSqBgkxfy+ofgeU=;
        b=DxlTeHVscndnwZ4DjNI6wYOIwmGhmij9RfG3abWtc4iKWdHGxMJ4n3uQRYIjQgqvAd
         hJjNQRuO/MLnGPbZtmfx7lMZIeF1SmiowDVf8yhEil0mTb8Mhs6YmADKl3QW7Wwh7KEp
         Apaj4oJvIoAQ9d61fXnrh1FNQO0th+svTsQTtVMvxB1SXOcBkFKLwTWK6sJwogitWvOE
         wgDZOz81p3gAWn3qoLWjHqF1BB3NYnHO9sVs9JyKkQSfycnZi1W3Dr6ikU1G8DNECPLM
         JAIzJTCIIWUUzmIRMUcqoQjweN2d+ao6VA+Ny2y0NcWy22CpFzXCHQwBLH/sYre29CSN
         rurg==
X-Gm-Message-State: AOAM532Q4gPR1l/MEtrt8drSc+pLUM3ck2lpeKEJNLERqpCXhSCdkeol
        84HfNsUr/PeIwpC7CJjEfVn++LqgseA=
X-Google-Smtp-Source: ABdhPJxLfkDO4iCiuUeswZwtunGkBt8+tw1TG/F4iu5B5T8B7OmBKBW9HA2yhyQKEDTUnbsvokDlYw==
X-Received: by 2002:aa7:c7cc:: with SMTP id o12mr56942124eds.291.1620994718359;
        Fri, 14 May 2021 05:18:38 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id cr21sm3435157ejc.2.2021.05.14.05.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 05:18:37 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/7] kernel-shark: Preserve markers when appending data
Date:   Fri, 14 May 2021 15:18:20 +0300
Message-Id: <20210514121826.161749-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210514121826.161749-1-y.karadz@gmail.com>
References: <20210514121826.161749-1-y.karadz@gmail.com>
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

