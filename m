Received: from smtpout2.mo529.mail-out.ovh.net (smtpout2.mo529.mail-out.ovh.net [79.137.123.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25479D313
	for <linux-trace-devel@vger.kernel.org>; Sun, 14 Jan 2024 17:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.109.139.82])
	by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 4E86220454;
	Sun, 14 Jan 2024 17:17:38 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.108) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 14 Jan
 2024 18:17:37 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-108S002126686b2-6824-4f8d-a664-6e313a433c7a,
                    5BE38D5D59959AD767059B58A5CDE138DFC9D9F8) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH 11/34] kernelshark: Prevent potential divide by zero in Shape::center()
Date: Sun, 14 Jan 2024 18:17:00 +0100
Message-ID: <20240114171723.14092-12-dev@benjarobin.fr>
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
X-Ovh-Tracer-GUID: 70ddaff6-5730-4ae6-a8e5-43873e05f87a
X-Ovh-Tracer-Id: 1671116938216431514
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrvdeiledgleelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpeeuvghnjhgrmhhinhcutffquefkpfcuoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqeenucggtffrrghtthgvrhhnpedtheetffeikedvjeegudelheelkeehheekgffgheehtdevjeffjedvgedtvefhjeenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtkedpledvrdduiedurdduvdeirdegnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeouggvvhessggvnhhjrghrohgsihhnrdhfrheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohephidrkhgrrhgrugiisehgmhgrihhlrdgtohhmpdhlihhnuhigqdhtrhgrtggvqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehvdelpdhmohguvgepshhmthhpohhuth

Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
---
 src/KsPlotTools.cpp | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/src/KsPlotTools.cpp b/src/KsPlotTools.cpp
index 1d63a9b..8011329 100644
--- a/src/KsPlotTools.cpp
+++ b/src/KsPlotTools.cpp
@@ -318,13 +318,15 @@ ksplot_point Shape::center() const
 {
 	ksplot_point c = {0, 0};
 
-	for (size_t i = 0; i < _nPoints; ++i) {
-		c.x += _points[i].x;
-		c.y += _points[i].y;
-	}
+	if (_nPoints > 0) {
+		for (size_t i = 0; i < _nPoints; ++i) {
+			c.x += _points[i].x;
+			c.y += _points[i].y;
+		}
 
-	c.x /= _nPoints;
-	c.y /= _nPoints;
+		c.x /= _nPoints;
+		c.y /= _nPoints;
+	}
 
 	return c;
 }
-- 
2.43.0

