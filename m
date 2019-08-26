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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24FF2C3A5A7
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Aug 2019 15:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEB2B217F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Aug 2019 15:58:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cK6apLkR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732398AbfHZP6m (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Aug 2019 11:58:42 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42251 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731198AbfHZP6l (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Aug 2019 11:58:41 -0400
Received: by mail-wr1-f68.google.com with SMTP id b16so15828354wrq.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Aug 2019 08:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vtekc/8TUCgCSIe0sMbDvDKMF6iWu1EXAUFkTczUjYc=;
        b=cK6apLkRil25Xu6ukLeffh/P3bhzdgIgnR874fLAbH+xNPmzGbfOMnORGsDiGoORGj
         w9qzCXZRdovo0mTRqNlSjznHjQMQkVyREhwSP6pLD/cqSXOe8i4C3qbH96y8EW3ZW/d2
         ePTyF3GJSDZYHmwesiYBmnkqSzxqubvqI0sYfuXsAV+WkFF2xEoTvO93P2/XaMRtIiDU
         7H1c3qpe89nb9ZgXcpOeJqM+xOgwW4UEolocsKiwXTCYzJP7aqrli9Nz5B68i3ek4uAa
         gvxjVzINhGSJ0KBFOTKiQENsAgLp8infreOw5uX3HtN3Z3PWulnMAJi9A7sBpJAwuskt
         COoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vtekc/8TUCgCSIe0sMbDvDKMF6iWu1EXAUFkTczUjYc=;
        b=OWsV97SB5uskIYtre0zj9oP0jBteb8D4o++jcPQs+u8G5LR61DHaNq4ExiwQoYmb4Q
         zZ13Q7VkS/vPo9Z8/Xjw+nnONwF3M5r7KOaMyYM4rD7VTqbASqzRNg6EHW6to0CnuwM8
         wXl92Riz5cPEgJzCXrnVcw35mRdHFdNsU28mRNz3WlVNAg+Vqdjmo/fdejlmdz/GEAvR
         6CIFrE/6xv9cKxm4G/16s1kKg0WQKdC23rkV3LFSbNscmFPTNXt9hzowceiDniUhQqMO
         zhgjsBj621EiH4500YkHTBVoMAkq0nJqOKCe6+l7Q7C6gTF+hJX/U2g7S+1bRdFz2Rym
         GHLw==
X-Gm-Message-State: APjAAAUgz3SomAD3B4D5rM7hR+coi5h2qTdYGQL+Yg61rXAkZze1UY9n
        eaZa2M62mzquOyo8lu4pAEk=
X-Google-Smtp-Source: APXvYqy20VAadhNbuXoW77/PD9huuS9tMuMGIrItKGVg5I1NTXvfbP2W3hXwkB6eMfrlyn+G9nX0rA==
X-Received: by 2002:adf:8541:: with SMTP id 59mr23117402wrh.298.1566835119911;
        Mon, 26 Aug 2019 08:58:39 -0700 (PDT)
Received: from localhost.localdomain ([84.40.85.140])
        by smtp.gmail.com with ESMTPSA id p13sm14447458wrw.90.2019.08.26.08.58.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 08:58:39 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, mike.auty@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 4/5] kernel-shark: Optimize the error messages when "Record" fails to start
Date:   Mon, 26 Aug 2019 18:58:10 +0300
Message-Id: <20190826155811.32021-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190826155811.32021-1-y.karadz@gmail.com>
References: <20190826155811.32021-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Removing duplicate code.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsMainWindow.cpp | 14 +++++++-------
 kernel-shark/src/KsMainWindow.hpp |  2 ++
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 73d6877..651cf59 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -1199,18 +1199,18 @@ void KsMainWindow::_captureFinished(int ret, QProcess::ExitStatus st)
 		return;
 	}
 
-	if (ret != 0 && st == QProcess::NormalExit) {
-		QString message = "Capture process failed:<br>";
-
-		message += capture->errorString();
-		message += capture->readAllStandardError();
-		_error(message, "captureFinishedErr", false, false);
-	}
+	if (ret != 0 && st == QProcess::NormalExit)
+		_captureErrorMessage(capture);
 }
 
 void KsMainWindow::_captureError(QProcess::ProcessError error)
 {
 	QProcess *capture = (QProcess *)sender();
+	_captureErrorMessage(capture);
+}
+
+void KsMainWindow::_captureErrorMessage(QProcess *capture)
+{
 	QString message = "Capture process failed:<br>";
 
 	message += capture->errorString();
diff --git a/kernel-shark/src/KsMainWindow.hpp b/kernel-shark/src/KsMainWindow.hpp
index 4a7b8ab..eef4f96 100644
--- a/kernel-shark/src/KsMainWindow.hpp
+++ b/kernel-shark/src/KsMainWindow.hpp
@@ -215,6 +215,8 @@ private:
 
 	void _captureError(QProcess::ProcessError error);
 
+	void _captureErrorMessage(QProcess *capture);
+
 	void _readSocket();
 
 	void _splitterMoved(int pos, int index);
-- 
2.20.1

