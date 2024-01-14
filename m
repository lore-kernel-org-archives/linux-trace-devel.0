Received: from 8.mo552.mail-out.ovh.net (8.mo552.mail-out.ovh.net [46.105.37.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45188568C
	for <linux-trace-devel@vger.kernel.org>; Sun, 14 Jan 2024 17:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.108.9.223])
	by mo552.mail-out.ovh.net (Postfix) with ESMTPS id 6BB2A2A39F;
	Sun, 14 Jan 2024 17:17:46 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.108) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 14 Jan
 2024 18:17:45 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-108S00266303df0-95bb-406d-85fd-f132a868acd8,
                    5BE38D5D59959AD767059B58A5CDE138DFC9D9F8) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH 33/34] kernelshark: Allow to reduce a bit more the graph height
Date: Sun, 14 Jan 2024 18:17:22 +0100
Message-ID: <20240114171723.14092-34-dev@benjarobin.fr>
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
X-Ovh-Tracer-GUID: 92cd0f5d-2133-4375-b3b9-2283227f9647
X-Ovh-Tracer-Id: 1673650212025556890
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrvdeiledgleelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpeeuvghnjhgrmhhinhcutffquefkpfcuoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqeenucggtffrrghtthgvrhhnpefhueelfeduleffvedtjeduteeffeevieduueevueetkedugeffteejleegtdduffenucffohhmrghinheptghonhhtvghnthhsmhgrrhhgihhnshdrthhophenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtkedpledvrdduiedurdduvdeirdegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeouggvvhessggvnhhjrghrohgsihhnrdhfrheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohephidrkhgrrhgrugiisehgmhgrihhlrdgtohhmpdhlihhnuhigqdhtrhgrtggvqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehhedvpdhmohguvgepshhmthhpohhuth

With this configuration, at least one core on the graph can be seen
---
 src/KsTraceGraph.cpp | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/KsTraceGraph.cpp b/src/KsTraceGraph.cpp
index bc910c8..4599a12 100644
--- a/src/KsTraceGraph.cpp
+++ b/src/KsTraceGraph.cpp
@@ -593,8 +593,8 @@ void KsTraceGraph::updateGeom()
 	       _layout.contentsMargins().top() +
 	       _layout.contentsMargins().bottom();
 
-	if (hMin > KS_GRAPH_HEIGHT * 8)
-		hMin = KS_GRAPH_HEIGHT * 8;
+	if (hMin > KS_GRAPH_HEIGHT * 6)
+		hMin = KS_GRAPH_HEIGHT * 6;
 
 	setMinimumHeight(hMin);
 
-- 
2.43.0

