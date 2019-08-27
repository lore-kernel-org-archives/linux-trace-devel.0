Return-Path: <SRS0=NWyF=WX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3A9EC3A5A3
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Aug 2019 13:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87DB22077B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Aug 2019 13:14:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="alme2UGj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfH0NOi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 27 Aug 2019 09:14:38 -0400
Received: from mail-wm1-f49.google.com ([209.85.128.49]:50368 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbfH0NOi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Aug 2019 09:14:38 -0400
Received: by mail-wm1-f49.google.com with SMTP id v15so3066184wml.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 27 Aug 2019 06:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AVuoKEc67AQ2R7gFNAmAOcsb/8SDbnPmTkb0i76xelI=;
        b=alme2UGjJeVxXuICA9ZYNOz7QYXzZAHOw0OhL4su56Ftd8JdcQ1G+Rk+OPh1R3aY0k
         uKsyPg2gPUyDbxUagf2j+9+istR68D5rHS6E3dY/L/QMlm9X0BjBx5vRyqUIoW34MKyS
         8D5IPkIGp4GW1KPc2oPqfVELVhoebR2UEdKGR2i2hDEUBWZephprZGC+a7PAZF/p0/Hk
         geuzEgNCEwcbshY7N533qZZZWyfkGesGvLODwEKNgk5pLmMitIAFkz6xDQDnpqaQ2sA3
         Fq5V4I1GEsqNPWur7xHzyPWDky4XkvCvcUk0QPAdIiFBeqpRFZmMrbfkaezIig6TFYIO
         PxdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AVuoKEc67AQ2R7gFNAmAOcsb/8SDbnPmTkb0i76xelI=;
        b=RrfovnYOw4IQwRdGOhYH1EihGmXXjt3NAGwib4vz9HdF3s5lpL7BmRG4T09uAFMAkj
         Vrqy63a0JZBWCwkHNxlPc6K2Mc8vbU6pHiAISGA8I24nTr+uxVAcXgHXNOp5GT4IUEgT
         qlFtzm1GycvSJX9Jnrs+ouvJXB9XAifuEDhFeYZejuecZsV9HC50gfqr2yqo+mfWRgSP
         torkE9BbdYGGUUbllm5cNzz/wctT3p1RTWGqbr9BaXcit4XLnoW6+4vMTmMhEwkdz1zh
         qOhE5rKicztOIit7J5EUyFmyge5w9wAszZLmA1yrTozsq6GxH2i9Y18AnXrd8nTPKxyJ
         fzsg==
X-Gm-Message-State: APjAAAXACou8TwSKJ7kYXbZQUCrBhFvmcg/Jd0TbOWxmTHT5KH60+0bG
        n8TLFMKZwGHukYBUYfTbswI=
X-Google-Smtp-Source: APXvYqzdl0++SGyDh9qVfQtCetEE9W3EWSTqsSyrvMB1F0AJcXnnaWlcZ/K6PjXqRhzGILjDBMa4Jw==
X-Received: by 2002:a05:600c:551:: with SMTP id k17mr28800361wmc.53.1566911675547;
        Tue, 27 Aug 2019 06:14:35 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id z2sm3088234wmi.2.2019.08.27.06.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2019 06:14:34 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Stephen Brennan <stephen@brennan.io>
Subject: [PATCH] kernel-shark: Provide parsing for quotation marks in Record command line
Date:   Tue, 27 Aug 2019 16:14:18 +0300
Message-Id: <20190827131418.18713-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
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

Suggested-by: Stephen Brennan <stephen@brennan.io>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204679
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsCaptureDialog.cpp | 38 ++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCaptureDialog.cpp
index dc1e9b2..b3393b6 100644
--- a/kernel-shark/src/KsCaptureDialog.cpp
+++ b/kernel-shark/src/KsCaptureDialog.cpp
@@ -157,7 +157,9 @@ KsCaptureControl::KsCaptureControl(QWidget *parent)
  */
 QStringList KsCaptureControl::getArgs()
 {
+	QString::SplitBehavior opt = QString::SkipEmptyParts;
 	QStringList argv;
+	QString cmdTmp;
 
 	argv << "record";
 
@@ -170,7 +172,36 @@ QStringList KsCaptureControl::getArgs()
 		argv << _eventsWidget.getCheckedEvents(true);
 
 	argv << "-o" << outputFileName();
-	argv << _commandLineEdit.text().split(" ");
+
+	cmdTmp = _commandLineEdit.text();
+	if (!cmdTmp.contains('\'') && !cmdTmp.contains('\"')) {
+		/* Split all command line arguments. */
+		argv << cmdTmp.split(" ", opt);
+	} else {
+		int iOpenQuots, iCloseQuots, size = cmdTmp.size();
+		int iSingleQuots = (cmdTmp.count('\'') == 2) ? cmdTmp.indexOf('\'') : size;
+		int iDoubleQuots = (cmdTmp.count('\"') == 2) ? cmdTmp.indexOf('\"') : size;
+
+		if (iSingleQuots < iDoubleQuots) {
+			iOpenQuots = iSingleQuots;
+			iCloseQuots = cmdTmp.lastIndexOf('\'') + 1;
+		} else if (iDoubleQuots < iSingleQuots) {
+			iOpenQuots = iDoubleQuots;
+			iCloseQuots = cmdTmp.lastIndexOf('\"') + 1;
+		} else {
+			emit print("\nERROR: Unable to parse the command.");
+			return {};
+		}
+
+		/* Split the arguments. */
+		argv << cmdTmp.left(iOpenQuots).split(" ", opt);
+
+		/* Everything in between the quotation marks goes in one piece. */
+		argv << cmdTmp.mid(iOpenQuots, iCloseQuots - iOpenQuots);
+
+		/* Split the rest of the arguments. */
+		argv << cmdTmp.right(size - iCloseQuots).split(" ", opt);
+	}
 
 	return argv;
 }
@@ -350,7 +381,10 @@ void KsCaptureControl::_browse()
 
 void KsCaptureControl::_apply()
 {
-	emit argsReady(getArgs().join(" "));
+	QStringList argv = getArgs();
+
+	if (argv.count())
+		emit argsReady(argv.join(" "));
 }
 
 /** @brief Create KsCaptureMonitor widget. */
-- 
2.20.1

