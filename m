Received: from smtpout2.mo529.mail-out.ovh.net (smtpout2.mo529.mail-out.ovh.net [79.137.123.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4A8D277
	for <linux-trace-devel@vger.kernel.org>; Sun, 14 Jan 2024 17:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.109.139.23])
	by mo529.mail-out.ovh.net (Postfix) with ESMTPS id E7FFE2044E;
	Sun, 14 Jan 2024 17:17:36 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.108) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 14 Jan
 2024 18:17:36 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-108S00258b352b3-a278-4cf8-9d71-13b871bab29f,
                    5BE38D5D59959AD767059B58A5CDE138DFC9D9F8) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH 08/34] kernelshark: Use lambda parameter instead of captured local variable
Date: Sun, 14 Jan 2024 18:16:57 +0100
Message-ID: <20240114171723.14092-9-dev@benjarobin.fr>
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
X-Ovh-Tracer-GUID: 2baba7a7-68e4-4460-ba6b-e0c6881e42fc
X-Ovh-Tracer-Id: 1670835464359665562
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrvdeiledgleelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpeeuvghnjhgrmhhinhcutffquefkpfcuoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqeenucggtffrrghtthgvrhhnpedtheetffeikedvjeegudelheelkeehheekgffgheehtdevjeffjedvgedtvefhjeenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtkedpledvrdduiedurdduvdeirdegnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeouggvvhessggvnhhjrghrohgsihhnrdhfrheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohephidrkhgrrhgrugiisehgmhgrihhlrdgtohhmpdhlihhnuhigqdhtrhgrtggvqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehvdelpdhmohguvgepshhmthhpohhuth

In KsGLWidget::_find(), fix lamFindEntryByCPU() and lamFindEntryByPid()
which had a parameter "b": use it instead of using captured "bin"
local variable.

Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
---
 src/KsGLWidget.cpp | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/KsGLWidget.cpp b/src/KsGLWidget.cpp
index 23485d2..dd9f41a 100644
--- a/src/KsGLWidget.cpp
+++ b/src/KsGLWidget.cpp
@@ -986,15 +986,15 @@ bool KsGLWidget::_find(int bin, int sd, int cpu, int pid,
 		 * The click is over the CPU graphs. First try the exact
 		 * match.
 		 */
-		if (lamGetEntryByCPU(bin))
+		if (lamGetEntryByCPU(b))
 			return true;
 
 		/* Now look for a match, nearby the position of the click. */
 		for (int i = 1; i < variance; ++i) {
-			if (bin + i <= hSize && lamGetEntryByCPU(bin + i))
+			if (b + i <= hSize && lamGetEntryByCPU(b + i))
 				return true;
 
-			if (bin - i >= 0 && lamGetEntryByCPU(bin - i))
+			if (b - i >= 0 && lamGetEntryByCPU(b - i))
 				return true;
 		}
 
@@ -1007,15 +1007,15 @@ bool KsGLWidget::_find(int bin, int sd, int cpu, int pid,
 		 * The click is over the Task graphs. First try the exact
 		 * match.
 		 */
-		if (lamGetEntryByPid(bin))
+		if (lamGetEntryByPid(b))
 			return true;
 
 		/* Now look for a match, nearby the position of the click. */
 		for (int i = 1; i < variance; ++i) {
-			if ((bin + i <= hSize) && lamGetEntryByPid(bin + i))
+			if ((b + i <= hSize) && lamGetEntryByPid(b + i))
 				return true;
 
-			if ((bin - i >= 0) && lamGetEntryByPid(bin - i))
+			if ((b - i >= 0) && lamGetEntryByPid(b - i))
 				return true;
 		}
 
-- 
2.43.0

