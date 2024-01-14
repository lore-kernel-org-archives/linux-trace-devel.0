Received: from smtpout3.mo529.mail-out.ovh.net (smtpout3.mo529.mail-out.ovh.net [46.105.54.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F1B53B9
	for <linux-trace-devel@vger.kernel.org>; Sun, 14 Jan 2024 17:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.109.139.82])
	by mo529.mail-out.ovh.net (Postfix) with ESMTPS id B454C20450;
	Sun, 14 Jan 2024 17:17:38 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.108) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 14 Jan
 2024 18:17:37 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-108S002bb2574f8-0b79-40a2-abbc-44a3059400e9,
                    5BE38D5D59959AD767059B58A5CDE138DFC9D9F8) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH 12/34] kernelshark: Fix potential access to uninitialized variable
Date: Sun, 14 Jan 2024 18:17:01 +0100
Message-ID: <20240114171723.14092-13-dev@benjarobin.fr>
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
X-Ovh-Tracer-GUID: d4e2a2e5-4f28-4d3a-9251-3817a9953219
X-Ovh-Tracer-Id: 1671398413905649562
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrvdeiledgleelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpeeuvghnjhgrmhhinhcutffquefkpfcuoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqeenucggtffrrghtthgvrhhnpedtheetffeikedvjeegudelheelkeehheekgffgheehtdevjeffjedvgedtvefhjeenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtkedpledvrdduiedurdduvdeirdegnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeouggvvhessggvnhhjrghrohgsihhnrdhfrheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohephidrkhgrrhgrugiisehgmhgrihhlrdgtohhmpdhlihhnuhigqdhtrhgrtggvqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehvdelpdhmohguvgepshhmthhpohhuth

If "nStreams" is zero, jstream may be accessed while uninitialized
in KsSession::_savePlots() and in KsSession::_getPlots()

Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
---
 src/KsSession.cpp | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/KsSession.cpp b/src/KsSession.cpp
index b9edb3a..af86281 100644
--- a/src/KsSession.cpp
+++ b/src/KsSession.cpp
@@ -348,7 +348,7 @@ void KsSession::loadGraphs(kshark_context *kshark_ctx,
 void KsSession::_savePlots(int sd, KsGLWidget *glw, bool cpu)
 {
 	kshark_config_doc *streamsConf = kshark_config_alloc(KS_CONFIG_JSON);
-	json_object *jallStreams, *jstream, *jstreamId, *jplots;
+	json_object *jallStreams, *jstream = nullptr, *jstreamId, *jplots;
 	QVector<int> plotIds;
 	int nStreams;
 
@@ -438,7 +438,7 @@ void KsSession::_saveComboPlots(KsGLWidget *glw)
 QVector<int> KsSession::_getPlots(int sd, bool cpu)
 {
 	kshark_config_doc *streamsConf = kshark_config_alloc(KS_CONFIG_JSON);
-	json_object *jallStreams, *jstream, *jstreamId, *jplots;
+	json_object *jallStreams, *jstream = nullptr, *jstreamId, *jplots;
 	int nStreams, nPlots, id;
 	const char *plotKey;
 	QVector<int> plots;
-- 
2.43.0

