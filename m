Return-Path: <SRS0=S2sz=XN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07F16C4CEC9
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Sep 2019 14:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D23092067B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Sep 2019 14:24:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eEFGB8Ts"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730029AbfIROYW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 18 Sep 2019 10:24:22 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37247 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbfIROYW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 18 Sep 2019 10:24:22 -0400
Received: by mail-wm1-f67.google.com with SMTP id f16so288896wmb.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Sep 2019 07:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BZuDjXgRuhQlde+olFqRQbMGAoEiI/QmyKJVEoHBlOk=;
        b=eEFGB8TsBj7KFQIE7xOkK9aRSPHIFViEm1DY6ngjci3/ZlshmR3H3v1K4ED67rvtNO
         CJfwijPICh0KFMVWO7Y7mq8yoBuMp/kpwOiMHDeX2z77G1aKtqmLvNc+3FC9aIidQOls
         fkxsdeQUmNNpI3zUzAsp9rTsXSmyCLY9sGpZvJwt9+ftU/3gKNG5a1eQaWjAb6NXFBP9
         hOb5G6pOigPX49jhfpYMq7mnsV8O87upAYqZ44ylPKInXsTc3ysCXvl8YBrI9sIYE+WB
         /qSKHUGVKRbM3YaOIgfbRMT3ENsDBMj+6sii+DZF//OeWj2PxpcQ2D26UONCmXFSRrhk
         fzfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BZuDjXgRuhQlde+olFqRQbMGAoEiI/QmyKJVEoHBlOk=;
        b=k7FdUhyV7beoE9t7lbfW9V3Y23AjPlJHKhSc7Eva5ljcok5VVp6Cnn3M3WvA73Jg2t
         O23h7JTmySTy9F/lqoIdkLbaZemhaoNNO6y7M49oWS3+WxuvmoW8dbNnkjQhant94jby
         BPM2ZzarsiH92jDboc926WkLheMs2WFxFN7XyBBzIBg6FTOTQ4LknA24Mw86VQRFkwfU
         i8NQ92mB5DwrwMSXmho5God2SOcrJA+/cgvVin9LIIM0ZcjzyFw3zpOW9IOx1mjDYBPP
         Igv9uDpjiIvGDmvoSjiExxqInQ4VOR2P+2LtXCn6ccnzgdCXiAPnfjrPh3JjIChopsrl
         0uVQ==
X-Gm-Message-State: APjAAAXJsOk2djGyLztYnGuFMfFHBnzfiGDCnWe+RWzUO/siMDbeij62
        BB6kMwDIR3mmT1nSUhNxueQ=
X-Google-Smtp-Source: APXvYqxdoblD+d+gI8NpnKkXGjJef/snLqzL6bMe4uMfzgt8vfOHhsQRdyLlbl+60gouRABxNWXqJg==
X-Received: by 2002:a1c:2b41:: with SMTP id r62mr3049542wmr.47.1568816660116;
        Wed, 18 Sep 2019 07:24:20 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a10sm7526251wrv.64.2019.09.18.07.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 07:24:19 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, stephen@brennan.io,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 2/3] kernel-shark: give more space to the command field of the Record dialog
Date:   Wed, 18 Sep 2019 17:23:18 +0300
Message-Id: <20190918142319.11821-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190918142319.11821-1-y.karadz@gmail.com>
References: <20190918142319.11821-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Since the Record dialog not support parsing of complex multi-line
commands the corresponding field of the widget has to be able to
accommodate such multi-line user input.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsCaptureDialog.cpp | 29 +++++++++++++++++++++++++---
 kernel-shark/src/KsCaptureDialog.hpp | 18 ++++++++++++++++-
 2 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCaptureDialog.cpp
index 7c2ef46..fff42aa 100644
--- a/kernel-shark/src/KsCaptureDialog.cpp
+++ b/kernel-shark/src/KsCaptureDialog.cpp
@@ -29,6 +29,25 @@ static inline tep_handle *local_events()
 	return tracecmd_local_events(tracecmd_get_tracing_dir());
 }
 
+/**
+ * @brief Create KsCommandLineEdit.
+ *
+ * @param text: Defaulst text to be shown.
+ * @param parent: The parent of this widget.
+ */
+KsCommandLineEdit::KsCommandLineEdit(QString text, QWidget *parent)
+: QPlainTextEdit(text, parent) {}
+
+QSize KsCommandLineEdit::minimumSizeHint() const
+{
+	return {FONT_WIDTH * 30, FONT_HEIGHT * 2};
+}
+
+QSize KsCommandLineEdit::sizeHint() const
+{
+	return {FONT_WIDTH * 30, FONT_HEIGHT * 3};
+}
+
 /** @brief Create KsCaptureControl widget. */
 KsCaptureControl::KsCaptureControl(QWidget *parent)
 : QWidget(parent),
@@ -117,7 +136,11 @@ KsCaptureControl::KsCaptureControl(QWidget *parent)
 	_commandLabel.adjustSize();
 	_commandLabel.setFixedWidth(_outputLabel.width());
 	_execLayout.addWidget(&_commandLabel, row, 0);
+
 	_commandLineEdit.setFixedWidth(FONT_WIDTH * 30);
+	_commandLineEdit.setMinimumHeight(FONT_HEIGHT * 2);
+	_commandLineEdit.setMaximumHeight(FONT_HEIGHT * 9);
+
 	_execLayout.addWidget(&_commandLineEdit, row, 1);
 	_commandCheckBox.setCheckState(Qt::Unchecked);
 	_commandCheckBox.adjustSize();
@@ -171,7 +194,7 @@ QStringList KsCaptureControl::getArgs()
 
 	argv << "-o" << outputFileName();
 
-	argv << KsUtils::splitArguments(_commandLineEdit.text());
+	argv << KsUtils::splitArguments(_commandLineEdit.toPlainText());
 
 	return argv;
 }
@@ -282,7 +305,7 @@ void KsCaptureControl::_importSettings()
 		_outputLineEdit.setText(KS_C_STR_CAST(temp->conf_doc));
 
 	if (kshark_config_doc_get(conf, "Command", temp))
-		_commandLineEdit.setText(KS_C_STR_CAST(temp->conf_doc));
+		_commandLineEdit.setPlainText(KS_C_STR_CAST(temp->conf_doc));
 }
 
 void KsCaptureControl::_exportSettings()
@@ -330,7 +353,7 @@ void KsCaptureControl::_exportSettings()
 	kshark_config_doc_add(conf, "Output", kshark_json_to_conf(jout));
 
 	/* Save the command. */
-	comm = _commandLineEdit.text();
+	comm = _commandLineEdit.toPlainText();
 	json_object *jcomm = json_object_new_string(comm.toStdString().c_str());
 	kshark_config_doc_add(conf, "Command", kshark_json_to_conf(jcomm));
 
diff --git a/kernel-shark/src/KsCaptureDialog.hpp b/kernel-shark/src/KsCaptureDialog.hpp
index f8ddf4a..612080c 100644
--- a/kernel-shark/src/KsCaptureDialog.hpp
+++ b/kernel-shark/src/KsCaptureDialog.hpp
@@ -18,6 +18,20 @@
 // KernelShark
 #include "KsWidgetsLib.hpp"
 
+/**
+ * The KsCommandLineEdit class is used to override the default size hints of
+ * the QPlainTextEdit class.
+ */
+struct KsCommandLineEdit : public QPlainTextEdit
+{
+	KsCommandLineEdit(QString text, QWidget *parent = 0);
+
+private:
+	QSize sizeHint() const override;
+
+	QSize minimumSizeHint() const override;
+};
+
 /**
  * The KsCaptureControl class provides a control panel for the KernelShark
  * Capture dialog.
@@ -57,7 +71,9 @@ private:
 
 	QLabel		_pluginsLabel, _outputLabel, _commandLabel;
 
-	QLineEdit	_outputLineEdit, _commandLineEdit;
+	QLineEdit	_outputLineEdit;
+
+	KsCommandLineEdit	_commandLineEdit;
 
 	QToolBar	_settingsToolBar, _controlToolBar;
 
-- 
2.20.1

