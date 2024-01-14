Received: from smtpout3.mo529.mail-out.ovh.net (smtpout3.mo529.mail-out.ovh.net [46.105.54.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237115396
	for <linux-trace-devel@vger.kernel.org>; Sun, 14 Jan 2024 17:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.109.139.23])
	by mo529.mail-out.ovh.net (Postfix) with ESMTPS id C0F2020447;
	Sun, 14 Jan 2024 17:17:35 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.108) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 14 Jan
 2024 18:17:35 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-108S002ae047cc6-7b8d-49dc-83c0-17caf7244724,
                    5BE38D5D59959AD767059B58A5CDE138DFC9D9F8) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH 05/34] kernelshark: Prevent potential detach of QMap container
Date: Sun, 14 Jan 2024 18:16:54 +0100
Message-ID: <20240114171723.14092-6-dev@benjarobin.fr>
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
X-Ovh-Tracer-GUID: a0a5bfa1-caa2-439d-9ba5-123a1cf5b73c
X-Ovh-Tracer-Id: 1670553989434204058
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrvdeiledgleelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpeeuvghnjhgrmhhinhcutffquefkpfcuoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqeenucggtffrrghtthgvrhhnpedtheetffeikedvjeegudelheelkeehheekgffgheehtdevjeffjedvgedtvefhjeenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtkedpledvrdduiedurdduvdeirdegnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeouggvvhessggvnhhjrghrohgsihhnrdhfrheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohephidrkhgrrhgrugiisehgmhgrihhlrdgtohhmpdhlihhnuhigqdhtrhgrtggvqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehvdelpdhmohguvgepshhmthhpohhuth

Use const_iterator instead. Fix range-loop-detach Clazy warning

Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
---
 src/KsGLWidget.cpp             | 5 +++--
 src/plugins/KVMComboDialog.cpp | 6 ++++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/src/KsGLWidget.cpp b/src/KsGLWidget.cpp
index 9e3dac3..0a44e77 100644
--- a/src/KsGLWidget.cpp
+++ b/src/KsGLWidget.cpp
@@ -137,9 +137,10 @@ void KsGLWidget::paintGL()
 	/* Draw the time axis. */
 	_drawAxisX(size);
 
-	for (auto const &stream: _graphs)
-		for (auto const &g: stream)
+	for (auto it = _graphs.cbegin(), end = _graphs.cend(); it != end; ++it) {
+		for (auto const &g: it.value())
 			g->draw(size);
+	}
 
 	for (auto const &s: _shapes) {
 		if (!s)
diff --git a/src/plugins/KVMComboDialog.cpp b/src/plugins/KVMComboDialog.cpp
index 2b95a53..6be68d4 100644
--- a/src/plugins/KVMComboDialog.cpp
+++ b/src/plugins/KVMComboDialog.cpp
@@ -308,13 +308,15 @@ void KsComboPlotDialog::_applyPress()
 	int nPlots(0);
 
 	_plotMap[guestId] = _streamCombos(guestId);
-	for (auto const &stream: _plotMap)
-		for (auto const &combo: stream) {
+
+	for (auto it = _plotMap.cbegin(), end = _plotMap.cend(); it != end; ++it) {
+			for (auto const &combo: it.value()) {
 			allCombosVec.append(2);
 			combo[0] >> allCombosVec;
 			combo[1] >> allCombosVec;
 			++nPlots;
 		}
+	}
 
 	emit apply(nPlots, allCombosVec);
 }
-- 
2.43.0

