Received: from smtpout1.mo529.mail-out.ovh.net (smtpout1.mo529.mail-out.ovh.net [178.32.125.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271915398
	for <linux-trace-devel@vger.kernel.org>; Sun, 14 Jan 2024 17:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.108.17.201])
	by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 9DBE72045C;
	Sun, 14 Jan 2024 17:17:40 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.108) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 14 Jan
 2024 18:17:39 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-108S0025dfc7a5d-5fa9-4e20-9766-f0dcaa465842,
                    5BE38D5D59959AD767059B58A5CDE138DFC9D9F8) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH 18/34] kernelshark: Fix detaching-temporary Clazy warning
Date: Sun, 14 Jan 2024 18:17:07 +0100
Message-ID: <20240114171723.14092-19-dev@benjarobin.fr>
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
X-Ovh-Tracer-GUID: eb165f13-b5c8-478d-a617-f559a82a66ad
X-Ovh-Tracer-Id: 1671961365748146074
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrvdeiledgleelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpeeuvghnjhgrmhhinhcutffquefkpfcuoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqeenucggtffrrghtthgvrhhnpeelheegledvvdelheduvdegfeeftdeuvdefveffgedvtdevtdfgieffueektdelgeenucffohhmrghinhephhgvrgguvghrrdgrthenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtkedpledvrdduiedurdduvdeirdegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeouggvvhessggvnhhjrghrohgsihhnrdhfrheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohephidrkhgrrhgrugiisehgmhgrihhlrdgtohhmpdhlihhnuhigqdhtrhgrtggvqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehvdelpdhmohguvgepshhmthhpohhuth

Use QList::at() instead of QList::operator[]()

Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
---
 src/KsTraceViewer.cpp | 4 ++--
 src/KsUtils.hpp       | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/KsTraceViewer.cpp b/src/KsTraceViewer.cpp
index 5e8e63f..86e9185 100644
--- a/src/KsTraceViewer.cpp
+++ b/src/KsTraceViewer.cpp
@@ -624,11 +624,11 @@ void KsTraceViewer::_resizeToContents()
 	 * column by hand.
 	 */
 	col = KsViewModel::TRACE_VIEW_COL_STREAM;
-	columnSize = STRING_WIDTH(_model.header()[col]) + FONT_WIDTH;
+	columnSize = STRING_WIDTH(_model.header().at(col)) + FONT_WIDTH;
 	_view.setColumnWidth(col, columnSize);
 
 	col = KsViewModel::TRACE_VIEW_COL_CPU;
-	columnSize = STRING_WIDTH(_model.header()[col]) + FONT_WIDTH * 2;
+	columnSize = STRING_WIDTH(_model.header().at(col)) + FONT_WIDTH * 2;
 	_view.setColumnWidth(col, columnSize);
 
 	col = KsViewModel::TRACE_VIEW_COL_INDEX;
diff --git a/src/KsUtils.hpp b/src/KsUtils.hpp
index 85f81c3..67af99a 100644
--- a/src/KsUtils.hpp
+++ b/src/KsUtils.hpp
@@ -25,10 +25,10 @@
 #include "KsPlotTools.hpp"
 
 /** Macro providing the height of the screen in pixels. */
-#define SCREEN_HEIGHT  QGuiApplication::screens()[0]->geometry().height()
+#define SCREEN_HEIGHT  QGuiApplication::screens().at(0)->geometry().height()
 
 /** Macro providing the width of the screen in pixels. */
-#define SCREEN_WIDTH   QGuiApplication::screens()[0]->geometry().width()
+#define SCREEN_WIDTH   QGuiApplication::screens().at(0)->geometry().width()
 
 //! @cond Doxygen_Suppress
 
-- 
2.43.0

