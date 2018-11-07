Return-Path: <SRS0=o0t1=NS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-bl2nam02on0062.outbound.protection.outlook.com ([104.47.38.62]:11903
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727630AbeKHBpl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Nov 2018 20:45:41 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 3/8] kernel-shark-qt: Update the visualization model before
 plotting new graphs
Date: Wed, 7 Nov 2018 16:14:35 +0000
Message-ID: <20181107161410.22507-4-ykaradzhov@vmware.com>
References: <20181107161410.22507-1-ykaradzhov@vmware.com>
In-Reply-To: <20181107161410.22507-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Updating the model before creating new graphs guaranties that all
previously plotted graphs are wiped out.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark-qt/src/KsGLWidget.cpp | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel-shark-qt/src/KsGLWidget.cpp b/kernel-shark-qt/src/KsGLW=
idget.cpp
index 2a0b16b..92b9224 100644
--- a/kernel-shark-qt/src/KsGLWidget.cpp
+++ b/kernel-shark-qt/src/KsGLWidget.cpp
@@ -484,6 +484,8 @@ void KsGLWidget::_makeGraphs(QVector<int> cpuList, QVec=
tor<int> taskList)
 		_graphs.append(graph);
 	};
=20
+	_model.update();
+
 	/* Create CPU graphs according to the cpuList. */
 	for (auto const &cpu: cpuList)
 		lamAddGraph(_newCPUGraph(cpu));
--=20
2.17.1
