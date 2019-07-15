Return-Path: <SRS0=+PQ5=VM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F687C7618F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Jul 2019 13:21:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 083912083D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Jul 2019 13:21:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s/Q+bKre"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730111AbfGONV0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Jul 2019 09:21:26 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45387 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730155AbfGONV0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Jul 2019 09:21:26 -0400
Received: by mail-wr1-f65.google.com with SMTP id f9so17034563wre.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Jul 2019 06:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EOBQ60ITXtZtIGdb716hV5lp4TeV2dveLh4AF40gqvY=;
        b=s/Q+bKreKedytPsnTQzHhfbOEzSnAqd+vBW1BLVLZZm3GnQlpPJGtEKwbIH1uHfo9M
         icOGv1YeRjPi2O8BCRy3a/oU1RtLkOjvtrZVlEsvwxPCoMey4Y/Shi4XHQ6aJKk9JNdU
         aaHfOcanxeQWOckUDGxZK7cM1cQ09EAYq5qaO5RcK0ElJH45/a7PBSXiCFd453VGMciR
         NcAgYGgJ51juECzD4leoPu7axYfJm6JQW3KzrDoDVxbDA+KOi0TKthl8izp4S55b/eWm
         P5G77d1frEQSedSshx/wLirD3O/taj+rMitQQPH3mUa89F2QEsSnpx7ISXJPo6+wt8rW
         UdBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EOBQ60ITXtZtIGdb716hV5lp4TeV2dveLh4AF40gqvY=;
        b=edUxB0vh4VjpVa0jnoqJzxadZGHNNTtiKGBzjxvK+hU7nYZDTvQLcDNNW/q2U61F36
         tzaoeUJ23oFQneulSjPg1v1c9B2+Zs/zBow12fMi6YBc8iFxY3vB75bTbIYLN9qN65kf
         8JYhz+t0gbaU3Lk4eVDacHoKn0QPWCNEn9poUBxqwgsvfaHwUIafWt0aR/8FMSlL4si7
         94b8ebKi1iK0fc1M+r1ACNlSZ6Qosu1gvwekSs8R2gUvY/Pq+KB45L24Azxb7amKE3eX
         M5Py6fB5CyfzUyqJCORtcqLRIhgVZCO6J4ULFOhrVlMINGCALJKmYcsCrQGGwhue0jGP
         zK7Q==
X-Gm-Message-State: APjAAAVv0Aux6hlzgwnJ3vPx4d8NfS732fEClMn+lCgKe3OeNfsM96AT
        Xl47fDLGFQev+jqffjvn98E=
X-Google-Smtp-Source: APXvYqztWcQ9LP3NYEf0B1QdB8/jQ2AJgDwurntikVSJ78NLTVQQCkcrl/Ads1iOQrI9TmsEhwVZZA==
X-Received: by 2002:a5d:6190:: with SMTP id j16mr17080094wru.49.1563196884128;
        Mon, 15 Jul 2019 06:21:24 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c78sm23819426wmd.16.2019.07.15.06.21.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 06:21:23 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/3] kernel-shark: Always clear the marker after resizing the table.
Date:   Mon, 15 Jul 2019 16:20:41 +0300
Message-Id: <20190715132042.5154-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715132042.5154-1-y.karadz@gmail.com>
References: <20190715132042.5154-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

It looks more like a Qt bug, but sometimes the automatic resize of
the table widget done in KsTraceViewer::_resizeToContents() has the
parasitic effect to select the first row of the table (making the row
green). If this is happening clear the selection by hand.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsTraceViewer.cpp | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel-shark/src/KsTraceViewer.cpp b/kernel-shark/src/KsTraceViewer.cpp
index 89e5dba..c176cef 100644
--- a/kernel-shark/src/KsTraceViewer.cpp
+++ b/kernel-shark/src/KsTraceViewer.cpp
@@ -563,12 +563,20 @@ void KsTraceViewer::keyReleaseEvent(QKeyEvent *event)
 
 void KsTraceViewer::_resizeToContents()
 {
-	int rows, columnSize;
+	int rows, columnSize, markRow = selectedRow();
 
 	_view.setVisible(false);
 	_view.resizeColumnsToContents();
 	_view.setVisible(true);
 
+	/*
+	 * It looks like a Qt bug, but sometimes when no row is selected in
+	 * the table, the automatic resize of the widget (the lines above) has
+	 * the parasitic effect to select the first row of the table.
+	 */
+	if (markRow == KS_NO_ROW_SELECTED)
+		_view.clearSelection();
+
 	/*
 	 * Because of some unknown reason the first column doesn't get
 	 * resized properly by the code above. We will resize this
-- 
2.20.1

