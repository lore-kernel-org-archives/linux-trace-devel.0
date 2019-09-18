Return-Path: <SRS0=S2sz=XN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1782EC4CEC4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Sep 2019 14:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCD172067B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Sep 2019 14:24:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UXBxhqFw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbfIROYT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 18 Sep 2019 10:24:19 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39146 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbfIROYT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 18 Sep 2019 10:24:19 -0400
Received: by mail-wm1-f66.google.com with SMTP id v17so273591wml.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Sep 2019 07:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rie2zl85JdSuDWSW7erJSkpG2/BsRM8suWlDpQuD1sA=;
        b=UXBxhqFwghxNbdvMPsZTehN4csdIaqtIS9LnJZqNspudu3bQGYYLP+tZ/oppRNNHd5
         WZBoUbeW0RrRrl6GNdf0lBI5cTtKQsLbQ3uSMyfF5UWA5VVrJlRAgxSNQFnYuHIpaxEy
         UdDT2bdGzISAQQnmEkzMq0Yv25QVygtNYEEXZZopXPKuJ9v58kePy4yQuKlWBivP9hPL
         DWSPAsTVFAc87bLJ5QRUMdbK/j/neuf0lurTHxw8aDp1neXnrCv5vceTcltrL7jNY6Ss
         N/sEq2GZPsta/1poHu5nah/uI7x7skqyLcb1LYFk1PVrw8Q97Y9PM+HGf77f1PY4t206
         zv4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rie2zl85JdSuDWSW7erJSkpG2/BsRM8suWlDpQuD1sA=;
        b=MyAX8jSeO+E3yMUwmYgkFm62BKtxR/BfhmXVZNIoCjk1Bn9Q/K4ffYsNixpq4GvqQf
         YugSPsio4cDH/31to48r/EgykT5fuVrN5Lk3ypqQ26e5TZNhBNxSQEqwN8884+354csj
         RLcjMklCXvl6SIRHhRjaGmzVTHDhYBKSyTvfalL8yd/ryi2C58AC9dJ8ciY2o066c0ge
         IrXFklJPzoa1jUtKZPlpM8rdtlkXENK5UFjAKFGNjvmZpSTulCkt+txyhtLaeb/SzTmY
         AMEO6NDQ62Li3Emle1qWe6Bu9wtMJ974L8Q7yA6tVWULkstzFfpJ1Ga4QyhujYERi5h4
         CUWA==
X-Gm-Message-State: APjAAAUTfDHDHEAyExaVshs+yh22ZX+2ypHNcRg6/gShsNmAny7hLAND
        zIzB3nV8OZStlDg9nmm1jJ6BmQAi
X-Google-Smtp-Source: APXvYqyztdeYrOAJ5sVXr0bYitSyqIdzwzCbwLz/6kAjbbD1toPrhB/4jai3hOT+T1wzAR1JtoSVmw==
X-Received: by 2002:a05:600c:2108:: with SMTP id u8mr3317315wml.13.1568816657468;
        Wed, 18 Sep 2019 07:24:17 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a10sm7526251wrv.64.2019.09.18.07.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 07:24:16 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, stephen@brennan.io,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 1/3] kernel-shark: Provide parsing for quotation marks in Record command line
Date:   Wed, 18 Sep 2019 17:23:17 +0300
Message-Id: <20190918142319.11821-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190918142319.11821-1-y.karadz@gmail.com>
References: <20190918142319.11821-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Shell-like parsing of quotation marks in the content of the "Command"
field of the "Record" dialog will give more options to the users.
For example, now we can trace

 python -c 'print("hello world")'

The patch also adds support for multi-line command options.

Suggested-by: Stephen Brennan <stephen@brennan.io>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204679
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsCaptureDialog.cpp | 10 +++++--
 kernel-shark/src/KsUtils.cpp         | 41 ++++++++++++++++++++++++++++
 kernel-shark/src/KsUtils.hpp         |  2 ++
 3 files changed, 50 insertions(+), 3 deletions(-)

diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCaptureDialog.cpp
index dc1e9b2..7c2ef46 100644
--- a/kernel-shark/src/KsCaptureDialog.cpp
+++ b/kernel-shark/src/KsCaptureDialog.cpp
@@ -170,7 +170,8 @@ QStringList KsCaptureControl::getArgs()
 		argv << _eventsWidget.getCheckedEvents(true);
 
 	argv << "-o" << outputFileName();
-	argv << _commandLineEdit.text().split(" ");
+
+	argv << KsUtils::splitArguments(_commandLineEdit.text());
 
 	return argv;
 }
@@ -350,7 +351,10 @@ void KsCaptureControl::_browse()
 
 void KsCaptureControl::_apply()
 {
-	emit argsReady(getArgs().join(" "));
+	QStringList argv = getArgs();
+
+	if (argv.count())
+		emit argsReady(argv.join(" "));
 }
 
 /** @brief Create KsCaptureMonitor widget. */
@@ -547,7 +551,7 @@ void KsCaptureDialog::_capture()
 	int argc;
 
 	if(_captureMon._argsModified) {
-		argv = _captureMon.text().split(" ");
+		argv = KsUtils::splitArguments(_captureMon.text());
 	} else {
 		argv = _captureCtrl.getArgs();
 	}
diff --git a/kernel-shark/src/KsUtils.cpp b/kernel-shark/src/KsUtils.cpp
index 58ce8c1..e99509f 100644
--- a/kernel-shark/src/KsUtils.cpp
+++ b/kernel-shark/src/KsUtils.cpp
@@ -257,6 +257,47 @@ QString getSaveFile(QWidget *parent,
 	return fileName;
 }
 
+/**
+ * Separate the command line arguments inside the string taking into account
+ * possible shell quoting and new lines.
+ */
+QStringList splitArguments(QString cmd)
+{
+	QString::SplitBehavior opt = QString::SkipEmptyParts;
+	int i, progress = 0, size;
+	QStringList argv;
+	QChar quote = 0;
+
+	/* Remove all new lines. */
+	cmd.replace("\\\n", " ");
+
+	size = cmd.count();
+	auto lamMid = [&] () {return cmd.mid(progress, i - progress);};
+	for (i = 0; i < size; ++i) {
+		if (cmd[i] == '\\') {
+			cmd.remove(i, 1);
+			size --;
+			continue;
+		}
+
+		if (cmd[i] == '\'' || cmd[i] == '"') {
+			if (quote.isNull()) {
+				argv << lamMid().split(" ", opt);
+				quote = cmd[i++];
+				progress = i;
+			} else if (quote == cmd[i]) {
+				argv << lamMid();
+				quote = 0;
+				progress = ++i;
+			}
+		}
+	}
+
+	argv << cmd.right(size - progress).split(" ", opt);
+
+	return argv;
+}
+
 }; // KsUtils
 
 /** A stream operator for converting QColor into KsPlot::Color. */
diff --git a/kernel-shark/src/KsUtils.hpp b/kernel-shark/src/KsUtils.hpp
index 7362c14..db1bf5e 100644
--- a/kernel-shark/src/KsUtils.hpp
+++ b/kernel-shark/src/KsUtils.hpp
@@ -130,6 +130,8 @@ QString getSaveFile(QWidget *parent,
 		    const QString &extension,
 		    QString &lastFilePath);
 
+QStringList splitArguments(QString cmd);
+
 }; // KsUtils
 
 /** Identifier of the Dual Marker active state. */
-- 
2.20.1

