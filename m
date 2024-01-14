Received: from smtpout3.mo529.mail-out.ovh.net (smtpout3.mo529.mail-out.ovh.net [46.105.54.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236E55392
	for <linux-trace-devel@vger.kernel.org>; Sun, 14 Jan 2024 17:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.109.139.23])
	by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 25DE520449;
	Sun, 14 Jan 2024 17:17:36 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.108) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 14 Jan
 2024 18:17:35 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-108S002fad01e1e-dd38-4906-af60-197e77d5f9e1,
                    5BE38D5D59959AD767059B58A5CDE138DFC9D9F8) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH 06/34] kernelshark: Fix used after free of QByteArray raw data
Date: Sun, 14 Jan 2024 18:16:55 +0100
Message-ID: <20240114171723.14092-7-dev@benjarobin.fr>
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
X-Ovh-Tracer-GUID: 75ffd58e-003d-4993-bc2d-e87c00d3aab1
X-Ovh-Tracer-Id: 1670553987669778330
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrvdeiledgleelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpeeuvghnjhgrmhhinhcutffquefkpfcuoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqeenucggtffrrghtthgvrhhnpedtheetffeikedvjeegudelheelkeehheekgffgheehtdevjeffjedvgedtvefhjeenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtkedpledvrdduiedurdduvdeirdegnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeouggvvhessggvnhhjrghrohgsihhnrdhfrheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohephidrkhgrrhgrugiisehgmhgrihhlrdgtohhmpdhlihhnuhigqdhtrhgrtggvqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehvdelpdhmohguvgepshhmthhpohhuth

In KsAdvFilteringDialog::_applyPress(), QByteArray raw data, obtained
from _filterEdit, is accessed after being freed.
Also prevent any unnecessary copy.

Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
---
 src/KsAdvFilteringDialog.cpp | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/src/KsAdvFilteringDialog.cpp b/src/KsAdvFilteringDialog.cpp
index 247f912..c0d6d48 100644
--- a/src/KsAdvFilteringDialog.cpp
+++ b/src/KsAdvFilteringDialog.cpp
@@ -443,8 +443,6 @@ void KsAdvFilteringDialog::_applyPress()
 	QMapIterator<int, QString> f(_filters);
 	kshark_context *kshark_ctx(NULL);
 	kshark_data_stream *stream;
-	const char *text;
-	char *filter;
 	int i(0);
 
 	if (!kshark_instance(&kshark_ctx))
@@ -476,18 +474,12 @@ void KsAdvFilteringDialog::_applyPress()
 		emit dataReload();
 	};
 
-	text = _filterEdit.text().toLocal8Bit().data();
-	if (strlen(text) == 0) {
+	QByteArray filter = _filterEdit.text().toLocal8Bit();
+	if (filter.isEmpty()) {
 		job_done();
 		return;
 	}
 
-	filter = (char*) malloc(strlen(text) + 1);
-	strcpy(filter, text);
-
-	kshark_tep_add_filter_str(stream, filter);
-
-	free(filter);
-
+	kshark_tep_add_filter_str(stream, filter.constData());
 	job_done();
 }
-- 
2.43.0

