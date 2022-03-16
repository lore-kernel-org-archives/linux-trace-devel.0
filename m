Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0F0AC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Mar 2022 14:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231411AbiCPOgb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Mar 2022 10:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232943AbiCPOgb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Mar 2022 10:36:31 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F5739BB1
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Mar 2022 07:35:15 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id p15so4618600ejc.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Mar 2022 07:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZVyTQiKh5ZfAGLCIgDVXimFZLlcuMLFZBygdf88hJiM=;
        b=dbcP/+3ISeQwNV6Yn4hjLQXWB6csaVhqAUk1twBMEp/X1+KciZ7rz3RgHsoMIA/QXL
         r6MRAdo6NRuJ9mQOY36dZRSF/aWcuMQu2lB0LEsWc7vaFrpHygA5TccWSrIjlYHs3pee
         ETJ6VmLT0nLgM/Geb/xdVUkd8rspEhC08zxP5nQDAWx9j3gX0kg3qsc3XWb08esC1Efo
         xR7MUR6ZIL0CXStZwqXBuyC4ACQGE9U5g29XvwTNnfqkqAdPLwLec7x4ZpgBpY+TjbN2
         Jm/PckL+ocUUt1Yx8P4VHPsVI/n1Nly9ybAUOYHGwLPSvsQMq6IfpBiJrs9xM9vxDHMW
         c9Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZVyTQiKh5ZfAGLCIgDVXimFZLlcuMLFZBygdf88hJiM=;
        b=EcEomiXkdJpQ7QhiSLdWflY9zWY6xyZeD9NKCRCFmKSRRiSinjXRZi7kqXr7JDqWFn
         DqZIHvFFzL2nvByg07Qeanxyrn6+Rkkfhc2GiGJyXVZeAn3W1PSeXdReQ+vg6OnfiDZM
         GhbnDCHIM5B13iBOEhmh4J5Q7bblkZqeCF+8Bs3ZiiAecykWRyBPx0o58qilhV7uHGXt
         /KKDCWXoWp40OHZdg1MXlLnxmucg15XwPxcOXmR3QeRU8uv23xvOWSRj2nKc654QrLgM
         LslIJG5t8cUf7HUQpZwWZ1UxCvG2t58V7gjbwsklYSwjYJIa9C/lYgpjmWujcwc5Ll2I
         U7QA==
X-Gm-Message-State: AOAM533S9gYtnlMhpUqSw6WQkznIVXE7IpniPA40QrXuHg5EXrXtaops
        /G7aMIKf6nhmvfJoGsHxrOzk5Z43gP0=
X-Google-Smtp-Source: ABdhPJwZFk4um1u6qRFzBdNfLa9D8vULBM12ZUMMnxs43S26tOY0ZMlsDbFPEXmq/i8zbUEnttZ2YQ==
X-Received: by 2002:a17:906:3283:b0:6ce:78f9:fafd with SMTP id 3-20020a170906328300b006ce78f9fafdmr246981ejw.534.1647441313592;
        Wed, 16 Mar 2022 07:35:13 -0700 (PDT)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id i4-20020a1709061e4400b006db370920bbsm982388ejj.90.2022.03.16.07.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 07:35:13 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] kernel-shark: Fix comment typos
Date:   Wed, 16 Mar 2022 16:34:50 +0200
Message-Id: <20220316143450.272611-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

No functional changes introduced.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsWidgetsLib.hpp | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/src/KsWidgetsLib.hpp b/src/KsWidgetsLib.hpp
index 428e8dd..6ec2bd1 100644
--- a/src/KsWidgetsLib.hpp
+++ b/src/KsWidgetsLib.hpp
@@ -230,7 +230,7 @@ public:
 	/** Get the name of the widget. */
 	QString name() const {return _name;}
 
-	/** Get the state of the "all" checkboxe. */
+	/** Get the state of the "all" checkbox. */
 	bool all() const
 	{
 		if(_allCb.checkState() == Qt::Checked)
@@ -238,7 +238,7 @@ public:
 		return false;
 	}
 
-	/** The "all" checkboxe to be visible or not. */
+	/** The "all" checkbox to be visible or not. */
 	void setVisibleCbAll(bool v) {_allCbAction->setVisible(v);}
 
 	void setDefault(bool);
@@ -282,10 +282,10 @@ protected:
 	/** Identifier of the Data stream for which the selection applies. */
 	int		_sd;
 
-	/** The "all" checkboxe. */
+	/** The "all" checkbox. */
 	QCheckBox	_allCb;
 
-	/** A vector of Id numbers coupled to each checkboxe. */
+	/** A vector of Id numbers coupled to each checkbox. */
 	QVector<int>	_id;
 
 	/** A nested widget used to position the checkboxes. */
@@ -342,13 +342,13 @@ public:
 
 	/**
 	 * The "apply" signal will emit a vector containing the Ids of all
-	 * checked checkboxe.
+	 * checked checkbox.
 	 */
 	void applyIds(bool v = true) {_applyIds = v;}
 
 	/**
 	 * The "apply" signal will emit a vector containing the statuse of all
-	 * checkboxe.
+	 * checkbox.
 	 */
 	void applyStatus(bool v = true) {_applyIds = !v;}
 
@@ -432,7 +432,7 @@ public:
 	KsCheckBoxTableWidget(int sd, const QString &name = "",
 			      QWidget *parent = nullptr);
 
-	/** Only one checkboxe at the time can be checked. */
+	/** Only one checkbox at the time can be checked. */
 	void setSingleSelection()
 	{
 		_table.setSelectionMode(QAbstractItemView::SingleSelection);
@@ -500,7 +500,7 @@ public:
 	KsCheckBoxTreeWidget(int sd, const QString &name = "",
 			     QWidget *parent = nullptr);
 
-	/** Only one checkboxe at the time can be checked. */
+	/** Only one checkbox at the time can be checked. */
 	void setSingleSelection()
 	{
 		_tree.setSelectionMode(QAbstractItemView::SingleSelection);
-- 
2.32.0

