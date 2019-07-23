Return-Path: <SRS0=P3iB=VU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CC61C7618E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Jul 2019 12:52:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8E1121901
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Jul 2019 12:52:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MjKhWaab"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389948AbfGWMwD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 08:52:03 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36723 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732432AbfGWMwD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 08:52:03 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so43128994wrs.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Jul 2019 05:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xoyij2NCyYTS84LBv1xSvP+kJxzGRYrq2YWH+GE/qxU=;
        b=MjKhWaaboQngX/17lc/biyZfybAIGv80JtosiPKw4MX1hXxJ/yFSqoSxeTayd2MUw6
         POK6L3pm7WJTuoaOBkQjeULpmN9DxsHDL7n2dGXfXe79Q69AQv45Iofk73dS+Kraw2FF
         H5fggWzep3LZIAlPJpwxDWOKuNLL66mp6/oUXiTwaJ1rxpQgENHkb0V2avP0bb4m72m9
         i9bbB6Z7uVyoGOcFByi75mHF93FuwcbzqENA8lUYO8gsZDs6HZdyACmG8W5h62BrhG6v
         EVxL07ATOWKFCC7XKgDHv00+Dbj6nq9TjXczTQwGkFRnWcPxE0N+sCXEqtQ5aVJEa9aC
         JmGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xoyij2NCyYTS84LBv1xSvP+kJxzGRYrq2YWH+GE/qxU=;
        b=euakcT0kJOM6PxZ9rxN0nnnXMOIAYhixqh1QTa5fQuPP97mgWgwmo/Qp9F7XL1CwyW
         ws8rPGGohdwpdNeQxhEjfW+Vz5YS9gS90DEaueggauSIAh4/POKz9xnCVcEcpmERcuFI
         6RSgqvXlCEPawxR5It5pHPcB0Mo8CEMIAmuL9ovG/7gZzniJmdLVuDgf1F6woJ+OI1o6
         kRhfkw52FDBqRs6vr8RwaTxOvFL/ptaZ8DZ80FaflmnblCY7mGk5lYf61shK/0n15Okw
         bCiEjS1fbya47j77PWx2gz63WbQjN6RGhzuzrQlcA3NbceO+yJoq4HG1bTiMRoOClTIH
         iIyQ==
X-Gm-Message-State: APjAAAUunu3NarPHo7wEFYBkAIj4BjH/15U1egp2DHd33qWj6xxbJqPB
        +I/2Ia35zv89XAWeueSuzz0=
X-Google-Smtp-Source: APXvYqziS9M18iqm1HRSbQbJiBzF9TVDgzDMnfXswkWTfD1fOvIJDekSVyeJMeSIa+qcer1geMFvVQ==
X-Received: by 2002:adf:ed8a:: with SMTP id c10mr83951481wro.33.1563886321466;
        Tue, 23 Jul 2019 05:52:01 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id e19sm57423320wra.71.2019.07.23.05.52.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 05:52:01 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, howaboutsynergy@pm.me,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/3] kernel-shark: Disable Capture if trace-cmd can't function
Date:   Tue, 23 Jul 2019 15:52:04 +0300
Message-Id: <20190723125204.22799-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190723125204.22799-1-y.karadz@gmail.com>
References: <20190723125204.22799-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In the case of an error all key buttons of the Record dialog are
disabled.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsCaptureDialog.cpp | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCaptureDialog.cpp
index 2e6e8f9..2962917 100644
--- a/kernel-shark/src/KsCaptureDialog.cpp
+++ b/kernel-shark/src/KsCaptureDialog.cpp
@@ -74,6 +74,19 @@ KsCaptureControl::KsCaptureControl(QWidget *parent)
 		_topLayout.addWidget(errorLabel);
 
 		lamAddLine();
+
+		/* Disable all key buttons. */
+		QVector<QWidget *> widgets =
+			{&_importSettingsButton,
+			 &_exportSettingsButton,
+			 &_outputBrowseButton,
+			 &_pluginsComboBox,
+			 &_commandCheckBox,
+			 &_applyButton,
+			 &_captureButton};
+
+		for (auto &b: widgets)
+			b->setDisabled(true);
 	}
 
 	pluginList.prepend("nop");
-- 
2.20.1

