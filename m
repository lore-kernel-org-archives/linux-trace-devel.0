Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423781D5CE8
	for <linux-trace-devel@vger.kernel.org>; Tue, 10 Dec 2024 10:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733828266; cv=none; b=G9BaQRERaPycofLpK391eZpGKXsQFPvhgssuF+pPQ4UkpMz+Mo/E376cEfiWnnKuONdiH3YuR0+cjB5adsu87nGgzE8q+IPzuK+EIcIj170lfe8rGKNe4RypRUxRFSO8kRlAisxu6Hmaq2QgXUjXVCW2TfEQ/b0peO5mFIcDo/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733828266; c=relaxed/simple;
	bh=+AUVHyjliUvf7DWPVXNhNDlPCvlcQ9fbUNLmSBVZoWA=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=uJrTwJOX5euC3cmLBqIzxGsTewwPJGpkpbD5GS/X0VJm/7ixQ/pftoyKhHLs1dtFCzdIDl8haZWpAYHhO0vF/4fr6DTItiS8W5/cJDseQHMDHW5rdqE1NtPKqWoouovkNnlP/GDVWpRZj6+F8j5Iu/S+pou3nqvLAQUozVc3es4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.whiteo.stw.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <l.stach@pengutronix.de>)
	id 1tKxvz-0003YN-I0
	for linux-trace-devel@vger.kernel.org; Tue, 10 Dec 2024 11:57:43 +0100
Received: from dude02.red.stw.pengutronix.de ([2a0a:edc0:0:1101:1d::28])
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.96)
	(envelope-from <l.stach@pengutronix.de>)
	id 1tKxvy-002fuX-1n
	for linux-trace-devel@vger.kernel.org;
	Tue, 10 Dec 2024 11:57:43 +0100
From: Lucas Stach <l.stach@pengutronix.de>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd meson: add options for doc and utest build
Date: Tue, 10 Dec 2024 11:57:43 +0100
Message-Id: <20241210105743.453410-1-l.stach@pengutronix.de>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-trace-devel@vger.kernel.org

In some cases building documentation or utest is not desired.
Add meson options to allow skipping those build targets.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
---
 meson.build       | 5 ++++-
 meson_options.txt | 4 ++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/meson.build b/meson.build
index 4773f4a941b1..237d9b400ea5 100644
--- a/meson.build
+++ b/meson.build
@@ -140,9 +140,11 @@ subdir('lib/trace-cmd')
 # trace-cmd
 subdir('tracecmd')
 subdir('python')
-if cunit_dep.found()
+if get_option('utest') and cunit_dep.found()
     subdir('utest')
 endif
+
+if get_option('doc')
 subdir('Documentation/trace-cmd')
 
 custom_target(
@@ -150,3 +152,4 @@ custom_target(
     output: 'docs',
     depends: [html, man],
     command: ['echo'])
+endif
diff --git a/meson_options.txt b/meson_options.txt
index 2d5d7457bed5..37d72ff29d87 100644
--- a/meson_options.txt
+++ b/meson_options.txt
@@ -21,3 +21,7 @@ option('docbook-suppress-sp', type : 'boolean', value : false,
        description : 'docbook suppress sp')
 option('python', type : 'combo', choices : ['auto', 'true', 'false'],
        description : 'Generate trac-cmd Python bindings')
+option('doc', type : 'boolean', value: true,
+       description : 'produce documentation')
+option('utest', type : 'boolean', value: true,
+       description : 'build utest')
