Received: from 1.mo552.mail-out.ovh.net (1.mo552.mail-out.ovh.net [178.32.96.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8C3569F
	for <linux-trace-devel@vger.kernel.org>; Sun, 14 Jan 2024 17:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.109.148.134])
	by mo552.mail-out.ovh.net (Postfix) with ESMTPS id 9E72A2A2C7;
	Sun, 14 Jan 2024 17:17:43 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.108) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 14 Jan
 2024 18:17:42 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-108S0029777e80d-5933-4f5a-81d7-e21dccda07ec,
                    5BE38D5D59959AD767059B58A5CDE138DFC9D9F8) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH 26/34] kernelshark: Remove unused KsDataWidget::wipPtr() and broken function
Date: Sun, 14 Jan 2024 18:17:15 +0100
Message-ID: <20240114171723.14092-27-dev@benjarobin.fr>
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
X-Ovh-Tracer-GUID: 76901da4-5465-4722-9698-6f6a9940dd57
X-Ovh-Tracer-Id: 1672805787614470042
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrvdeiledgleelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpeeuvghnjhgrmhhinhcutffquefkpfcuoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqeenucggtffrrghtthgvrhhnpedtheetffeikedvjeegudelheelkeehheekgffgheehtdevjeffjedvgedtvefhjeenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtkedpledvrdduiedurdduvdeirdegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeouggvvhessggvnhhjrghrohgsihhnrdhfrheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohephidrkhgrrhgrugiisehgmhgrihhlrdgtohhmpdhlihhnuhigqdhtrhgrtggvqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehhedvpdhmohguvgepshhmthhpohhuth

Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
---
 src/KsWidgetsLib.hpp | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/src/KsWidgetsLib.hpp b/src/KsWidgetsLib.hpp
index e21441d..48108cd 100644
--- a/src/KsWidgetsLib.hpp
+++ b/src/KsWidgetsLib.hpp
@@ -123,12 +123,6 @@ public:
 	explicit KsDataWidget(QWidget *parent = nullptr)
 	: QWidget(parent), _workInProgress(nullptr) {}
 
-	/** Set a pointer to the KsWorkInProgress widget. */
-	const KsWorkInProgress *wipPtr(KsWorkInProgress *wip) const
-	{
-		return _workInProgress;
-	}
-
 	/** Set the pointer to the KsWorkInProgress widget. */
 	void setWipPtr(KsWorkInProgress *wip)
 	{
-- 
2.43.0

