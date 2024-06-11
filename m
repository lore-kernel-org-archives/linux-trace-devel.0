Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62795282FD
	for <linux-trace-devel@vger.kernel.org>; Tue, 11 Jun 2024 15:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718120022; cv=none; b=ej50S+GBRaxSWY7Ajg4I04Y43d07CZn+fmdqtr7FL5Csu8scEXm7cAFoBQji8oF7WKYDKyB/RGTmp9xoT6QGrv0dBRfGjiaRw1L2kdcsmKGp7vQbUWZ4wKRnsHLrsU/GgHsWptdi4MloaZ6KZDz90RMDRIeJ94AY59mA1nQsKQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718120022; c=relaxed/simple;
	bh=r0aI4Jyv16MdS1k/KOIANavJWfI/B3vsfBjsoUvp2nQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mg9fk/YIwFutDlPqQY5TBAZQTYaGM3kUJixziNy4xWDSJHFgvqs3slT+75L7p5iOOobb7nKXOpiNL3poM6JfqtFGnAJVXnUvw01LIo8/xwRHnz1bOymZU2IMHtA29W9LJRutfZbupO/eOhe1irkWFNPlOFx6F2puZtOlPa76fTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Htl49dFP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Htl49dFP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718120020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eIDKu+9C1It2DUpYl50Pn3yqrhxEBAzRTyCLU1DavSo=;
	b=Htl49dFP4joy4PyheGsMV9F/LOZ9yGhs9hpC7Zojuu+9inMw2bp/PyS8MaZS+r0ON+qM0P
	lUQNzs7+QQHiMkFI67bsoV/BepJ0tk6UHwMQL+QC13zAz36RvztQoeUCib6xM3CpJ/kBDB
	KqsXM2AmzXLFeWEn+stG9zeP9GMM8fE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-458-tUUN6k94PxC3MBRiabJUCw-1; Tue,
 11 Jun 2024 11:33:38 -0400
X-MC-Unique: tUUN6k94PxC3MBRiabJUCw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0205A195608F;
	Tue, 11 Jun 2024 15:33:38 +0000 (UTC)
Received: from fedora (unknown [10.43.17.163])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id C5B0219560AF;
	Tue, 11 Jun 2024 15:33:35 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Tue, 11 Jun 2024 17:33:34 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Yordan Karadzhov <y.karadz@gmail.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH] kernelshark: fix compiling error in LatencyPlot.cpp
Date: Tue, 11 Jun 2024 17:33:34 +0200
Message-ID: <20240611153334.103780-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Include the <algorithm> header to use std::for_each.

Fixes the following compilation error:
kernel-shark/src/plugins/LatencyPlot.cpp: In function void draw_latency(kshark_cpp_argv*, int, int, int):
kernel-shark/src/plugins/LatencyPlot.cpp:306:14: error: for_each is not a member of std
  306 |         std::for_each(range.first, range.second, lamPlotLat);
      |              ^~~~~~~~

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 src/plugins/LatencyPlot.cpp | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/plugins/LatencyPlot.cpp b/src/plugins/LatencyPlot.cpp
index d412917..5e3393b 100644
--- a/src/plugins/LatencyPlot.cpp
+++ b/src/plugins/LatencyPlot.cpp
@@ -15,6 +15,7 @@
 // C++
 #include <unordered_map>
 #include <iostream>
+#include <algorithm>
 
 // KernelShark
 #include "plugins/latency_plot.h"
-- 
2.45.2

