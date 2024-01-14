Received: from 8.mo552.mail-out.ovh.net (8.mo552.mail-out.ovh.net [46.105.37.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2864A538D
	for <linux-trace-devel@vger.kernel.org>; Sun, 14 Jan 2024 17:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.109.148.134])
	by mo552.mail-out.ovh.net (Postfix) with ESMTPS id 5A5662A28F;
	Sun, 14 Jan 2024 17:17:44 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.108) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 14 Jan
 2024 18:17:43 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-108S0021a475f12-1f84-4e08-b09a-60b3543db6a7,
                    5BE38D5D59959AD767059B58A5CDE138DFC9D9F8) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH 28/34] kernelshark: Fixed loop counter incremented suspiciously twice
Date: Sun, 14 Jan 2024 18:17:17 +0100
Message-ID: <20240114171723.14092-29-dev@benjarobin.fr>
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
X-Ovh-Tracer-GUID: f0d5b978-e5a6-44b8-86b5-bfd440253f01
X-Ovh-Tracer-Id: 1673087264126492570
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrvdeiledgleelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpeeuvghnjhgrmhhinhcutffquefkpfcuoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqeenucggtffrrghtthgvrhhnpedtheetffeikedvjeegudelheelkeehheekgffgheehtdevjeffjedvgedtvefhjeenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtkedpledvrdduiedurdduvdeirdegnecuvehluhhsthgvrhfuihiivgepuddunecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqedpnhgspghrtghpthhtohepuddprhgtphhtthhopeihrdhkrghrrgguiiesghhmrghilhdrtghomhdplhhinhhugidqthhrrggtvgdquggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheehvddpmhhouggvpehsmhhtphhouhht

Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
---
 examples/datafilter.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/examples/datafilter.c b/examples/datafilter.c
index 38afab8..8e86d9c 100644
--- a/examples/datafilter.c
+++ b/examples/datafilter.c
@@ -69,7 +69,6 @@ int main(int argc, char **argv)
 
 	/* Print to the screen the first 10 visible entries. */
 	count = 0;
-	i = 0;
 	for (i = 0; i < n_rows; ++i) {
 		if (data[i]->visible & KS_TEXT_VIEW_FILTER_MASK) {
 			entry_str = kshark_dump_entry(data[i]);
@@ -79,8 +78,6 @@ int main(int argc, char **argv)
 			if (++count > 10)
 				break;
 		}
-
-		++i;
 	}
 
 	puts("\n\n");
@@ -102,7 +99,6 @@ int main(int argc, char **argv)
 
 	/* Print to the screen the first 10 visible entries. */
 	count = 0;
-	i = 0;
 	for (i = 0; i < n_rows; ++i) {
 		if (data[i]->visible & KS_TEXT_VIEW_FILTER_MASK) {
 			entry_str = kshark_dump_entry(data[i]);
@@ -112,8 +108,6 @@ int main(int argc, char **argv)
 			if (++count > 10)
 				break;
 		}
-
-		++i;
 	}
 
 	puts("\n\n");
-- 
2.43.0

