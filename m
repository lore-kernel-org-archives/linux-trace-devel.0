Return-Path: <SRS0=4mzf=QT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22330C282C4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Feb 2019 17:04:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0DCC20700
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Feb 2019 17:04:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729617AbfBLREc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Feb 2019 12:04:32 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40410 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729700AbfBLREc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Feb 2019 12:04:32 -0500
Received: by mail-wr1-f66.google.com with SMTP id q1so3512277wrp.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Feb 2019 09:04:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0Hx1wgVdc1G6EHiAOFyWhFcEZrPnlmzgJ43u/19ITrA=;
        b=IJwZCBpfefcBrRNPWTTRvNxjsEATkB7rc8xwLjRezyJsepe/Sy7TR83zWGfgKudyd1
         vpamEThgLvZazD8EOvV9ENHrjHHC8skHNRnUDULz+HKewcHlMVOxC2OKl2tFpAzua/T5
         PqOSMApMOFsDL7xycGl/DAmHZ9jPZVvH3lV9yQQo4guhgNAtQ8NYRKr5xmc2SMgT+qXb
         SVrg84+h97loPknlVCQapize7Fniv1H89ZStn5BbVU593hD07Bky34KF+1FcuDNvZO9Q
         jiJt8aqDG3hCRSBrd28J7mTAFiqq0LKF+pEsQWXuln59HqbtKzJJh0TY8HqkKIHJS6m9
         YnDA==
X-Gm-Message-State: AHQUAubgiYJXr7fmZ5JmDg12UyzBLxxNv5zBYMe8YGSFq3i2jMdOjTgM
        wogniSVzqHK0svlvL0PpFXw=
X-Google-Smtp-Source: AHgI3IagxvINaSxQQY9A2p8pV8MHkYETMVUxvD6nYFHRaRZQ2sJWj0sNmIBdLXNvSkNTlc9LCntuGQ==
X-Received: by 2002:adf:e706:: with SMTP id c6mr3682597wrm.278.1549991070810;
        Tue, 12 Feb 2019 09:04:30 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c139sm5579732wmd.13.2019.02.12.09.04.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Feb 2019 09:04:30 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 4/5] kernel-shark-qt: Do marker-deselect by right mouse click of the button
Date:   Tue, 12 Feb 2019 19:04:01 +0200
Message-Id: <20190212170402.10104-5-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190212170402.10104-1-ykaradzhov@vmware.com>
References: <20190212170402.10104-1-ykaradzhov@vmware.com>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Methods for deselecting Marker A and B are added to KsMainWindow. Those
methods are connected to the "deselect" signals of the two marker buttons.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202327
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsMainWindow.cpp | 30 ++++++++++++++++++++++++++++++
 kernel-shark/src/KsMainWindow.hpp |  4 ++++
 2 files changed, 34 insertions(+)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 06770d9..443b7b0 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -119,6 +119,12 @@ KsMainWindow::KsMainWindow(QWidget *parent)
 	connect(&_deselectShortcut,	&QShortcut::activated,
 		this,			&KsMainWindow::_deselect);
 
+	connect(&_mState,	&KsDualMarkerSM::deselectA,
+		this,		&KsMainWindow::_deselectA);
+
+	connect(&_mState,	&KsDualMarkerSM::deselectB,
+		this,		&KsMainWindow::_deselectB);
+
 	_resizeEmpty();
 }
 
@@ -1137,3 +1143,27 @@ void KsMainWindow::_deselect()
 	_mState.updateLabels();
 	_graph.glPtr()->model()->update();
 }
+
+void KsMainWindow::_deselectA()
+{
+	if (_mState.getState() == DualMarkerState::A)
+		_view.clearSelection();
+	else
+		_view.passiveMarkerSelectRow(KS_NO_ROW_SELECTED);
+
+	_mState.markerA().remove();
+	_mState.updateLabels();
+	_graph.glPtr()->model()->update();
+}
+
+void KsMainWindow::_deselectB()
+{
+	if (_mState.getState() == DualMarkerState::B)
+		_view.clearSelection();
+	else
+		_view.passiveMarkerSelectRow(KS_NO_ROW_SELECTED);
+
+	_mState.markerB().remove();
+	_mState.updateLabels();
+	_graph.glPtr()->model()->update();
+}
diff --git a/kernel-shark/src/KsMainWindow.hpp b/kernel-shark/src/KsMainWindow.hpp
index 44f7dd7..abfe196 100644
--- a/kernel-shark/src/KsMainWindow.hpp
+++ b/kernel-shark/src/KsMainWindow.hpp
@@ -218,6 +218,10 @@ private:
 
 	void _deselect();
 
+	void _deselectA();
+
+	void _deselectB();
+
 	void _updateFilterMenu();
 
 	void _filterSyncCBoxUpdate(kshark_context *kshark_ctx);
-- 
2.17.1

