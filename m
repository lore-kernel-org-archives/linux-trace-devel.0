Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFF13C4167B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Dec 2022 20:46:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiLNUqs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 14 Dec 2022 15:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiLNUqr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 14 Dec 2022 15:46:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C12B28E39
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Dec 2022 12:46:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E126561BEA
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Dec 2022 20:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E178CC433D2;
        Wed, 14 Dec 2022 20:46:44 +0000 (UTC)
Date:   Wed, 14 Dec 2022 15:46:43 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH] kernel-shark: Show multi-line events in quick view
Message-ID: <20221214154643.43a4e137@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Some events (stack traces) have multiple lines, but the list view of each
event is just a single line. To get the content of the full event, if the
user selects the right mouse button over the event to trigger the quick
view, display the entire content of the event.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/KsQuickContextMenu.cpp | 9 +++++++++
 src/KsQuickContextMenu.hpp | 2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/src/KsQuickContextMenu.cpp b/src/KsQuickContextMenu.cpp
index 6fa242de348d..cc714bfb1aae 100644
--- a/src/KsQuickContextMenu.cpp
+++ b/src/KsQuickContextMenu.cpp
@@ -52,6 +52,7 @@ KsQuickContextMenu::KsQuickContextMenu(KsDualMarkerSM *dm,
   _row(row),
   _rawTime(this),
   _rawEvent(this),
+  _eventInfo(this),
   _graphSyncCBox(nullptr),
   _listSyncCBox(nullptr),
   _hideTaskAction(this),
@@ -104,6 +105,14 @@ KsQuickContextMenu::KsQuickContextMenu(KsDualMarkerSM *dm,
 		evtData += field + ":  " + val.setNum(fieldVal) + "\n\t";
 	}
 
+	QString evtInfo("\t");
+	evtInfo += kshark_get_info(entry);
+	evtInfo += "\n";
+
+	addSection("Event info");
+	_eventInfo.setDefaultWidget(new QLabel(evtInfo));
+	addAction(&_eventInfo);
+
 	addSection("Raw event");
 	time = QString("\ttime:  %1 [ns]").arg(entry->ts);
 
diff --git a/src/KsQuickContextMenu.hpp b/src/KsQuickContextMenu.hpp
index ca0b341dd363..c07c1a534d3a 100644
--- a/src/KsQuickContextMenu.hpp
+++ b/src/KsQuickContextMenu.hpp
@@ -91,7 +91,7 @@ private:
 
 	size_t		_row;
 
-	QWidgetAction	_rawTime, _rawEvent;
+	QWidgetAction	_rawTime, _rawEvent, _eventInfo;
 
 	QCheckBox	*_graphSyncCBox, *_listSyncCBox;
 
-- 
2.35.1

