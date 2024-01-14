Received: from smtpout1.mo529.mail-out.ovh.net (smtpout1.mo529.mail-out.ovh.net [178.32.125.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E276B5399
	for <linux-trace-devel@vger.kernel.org>; Sun, 14 Jan 2024 17:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.108.17.201])
	by mo529.mail-out.ovh.net (Postfix) with ESMTPS id ABFAA2046A;
	Sun, 14 Jan 2024 17:17:41 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.108) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 14 Jan
 2024 18:17:41 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-108S002837e4b56-ac09-456f-b2c1-556e405f59c3,
                    5BE38D5D59959AD767059B58A5CDE138DFC9D9F8) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH 21/34] kernelshark: Fix potential access to uninitialized variable
Date: Sun, 14 Jan 2024 18:17:10 +0100
Message-ID: <20240114171723.14092-22-dev@benjarobin.fr>
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
X-Ovh-Tracer-GUID: dca7f67a-ab4a-4778-a3c3-b6b56b09d07b
X-Ovh-Tracer-Id: 1672242840919105434
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrvdeiledgleelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpeeuvghnjhgrmhhinhcutffquefkpfcuoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqeenucggtffrrghtthgvrhhnpedtheetffeikedvjeegudelheelkeehheekgffgheehtdevjeffjedvgedtvefhjeenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtkedpledvrdduiedurdduvdeirdegnecuvehluhhsthgvrhfuihiivgepfeefnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqedpnhgspghrtghpthhtohepuddprhgtphhtthhopeihrdhkrghrrgguiiesghhmrghilhdrtghomhdplhhinhhugidqthhrrggtvgdquggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhohedvledpmhhouggvpehsmhhtphhouhht

Always call json_object_put() with a valid "jlist" pointer.

Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
---
 src/libkshark-configio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/libkshark-configio.c b/src/libkshark-configio.c
index 853e056..49f957b 100644
--- a/src/libkshark-configio.c
+++ b/src/libkshark-configio.c
@@ -777,7 +777,7 @@ static bool kshark_plugin_from_json(struct kshark_context *kshark_ctx,
 static bool kshark_all_plugins_from_json(struct kshark_context *kshark_ctx,
 					 struct json_object *jobj)
 {
-	struct json_object *jlist, *jfile;
+	struct json_object *jlist = NULL, *jfile = NULL;
 	int i, n_plugins;
 
 	if (!kshark_ctx || !jobj)
@@ -902,7 +902,7 @@ static bool kshark_stream_plugins_from_json(struct kshark_context *kshark_ctx,
 	int i, n_plugins;
 	bool active;
 
-	jplg = jname = jstatus = NULL;
+	jlist = jplg = jname = jstatus = NULL;
 
 	if (!kshark_ctx || !stream || !jobj)
 		return false;
-- 
2.43.0

