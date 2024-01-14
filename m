Received: from smtpout2.mo529.mail-out.ovh.net (smtpout2.mo529.mail-out.ovh.net [79.137.123.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFDDD285
	for <linux-trace-devel@vger.kernel.org>; Sun, 14 Jan 2024 17:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.109.139.23])
	by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 59E50203BF;
	Sun, 14 Jan 2024 17:17:35 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.108) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 14 Jan
 2024 18:17:34 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-108S002eddd2468-b321-42cd-84c3-5498fb8e2498,
                    5BE38D5D59959AD767059B58A5CDE138DFC9D9F8) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH 04/34] kernelshark: Do not create a temporary container for looping over QMap
Date: Sun, 14 Jan 2024 18:16:53 +0100
Message-ID: <20240114171723.14092-5-dev@benjarobin.fr>
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
X-Ovh-Tracer-GUID: 79955601-d5b6-420a-b170-69061dd169e5
X-Ovh-Tracer-Id: 1670553986790285210
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrvdeiledgleelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpeeuvghnjhgrmhhinhcutffquefkpfcuoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqeenucggtffrrghtthgvrhhnpedtheetffeikedvjeegudelheelkeehheekgffgheehtdevjeffjedvgedtvefhjeenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtkedpledvrdduiedurdduvdeirdegnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeouggvvhessggvnhhjrghrohgsihhnrdhfrheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohephidrkhgrrhgrugiisehgmhgrihhlrdgtohhmpdhlihhnuhigqdhtrhgrtggvqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehvdelpdhmohguvgepshhmthhpohhuth

Use const_iterator instead. Fix container-anti-pattern Clazy warning

Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
---
 src/KsAdvFilteringDialog.cpp | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/KsAdvFilteringDialog.cpp b/src/KsAdvFilteringDialog.cpp
index 4683c3d..247f912 100644
--- a/src/KsAdvFilteringDialog.cpp
+++ b/src/KsAdvFilteringDialog.cpp
@@ -276,8 +276,8 @@ void KsAdvFilteringDialog::_makeFilterTable()
 	headers << "Delete" << "Stream" << "Event" << " Id" << "Filter";
 	_table->init(headers, _filters.count());
 
-	for(auto f : _filters.keys()) {
-		QStringList thisFilter = _filters.value(f).split(":");
+	for (auto it = _filters.cbegin(), end = _filters.cend(); it != end; ++it) {
+		QStringList thisFilter = it.value().split(":");
 
 		i1 = new QTableWidgetItem(thisFilter[0]);
 		_table->setItem(count, 1, i1);
@@ -285,7 +285,7 @@ void KsAdvFilteringDialog::_makeFilterTable()
 		i1 = new QTableWidgetItem(thisFilter[1]);
 		_table->setItem(count, 2, i1);
 
-		i2 = new QTableWidgetItem(tr("%1").arg(f));
+		i2 = new QTableWidgetItem(tr("%1").arg(it.key()));
 		_table->setItem(count, 3, i2);
 
 		i3 = new QTableWidgetItem(thisFilter[2]);
-- 
2.43.0

