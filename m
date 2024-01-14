Received: from 7.mo552.mail-out.ovh.net (7.mo552.mail-out.ovh.net [188.165.59.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE9E5399
	for <linux-trace-devel@vger.kernel.org>; Sun, 14 Jan 2024 17:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.108.9.223])
	by mo552.mail-out.ovh.net (Postfix) with ESMTPS id BFC3D2A3ED;
	Sun, 14 Jan 2024 17:17:46 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.108) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 14 Jan
 2024 18:17:46 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-108S0028589d1dd-f8d6-4613-b168-6c9e635a8b78,
                    5BE38D5D59959AD767059B58A5CDE138DFC9D9F8) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH 34/34] kernelshark: Cleanup of KsDualMarker methods
Date: Sun, 14 Jan 2024 18:17:23 +0100
Message-ID: <20240114171723.14092-35-dev@benjarobin.fr>
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
X-Ovh-Tracer-GUID: c5b92a38-7de5-4c3f-abb9-609ca25be3b4
X-Ovh-Tracer-Id: 1673650213980495770
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrvdeiledgleelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpeeuvghnjhgrmhhinhcutffquefkpfcuoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqeenucggtffrrghtthgvrhhnpedtheetffeikedvjeegudelheelkeehheekgffgheehtdevjeffjedvgedtvefhjeenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtkedpledvrdduiedurdduvdeirdegnecuvehluhhsthgvrhfuihiivgepuddunecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqedpnhgspghrtghpthhtohepuddprhgtphhtthhopeihrdhkrghrrgguiiesghhmrghilhdrtghomhdplhhinhhugidqthhrrggtvgdquggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheehvddpmhhouggvpehsmhhtphhouhht

Remove stateAPtr and stateBPtr methods since no longer needed

Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
---
 src/KsDualMarker.hpp | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/src/KsDualMarker.hpp b/src/KsDualMarker.hpp
index 73c3960..e81d721 100644
--- a/src/KsDualMarker.hpp
+++ b/src/KsDualMarker.hpp
@@ -144,22 +144,16 @@ public:
 	/** Get the marker B. */
 	KsGraphMark &markerB() {return _markB;}
 
-	/** Get a pointer to the State A object. */
-	QState *stateAPtr() {return _stateA;}
-
-	/** Get a pointer to the State B object. */
-	QState *stateBPtr() {return _stateB;}
-
 	void updateMarkers(const KsDataStore &data,
 			   KsGLWidget *glw);
 
 	void updateLabels();
 
 	/** Get the index inside the data array marker A points to. */
-	ssize_t markerAPos() {return markerA()._isSet ? markerA()._pos : -1;}
+	ssize_t markerAPos() {return _markA._isSet ? _markA._pos : -1;}
 
 	/** Get the index inside the data array marker B points to. */
-	ssize_t markerBPos() {return markerB()._isSet ? markerB()._pos : -1;}
+	ssize_t markerBPos() {return _markB._isSet ? _markB._pos : -1;}
 
 signals:
 	/**
-- 
2.43.0

