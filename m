Return-Path: <SRS0=4mzf=QT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C81C282C4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Feb 2019 17:04:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE68B20700
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Feb 2019 17:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729694AbfBLRE2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Feb 2019 12:04:28 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34889 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728353AbfBLRE2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Feb 2019 12:04:28 -0500
Received: by mail-wm1-f65.google.com with SMTP id t200so3855552wmt.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Feb 2019 09:04:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TPzahrGxSiS7re5yq69qr922slzySdv8npjmVQB6tq0=;
        b=SOvwCdQvpuY7Y0Nj9tdHYGnRO69fv7kq08V/CaB3LNF+VtGVOX9cJYlgBfrpWQxXBz
         tqIf8asBcm75et/qIgEHBx78caOchnaW34sH+rZx4gMy0TkfJuDaziwjEwTH9CJ7Dplv
         waYt9Lqg3nO+nsev9OnA68abPXYHRsSQigeZ99NXc4vwkqcj7Aq8ZYRkFcteDPFH0UzW
         joslXsl8G/JqdlBy0Yn5/3DUWyuvFbIVZZgLr4IbbNYQ8ZgSD8jUnoO0QSOpVLiUsjYJ
         QYvVgzVZMrD+hTblxV3hYApVtcreH6J3PKhE7wT+fEg5CPOqzoBAlyXDmvyzos114rst
         rlXA==
X-Gm-Message-State: AHQUAuY+YoIJCacAQq/yUXArHAN7qgyzlkJlnqG1fnzLsG0oEU4DbL4+
        S0hVbmDd8tDHKwCZ1T2UlfU=
X-Google-Smtp-Source: AHgI3IZz3ALqcpRotvMEAeb89R2K6jVAA3UcDmWKKgM8nNljjuQCNpy2fmYHChT13XMdcNgejab1EQ==
X-Received: by 2002:a1c:6788:: with SMTP id b130mr40889wmc.102.1549991065870;
        Tue, 12 Feb 2019 09:04:25 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c139sm5579732wmd.13.2019.02.12.09.04.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Feb 2019 09:04:25 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 1/5] kernel-shark: Customize the marker switching button
Date:   Tue, 12 Feb 2019 19:03:58 +0200
Message-Id: <20190212170402.10104-2-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190212170402.10104-1-ykaradzhov@vmware.com>
References: <20190212170402.10104-1-ykaradzhov@vmware.com>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The handler for "mouse press events" in the customized button is
reimplemented in order to provide the emission of a "deselect"
signal in the case of right mouse click. Two additional signals are
defined in KsDualMarkerSM. Those signals are used to re-emit the
"deselect" signals of the two marker buttons. Later (in another patch)
the signals will be connected to methods where the actual deselection
of the markers will take place.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202327
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsDualMarker.cpp | 21 ++++++++++++++
 kernel-shark/src/KsDualMarker.hpp | 46 +++++++++++++++++++++++++++++--
 2 files changed, 65 insertions(+), 2 deletions(-)

diff --git a/kernel-shark/src/KsDualMarker.cpp b/kernel-shark/src/KsDualMarker.cpp
index dbeb923..43bc177 100644
--- a/kernel-shark/src/KsDualMarker.cpp
+++ b/kernel-shark/src/KsDualMarker.cpp
@@ -12,6 +12,21 @@
 #include "KsDualMarker.hpp"
 #include "KsGLWidget.hpp"
 
+/**
+ * Reimplemented handler for mouse press events. Right mouse click events will
+ * deselect the corresponding marker.
+ */
+void KsMarkerButton::mousePressEvent(QMouseEvent *e)
+{
+	if(e->button() == Qt::RightButton) {
+		emit deselect();
+
+		return;
+	}
+
+	QPushButton::mousePressEvent(e);
+}
+
 /**
  * @brief Create KsGraphMark object.
  *
@@ -178,6 +193,9 @@ KsDualMarkerSM::KsDualMarkerSM(QWidget *parent)
 	connect(&_buttonB,	&QPushButton::clicked,
 		this,		&KsDualMarkerSM::_doStateB);
 
+	connect(&_buttonB,	&KsMarkerButton::deselect,
+		this,		&KsDualMarkerSM::deselectB);
+
 	/* Define transitions from State B to State A. */
 	_stateB->addTransition(this,	&KsDualMarkerSM::machineToA, _stateA);
 
@@ -192,6 +210,9 @@ KsDualMarkerSM::KsDualMarkerSM(QWidget *parent)
 	connect(&_buttonA,	&QPushButton::clicked,
 		this,		&KsDualMarkerSM::_doStateA);
 
+	connect(&_buttonA,	&KsMarkerButton::deselect,
+		this,		&KsDualMarkerSM::deselectA);
+
 	_machine.addState(_stateA);
 	_machine.addState(_stateB);
 	_machine.setInitialState(_stateA);
diff --git a/kernel-shark/src/KsDualMarker.hpp b/kernel-shark/src/KsDualMarker.hpp
index 73d4f8a..597bddb 100644
--- a/kernel-shark/src/KsDualMarker.hpp
+++ b/kernel-shark/src/KsDualMarker.hpp
@@ -19,6 +19,36 @@
 #include "KsUtils.hpp"
 #include "KsPlotTools.hpp"
 
+/**
+ * The Marker Button class provides a button that deselect the corresponding
+ * marker in the case of a Right  mouse click.
+ */
+class KsMarkerButton : public QPushButton
+{
+	Q_OBJECT
+public:
+	/**
+	 * @brief Create a default button.
+	 */
+	explicit KsMarkerButton(QWidget *parent = nullptr)
+	: QPushButton(parent) {}
+
+	/**
+	 * @brief Create a button with text.
+	 */
+	explicit KsMarkerButton(const QString &text, QWidget *parent = nullptr)
+	: QPushButton(text, parent) {}
+
+	void mousePressEvent(QMouseEvent *e);
+
+signals:
+	/**
+	 * This signal is emitted when the button is click by the Right mouse
+	 * button.
+	 */
+	void deselect();
+};
+
 class KsGLWidget;
 
 /** The KsGraphMark represents a marker for KernelShark GUI. */
@@ -161,10 +191,22 @@ signals:
 	 */
 	void machineToB();
 
+	/**
+	 * This signal is used to re-emitted the deselect signal of the
+	 * Marker A button.
+	 */
+	void deselectA();
+
+	/**
+	 * This signal is used to re-emitted the deselect signal of the
+	 * Marker B button.
+	 */
+	void deselectB();
+
 private:
-	QPushButton	 _buttonA;
+	KsMarkerButton	 _buttonA;
 
-	QPushButton	 _buttonB;
+	KsMarkerButton	 _buttonB;
 
 	QLabel		 _labelMA, _labelMB, _labelDelta;
 
-- 
2.17.1

