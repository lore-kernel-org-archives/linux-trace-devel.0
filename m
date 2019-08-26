Return-Path: <SRS0=87e6=WW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C64EC3A59F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Aug 2019 15:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 434AB217F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Aug 2019 15:58:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DGzeYuQa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731513AbfHZP6i (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Aug 2019 11:58:38 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39673 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727864AbfHZP6h (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Aug 2019 11:58:37 -0400
Received: by mail-wr1-f66.google.com with SMTP id t16so15853735wra.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Aug 2019 08:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pbdhstZEdbfMh7PZnm9j1QeONGkXSdkZbPuAkuj3VZ0=;
        b=DGzeYuQaU4aRCxNv2ntu1zq0M2CL4B3RhSfwGmo6BwxAejB/ljuZHrAlL5a4SHt0Rv
         jSHD7zoa6iqE5zjQM0DIFc8Dgu4475dL92cK6iSZ4V7ux2qBdHKmWzZ94EFC/aBS5Eh9
         9qfGg2xK/O11fV7W7Zs0G8IR1zpAtfL1f4McYEnVNWmvGdiuKlL3QIdjvN5jE6TZ+AlV
         R5MikknTFOx8oXwTpiKq99utGeQHs9KzbYIsRkib7eUAFxrcMZUSUugtD3xCYBhXDGGB
         3LCUNKBuuA6qg4/skJvb6q4eXyAwahVojsfJ/el8jxM+LVio4LyCYyHIXOMPbxVmSNYt
         MJaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pbdhstZEdbfMh7PZnm9j1QeONGkXSdkZbPuAkuj3VZ0=;
        b=Th/H1F5JAaIgDZ+9J1aYKkCz7AIanoqwZzIYjehvK+DvOPzZ+IWfoqT779B6TJfjbQ
         zLcCpvGgY8Y9GnKZPb79bracbI7hWaoPRTz5zc9qu1wA8dwprzvBqhqqr2mPI2uJhj/C
         dEH5Cy6HCbhy6KtAaMmQ8l3XY3L1tW+8tSkkKrBx5vsJ9cGeH8Ic8f1nDzD43mwoBS1A
         YOjFG4evj5o5zi8spk1WM6h5+SFpbbYhgXLq8u7lEy5zqCEr46Ss9V9QkmEtk+nfcVWg
         bU/cnz+MUtBkW/OgSWBnxImaJEjxCRaYNzQpnRXpOjklZe5rodIxpIJH9HkCzRqNTHsN
         sOGg==
X-Gm-Message-State: APjAAAUfrHgpB15hHUMjQ/62HuJlzj04fisNJ6p9aN1XS2GQEiWv7MRe
        cDiBioJ+M75K0AsQjIPukS8=
X-Google-Smtp-Source: APXvYqxkNspiiW8f83UITwmmM8tJAQil74fHRufslCbF1VhChk+S/DtvXJdAYBPtfXtaqkEDeusW3w==
X-Received: by 2002:adf:ec4f:: with SMTP id w15mr23341532wrn.311.1566835115682;
        Mon, 26 Aug 2019 08:58:35 -0700 (PDT)
Received: from localhost.localdomain ([84.40.85.140])
        by smtp.gmail.com with ESMTPSA id p13sm14447458wrw.90.2019.08.26.08.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 08:58:35 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, mike.auty@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 1/5] kernel-shark: Show warning message when running as Root
Date:   Mon, 26 Aug 2019 18:58:07 +0300
Message-Id: <20190826155811.32021-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190826155811.32021-1-y.karadz@gmail.com>
References: <20190826155811.32021-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Running the KernelShark GUI with Root privileges is not recommended due
to security reasons. The user will be allowed to continue on its own risk.

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204475
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsMainWindow.cpp | 28 ++++++++++++++++++++++++++++
 kernel-shark/src/KsMainWindow.hpp |  2 ++
 2 files changed, 30 insertions(+)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 6439265..2f86517 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -76,6 +76,9 @@ KsMainWindow::KsMainWindow(QWidget *parent)
 	_createMenus();
 	_initCapture();
 
+	if (geteuid() == 0)
+		_rootWarning();
+
 	_splitter.addWidget(&_graph);
 	_splitter.addWidget(&_view);
 	setCentralWidget(&_splitter);
@@ -1271,3 +1274,28 @@ void KsMainWindow::_deselectB()
 	_mState.updateLabels();
 	_graph.glPtr()->model()->update();
 }
+
+void KsMainWindow::_rootWarning()
+{
+	QString cbFlag("noRootWarn");
+
+	if (_settings.value(cbFlag).toBool())
+		return;
+
+	QMessageBox warn;
+	warn.setText("KernelShark will have Root privileges.");
+	warn.setInformativeText("Continue on your own risk.");
+	warn.setIcon(QMessageBox::Warning);
+	warn.setStandardButtons(QMessageBox::Close);
+
+	QCheckBox cb("Don't show this message again.");
+
+	auto lamCbChec = [&] (int state) {
+		if (state)
+			_settings.setValue(cbFlag, true);
+	};
+
+	connect(&cb, &QCheckBox::stateChanged, lamCbChec);
+	warn.setCheckBox(&cb);
+	warn.exec();
+}
diff --git a/kernel-shark/src/KsMainWindow.hpp b/kernel-shark/src/KsMainWindow.hpp
index 62e66a0..4a7b8ab 100644
--- a/kernel-shark/src/KsMainWindow.hpp
+++ b/kernel-shark/src/KsMainWindow.hpp
@@ -238,6 +238,8 @@ private:
 
 	void _deselectB();
 
+	void _rootWarning();
+
 	void _updateFilterMenu();
 
 	void _filterSyncCBoxUpdate(kshark_context *kshark_ctx);
-- 
2.20.1

