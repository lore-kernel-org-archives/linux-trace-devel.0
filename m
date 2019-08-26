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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE80DC3A5A4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Aug 2019 15:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4E1920828
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Aug 2019 15:58:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kQeR/Egt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732399AbfHZP6n (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Aug 2019 11:58:43 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:43400 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732358AbfHZP6m (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Aug 2019 11:58:42 -0400
Received: by mail-wr1-f49.google.com with SMTP id y8so15822720wrn.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Aug 2019 08:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OJwPOInCRgMIIkP1ZIlezZ2ICpdstTAzxqMpKVnFCVI=;
        b=kQeR/EgtOb6QdXmIJdnDZo5/4VbZrM6ta6N4Guj1wOOJmDmC3C1cw6CniayqMoDDyT
         tjUbfW/kidpRmrAwgyJs3uMC5iKRFkpm2WpgpiJtQQSdPSxcpcMVumOjiVk5FMA226X0
         sOi7lz7evjqIbBufiQ5BwJ49QxP47O+2t7lEss1/htF49obnGyv4NpAqJ3eol4eMq++P
         qX43UsSPAJsZbFgYV/2U6STgu75T7o9rBImF+anAxJGN6/D5iiZZEJJlT+3f/qs2/erB
         zw8WjdpGcs8eR7QP03Nq76LPqvTx9YltWsROYK4bQb/TqxjKMZDFk4tZASV6qjlNeciG
         dXAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OJwPOInCRgMIIkP1ZIlezZ2ICpdstTAzxqMpKVnFCVI=;
        b=om5Kd92NkjEXShJfD2WHaoB26c0qBofgB6DF1or56C46QnVuJtemWEcbPoyeRcxKCO
         eDwnaADUgc+jBS0t+WJFOpe3EWIK+4WF4GZXAV03+RV5xAYl/8nlaGtlftqrOAvEwXqz
         KyNEn2Ex6XeH+Vgz1bgrxrHJCcLLKMUvwvcdnZbPx1ZVySvYxdGMJLQLSoURa4oJjxfq
         xnfoQ9BsIB36OgScK7dm0wirSSf/pkGaN3B5r7dyn9GfnipxBkIAkWFGdeMW4nL/98Rs
         EMLPYoMvZY+7kVY5hgOYmyY1MxVjOBhBuOKbYcvSMizGWDJuSeeHIdCvoyn16IwnU24e
         tKTA==
X-Gm-Message-State: APjAAAUzY3rfe9EPH5efS2geYM1rz0mYQfXCd4PynSxhNGYMdg6AuShK
        wSPMzbqLOWDLzMoGigDtlnhyqVx+
X-Google-Smtp-Source: APXvYqxERTqLPsZuIb8TtqY9LwOf2/tiUC/FkSa5iTuVVEuEFrpGjotQ/QgTlNUbVzARTcUSEji9QQ==
X-Received: by 2002:adf:facc:: with SMTP id a12mr12199840wrs.205.1566835121342;
        Mon, 26 Aug 2019 08:58:41 -0700 (PDT)
Received: from localhost.localdomain ([84.40.85.140])
        by smtp.gmail.com with ESMTPSA id p13sm14447458wrw.90.2019.08.26.08.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 08:58:40 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, mike.auty@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 5/5] kernel-shark: Better formatting of the error messages from "Record"
Date:   Mon, 26 Aug 2019 18:58:11 +0300
Message-Id: <20190826155811.32021-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190826155811.32021-1-y.karadz@gmail.com>
References: <20190826155811.32021-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Make the message easier to read and understand by separating the
QProcess's error and the Standard error.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsMainWindow.cpp | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 651cf59..a3b5ce7 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -1211,9 +1211,10 @@ void KsMainWindow::_captureError(QProcess::ProcessError error)
 
 void KsMainWindow::_captureErrorMessage(QProcess *capture)
 {
-	QString message = "Capture process failed:<br>";
+	QString message = "Capture process failed: ";
 
 	message += capture->errorString();
+	message += "<br>Standard Error :";
 	message += capture->readAllStandardError();
 	_error(message, "captureFinishedErr", false, false);
 }
-- 
2.20.1

