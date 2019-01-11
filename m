Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:39861 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730940AbfAKPFo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Jan 2019 10:05:44 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
        <u.kleine-koenig@pengutronix.de>
To: linux-trace-devel@vger.kernel.org
Cc: kernel@pengutronix.de, Yordan Karadzhov <ykaradzhov@vmware.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v2] Fix formatting of fixed-point numbers to not skip zeros
Date: Fri, 11 Jan 2019 16:05:36 +0100
Message-Id: <20190111150536.28204-1-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20190111092954.05966ae8@gandalf.local.home>
References: <20190111092954.05966ae8@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

When a timestamp that represents 1.00001 is converted to (for example)
seconds and microseconds this results in seconds=1 and useconds=10. To
format that into a string requires the format %lu.%06lu to yield
"1.000010". Some code parts used %lu.%lu however which results in "1.10"
which is wrong.

This was noticed because I failed to find a significant location in a trace
provided by a colleague as the reported timestamp was wrong :-|

This change fixes all occurrences of this problem found by
$(grep -E '\.%[^0s]').

Reviewed-by: Yordan Karadzhov <ykaradzhov@vmware.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 kernel-shark-qt/src/KsTraceGraph.cpp | 10 +++++-----
 python/event-viewer.py               |  4 ++--
 python/tracecmd.py                   |  2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel-shark-qt/src/KsTraceGraph.cpp b/kernel-shark-qt/src/KsTraceGraph.cpp
index 462918f8a37a..844c79494e9b 100644
--- a/kernel-shark-qt/src/KsTraceGraph.cpp
+++ b/kernel-shark-qt/src/KsTraceGraph.cpp
@@ -279,7 +279,7 @@ void KsTraceGraph::_resetPointer(uint64_t ts, int cpu, int pid)
 	QString pointer;
 
 	kshark_convert_nano(ts, &sec, &usec);
-	pointer.sprintf("%lu.%lu", sec, usec);
+	pointer.sprintf("%lu.%06lu", sec, usec);
 	_labelP2.setText(pointer);
 
 	if (pid > 0 && cpu >= 0) {
@@ -315,7 +315,7 @@ void KsTraceGraph::_setPointerInfo(size_t i)
 	uint64_t sec, usec;
 
 	kshark_convert_nano(e->ts, &sec, &usec);
-	pointer.sprintf("%lu.%lu", sec, usec);
+	pointer.sprintf("%lu.%06lu", sec, usec);
 	_labelP2.setText(pointer);
 
 	comm.append("-");
@@ -601,17 +601,17 @@ void KsTraceGraph::_updateTimeLegends()
 	QString tMin, tMid, tMax;
 
 	kshark_convert_nano(_glWindow.model()->histo()->min, &sec, &usec);
-	tMin.sprintf("%lu.%lu", sec, usec);
+	tMin.sprintf("%lu.%06lu", sec, usec);
 	_labelXMin.setText(tMin);
 
 	tsMid = (_glWindow.model()->histo()->min +
 		 _glWindow.model()->histo()->max) / 2;
 	kshark_convert_nano(tsMid, &sec, &usec);
-	tMid.sprintf("%lu.%lu", sec, usec);
+	tMid.sprintf("%lu.%06lu", sec, usec);
 	_labelXMid.setText(tMid);
 
 	kshark_convert_nano(_glWindow.model()->histo()->max, &sec, &usec);
-	tMax.sprintf("%lu.%lu", sec, usec);
+	tMax.sprintf("%lu.%06lu", sec, usec);
 	_labelXMax.setText(tMax);
 }
 
diff --git a/python/event-viewer.py b/python/event-viewer.py
index 651761a083c9..3a082b81fc3d 100755
--- a/python/event-viewer.py
+++ b/python/event-viewer.py
@@ -203,8 +203,8 @@ class EventView(gtk.TreeView):
             return False
 
         if data == "ts":
-            cell.set_property("markup", "%d.%d" % (ev.ts/1000000000,
-                                                   ev.ts%1000000000))
+            cell.set_property("markup", "%d.%09d" % (ev.ts/1000000000,
+                                                     ev.ts%1000000000))
             data_func_cnt = data_func_cnt + 1
             if app:
                 app.inc_data_func()
diff --git a/python/tracecmd.py b/python/tracecmd.py
index 1267941aa388..f551a1489e25 100644
--- a/python/tracecmd.py
+++ b/python/tracecmd.py
@@ -62,7 +62,7 @@ class Event(object, DictMixin):
         self._format = format
 
     def __str__(self):
-        return "%d.%d CPU%d %s: pid=%d comm=%s type=%d" % \
+        return "%d.%09d CPU%d %s: pid=%d comm=%s type=%d" % \
                (self.ts/1000000000, self.ts%1000000000, self.cpu, self.name,
                 self.num_field("common_pid"), self.comm, self.type)
 
-- 
2.20.1
