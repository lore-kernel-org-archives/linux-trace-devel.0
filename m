Received: from smtpout3.mo529.mail-out.ovh.net (smtpout3.mo529.mail-out.ovh.net [46.105.54.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234DE538D
	for <linux-trace-devel@vger.kernel.org>; Sun, 14 Jan 2024 17:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.109.139.23])
	by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 88AE32044C;
	Sun, 14 Jan 2024 17:17:36 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.108) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 14 Jan
 2024 18:17:35 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-108S0028b7ceb55-890a-4d3b-a2e6-d918ba3e564f,
                    5BE38D5D59959AD767059B58A5CDE138DFC9D9F8) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH 07/34] kernelshark: Fix potential memory leak in KsGLWidget
Date: Sun, 14 Jan 2024 18:16:56 +0100
Message-ID: <20240114171723.14092-8-dev@benjarobin.fr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240114171723.14092-1-dev@benjarobin.fr>
References: <20240114171723.14092-1-dev@benjarobin.fr>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DAG1EX2.mxp5.local (172.16.2.2) To DAG6EX2.mxp5.local
 (172.16.2.52)
X-Ovh-Tracer-GUID: 1674ac05-a141-461f-86be-d3efde018a96
X-Ovh-Tracer-Id: 1670835463949279130
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrvdeiledgleelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpeeuvghnjhgrmhhinhcutffquefkpfcuoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqeenucggtffrrghtthgvrhhnpedtheetffeikedvjeegudelheelkeehheekgffgheehtdevjeffjedvgedtvefhjeenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtkedpledvrdduiedurdduvdeirdegnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeouggvvhessggvnhhjrghrohgsihhnrdhfrheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohephidrkhgrrhgrugiisehgmhgrihhlrdgtohhmpdhlihhnuhigqdhtrhgrtggvqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehvdelpdhmohguvgepshhmthhpohhuth

In KsGLWidget::_newCPUGraph() and in KsGLWidget::_newTaskGraph()
allocate KsPlot::Graph after getting data stream successfully.
Also remove unused "name" local variable in both functions.

Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
---
 src/KsGLWidget.cpp | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/src/KsGLWidget.cpp b/src/KsGLWidget.cpp
index 0a44e77..23485d2 100644
--- a/src/KsGLWidget.cpp
+++ b/src/KsGLWidget.cpp
@@ -794,13 +794,8 @@ void KsGLWidget::_makePluginShapes()
 
 KsPlot::Graph *KsGLWidget::_newCPUGraph(int sd, int cpu)
 {
-	QString name;
-	/* The CPU graph needs to know only the colors of the tasks. */
-	KsPlot::Graph *graph = new KsPlot::Graph(_model.histo(),
-						 &_pidColors,
-						 &_pidColors);
-
-	kshark_context *kshark_ctx(nullptr);
+	KsPlot::Graph *graph = nullptr;
+	kshark_context *kshark_ctx = nullptr;
 	kshark_data_stream *stream;
 	kshark_entry_collection *col;
 
@@ -811,6 +806,8 @@ KsPlot::Graph *KsGLWidget::_newCPUGraph(int sd, int cpu)
 	if (!stream)
 		return nullptr;
 
+	/* The CPU graph needs to know only the colors of the tasks. */
+	graph = new KsPlot::Graph(_model.histo(), &_pidColors, &_pidColors);
 	graph->setIdleSuppressed(true, stream->idle_pid);
 	graph->setHeight(KS_GRAPH_HEIGHT);
 	graph->setLabelText(KsUtils::cpuPlotName(cpu).toStdString());
@@ -827,15 +824,8 @@ KsPlot::Graph *KsGLWidget::_newCPUGraph(int sd, int cpu)
 
 KsPlot::Graph *KsGLWidget::_newTaskGraph(int sd, int pid)
 {
-	QString name;
-	/*
-	 * The Task graph needs to know the colors of the tasks and the colors
-	 * of the CPUs.
-	 */
-	KsPlot::Graph *graph = new KsPlot::Graph(_model.histo(),
-						 &_pidColors,
-						 &_cpuColors);
-	kshark_context *kshark_ctx(nullptr);
+	KsPlot::Graph *graph = nullptr;
+	kshark_context *kshark_ctx = nullptr;
 	kshark_entry_collection *col;
 	kshark_data_stream *stream;
 
@@ -846,6 +836,9 @@ KsPlot::Graph *KsGLWidget::_newTaskGraph(int sd, int pid)
 	if (!stream)
 		return nullptr;
 
+	/* The Task graph needs to know the colors of the tasks and the colors
+	 * of the CPUs */
+	graph = new KsPlot::Graph(_model.histo(), &_pidColors, &_cpuColors);
 	graph->setHeight(KS_GRAPH_HEIGHT);
 	graph->setLabelText(KsUtils::taskPlotName(sd, pid).toStdString());
 
-- 
2.43.0

