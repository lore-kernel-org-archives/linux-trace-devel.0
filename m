Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4353984A
	for <linux-trace-devel@vger.kernel.org>; Mon, 11 Mar 2024 11:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710155510; cv=none; b=U4NHh7VpIaU2B+pHyCeZfHYwShd0RH14zB8k+ZO/jPyLK8ieOAoFi0WonzxICf6h0FcfWY7o1HJzm7sj7ArAs51ZIV3it9XDPXQB4Fqe/RL6Yphxd/RuOtKveouqtTcBC77MjpAzyMXVIpo50DOeg+AvnDE+A6TcJqISemWgRts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710155510; c=relaxed/simple;
	bh=q2iKLJyFnFDLS0hpZ6JyBex8qHL/mRbgY5F3mVRVlqg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZcKCNGCivTy765JY1ksS6sOBrXfQnkWIhuxtXz1kYtTDPnx87Tj5jopircdVjqauhTo/A1yXgmGyxm8QQ93DSMApy+2ZAW5lieFvdfCvsoTVxrpWUs9Pq1/90XisCkt/FXgkTaViuY7M2HC5Mv7xDaos3zKEKGdoQ5Wk/xg82/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=O6IKwKLp; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=WUT4bG8/; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="O6IKwKLp";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="WUT4bG8/"
From: Alexander Kanavin <alex@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1710155506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fcHLQDYnnlVxzW/mrNoJsU2o6bk4a+8rpjj3w4xVc6g=;
	b=O6IKwKLpq94caB4LWXuTKAxWKuibHB+OvXGrz6aQqU1H7+Ueqj+27rTKiWjQHvmBXpzo00
	Lh0ciY+WPkLx1sU472/rpDKoHag4s94wFZaVYrzAghrO9cvRvYgDkUjIRaltJN8wmIf8B3
	q5OdB/jCmAYiy0GPoaDB1UR3q9Z0hzQrI4OXmnv2gz0kDTEkgND9KlDw5Gi7MFVFA5lgx2
	70JSeBi+JTa+W0ChGTn5Ma8RPfeT3A2WwSYQ96MQyhHHVlO0TassYxzaEswEcevR11ThJ7
	9mGPVs5X0PxesZ3nYPhdxS8eKspB7M65Y1JU5UV0aFXpReuw1TddEq804rvFbg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1710155506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fcHLQDYnnlVxzW/mrNoJsU2o6bk4a+8rpjj3w4xVc6g=;
	b=WUT4bG8/PrnQSWNYKOctiN4qWmyCclnWXvNcsNr5pEP+Ub67OVTwsOfvHW8fraZJJSFJH3
	S6ANqQgA5r11L5Dw==
To: linux-trace-devel@vger.kernel.org,
	rostedt@goodmis.org
Cc: Alexander Kanavin <alex@linutronix.de>,
	Ross Burton <ross.burton@arm.com>
Subject: [PATCH] build: various fixes for the Meson build of libtraceevent
Date: Mon, 11 Mar 2024 12:11:40 +0100
Message-Id: <20240311111140.1789879-1-alex@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

- Make the plugin directory the same as the Makefiles
- Install the plugins as modules not static and versioned shared libraries

Signed-off-by: Ross Burton <ross.burton@arm.com>
Signed-off-by: Alexander Kanavin <alex@linutronix.de>
---
 meson.build         | 2 +-
 plugins/meson.build | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/meson.build b/meson.build
index 40ce38c..1eb7912 100644
--- a/meson.build
+++ b/meson.build
@@ -25,7 +25,7 @@ htmldir = join_paths(prefixdir, get_option('htmldir'))
 libdir = join_paths(prefixdir, get_option('libdir'))
 plugindir = get_option('plugindir')
 if plugindir == ''
-    plugindir = join_paths(libdir, 'libtraceevent/plugins')
+    plugindir = join_paths(libdir, 'traceevent/plugins')
 endif
 
 add_project_arguments(
diff --git a/plugins/meson.build b/plugins/meson.build
index 74ad664..4919be4 100644
--- a/plugins/meson.build
+++ b/plugins/meson.build
@@ -19,11 +19,10 @@ plugins = [
 
 pdeps = []
 foreach plugin : plugins
-    pdeps += library(
+    pdeps += shared_module(
         plugin.replace('.c', ''),
         plugin,
         name_prefix: '',
-        version: library_version,
         dependencies: [libtraceevent_dep],
         include_directories: [incdir],
         install: true,
-- 
2.39.2

