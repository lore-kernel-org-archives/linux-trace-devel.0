Received: from smtpout3.mo529.mail-out.ovh.net (smtpout3.mo529.mail-out.ovh.net [46.105.54.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C45E53AC
	for <linux-trace-devel@vger.kernel.org>; Sun, 14 Jan 2024 17:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.109.139.23])
	by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 76CB620452;
	Sun, 14 Jan 2024 17:17:37 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.108) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 14 Jan
 2024 18:17:36 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-108S002979fcb5f-cccb-493a-bd42-04d5b4bb21c2,
                    5BE38D5D59959AD767059B58A5CDE138DFC9D9F8) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH 09/34] kernelshark: Keep overridden method protected instead of public
Date: Sun, 14 Jan 2024 18:16:58 +0100
Message-ID: <20240114171723.14092-10-dev@benjarobin.fr>
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
X-Ovh-Tracer-GUID: 9cc5d8b1-128b-4b67-be8e-4b96f7c8f05d
X-Ovh-Tracer-Id: 1670835463560388506
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrvdeiledgleelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpeeuvghnjhgrmhhinhcutffquefkpfcuoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqeenucggtffrrghtthgvrhhnpedtheetffeikedvjeegudelheelkeehheekgffgheehtdevjeffjedvgedtvefhjeenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtkedpledvrdduiedurdduvdeirdegnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeouggvvhessggvnhhjrghrohgsihhnrdhfrheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohephidrkhgrrhgrugiisehgmhgrihhlrdgtohhmpdhlihhnuhigqdhtrhgrtggvqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehvdelpdhmohguvgepshhmthhpohhuth

Also add "override" keyword when missing.

Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
---
 src/KsGLWidget.hpp    | 41 +++++++++++++++++++++--------------------
 src/KsModels.hpp      |  9 +++++----
 src/KsPlotTools.hpp   |  2 +-
 src/KsTraceViewer.hpp |  9 +++++----
 src/KsWidgetsLib.hpp  |  9 +++++----
 5 files changed, 37 insertions(+), 33 deletions(-)

diff --git a/src/KsGLWidget.hpp b/src/KsGLWidget.hpp
index 1c6253f..cafc70b 100644
--- a/src/KsGLWidget.hpp
+++ b/src/KsGLWidget.hpp
@@ -75,12 +75,6 @@ public:
 
 	~KsGLWidget();
 
-	void initializeGL() override;
-
-	void resizeGL(int w, int h) override;
-
-	void paintGL() override;
-
 	void render();
 
 	void reset();
@@ -88,20 +82,6 @@ public:
 	/** Reprocess all graphs. */
 	void updateGeom() {resizeGL(width(), height());}
 
-	void mousePressEvent(QMouseEvent *event);
-
-	void mouseMoveEvent(QMouseEvent *event);
-
-	void mouseReleaseEvent(QMouseEvent *event);
-
-	void mouseDoubleClickEvent(QMouseEvent *event);
-
-	void wheelEvent(QWheelEvent * event);
-
-	void keyPressEvent(QKeyEvent *event);
-
-	void keyReleaseEvent(QKeyEvent *event);
-
 	void loadData(KsDataStore *data, bool resetPlots);
 
 	void loadColors();
@@ -214,6 +194,27 @@ public:
 	/** Free the list of plugin-defined shapes. */
 	void freePluginShapes();
 
+protected:
+	void initializeGL() override;
+
+	void resizeGL(int w, int h) override;
+
+	void paintGL() override;
+
+	void mousePressEvent(QMouseEvent *event) override;
+
+	void mouseMoveEvent(QMouseEvent *event) override;
+
+	void mouseReleaseEvent(QMouseEvent *event) override;
+
+	void mouseDoubleClickEvent(QMouseEvent *event) override;
+
+	void wheelEvent(QWheelEvent * event) override;
+
+	void keyPressEvent(QKeyEvent *event) override;
+
+	void keyReleaseEvent(QKeyEvent *event) override;
+
 signals:
 	/**
 	 * This signal is emitted when the mouse moves over a visible
diff --git a/src/KsModels.hpp b/src/KsModels.hpp
index 2883ce3..e113cf5 100644
--- a/src/KsModels.hpp
+++ b/src/KsModels.hpp
@@ -172,9 +172,6 @@ class KsFilterProxyModel : public QSortFilterProxyModel
 public:
 	explicit KsFilterProxyModel(QObject *parent = nullptr);
 
-	bool filterAcceptsRow(int sourceRow,
-			      const QModelIndex &sourceParent) const override;
-
 	void fill(KsDataStore *data);
 
 	void setSource(KsViewModel *s);
@@ -224,9 +221,13 @@ public:
 	/** A mutex used by the condition variable. */
 	std::mutex		_mutex;
 
-	/** A flag used to stop the serch for all threads. */
+	/** A flag used to stop the search for all threads. */
 	bool			_searchStop;
 
+protected:
+	bool filterAcceptsRow(int sourceRow,
+			      const QModelIndex &sourceParent) const override;
+
 private:
 	int			_searchProgress;
 
diff --git a/src/KsPlotTools.hpp b/src/KsPlotTools.hpp
index 68bd6f7..8f53077 100644
--- a/src/KsPlotTools.hpp
+++ b/src/KsPlotTools.hpp
@@ -662,7 +662,7 @@ private:
 	/** The vertical size (height) of the graphical element. */
 	int _height;
 
-	void _draw(const Color &col, float size) const;
+	void _draw(const Color &col, float size) const override;
 };
 
 }; // KsPlot
diff --git a/src/KsTraceViewer.hpp b/src/KsTraceViewer.hpp
index 99e4d38..7cc5751 100644
--- a/src/KsTraceViewer.hpp
+++ b/src/KsTraceViewer.hpp
@@ -79,10 +79,6 @@ public:
 
 	void setTopRow(size_t r);
 
-	void resizeEvent(QResizeEvent* event) override;
-
-	void keyReleaseEvent(QKeyEvent *event);
-
 	void markSwitch();
 
 	void showRow(size_t r, bool mark);
@@ -101,6 +97,11 @@ public:
 		_model.loadColors();
 	}
 
+protected:
+	void resizeEvent(QResizeEvent* event) override;
+
+	void keyReleaseEvent(QKeyEvent *event) override;
+
 signals:
 	/** Signal emitted when new row is selected. */
 	void select(size_t);
diff --git a/src/KsWidgetsLib.hpp b/src/KsWidgetsLib.hpp
index cc2dc99..e21441d 100644
--- a/src/KsWidgetsLib.hpp
+++ b/src/KsWidgetsLib.hpp
@@ -261,20 +261,21 @@ public:
 	 */
 	int sd() const {return _sd;}
 
+	/** The user provided an input. The widget has been modified. */
+	bool _userInput;
+
+protected:
 	/**
 	 * Reimplemented event handler used to update the geometry of the widget on
 	 * resize events.
 	 */
-	void resizeEvent(QResizeEvent* event)
+	void resizeEvent(QResizeEvent* event) override
 	{
 		KsUtils::setElidedText(&_streamLabel, _streamName,
 				       Qt::ElideLeft, width());
 		QApplication::processEvents();
 	}
 
-	/** The user provided an input. The widget has been modified. */
-	bool _userInput;
-
 protected:
 	QToolBar _tb;
 
-- 
2.43.0

