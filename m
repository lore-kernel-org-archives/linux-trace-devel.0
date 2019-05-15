Return-Path: <SRS0=5FCK=TP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C0B1C04E53
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 May 2019 19:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C5AA20843
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 May 2019 19:10:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbfEOTKq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 15 May 2019 15:10:46 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34349 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbfEOTKq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 May 2019 15:10:46 -0400
Received: by mail-pl1-f194.google.com with SMTP id w7so338735plz.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 15 May 2019 12:10:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x8NMODX5sqluhbXf6VrgopcpmsYyySuuVWNORWvMLAM=;
        b=kHTKZCy+iRsQtjtAAKFDqL/Svxaw0Q6rfXgZTt/u9jpdiYsLJbTg63dJRcjmeJYoyL
         kZbdc6jl/fJTlJmhuNwJFVP0Ftq8NrTvI+1oTHIfgX/lwS7AKTbMre/YKQkM5y5GFHyR
         POXIe7FkmGjDKxS52AzG7bcTwEAw7q8xn+kJnSofVcj5yiIykiyRpatJBBg4nmQojHew
         IktD63qrWyHj4Hdx4VIxSNjW0xwE6huW0MzrmCqJg9WOOBwZeyONf8UpvuIgdP5HnkJC
         5heS7k1ub3suHClwaVGqOk5PZN1hIPFQJqAFxkh/xGpl+KDV+feLunUDO2gQ0B0HYK9T
         yqOw==
X-Gm-Message-State: APjAAAXBCnBMYLoVNpPXRk4FWGvVSQ+PHc20BK0IV+gxEh68KYTDWgXC
        RYpQ89NxQ6hBmRbWpHoTqlpFthY5
X-Google-Smtp-Source: APXvYqxFeaHdkH8g5J/trBe0r6te7S2mZXDgLCdIo+q0jbKvo+vxTmvwjwva1OXV/SuVLeiV90ssxQ==
X-Received: by 2002:a17:902:6b81:: with SMTP id p1mr45060123plk.207.1557947445871;
        Wed, 15 May 2019 12:10:45 -0700 (PDT)
Received: from localhost.localdomain (50-204-120-225-static.hfc.comcastbusiness.net. [50.204.120.225])
        by smtp.gmail.com with ESMTPSA id l65sm5772595pfb.7.2019.05.15.12.10.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 12:10:45 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 6/6] kernel-shark: Handle the case when the marker points to a filtered entry
Date:   Wed, 15 May 2019 12:09:11 -0700
Message-Id: <20190515190911.20755-7-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190515190911.20755-1-ykaradzhov@vmware.com>
References: <20190515190911.20755-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Markers can point to entries that are filtered out. In such a case
the filtered marker is plotted using a dashed line.

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsDualMarker.cpp  | 10 +++++++++
 kernel-shark/src/KsPlotTools.cpp   | 33 +++++++++++++++++++++++++++++-
 kernel-shark/src/KsPlotTools.hpp   | 11 +++++++++-
 kernel-shark/src/KsTraceViewer.cpp | 22 ++++++++++++--------
 4 files changed, 65 insertions(+), 11 deletions(-)

diff --git a/kernel-shark/src/KsDualMarker.cpp b/kernel-shark/src/KsDualMarker.cpp
index 5dcbaae..755e246 100644
--- a/kernel-shark/src/KsDualMarker.cpp
+++ b/kernel-shark/src/KsDualMarker.cpp
@@ -79,9 +79,19 @@ bool KsGraphMark::set(const KsDataStore &data,
 		      kshark_trace_histo *histo,
 		      size_t pos, int cpuGraph, int taskGraph)
 {
+	uint8_t visFlags;
+
 	_isSet = true;
 	_pos = pos;
 	_ts = data.rows()[_pos]->ts;
+	visFlags = data.rows()[_pos]->visible;
+
+	if ((visFlags & KS_TEXT_VIEW_FILTER_MASK) &&
+	    (visFlags & KS_GRAPH_VIEW_FILTER_MASK))
+		_mark.setDashed(false);
+	else
+		_mark.setDashed(true);
+
 	_cpu = cpuGraph;
 	_task = taskGraph;
 
diff --git a/kernel-shark/src/KsPlotTools.cpp b/kernel-shark/src/KsPlotTools.cpp
index f95ada5..a8eddcd 100644
--- a/kernel-shark/src/KsPlotTools.cpp
+++ b/kernel-shark/src/KsPlotTools.cpp
@@ -379,6 +379,32 @@ void drawLine(const Point &a, const Point &b,
 			 size);
 }
 
+/**
+ * @brief Draw a dashed line between point "a" and point "b".
+ *
+ * @param a: The first finishing point of the line.
+ * @param b: The second finishing point of the line.
+ * @param col: The color of the line.
+ * @param size: The size of the line.
+ * @param period: The period of the dashed line.
+ */
+void drawDashedLine(const Point &a, const Point &b,
+		    const Color &col, float size, float period)
+{
+	int dx = b.x() - a.x(), dy = b.y() - a.y();
+	float mod = sqrt(dx * dx + dy * dy);
+	int n = mod / period;
+	Point p1, p2;
+
+	for (int i = 0; i < n; ++i) {
+		p1.setX(a.x() + (i + .25) * dx / n);
+		p1.setY(a.y() + (i + .25) * dy / n);
+		p2.setX(a.x() + (i + .75) * dx / n);
+		p2.setY(a.y() + (i + .75) * dy / n);
+		drawLine(p1, p2, col, size);
+	}
+}
+
 /** @brief Create a default line. The two points are initialized at (0, 0). */
 Line::Line()
 : Shape(2)
@@ -430,6 +456,7 @@ void Polygon::_draw(const Color &col, float size) const
  * @brief Create a default Mark.
  */
 Mark::Mark()
+: _dashed(false)
 {
 	_visible = false;
 	_cpu._color = Color(225, 255, 100);
@@ -440,7 +467,11 @@ Mark::Mark()
 
 void Mark::_draw(const Color &col, float size) const
 {
-	drawLine(_a, _b, col, size);
+	if (_dashed)
+		drawDashedLine(_a, _b, col, size, 3 * _cpu._size / size);
+	else
+		drawLine(_a, _b, col, size);
+
 	_cpu.draw();
 	_task.draw();
 }
diff --git a/kernel-shark/src/KsPlotTools.hpp b/kernel-shark/src/KsPlotTools.hpp
index 11c49eb..ee447f1 100644
--- a/kernel-shark/src/KsPlotTools.hpp
+++ b/kernel-shark/src/KsPlotTools.hpp
@@ -204,7 +204,10 @@ private:
 };
 
 void drawLine(const Point &a, const Point &b,
-	      const Color &col, float s);
+	      const Color &col, float size);
+
+void drawDashedLine(const Point &a, const Point &b,
+		    const Color &col, float size, float period);
 
 /** This class represents a straight line. */
 class Line : public Shape {
@@ -326,6 +329,9 @@ public:
 
 	void setTaskVisible(bool v);
 
+	/** If True, the Mark will be plotted as a dashed line. */
+	void setDashed(bool d) {_dashed = d;}
+
 private:
 	void _draw(const Color &col, float size = 1.) const override;
 
@@ -340,6 +346,9 @@ private:
 
 	/** A point indicating the position of the Mark in a Task graph. */
 	Point _task;
+
+	/* If True, plot the Mark as a dashed line. */
+	bool _dashed;
 };
 
 /** This class represents a KernelShark graph's bin. */
diff --git a/kernel-shark/src/KsTraceViewer.cpp b/kernel-shark/src/KsTraceViewer.cpp
index 04a38b8..05977c3 100644
--- a/kernel-shark/src/KsTraceViewer.cpp
+++ b/kernel-shark/src/KsTraceViewer.cpp
@@ -493,15 +493,19 @@ void KsTraceViewer::markSwitch()
 		QModelIndex index =
 			_proxyModel.mapFromSource(_model.index(row, 0));
 
-		/*
-		 * The row of the active marker will be colored according to
-		 * the assigned property of the current state of the Dual
-		 * marker. Auto-scrolling is temporarily disabled because we
-		 * do not want to scroll to the position of the marker yet.
-		 */
-		_view.setAutoScroll(false);
-		_view.selectRow(index.row());
-		_view.setAutoScroll(true);
+		if (index.isValid()) {
+			/*
+			 * The row of the active marker will be colored according to
+			 * the assigned property of the current state of the Dual
+			 * marker. Auto-scrolling is temporarily disabled because we
+			 * do not want to scroll to the position of the marker yet.
+			 */
+			_view.setAutoScroll(false);
+			_view.selectRow(index.row());
+			_view.setAutoScroll(true);
+		} else {
+			_view.clearSelection();
+		}
 	} else {
 		_view.clearSelection();
 	}
-- 
2.20.1

