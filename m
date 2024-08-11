Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B009446AF
	for <linux-trace-devel@vger.kernel.org>; Sun, 11 Aug 2024 13:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723384529; cv=none; b=mm7+C+JPmTLc5G6eBKFCvN1C42MtVKtyaxKkJGzeiugb15yGnlQ+wjq2GDT/AmSWHpokGCoUQS1gUdFCZ3p439mqpQ+6U1zc/Ft5LyZZsOqp2U3r+P8fc1DtE3d3NxmD9CK6qZJk7omUtFn1CiUmH5zbHbmyTJ149DV9sVp1ZPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723384529; c=relaxed/simple;
	bh=hQGfC1bDq+T5tEh50LcwYg97mwBJOdrCqwzfhEITYic=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FwZfnyaY/LF+u5+yhJ+hMLHhYLJPlf1ZqMNX9+OKlsdmMhJXIocGf44hEJZVPyNiCRfWJiq/ZscdkcxGE1nxDrj7tlXRuIofrjyPqb9mMAUsr1tp+mJr6N5IPuJsAQzrxpTxcSM0w9I65x1LB8dWavWe1qN2B/+4GPkk9oi3mG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=fiona.klute@gmx.de header.b=idjIi6Xh; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=fiona.klute@gmx.de header.b="idjIi6Xh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1723384523; x=1723989323; i=fiona.klute@gmx.de;
	bh=hQGfC1bDq+T5tEh50LcwYg97mwBJOdrCqwzfhEITYic=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:Message-ID:
	 MIME-Version:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=idjIi6XhHN+Z/0ikA0vNRLPiGMDcQjdKz+pf6ShP4VcwrjYCIiwNhaaxsVmfFnBC
	 M0DmwByQyuK6QEwlMRgs1AsVg3xvi69KTR2H+0Ict4zHlg9RgZMA33nt25Lw1b5xe
	 U1gVseEW6/UzDo8ONcZI4iIuJZ8bG87Ow57sMEnyyGprK3Xb1mSXiVp6CHNWTGkap
	 aBanHVmzTjGtRXxhacHCC9+2umqm4OmtZHVLg9xgxRItoh9O6mPO/tGI4hhAuNYp4
	 FM6x1x065C7v6NUu3eYeLnvIRAj1rAkGeuQGRI08iQEFSQCVW4LnDbhdD+YU1qQfl
	 +iPvlxhhPGG9NfDaOQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from haruka.lan ([85.22.123.31]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mxm3K-1sGPvZ2jgE-00y0p7; Sun, 11
 Aug 2024 15:55:23 +0200
From: Fiona Klute <fiona.klute@gmx.de>
To: linux-trace-devel@vger.kernel.org
Cc: Fiona Klute <fiona.klute@gmx.de>
Subject: [PATCH] trace-cmd: utest: include libgen.h for POSIX basename()
Date: Sun, 11 Aug 2024 15:55:16 +0200
Message-ID: <20240811135517.3764297-1-fiona.klute@gmx.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:imWPp2qgI4Em1ruT154anYGwUBjA6cpzssDiVvppIWq2fhzowhZ
 XQeh9BV+sRboB3nO2Qs7L3r9+X3R/a3Epm8kqNkx4Bh477zIayWEowTh1vPCP4Mrw9kecP8
 Ns+WdJKwtPGrggqpEF+jLNQl1WmPgmt2BrCBNGDi+oNttzuzhPCBzjy0chJzM5SiZ8If/cr
 fn8EuiwnyBtdXq04l80UA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:4/K2i8pVOZQ=;BsPFRTahbi75XZ623bS/yewmfTl
 6Dq43E8tNcpgkmTMODWTeh5o/LUZ2RuLBuZ4A3WCkg9zMXCn110D2OyLdltrFYJmaOMMZeZED
 AdbWeO5qSI1lrtmSNY0sl68W/jgt9ayU5wEnEOD/kSJ15RybN/Pb+sXQEBR/lOfEkWavy+78K
 nt7/LcYPy/EpggynrXAdCVbprabaDoCE+H2hHt08V09ryq6NDdiEhjgaKnV54si9ICpsYkFRH
 k/ZBsrixhKvqCVBGvnX2H12kRoPBcUehCrhiXcNnE6Qr+tpWsiwdHEZwWvymnf3XDHSTFTlSB
 N4SWaqR3BdKccaCSPQoXh0TJRaoxbsZ/k+wt+1fhdiD7o1DR3QDGHwXrk7KAm/105KVnK1vbX
 EdKwdViKj14xynF+9GmRU3McJqHT5yqOgj/rXe1Nld7OFftGRs54ofJ0YXLBSCw8C1lVeN+L1
 o+3QTuT18SFvkZsFFNk9hXHR7K3mW8VoVh+DYZsRIDoDBFR1y6OdpeCibuFwt1AaiEpMpukwt
 MYBiOSsQJbcreYNcsfENf6Mobby9dZk46xAcp+55nhzNX5fHuE+3IdQkDBUmzW03pmC0hqK3v
 wUWL0CKPbwvxV0b8WUa5wxjvpes2Uzv5DZKnRHSRwdspolerxbzcXpazgAcqUjUuZdQbm0M/d
 W9+BkKkwcdvbCRYQuVq1xVREA06xIz4Jbr39S5qtV0G9FrCxmIRsPj8ZhNFNrWwCzJtPFakma
 aywZWSBZDpMPMSmdA+ZEp9YojADfuu7itEM+hDhir5E0uK6739I0BKU6b8jDvslgj9P8fBHmV
 9nhT+0Xy1rHvQi8XEkjLbifg==

This fixes building utest/trace-utest.c with musl (e.g. on Alpine),
which doesn't provide the GNU version.

Signed-off-by: Fiona Klute <fiona.klute@gmx.de>
=2D--
 utest/trace-utest.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/utest/trace-utest.c b/utest/trace-utest.c
index 051a0285..6bb190ee 100644
=2D-- a/utest/trace-utest.c
+++ b/utest/trace-utest.c
@@ -7,6 +7,7 @@
 #include <unistd.h>
 #include <getopt.h>
 #include <stdlib.h>
+#include <libgen.h>

 #include <CUnit/CUnit.h>
 #include <CUnit/Basic.h>
=2D-
2.45.2

