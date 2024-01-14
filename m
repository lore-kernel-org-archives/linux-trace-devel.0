Received: from smtpout3.mo529.mail-out.ovh.net (smtpout3.mo529.mail-out.ovh.net [46.105.54.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EE55397
	for <linux-trace-devel@vger.kernel.org>; Sun, 14 Jan 2024 17:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.109.139.82])
	by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 0CBE12044A;
	Sun, 14 Jan 2024 17:17:39 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.108) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 14 Jan
 2024 18:17:38 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-108S002f08b9de7-4b0e-4fe2-bdab-99c9f525f6bb,
                    5BE38D5D59959AD767059B58A5CDE138DFC9D9F8) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH 13/34] kernelshark: Remove unused locals variables
Date: Sun, 14 Jan 2024 18:17:02 +0100
Message-ID: <20240114171723.14092-14-dev@benjarobin.fr>
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
X-Ovh-Tracer-GUID: d51ea551-61f6-495f-aebf-96cc3ef9f2d0
X-Ovh-Tracer-Id: 1671398411719171994
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrvdeiledgleelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpeeuvghnjhgrmhhinhcutffquefkpfcuoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqeenucggtffrrghtthgvrhhnpedtheetffeikedvjeegudelheelkeehheekgffgheehtdevjeffjedvgedtvefhjeenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtkedpledvrdduiedurdduvdeirdegnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeouggvvhessggvnhhjrghrohgsihhnrdhfrheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohephidrkhgrrhgrugiisehgmhgrihhlrdgtohhmpdhlihhnuhigqdhtrhgrtggvqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehvdelpdhmohguvgepshhmthhpohhuth

Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
---
 src/KsTraceGraph.cpp           | 1 -
 src/KsUtils.cpp                | 1 -
 src/plugins/KVMComboDialog.cpp | 1 -
 3 files changed, 3 deletions(-)

diff --git a/src/KsTraceGraph.cpp b/src/KsTraceGraph.cpp
index f80477d..bc910c8 100644
--- a/src/KsTraceGraph.cpp
+++ b/src/KsTraceGraph.cpp
@@ -331,7 +331,6 @@ void KsTraceGraph::_setPointerInfo(size_t i)
 	QString aux(lanMakeString(kshark_get_aux_info(e)));
 	QString info(lanMakeString(kshark_get_info(e)));
 	QString comm(lanMakeString(kshark_get_task(e)));
-	QString elidedText;
 	int labelWidth;
 	uint64_t sec, usec;
 	char *pointer;
diff --git a/src/KsUtils.cpp b/src/KsUtils.cpp
index b84add4..fc1fc52 100644
--- a/src/KsUtils.cpp
+++ b/src/KsUtils.cpp
@@ -1414,7 +1414,6 @@ void KsPluginManager::updatePlugins(int sd, QVector<int> pluginStates)
 	kshark_context *kshark_ctx(nullptr);
 	kshark_data_stream *stream;
 	kshark_dpi_list *plugin;
-	QVector<int> vec;
 	int i(0);
 
 	if (!kshark_instance(&kshark_ctx))
diff --git a/src/plugins/KVMComboDialog.cpp b/src/plugins/KVMComboDialog.cpp
index 6be68d4..99113ed 100644
--- a/src/plugins/KVMComboDialog.cpp
+++ b/src/plugins/KVMComboDialog.cpp
@@ -342,7 +342,6 @@ void KsComboPlotDialog::_guestStreamChanged(int)
 		return;
 
 	int newGuestId = _guestStreamComboBox.currentData().toInt();
-	QVector<int> vcpuCBs(_guestMapCount, 0);
 
 	_plotMap[_currentGuestStream] = _streamCombos(_currentGuestStream);
 
-- 
2.43.0

