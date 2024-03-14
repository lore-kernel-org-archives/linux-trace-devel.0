Received: from mx.n90.eu (mx.n90.eu [65.21.251.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502CB7316C
	for <linux-trace-devel@vger.kernel.org>; Thu, 14 Mar 2024 16:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.251.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710433676; cv=none; b=BbkqAHW9jpIcz2+3oLK2tkHNhIVtSRx8qdhaLrqrcKfVc2txKdNpbXCV5iYlHBSdtPWCp8p+8Yi+USxQs6Fi49u2F8la1Hus1zUv2wbJ0fHdE03hitMtEnvO2mmW+WA474w5tyLZmBCwvPBxFjePKasXBSO4zn2rz6tz60GuUVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710433676; c=relaxed/simple;
	bh=6f5MapfZM0dA19x71O6XjxP2+SlxOFFvq2zlF5V3jEw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WaSTqtHjSVSn9ufxiSSM/Z8PLcUegLtxZoH8Uc5Rqbv6eC2+qEzAKjWKNpPRE6K+LTiRafaZP+bXszXLmlAfwXXv0fxn6sedx12jxlUX6i6/hilN4fReBap8ZMArDIjBDXyjNQ4gcDyQ81hYZEEi0wjmhyeK8kHZm+85rR2n/eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=n90.eu; spf=pass smtp.mailfrom=n90.eu; dkim=pass (2048-bit key) header.d=n90.eu header.i=@n90.eu header.b=f9Oz2+eo; arc=none smtp.client-ip=65.21.251.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=n90.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=n90.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=n90.eu header.i=@n90.eu header.b="f9Oz2+eo"
From: Aleksander Trofimowicz <trof@n90.eu>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=n90.eu; s=default;
	t=1710433252; bh=u5hZ2UPllf6vGFcdT+RUn4NIY3yqW+dTYfTl/Wx9B3A=;
	h=From:To:Subject:Date;
	b=f9Oz2+eoO4MpSAKHPQmeWvw7Hc89pza/zPwuLM/nU8cSYD9FH1395VFq0bk+sJXMG
	 QB/e8bVvv/uUEkkQZWrxvBHjCwDIpSeaH9/Ghn/sRd8rgOqKalK7rpYoT4URY3E88f
	 DpFNwsrnAHuQPb45d+97sGNflLswGOSWGR6uazNnri1eY1LCyu647B92DTwS0Cy2Um
	 20pRT4LshJhfvlPVje8a9mtTf01BKy4ZvqQm+ytmyft9U3WSVj2qNngMKgnTOcCb2T
	 5X9gVF6TFtWmjgfxAYgnyYdYfXC0E9BypC7F/AIRifN7SsRwPcHCjG3KyTMFFHF03R
	 Idlo4+ZCT+z9w==
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtracefs meson: Use SemVer in the build description
X-Mailer: boring 1.0
Date: Thu, 14 Mar 2024 16:20:43 +0000
Message-ID: <87v85okco4.fsf@mx.n90.eu>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Meson adheres to RPM rules while exercising version
sorting. Therefore 1.8 < 1.8.0; Meson-driven builds of trace-cmd
are broken since b86599e459 since a dependency requirement
cannot be met.

Signed-off-by: Aleksander Trofimowicz <trof@n90.eu>
---
 meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/meson.build b/meson.build
index 3156f1c..91ee79a 100644
--- a/meson.build
+++ b/meson.build
@@ -6,7 +6,7 @@ project(
     'libtracefs', ['c'],
     meson_version: '>= 0.50.0',
     license: 'LGPL-2.1',
-    version: '1.8',
+    version: '1.8.0',
     default_options: [
         'c_std=gnu99',
         'buildtype=debug',
--
2.44.0
--
at
