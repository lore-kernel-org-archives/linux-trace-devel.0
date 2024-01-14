Received: from 1.mo552.mail-out.ovh.net (1.mo552.mail-out.ovh.net [178.32.96.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E75539E
	for <linux-trace-devel@vger.kernel.org>; Sun, 14 Jan 2024 17:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.108.9.159])
	by mo552.mail-out.ovh.net (Postfix) with ESMTPS id BC6AE2A3EB;
	Sun, 14 Jan 2024 17:17:44 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.108) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 14 Jan
 2024 18:17:44 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-108S002e9cbf00c-244c-464c-8a1f-571ac5c27b29,
                    5BE38D5D59959AD767059B58A5CDE138DFC9D9F8) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH 29/34] kernelshark: Fix tepdata_dump_entry() for event_id = KS_EVENT_OVERFLOW
Date: Sun, 14 Jan 2024 18:17:18 +0100
Message-ID: <20240114171723.14092-30-dev@benjarobin.fr>
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
X-Ovh-Tracer-GUID: f20dbfc4-150a-496d-89a9-108651be5b92
X-Ovh-Tracer-Id: 1673087265044127642
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrvdeiledgleelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpeeuvghnjhgrmhhinhcutffquefkpfcuoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqeenucggtffrrghtthgvrhhnpedtheetffeikedvjeegudelheelkeehheekgffgheehtdevjeffjedvgedtvefhjeenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtkedpledvrdduiedurdduvdeirdegnecuvehluhhsthgvrhfuihiivgepuddunecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqedpnhgspghrtghpthhtohepuddprhgtphhtthhopeihrdhkrghrrgguiiesghhmrghilhdrtghomhdplhhinhhugidqthhrrggtvgdquggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheehvddpmhhouggvpehsmhhtphhouhht

Generated string was dropped, and did generate a memory leak,
because of the missing break.

Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
---
 src/libkshark-tepdata.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index d15c155..a178de6 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -1047,6 +1047,7 @@ static char *tepdata_dump_entry(struct kshark_data_stream *stream,
 		case KS_EVENT_OVERFLOW:
 			entry_str = tepdata_dump_custom_entry(stream, entry,
 							     missed_events_dump);
+			break;
 		default:
 			return NULL;
 		}
-- 
2.43.0

