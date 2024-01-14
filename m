Received: from smtpout2.mo529.mail-out.ovh.net (smtpout2.mo529.mail-out.ovh.net [79.137.123.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40687D27F
	for <linux-trace-devel@vger.kernel.org>; Sun, 14 Jan 2024 17:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.109.139.23])
	by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 00C9420429;
	Sun, 14 Jan 2024 17:17:35 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.108) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 14 Jan
 2024 18:17:34 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-108S0029477b5af-68f4-428a-8fab-c155652c6e19,
                    5BE38D5D59959AD767059B58A5CDE138DFC9D9F8) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH 03/34] kernelshark: Remove function param when not used, whenever possible
Date: Sun, 14 Jan 2024 18:16:52 +0100
Message-ID: <20240114171723.14092-4-dev@benjarobin.fr>
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
X-Ovh-Tracer-GUID: a25efa11-4697-43e9-94e6-f8c9916dcffb
X-Ovh-Tracer-Id: 1670272512652697498
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrvdeiledgleelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpeeuvghnjhgrmhhinhcutffquefkpfcuoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqeenucggtffrrghtthgvrhhnpedtheetffeikedvjeegudelheelkeehheekgffgheehtdevjeffjedvgedtvefhjeenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtkedpledvrdduiedurdduvdeirdegnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeouggvvhessggvnhhjrghrohgsihhnrdhfrheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohephidrkhgrrhgrugiisehgmhgrihhlrdgtohhmpdhlihhnuhigqdhtrhgrtggvqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehvdelpdhmohguvgepshhmthhpohhuth

Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
---
 src/KsAdvFilteringDialog.cpp | 4 ++--
 src/KsAdvFilteringDialog.hpp | 2 +-
 src/KsMainWindow.cpp         | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/src/KsAdvFilteringDialog.cpp b/src/KsAdvFilteringDialog.cpp
index b934db6..4683c3d 100644
--- a/src/KsAdvFilteringDialog.cpp
+++ b/src/KsAdvFilteringDialog.cpp
@@ -80,7 +80,7 @@ KsAdvFilteringDialog::KsAdvFilteringDialog(QWidget *parent)
 	_getFilters(kshark_ctx);
 
 	if (_filters.count()) {
-		_makeFilterTable(kshark_ctx);
+		_makeFilterTable();
 		lamAddLine();
 	}
 
@@ -264,7 +264,7 @@ void KsAdvFilteringDialog::_getFilters(kshark_context *kshark_ctx)
 	}
 }
 
-void KsAdvFilteringDialog::_makeFilterTable(struct kshark_context *kshark_ctx)
+void KsAdvFilteringDialog::_makeFilterTable()
 {
 	QMapIterator<int, QString> f(_filters);
 	QTableWidgetItem *i1, *i2, *i3;
diff --git a/src/KsAdvFilteringDialog.hpp b/src/KsAdvFilteringDialog.hpp
index a23e8d9..30bbadc 100644
--- a/src/KsAdvFilteringDialog.hpp
+++ b/src/KsAdvFilteringDialog.hpp
@@ -80,7 +80,7 @@ private:
 
 	void _getFilters(kshark_context *kshark_ctx);
 
-	void _makeFilterTable(kshark_context *kshark_ctx);
+	void _makeFilterTable();
 
 	QStringList _getEventFields(int eventId);
 
diff --git a/src/KsMainWindow.cpp b/src/KsMainWindow.cpp
index ef15b20..68853d6 100644
--- a/src/KsMainWindow.cpp
+++ b/src/KsMainWindow.cpp
@@ -1434,12 +1434,12 @@ void KsMainWindow::loadSession(const QString &fileName)
 	_session.loadUserPlugins(kshark_ctx, &_plugins);
 	pb.setValue(20);
 
-	auto lamLoadJob = [&] (KsDataStore *d) {
+	auto lamLoadJob = [&] () {
 		_session.loadDataStreams(kshark_ctx, &_data);
 		loadDone = true;
 	};
 
-	std::thread job = std::thread(lamLoadJob, &_data);
+	std::thread job = std::thread(lamLoadJob);
 
 	for (int i = 0; i < 150; ++i) {
 		/*
-- 
2.43.0

