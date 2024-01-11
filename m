Received: from smtpout3.mo529.mail-out.ovh.net (smtpout3.mo529.mail-out.ovh.net [46.105.54.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE4115E9B
	for <linux-trace-devel@vger.kernel.org>; Thu, 11 Jan 2024 19:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.109.140.5])
	by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 27AF520B33;
	Thu, 11 Jan 2024 19:07:21 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.109) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 11 Jan
 2024 20:07:20 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-109S0034beab619-d582-4d56-8f42-7cd3dd9ca7ad,
                    9E13174A6675E0777CCB02211AA1E1CC2CFEBB1E) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH] KsGLWidget: Fix modelReset() signaling, rename update to updateGeom
Date: Thu, 11 Jan 2024 20:07:12 +0100
Message-ID: <20240111190712.7670-1-dev@benjarobin.fr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DAG9EX1.mxp5.local (172.16.2.81) To DAG6EX2.mxp5.local
 (172.16.2.52)
X-Ovh-Tracer-GUID: 09b755be-4926-4ea9-bea5-43c50dc5a7b7
X-Ovh-Tracer-Id: 4352729040837894042
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrvdeifedguddulecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecunecujfgurhephffvvefufffkofgggfgtihesthekredtredttdenucfhrhhomhepuegvnhhjrghmihhnucftqfeukffpuceouggvvhessggvnhhjrghrohgsihhnrdhfrheqnecuggftrfgrthhtvghrnhephfeuheehueejvdfhheehgfeikefhkeeufedvtdffgfekiefhtdeivefhhfeiieejnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtledpledvrdduiedurdduvdeirdegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeouggvvhessggvnhhjrghrohgsihhnrdhfrheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohephidrkhgrrhgrugiisehgmhgrihhlrdgtohhmpdhlihhnuhigqdhtrhgrtggvqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehvdelpdhmohguvgepshhmthhpohhuth

Fix segfault introduced by the migration to Qt6.

There was a public update() function in KsGLWidget class which overrides
QWidget::update(). The QAbstractTableModel::modelReset signal was connected
to the QWidget::update slot using "old" connect syntax. This was working
since QWidget::update was declared as a slot, and registered in QWidget
meta information.

When migrating to Qt6, the new connect syntax was used, which accidentally
connect the KsGLWidget::update function instead of QWidget::update.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=218350
Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
---
 src/KsGLWidget.cpp   | 4 ++--
 src/KsGLWidget.hpp   | 2 +-
 src/KsTraceGraph.cpp | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/KsGLWidget.cpp b/src/KsGLWidget.cpp
index 023d1c8..9e3dac3 100644
--- a/src/KsGLWidget.cpp
+++ b/src/KsGLWidget.cpp
@@ -53,7 +53,7 @@ KsGLWidget::KsGLWidget(QWidget *parent)
 	setMouseTracking(true);
 
 	connect(&_model,	&QAbstractTableModel::modelReset,
-		this,		&KsGLWidget::update);
+		this,		qOverload<>(&KsGLWidget::update));
 }
 
 void KsGLWidget::_freeGraphs()
@@ -89,7 +89,7 @@ void KsGLWidget::initializeGL()
 	ksplot_init_font(&_font, 15, TT_FONT_FILE);
 
 	_labelSize = _getMaxLabelSize() + FONT_WIDTH * 2;
-	update();
+	updateGeom();
 }
 
 /**
diff --git a/src/KsGLWidget.hpp b/src/KsGLWidget.hpp
index 03bd5eb..1c6253f 100644
--- a/src/KsGLWidget.hpp
+++ b/src/KsGLWidget.hpp
@@ -86,7 +86,7 @@ public:
 	void reset();
 
 	/** Reprocess all graphs. */
-	void update() {resizeGL(width(), height());}
+	void updateGeom() {resizeGL(width(), height());}
 
 	void mousePressEvent(QMouseEvent *event);
 
diff --git a/src/KsTraceGraph.cpp b/src/KsTraceGraph.cpp
index 65e5a79..f80477d 100644
--- a/src/KsTraceGraph.cpp
+++ b/src/KsTraceGraph.cpp
@@ -614,7 +614,7 @@ void KsTraceGraph::updateGeom()
 			       * widget is extended to maximum.
 			       */
 
-	_glWindow.update();
+	_glWindow.updateGeom();
 }
 
 /**
-- 
2.43.0

