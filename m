Return-Path: <SRS0=uJAW=VG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0746DC73C46
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 15:57:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4EE7216E3
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Jul 2019 15:57:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TfCHvVkf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbfGIP5Y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Jul 2019 11:57:24 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:33840 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfGIP5Y (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Jul 2019 11:57:24 -0400
Received: by mail-wr1-f52.google.com with SMTP id 31so4834229wrm.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 09 Jul 2019 08:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G8BNxHGQFIurQtSbHNJIYbTT2zYIjn4djInsYOxdlEk=;
        b=TfCHvVkfob2din3YdqoXLToDUCaXPMVqbvhk78XqIz5tCbv5HBGjskhytYQLutTuRQ
         87ayPCrrH8AslLwkEZ+sg4aB20SVcsiluC1d8hqrh0aezq7eB9CbJ0IBcjf++InnfUNQ
         G9TC/hOZktFVC42RAt59JDAymCaKPrImCwkgdyG0+F/T/AAPsYEntwyRAK5DVulwdXlo
         3l9zuB0azI4kY2nkpdxh4S4QWTwEuQTW9qhG9lbfiVLfSDljh3bxvm0rJnFF9tqOxskr
         GtwTm+pIxkNVM1YvptMsTlhItu6iX3LrDjq5Nss1W3Ms4q8BtquevJoE5WI82lB8d8E5
         coNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G8BNxHGQFIurQtSbHNJIYbTT2zYIjn4djInsYOxdlEk=;
        b=Ep4EO8leIx33X72tVB1YBhP626kZZsEpR7NQ3xJXhDogCl1HVqFs++9Zz0FwMQogvw
         SIuSzw8NDMOC4oa1yQunvxm8t7sLluKMlk1ijfDiEJAjrHIY5YvaFV9QlTMXG026R7nW
         DZRUweEyvpgW6guFkHEaQYXagaRJho+e2o5iUG8XySXhIpkmLNHL+lYmTYq2vhfxfgL+
         S3/Mvt2AqIcSx60zooREbp3BRvkeb0XWREm0YORy/rYhgNROtj0Tok/yPCo7cWO92DKu
         3aIsmb9B0oa+CN4KSO7BEdNBpIxYW+2N0b6GA6FFBv0vZCvmY801fUwzXtu90KpR6Gjn
         bGlA==
X-Gm-Message-State: APjAAAXh8iysYaetwEeZaHByq341x5uncEP1pYzALIySE/bpq+yEEfoR
        0k5PoLtMZcL3i7PoR7xyoq8=
X-Google-Smtp-Source: APXvYqyM6kMVzLYAhHKaIDGmalzs5K/Q9FE8CDzvHL103RZqdiPEd/Kb+Yi/Uly8+ipGJePCZbEFyA==
X-Received: by 2002:adf:e50b:: with SMTP id j11mr25957430wrm.351.1562687842363;
        Tue, 09 Jul 2019 08:57:22 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id v5sm24313746wre.50.2019.07.09.08.57.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 08:57:22 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/8] kernel-shark: Add method for getting all selected events
Date:   Tue,  9 Jul 2019 18:56:44 +0300
Message-Id: <20190709155650.2345-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190709155650.2345-1-y.karadz@gmail.com>
References: <20190709155650.2345-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new method is added to the class KsEventsCheckBoxWidget. It returns
a list of strings containing all selected events. If the whole system
is selected (the top level checkbox is checked), only the name of the
system is added to the list.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsWidgetsLib.cpp | 41 +++++++++++++++++++++++++++++++
 kernel-shark/src/KsWidgetsLib.hpp |  2 ++
 2 files changed, 43 insertions(+)

diff --git a/kernel-shark/src/KsWidgetsLib.cpp b/kernel-shark/src/KsWidgetsLib.cpp
index ea02b5e..1c55c79 100644
--- a/kernel-shark/src/KsWidgetsLib.cpp
+++ b/kernel-shark/src/KsWidgetsLib.cpp
@@ -706,6 +706,47 @@ KsEventsCheckBoxWidget::KsEventsCheckBoxWidget(struct tep_handle *tep,
 	_adjustSize();
 }
 
+/**
+ * @brief Get a list of all checked events. If the whole system is selected
+ *	  (the top level checkbox is checked), only the name of the system is
+ *	  added to the list.
+ *
+ * @param option: If True, "-e" is added as prefix to each element of the list.
+ *
+ * @returns A list of checked events or systems.
+ */
+QStringList KsEventsCheckBoxWidget::getCheckedEvents(bool option)
+{
+	QTreeWidgetItem *sysItem, *evtItem;
+	QStringList list;
+	QString optStr;
+	int nSys, nEvts;
+
+	if (option)
+		optStr = "-e";
+
+	nSys = _tree.topLevelItemCount();
+	for(int t = 0; t < nSys; ++t) {
+		sysItem = _tree.topLevelItem(t);
+		if (sysItem->checkState(0) == Qt::Checked) {
+			list << optStr + sysItem->text(0);
+		} else {
+			nEvts = sysItem->childCount();
+			for (int c = 0; c < nEvts; ++c) {
+				evtItem = sysItem->child(c);
+				if (evtItem->checkState(0) == Qt::Checked) {
+					list << optStr +
+						sysItem->text(0) +
+						":" +
+						evtItem->text(0);
+				}
+			}
+		}
+	}
+
+	return list;
+}
+
 /** Remove a System from the Checkbox tree. */
 void KsEventsCheckBoxWidget::removeSystem(QString name) {
 	QTreeWidgetItem *item =
diff --git a/kernel-shark/src/KsWidgetsLib.hpp b/kernel-shark/src/KsWidgetsLib.hpp
index 6f22374..0d79250 100644
--- a/kernel-shark/src/KsWidgetsLib.hpp
+++ b/kernel-shark/src/KsWidgetsLib.hpp
@@ -333,6 +333,8 @@ struct KsEventsCheckBoxWidget : public KsCheckBoxTreeWidget
 	KsEventsCheckBoxWidget(struct tep_handle *pe,
 			       QWidget *parent = nullptr);
 
+	QStringList getCheckedEvents(bool option);
+
 	void removeSystem(QString name);
 };
 
-- 
2.20.1

