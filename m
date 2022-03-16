Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C08AC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Mar 2022 14:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241769AbiCPOir (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Mar 2022 10:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238737AbiCPOiq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Mar 2022 10:38:46 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF0252E2C
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Mar 2022 07:37:32 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id yy13so4661121ejb.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Mar 2022 07:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XtrHW8Gf5ru7KWcWlXYE3NPBzAVwttKoSsIEVDR5Jvc=;
        b=RYHAgUkHElGr2XmwdxoicSgJXIIkBbNWaIfsoJuRV1u1EcrFNQwdYRLu96PGBDBYlR
         PMMhXzAt/ayQZBu4uttfGN135r+/nPvPmtZiRtkvJd58GCSS7VSOyESHU5bx32VxrIX9
         cDmV/VOO4RFqlNqsS9szWX+uHyw2h8NIYjMLxnenYZ+QLCAyTYPDH5QvB0D2acdA1yZI
         +mlCKRkroJWcNV8DRz1h9FERA2JtGoNwpvCN+Q/b3Gs4jXJwU5UPPVddBs55AWrN/UR6
         W7k3IaUWR/f4tn7X1ufvA6OL0Gsl2B/x8af4iUQzN0NGmDeeOqJxqtJ6L6tQhUM1uGOQ
         dgBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XtrHW8Gf5ru7KWcWlXYE3NPBzAVwttKoSsIEVDR5Jvc=;
        b=5ay1hAIktoNBvPiybcIhxQvUicOA8wOUQ/k1xkLRrWS5bhUsyJCEfLbU+lYaISXr4O
         NC0bnp+BzJ4iiiI5BIhi7y4JfPt84U+Z084RKGDQLmAlhdAjiFH5xYcdjv6QRTX+LTcO
         URyeJbPpupKwvfU/FEh52uut8qHLuv5Y/+jjCfTBFpgQ9Asi0dQKcEjl574WtPYHPJ1l
         TWr/zlA0b4cyb0UXdryoPZ2mzSK2GcnLLiZSI1LD5cOq0cW+VrdlwRbW6Atdn/C3ctue
         M7SQw0FTkmWakQxf95V3hVL1SWnITMdfEg9p4LV6dPmYB7GY+edks5OflImFjRB5iO4j
         jjfw==
X-Gm-Message-State: AOAM5312VvxDoSbvYgUHGVkEo+HjUVBMuxyG9/lRx7QTjQ177/j8iIHj
        L3EqBa62Q7p34hK2fOTVGZvO6uymuB8=
X-Google-Smtp-Source: ABdhPJwMnSTAQpWDrsu4jLRCideFPoK5v6gs7oh/qQOnDTkXyxRtmvins98gqQiysBw+0HpQYb5aLw==
X-Received: by 2002:a17:906:c10f:b0:6da:88aa:9d06 with SMTP id do15-20020a170906c10f00b006da88aa9d06mr282343ejc.196.1647441450960;
        Wed, 16 Mar 2022 07:37:30 -0700 (PDT)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id y13-20020a1709060a8d00b006dabeaf86c7sm959445ejf.137.2022.03.16.07.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 07:37:30 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/2] kernel-shark: CPU plots dialog ease spotting empty CPUs
Date:   Wed, 16 Mar 2022 16:37:17 +0200
Message-Id: <20220316143717.272899-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220316143717.272899-1-y.karadz@gmail.com>
References: <20220316143717.272899-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The CPU plots dialog will show only the ones with content. A "hide empty"
checkbox is added, that by default is checked. If it is unchecked, then
all the CPUs would show up.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=215677
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsWidgetsLib.cpp | 26 +++++++++++++++++++++++++-
 src/KsWidgetsLib.hpp |  7 +++++--
 2 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/src/KsWidgetsLib.cpp b/src/KsWidgetsLib.cpp
index e30bf27..7b3192d 100644
--- a/src/KsWidgetsLib.cpp
+++ b/src/KsWidgetsLib.cpp
@@ -906,12 +906,35 @@ void KsCheckBoxTreeWidget::_verify()
  * @param parent: The parent of this widget.
  */
 KsCPUCheckBoxWidget::KsCPUCheckBoxWidget(kshark_data_stream *stream, QWidget *parent)
-: KsCheckBoxTreeWidget(stream->stream_id, "CPUs", parent)
+: KsCheckBoxTreeWidget(stream->stream_id, "CPUs", parent),
+  _hideEmpty("hide empty")
 {
 	int height(FONT_HEIGHT * 1.5);
 	KsPlot::ColorTable colors;
 	QString style;
 
+	_hideEmpty.setCheckState(Qt::Checked);
+	_tb.addSeparator();
+	_tb.addWidget(&_hideEmpty);
+
+	auto lamHideEmpty = [this, stream] (bool hide) {
+		QTreeWidgetItem *item;
+		bool isIdle;
+
+		for(int cpu = 0; cpu < stream->n_cpus; ++cpu) {
+			item = _tree.topLevelItem(cpu);
+			if (hide) {
+				isIdle = kshark_hash_id_find(stream->idle_cpus, cpu);
+				item->setHidden(isIdle);
+			} else {
+				item->setHidden(false);
+			}
+		}
+	};
+
+	connect(&_hideEmpty,	&QCheckBox::clicked,
+				lamHideEmpty);
+
 	style = QString("QTreeView::item { height: %1 ;}").arg(height);
 	_tree.setStyleSheet(style);
 
@@ -934,6 +957,7 @@ KsCPUCheckBoxWidget::KsCPUCheckBoxWidget(kshark_data_stream *stream, QWidget *pa
 		_cb[i] = cpuItem;
 	}
 
+	lamHideEmpty(true);
 	_adjustSize();
 }
 
diff --git a/src/KsWidgetsLib.hpp b/src/KsWidgetsLib.hpp
index 6ec2bd1..2cc3535 100644
--- a/src/KsWidgetsLib.hpp
+++ b/src/KsWidgetsLib.hpp
@@ -275,10 +275,9 @@ public:
 	/** The user provided an input. The widget has been modified. */
 	bool _userInput;
 
-private:
+protected:
 	QToolBar _tb;
 
-protected:
 	/** Identifier of the Data stream for which the selection applies. */
 	int		_sd;
 
@@ -544,6 +543,10 @@ struct KsCPUCheckBoxWidget : public KsCheckBoxTreeWidget
 
 	KsCPUCheckBoxWidget(kshark_data_stream *stream,
 			    QWidget *parent = nullptr);
+
+private:
+	/** The "hide empty" checkbox. */
+	QCheckBox	_hideEmpty;
 };
 
 /**
-- 
2.32.0

