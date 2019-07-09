Return-Path: <SRS0=uJAW=VG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D5DBC73C46
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 15:57:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 369BA216C4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 15:57:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SdTwv5qE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbfGIP50 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Jul 2019 11:57:26 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:50770 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfGIP5Z (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Jul 2019 11:57:25 -0400
Received: by mail-wm1-f46.google.com with SMTP id v15so3652444wml.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 09 Jul 2019 08:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4vTSVwzPagn4coALClzcY4CBNS9gpkyjygDFxvKLxyE=;
        b=SdTwv5qEecv8z7SL7gA/w+C6qizCgHDFbH2s7GSFVqB27avatPjHMgpHIV9SzOu/NI
         py4CNaBPerZjoGyBnefCPuYm0IitEk+GOg+y2m6tqZIzvKZlVpESN01CVAd8bEW0ruac
         vDxXOxuowkFGIv8Go3A2JeD2YxX2XBAsWggwc+16bpzyytnpUME/eL/M/2U10shzcudt
         1bqN/IHYfW9fbAQPbWPlcf9BuC255JE9N7oQCVkebKOpkfAyEN9JJcsvtaA7IvH/NpXX
         0y09Bfe2ulTZYUFoHHlokuc5jBTsmyFPZQeRXUvUNbE99akXBWI9482jfqshC+zN5RQb
         sK8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4vTSVwzPagn4coALClzcY4CBNS9gpkyjygDFxvKLxyE=;
        b=HKgzizeuRg4eKtUHoeCEdmjF5RAPCELAuMAntgr3ag34qsYoZp5yJlYsrLWDVGuwhc
         b8XIWTo+pdxYXD2140+78c2194nBSp3FCn6ipg7U8eyT/dGLvJbdmqJdPxN0snuMZ4tZ
         81A/W8vAOS7rT+4pja3wFAj/U/BWVAdUFcbTHTtiZtU5/pXrwyf+7QaXvwPgiTM3e9gZ
         wCqqUrPeNBBxYjUUvQIT++/LTvRt26MPNbaYX/5pj8+cuKXayODvLQlqC5J0ba3tta5U
         cGMHGf5hURzpCj6f93cfGjc45SNFZneoWz5WC7noyC/saTMUPEVNdjRwsXVFh4C5hpwa
         O8zA==
X-Gm-Message-State: APjAAAXmngYNgrO0Lolxy/jKkw3/JiFU1SjtWPYKqI5gs8RnY8TStJUm
        sCp5cabTDV34Szd9qWZUuPfMTn79HQI=
X-Google-Smtp-Source: APXvYqzQae2iOFTojM1DqU8fyL29mpWJ9aLHQ4jaij3gyET0q4tNJBFwhxs03pZeODm4xEuGtdEsuQ==
X-Received: by 2002:a7b:cbcb:: with SMTP id n11mr574565wmi.146.1562687843609;
        Tue, 09 Jul 2019 08:57:23 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id v5sm24313746wre.50.2019.07.09.08.57.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 08:57:23 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/8] kernel-shark: Optimize the command line options used by the capture dialog
Date:   Tue,  9 Jul 2019 18:56:45 +0300
Message-Id: <20190709155650.2345-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190709155650.2345-1-y.karadz@gmail.com>
References: <20190709155650.2345-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Do not include all events belonging to a given system if the whole system
is selected. Add only the name of the system instead. Do not specify a
plugin if the selected plugin is "nop".

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsCaptureDialog.cpp | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCaptureDialog.cpp
index b107595..7da6c08 100644
--- a/kernel-shark/src/KsCaptureDialog.cpp
+++ b/kernel-shark/src/KsCaptureDialog.cpp
@@ -143,23 +143,14 @@ QStringList KsCaptureControl::getArgs()
 	QStringList argv;
 
 	argv << "record";
-	argv << "-p" << _pluginsComboBox.currentText();
 
-	if (_eventsWidget.all()) {
-		argv << "-e" << "all";
-	} else {
-		QVector<int> evtIds = _eventsWidget.getCheckedIds();
-		tep_event *event;
+	if (_pluginsComboBox.currentText() != "nop")
+		argv << "-p" << _pluginsComboBox.currentText();
 
-		for (auto const &id: evtIds) {
-			event = tep_find_event(_localTEP, id);
-			if (!event)
-				continue;
-
-			argv << "-e" + QString(event->system) +
-				":" + QString(event->name);
-		}
-	}
+	if (_eventsWidget.all())
+		argv << "-e" << "all";
+	else
+		argv << _eventsWidget.getCheckedEvents(true);
 
 	argv << "-o" << outputFileName();
 	argv << _commandLineEdit.text().split(" ");
-- 
2.20.1

