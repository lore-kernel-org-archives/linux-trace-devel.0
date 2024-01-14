Received: from 9.mo552.mail-out.ovh.net (9.mo552.mail-out.ovh.net [87.98.180.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683976118
	for <linux-trace-devel@vger.kernel.org>; Sun, 14 Jan 2024 17:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.109.148.134])
	by mo552.mail-out.ovh.net (Postfix) with ESMTPS id 11FE32A37F;
	Sun, 14 Jan 2024 17:17:44 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.108) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 14 Jan
 2024 18:17:43 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-108S0020a5cec83-aaa0-401f-88de-4fd84d4570e9,
                    5BE38D5D59959AD767059B58A5CDE138DFC9D9F8) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH 27/34] kernelshark: In KsTimeOffsetDialog() constructor use parent param
Date: Sun, 14 Jan 2024 18:17:16 +0100
Message-ID: <20240114171723.14092-28-dev@benjarobin.fr>
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
X-Ovh-Tracer-GUID: a16aae19-592c-45b2-801b-feb74746cf3f
X-Ovh-Tracer-Id: 1672805790629322650
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrvdeiledgleelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpeeuvghnjhgrmhhinhcutffquefkpfcuoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqeenucggtffrrghtthgvrhhnpedtheetffeikedvjeegudelheelkeehheekgffgheehtdevjeffjedvgedtvefhjeenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtkedpledvrdduiedurdduvdeirdegnecuvehluhhsthgvrhfuihiivgepuddunecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqedpnhgspghrtghpthhtohepuddprhgtphhtthhopeihrdhkrghrrgguiiesghhmrghilhdrtghomhdplhhinhhugidqthhrrggtvgdquggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheehvddpmhhouggvpehsmhhtphhouhht

Pass parent parameter to QDialog() constructor

Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
---
 src/KsWidgetsLib.cpp | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/KsWidgetsLib.cpp b/src/KsWidgetsLib.cpp
index 3ad93fa..5191c9f 100644
--- a/src/KsWidgetsLib.cpp
+++ b/src/KsWidgetsLib.cpp
@@ -209,7 +209,7 @@ bool fileExistsDialog(QString fileName)
 }
 
 /** Create KsTimeOffsetDialog. */
-KsTimeOffsetDialog::KsTimeOffsetDialog(QWidget *parent)
+KsTimeOffsetDialog::KsTimeOffsetDialog(QWidget *parent) : QDialog(parent)
 {
 	kshark_context *kshark_ctx(nullptr);
 	QVector<int> streamIds;
-- 
2.43.0

