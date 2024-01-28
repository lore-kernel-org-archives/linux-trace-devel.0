Received: from smtpout1.mo529.mail-out.ovh.net (smtpout1.mo529.mail-out.ovh.net [178.32.125.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CA226AE8
	for <linux-trace-devel@vger.kernel.org>; Sun, 28 Jan 2024 19:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.32.125.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706468793; cv=none; b=XuDtoaawpLKkMDxMT/fyZfXGxyn7q+5Hmtmq2mo/kZ3hWNz82xrs3lexAS3bOwn5vpa0FpJA9uVHl6iWln5HVuuLIFsK+UNweL7FM+gAx8uUHVyGGiyD1mvSUcXPRsjb0Os7fixvcDszfGNCz62YpDY1UaLsnY+8+j+TBmcNN70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706468793; c=relaxed/simple;
	bh=t5NP3EmwwZztrifTiwz7BgOHBA8M4CwlZ7gW6qIWwQw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Uz5P0NNqqs5J9LaJXDGzWuiDdWbFVGBtWMTDHLzoPI6i9T1QTs04tUZ3A9xmIkGBfo0ULQawdexV36avy5O0R+UHqQFNXdPPWXVy71jQt5Zu2tv7kalN+dT+MyK7TU8Q2kG1kYTNONRaXPJ7jEXB2AURRBWo1gi24fnGB/yLrEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr; spf=pass smtp.mailfrom=benjarobin.fr; arc=none smtp.client-ip=178.32.125.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.108.9.16])
	by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 46AE120498;
	Sun, 28 Jan 2024 19:00:31 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.98) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 28 Jan
 2024 20:00:30 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-98R002a79391e6-9e20-4b6f-b0fa-8b5caa7702eb,
                    F6BBF12166BF17D31185B0BF3C367C102A143481) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH v2 33/34] kernelshark: Allow to reduce a bit more the graph height
Date: Sun, 28 Jan 2024 19:59:48 +0100
Message-ID: <20240128185948.54928-1-dev@benjarobin.fr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <00e30015-f34b-e80f-bea3-a49d743f9ae2@gmail.com>
References: <00e30015-f34b-e80f-bea3-a49d743f9ae2@gmail.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DAG5EX2.mxp5.local (172.16.2.42) To DAG6EX2.mxp5.local
 (172.16.2.52)
X-Ovh-Tracer-GUID: 4962092b-1468-40a7-bb49-fad96e88f561
X-Ovh-Tracer-Id: 11839400471348600730
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrfedtvddguddukecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecunecujfgurhephffvvefufffkofgjfhgggfgtihesthekredtredttdenucfhrhhomhepuegvnhhjrghmihhnucftqfeukffpuceouggvvhessggvnhhjrghrohgsihhnrdhfrheqnecuggftrfgrthhtvghrnhephfeuleefudelffevtdejudetfeefveeiudeuveeuteekudegffetjeelgedtudffnecuffhomhgrihhnpegtohhnthgvnhhtshhmrghrghhinhhsrdhtohhpnecukfhppeduvdejrddtrddtrddupdefjedrheelrddugedvrdelkedpledvrdduiedurdduvdeirdegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeouggvvhessggvnhhjrghrohgsihhnrdhfrheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohephidrkhgrrhgrugiisehgmhgrihhlrdgtohhmpdhlihhnuhigqdhtrhgrtggvqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehvdelpdhmohguvgepshhmthhpohhuth

Reduce minimum height of the graph widget which allows the user (using the
splitter widget) to expand a bit more the trace viewer (KsTraceViewer)
which provide the table view (KsTableView).
This is very useful when a user has a very small screen.
With this configuration, at least one CPU core on the graph (KsTraceGraph)
can be seen, so the graph widget is still perfectly usable.

Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
---
 src/KsTraceGraph.cpp | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/KsTraceGraph.cpp b/src/KsTraceGraph.cpp
index bc910c8..4599a12 100644
--- a/src/KsTraceGraph.cpp
+++ b/src/KsTraceGraph.cpp
@@ -593,8 +593,8 @@ void KsTraceGraph::updateGeom()
 	       _layout.contentsMargins().top() +
 	       _layout.contentsMargins().bottom();
 
-	if (hMin > KS_GRAPH_HEIGHT * 8)
-		hMin = KS_GRAPH_HEIGHT * 8;
+	if (hMin > KS_GRAPH_HEIGHT * 6)
+		hMin = KS_GRAPH_HEIGHT * 6;
 
 	setMinimumHeight(hMin);
 
-- 
2.43.0

