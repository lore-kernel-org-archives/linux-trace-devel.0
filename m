Received: from smtpout3.mo529.mail-out.ovh.net (smtpout3.mo529.mail-out.ovh.net [46.105.54.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C48053AE
	for <linux-trace-devel@vger.kernel.org>; Sun, 14 Jan 2024 17:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.109.139.82])
	by mo529.mail-out.ovh.net (Postfix) with ESMTPS id E11D32044F;
	Sun, 14 Jan 2024 17:17:37 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.108) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 14 Jan
 2024 18:17:36 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-108S0026e5b45bc-153e-4188-b817-4ca8d7bbb4b9,
                    5BE38D5D59959AD767059B58A5CDE138DFC9D9F8) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH 10/34] kernelshark: Use sliced() or first() instead of mid/right/left()
Date: Sun, 14 Jan 2024 18:16:59 +0100
Message-ID: <20240114171723.14092-11-dev@benjarobin.fr>
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
X-Ovh-Tracer-GUID: a6f81f6c-764c-4e66-b7c7-0ce3aa4796e6
X-Ovh-Tracer-Id: 1671116940802482074
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrvdeiledgleelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpeeuvghnjhgrmhhinhcutffquefkpfcuoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqeenucggtffrrghtthgvrhhnpedtheetffeikedvjeegudelheelkeehheekgffgheehtdevjeffjedvgedtvefhjeenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtkedpledvrdduiedurdduvdeirdegnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeouggvvhessggvnhhjrghrohgsihhnrdhfrheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohephidrkhgrrhgrugiisehgmhgrihhlrdgtohhmpdhlihhnuhigqdhtrhgrtggvqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehvdelpdhmohguvgepshhmthhpohhuth

Fix Clazy warning and it is faster.

Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
---
 src/KsMainWindow.cpp | 2 +-
 src/KsUtils.cpp      | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/KsMainWindow.cpp b/src/KsMainWindow.cpp
index 68853d6..72ad371 100644
--- a/src/KsMainWindow.cpp
+++ b/src/KsMainWindow.cpp
@@ -1275,7 +1275,7 @@ void KsMainWindow::_load(const QString& fileName, bool append)
 		pbLabel += fileName;
 	} else {
 		pbLabel += "...";
-		pbLabel += fileName.mid(fileName.size() - 37, 37);
+		pbLabel += fileName.sliced(fileName.size() - 37);
 	}
 
 	setWindowTitle("Kernel Shark");
diff --git a/src/KsUtils.cpp b/src/KsUtils.cpp
index a68e4c1..b84add4 100644
--- a/src/KsUtils.cpp
+++ b/src/KsUtils.cpp
@@ -534,8 +534,8 @@ QVector<int> parseIdList(QString v_str)
 		int i = item.indexOf('-');
 		if (i > 0) {
 			/* This item is an interval. */
-			int to = item.right(item.size() - i - 1).toInt();
-			int from = item.left(i).toInt();
+			int to = item.sliced(i + 1).toInt();
+			int from = item.first(i).toInt();
 			int s = v.size();
 
 			v.resize(s + to - from + 1);
-- 
2.43.0

