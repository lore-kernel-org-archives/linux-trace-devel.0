Received: from smtpout3.mo529.mail-out.ovh.net (smtpout3.mo529.mail-out.ovh.net [46.105.54.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F78538B
	for <linux-trace-devel@vger.kernel.org>; Sun, 14 Jan 2024 17:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.109.139.23])
	by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 9AA9620448;
	Sun, 14 Jan 2024 17:17:34 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.108) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 14 Jan
 2024 18:17:33 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-108S0027eac622a-0ad5-41b9-892e-b1c5eebe442a,
                    5BE38D5D59959AD767059B58A5CDE138DFC9D9F8) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH 02/34] kernelshark: Add .gitignore
Date: Sun, 14 Jan 2024 18:16:51 +0100
Message-ID: <20240114171723.14092-3-dev@benjarobin.fr>
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
X-Ovh-Tracer-GUID: 0eadc427-a6fc-4787-a112-6b7a28eadd8a
X-Ovh-Tracer-Id: 1670272512414932890
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrvdeiledgleelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpeeuvghnjhgrmhhinhcutffquefkpfcuoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqeenucggtffrrghtthgvrhhnpedtheetffeikedvjeegudelheelkeehheekgffgheehtdevjeffjedvgedtvefhjeenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtkedpledvrdduiedurdduvdeirdegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeouggvvhessggvnhhjrghrohgsihhnrdhfrheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohephidrkhgrrhgrugiisehgmhgrihhlrdgtohhmpdhlihhnuhigqdhtrhgrtggvqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehvdelpdhmohguvgepshhmthhpohhuth

Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
---
 .gitignore | 15 +++++++++++++++
 1 file changed, 15 insertions(+)
 create mode 100644 .gitignore

diff --git a/.gitignore b/.gitignore
new file mode 100644
index 0000000..87a23cc
--- /dev/null
+++ b/.gitignore
@@ -0,0 +1,15 @@
+
+# Ignore everything in bin directory except kshark-su-record
+/bin/*
+!/bin/kshark-su-record
+
+# Ignore generated files
+CMakeLists.txt.user
+/libkshark.pc
+/org.freedesktop.kshark-record.policy
+/kernelshark.desktop
+/src/KsCmakeDef.hpp
+/lib/*
+/tests/*.so
+/tests/kshark-tests
+/tests/kshark-gui-tests
-- 
2.43.0

