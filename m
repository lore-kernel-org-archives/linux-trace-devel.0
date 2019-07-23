Return-Path: <SRS0=P3iB=VU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76A01C7618E
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Jul 2019 12:52:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A67E21901
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Jul 2019 12:52:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oKpDWjV7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389914AbfGWMwB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 08:52:01 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41647 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732432AbfGWMwA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 08:52:00 -0400
Received: by mail-wr1-f68.google.com with SMTP id c2so39853196wrm.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Jul 2019 05:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RFVw4HfewavyR0oE+NeHv+pjPUawhk5+prelYCykGRg=;
        b=oKpDWjV7Ri6FR9Z8OLpUPvRxUHaLhBq9GlixuUGnbC/NMvCuGp3osdHS0boCKAu59i
         Gv3DVgTk4sVJeFieYmLUBqxemb/sr+hovqKbAYgf4N00N28A+GB/ybN7Fe3e+5sA65te
         36H8L/R/sokghrEV68PgWGG5yAt1DXRS0xP9lkMm+n6yxQ8FNrgkLfm/++bL0HhjUMmG
         YA0YOMtq8SwwuR8ZW0C2L4FPC7ouohWDpSQAIEvrJd0ftEvpFhtPxo44kL4Ds7ebtAnV
         A4nHepPhsE4vA/7Gjv4jqLPsnWXmjZNA7MSrYFJ1znPX1rqTz6IZjPnwYTFEt4p06ytK
         T+tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RFVw4HfewavyR0oE+NeHv+pjPUawhk5+prelYCykGRg=;
        b=pt7Xa9lIkV9aQKyLJMqitfD62YefVYmjQuDmRl2sdZfaIq9LdJEjgDL8beMKy0hblU
         qGReTtQwJuOZyE1oghNkIT7u0LAaj8gPyuXsVFR4KfOO2EFmEC6i7vQZhR4wrPmvzxRr
         VTyyoZnNANdnlOWXzfGp774Flis8D86pr40c9XEI5ENYtQUSsH2N9JKGHkcQOq0K3nJr
         cS6RqJZncxFmjjIeF/ffcdCDhlwKabsRR6ypCtHhKIhy1Imm9mZmTImjwpjooPqAGIWL
         JkB2p8dYdXJdZv9Pv/45tPhipzFb1wqKItxNwPJ61ZS7gxIKnTLLsa7pw9vWs+MxVobi
         CKTg==
X-Gm-Message-State: APjAAAVlHsnCuP2MmQ0FA0Kaqw5RZY8V/ffzRPgU4dCSuiCCDhn6+4RE
        CL+BUgvq8Vax7qp8akuGJFo=
X-Google-Smtp-Source: APXvYqwbHOGKzLB4Ndg0ctVJhuhkF6FIHKMI3DPLqAtio73EuWg46u+Q+EX1KQSbG2NprTYrfuYTyQ==
X-Received: by 2002:a5d:4211:: with SMTP id n17mr11821439wrq.137.1563886318837;
        Tue, 23 Jul 2019 05:51:58 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id e19sm57423320wra.71.2019.07.23.05.51.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 05:51:58 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, howaboutsynergy@pm.me,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/3] kernel-shark: Make KsEventsCheckBoxWidget::removeSystem more robust
Date:   Tue, 23 Jul 2019 15:52:02 +0300
Message-Id: <20190723125204.22799-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190723125204.22799-1-y.karadz@gmail.com>
References: <20190723125204.22799-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The function has to be able to handle safely the case when the Checkbox
tree widget is empty or it does not contain the item to be removed.

Reported-by: howaboutsynergy <howaboutsynergy@pm.me>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204277
Fixes: 4a02481fff (Remove all system=ftrace events from Record dialog)
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsWidgetsLib.cpp | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel-shark/src/KsWidgetsLib.cpp b/kernel-shark/src/KsWidgetsLib.cpp
index 84afec9..330230e 100644
--- a/kernel-shark/src/KsWidgetsLib.cpp
+++ b/kernel-shark/src/KsWidgetsLib.cpp
@@ -749,10 +749,13 @@ QStringList KsEventsCheckBoxWidget::getCheckedEvents(bool option)
 
 /** Remove a System from the Checkbox tree. */
 void KsEventsCheckBoxWidget::removeSystem(QString name) {
-	QTreeWidgetItem *item =
-		_tree.findItems(name, Qt::MatchFixedString, 0)[0];
+	auto itemList = _tree.findItems(name, Qt::MatchFixedString, 0);
+	int index;
 
-	int index = _tree.indexOfTopLevelItem(item);
+	if (itemList.isEmpty())
+		return;
+
+	index = _tree.indexOfTopLevelItem(itemList[0]);
 	if (index >= 0)
 		_tree.takeTopLevelItem(index);
 }
-- 
2.20.1

