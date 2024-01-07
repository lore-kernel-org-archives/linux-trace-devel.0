Received: from smtpcmd01-sp1.aruba.it (smtpcmd01-sp1.aruba.it [62.149.158.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5352C13AE2
	for <linux-trace-devel@vger.kernel.org>; Sun,  7 Jan 2024 23:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benettiengineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=benettiengineering.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b="Q7Sjwtg/"
Received: from localhost.localdomain ([84.33.84.190])
	by Aruba Outgoing Smtp  with ESMTPSA
	id McFGro73NPhz2McFGrkSN4; Mon, 08 Jan 2024 00:07:54 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1704668874; bh=GrzPyiZNDFWAYlM6xUeJ6eVJr2vYcUzcmLlyP1N2MxY=;
	h=From:To:Subject:Date:MIME-Version;
	b=Q7Sjwtg/3YbIHxnBNYQkC3h62/uZOS0MU9OwpwqRtTMhl/fSh2O+oDm4WKBRjp7T5
	 JOH67J4Yx/4BcdP88M45rw488QBLZzzxJwzfGBHNQFH9+X1xdwz1p8qcEGuj2IwG7D
	 YS8BmQcso1JBSZ/8KEXMNIGEnganvucXc9Kk2sPzEE4O0uPnKzX0Y38GB8K/oesCiT
	 zyUxNQc4qfSa6nKvVbSNx1HjvyHhGIQ0NX5rDmLga0EQvezPJIfoeNjgSoXIMDbEGc
	 BbCiHBEwBVgpwM3mV+1TZJwAuJIZjaUsbsIlCnjQ1mPnDhcvQkZnbLeqDoSfG1beSN
	 LHYDDnpI3nZmw==
From: Giulio Benetti <giulio.benetti@benettiengineering.com>
To: linux-trace-devel@vger.kernel.org
Cc: Giulio Benetti <giulio.benetti@benettiengineering.com>
Subject: [PATCH] libtraceevent: add libdl dependency to meson
Date: Mon,  8 Jan 2024 00:07:53 +0100
Message-Id: <20240107230753.461368-1-giulio.benetti@benettiengineering.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfPepHTWTp9Q1l6wti5qeKZEJ/8ARsWlyU5YKT6BJBzHNuTiAzd+sygTQDJinY140pH7R1CNHcf9DFHwLRJpCYqO9WMsl6XToVxwL5JhjfEhntbijSKx4
 BRN7oRRHf4+1FRL3eMwU6Q0oXiV5cvvPDM9gB19URZ0Gh9DHA94AdxrkQOWndlgz1/4Cje0i3sjzmM9/Q54nFm3151hcv2ZFPgvbANxLhZhLnlwXHvUrY2rq
 KWI2SjoBzHe244oAoqpTySf0NEkRyWOSOYttS2eheclowcGSHGrJmVPMRRju3W85

Libdl is mandatory since it's used by plugins, so let's add it to meson to
prevent build failure where -ldl is not implicit.

Signed-off-by: Giulio Benetti <giulio.benetti@benettiengineering.com>
---
 src/meson.build | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/meson.build b/src/meson.build
index 20b1b7b..cd48de7 100644
--- a/src/meson.build
+++ b/src/meson.build
@@ -13,10 +13,14 @@ sources= [
    'trace-seq.c',
 ]
 
+cc = meson.get_compiler('c')
+dl_dep = cc.find_library('dl')
+
 libtraceevent = library(
     'traceevent',
     sources,
     version: library_version,
+    dependencies: [dl_dep],
     include_directories: [incdir],
     install: true)
 
-- 
2.34.1

