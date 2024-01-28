Received: from smtpout1.mo529.mail-out.ovh.net (smtpout1.mo529.mail-out.ovh.net [178.32.125.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A514E31A82
	for <linux-trace-devel@vger.kernel.org>; Sun, 28 Jan 2024 19:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.32.125.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706469986; cv=none; b=bqKTKvMZVXzs3PP3E6L3hVVG3OevrOQOgkJcxX9kgYhJ+6cJXonCOxJ/iRS4rAOsnUcSJZ0rj/DdhRPRXszN3jwm/SKGteuR7eLbb7vbff3sWoFENwJUO23QTR13+oaiimyxtvCjfWwTq2gf7WQrXZ91KoOJE2Qnp8oPvJt3PjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706469986; c=relaxed/simple;
	bh=b2BDqdOLKlFpbBEKxJWAsTDNfOSB7v9ZmSM5vAp0Qx8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RvUknH/CGFB1cYLlbTw1zopj5zWzRn/KDJLFQBid7kRj5VkDbujsAccCguj8iWD9hGdTRIde6xRQESAb3ONEfxKDOx4hs/DkpEEH7hxIT8Gy/7eMWFY2LpgMmKydTYOz2WXhK57HteX5OyweW34HU0JDQEIP1p4iAgw47psJHAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr; spf=pass smtp.mailfrom=benjarobin.fr; arc=none smtp.client-ip=178.32.125.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.109.140.93])
	by mo529.mail-out.ovh.net (Postfix) with ESMTPS id C33A52044F;
	Sun, 28 Jan 2024 19:26:21 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.106) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 28 Jan
 2024 20:26:21 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-106R00662ac2f67-aa6c-41af-bf85-352244ba7130,
                    F6BBF12166BF17D31185B0BF3C367C102A143481) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH v2 11/34] kernelshark: Prevent potential divide by zero in Shape::center()
Date: Sun, 28 Jan 2024 20:26:14 +0100
Message-ID: <20240128192614.56399-1-dev@benjarobin.fr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <b6f83022-36f2-1115-2221-25f77be26332@gmail.com>
References: <b6f83022-36f2-1115-2221-25f77be26332@gmail.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DAG7EX1.mxp5.local (172.16.2.61) To DAG6EX2.mxp5.local
 (172.16.2.52)
X-Ovh-Tracer-GUID: a42ef0c5-9623-46fc-b72f-2185a2c97ce6
X-Ovh-Tracer-Id: 12275968162557747098
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrfedtvddguddvfecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecunecujfgurhephffvvefufffkofgjfhgggfgtihesthekredtredttdenucfhrhhomhepuegvnhhjrghmihhnucftqfeukffpuceouggvvhessggvnhhjrghrohgsihhnrdhfrheqnecuggftrfgrthhtvghrnheptdehteffieekvdejgeduleehleekheehkefggfehhedtveejffejvdegtdevhfejnecukfhppeduvdejrddtrddtrddupdefjedrheelrddugedvrddutdeipdelvddrudeiuddruddviedrgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqedpnhgspghrtghpthhtohepuddprhgtphhtthhopeihrdhkrghrrgguiiesghhmrghilhdrtghomhdplhhinhhugidqthhrrggtvgdquggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhohedvledpmhhouggvpehsmhhtphhouhht

Signed-off-by: Benjamin ROBIN <dev@benjarobin.fr>
---
 src/KsPlotTools.cpp | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/KsPlotTools.cpp b/src/KsPlotTools.cpp
index 1d63a9b..f362eaa 100644
--- a/src/KsPlotTools.cpp
+++ b/src/KsPlotTools.cpp
@@ -318,6 +318,9 @@ ksplot_point Shape::center() const
 {
 	ksplot_point c = {0, 0};
 
+	if (_nPoints == 0)
+		return c;
+
 	for (size_t i = 0; i < _nPoints; ++i) {
 		c.x += _points[i].x;
 		c.y += _points[i].y;
-- 
2.43.0

