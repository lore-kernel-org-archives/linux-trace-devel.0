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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AE56C76192
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Jul 2019 13:21:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 346052083D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Jul 2019 13:21:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ubbmDjZH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730155AbfGONV1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Jul 2019 09:21:27 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:42114 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730162AbfGONV1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Jul 2019 09:21:27 -0400
Received: by mail-wr1-f43.google.com with SMTP id x1so2073970wrr.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Jul 2019 06:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1qWdphIC5MG/9KGy/S6VtxIcYiqQsZWRRowFrH6kblc=;
        b=ubbmDjZHQCK7CLx9wzWbrcFQyA5gyiQtfuVzhd2r0C4GjWnouI9xTs7UNtMXSsU9c4
         V1DOkLokkU9dzKRbQSkmniUewEOlPtp4lG/m/pz2AGdDieAyyA+neL3/ZWxrr7VMZL18
         ar2HR30rTUuJg2zm6wgSalQpCg47db9dvGunx/AKMrqLAQAx2O20Nt5gEJ4XxlfXaID+
         g4v7b8mbdo1QY8pvFhszSPgcBkjtfEqaucWR06q3sZUmbhwi/AFescUfUDmzCsyKn61E
         6UQs0CzxBSHFn8p6ZQ1ImNQV4IBxRrr5QqGa7mPQTABt0UVU1VXkXH6/1JktfyLmSmWH
         dISg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1qWdphIC5MG/9KGy/S6VtxIcYiqQsZWRRowFrH6kblc=;
        b=ofZLVonq2KumBKYsphG2LmeOhaLAkqGbDsKb6ndadVGz9rR1r+0fB5RTpSrGEOAF6N
         +7ZpLVgWz/xH7sHiG3ZYh/c6oN+gWRiLrU/b28Yt7odrr0aaob/IQC3s2XXDde1Uuq5i
         EFq80be0fWRLxUt1R0tv2wIpS+AwM/9JuPf3I17YjbsMSo3DA0zPFYSQ5Nclf0RfM5Dn
         c15j2MLtvuoMZQ9ATwD9Ew1gszxD1RzeF0onyCY/UpP7SKdKOccgYAF7FcU/EJ2DIjep
         kUBaHtkN3phmKVbuIQKIc7iRkZ3ccktdsmjb5/kA85WhaUhkMhLoDLOyzQoNw0ZosJ+i
         iWSQ==
X-Gm-Message-State: APjAAAVv2U5lF9nJIL50kUB4GJspiwJ5T7VXbMYsnls60M1tdHqYasDt
        Mti3sWU7NDWYNij1t6AbEQE=
X-Google-Smtp-Source: APXvYqz7M/thwNico+6kXL3MGDj6YuiHKEu2axhhW5PbpzJ1ToJgS9vVmWw2R5p/tpTXswvG2KjsDw==
X-Received: by 2002:adf:9f0e:: with SMTP id l14mr27228075wrf.23.1563196885275;
        Mon, 15 Jul 2019 06:21:25 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c78sm23819426wmd.16.2019.07.15.06.21.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 06:21:25 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/3] kernel-shark: Don't try to update the markers if no data is loaded
Date:   Mon, 15 Jul 2019 16:20:42 +0300
Message-Id: <20190715132042.5154-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715132042.5154-1-y.karadz@gmail.com>
References: <20190715132042.5154-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This change aims to avoid showing the labels of the time axis (zeros)
when no data is loaded.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsMainWindow.cpp | 18 ++++++++++++------
 kernel-shark/src/KsMainWindow.hpp |  2 ++
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 8826cf5..c8d9d25 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -1210,12 +1210,20 @@ void KsMainWindow::_splitterMoved(int pos, int index)
 	_session.saveSplitterSize(_splitter);
 }
 
+void KsMainWindow::_updateMarkData()
+{
+	if (_data.size() < 1)
+		return;
+
+	_mState.updateLabels();
+	_graph.glPtr()->model()->update();
+}
+
 void KsMainWindow::_deselectActive()
 {
 	_view.clearSelection();
 	_mState.activeMarker().remove();
-	_mState.updateLabels();
-	_graph.glPtr()->model()->update();
+	_updateMarkData();
 }
 
 void KsMainWindow::_deselectA()
@@ -1226,8 +1234,7 @@ void KsMainWindow::_deselectA()
 		_view.passiveMarkerSelectRow(KS_NO_ROW_SELECTED);
 
 	_mState.markerA().remove();
-	_mState.updateLabels();
-	_graph.glPtr()->model()->update();
+	_updateMarkData();
 }
 
 void KsMainWindow::_deselectB()
@@ -1238,6 +1245,5 @@ void KsMainWindow::_deselectB()
 		_view.passiveMarkerSelectRow(KS_NO_ROW_SELECTED);
 
 	_mState.markerB().remove();
-	_mState.updateLabels();
-	_graph.glPtr()->model()->update();
+	_updateMarkData();
 }
diff --git a/kernel-shark/src/KsMainWindow.hpp b/kernel-shark/src/KsMainWindow.hpp
index 62e66a0..7e2e839 100644
--- a/kernel-shark/src/KsMainWindow.hpp
+++ b/kernel-shark/src/KsMainWindow.hpp
@@ -232,6 +232,8 @@ private:
 	void _error(const QString &text, const QString &errCode,
 		    bool resize, bool unloadPlugins);
 
+	void _updateMarkData();
+
 	void _deselectActive();
 
 	void _deselectA();
-- 
2.20.1

