Received: from rcdn-iport-9.cisco.com (rcdn-iport-9.cisco.com [173.37.86.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8471F192E
	for <linux-trace-devel@vger.kernel.org>; Mon, 24 Mar 2025 23:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742860755; cv=none; b=X+g1kYnSI25cGNEiaRS77N/aQnj3M5mA2RgpsGXw5w3DM+GW4HyhSaVLTiY4TAAOYaC83m0QIGHjcaRyTRC0QGAiLM5suuiUCpxzS+6bIyTSrOD/PNmrJ6MIntAK1/fWOBi9ARJxotKSa7A+1XUVISst7kZ1UQxwv4gwof/h0ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742860755; c=relaxed/simple;
	bh=E37SYBpgui9eptX7XnPSsxTiaxAX4io0tg8Z1noZPso=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=lvm40eRfzFLysuJckvGM0US5Pm4wHey6J92QHIYxFThS7fEFK1v5ETDHsa4hnZM7zj7bVjflCpJUjas5T9KhSt6BkYEn+sf6B+lPOFAuQtOiNCTSWjdNxKgDMw1zJeA+lzCCbwnIECLuYu6/y1jdV4jE3sSkPHSim0Tq3GBdDAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=gcP34eR5; arc=none smtp.client-ip=173.37.86.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="gcP34eR5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1487; q=dns/txt;
  s=iport01; t=1742860753; x=1744070353;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+sS+s5HQu444tyEBkAH78AccCOU+boUBCKeKPHwrtgI=;
  b=gcP34eR5V+3ly3HFN1lob+dNaLBYbbVRdq4tjyqapz8DB4s384ZMdMTg
   H460JSnGFoUUmlOIf809MKICfOsKeuOqE0cpb1z1Kfz4f6hG/mT+QtOh/
   M4DlijqP1CIDmXIXz81F9uHsoJm2WViZDCUMA0+WY0vziXMaAQF1zIZXX
   xFnzYGKpAI2mk31X+ipwyRWvj/POCFLz43Jz4t6oVl+uNMzazQl8w/5aP
   SulD7RngcKQy2R8xEmPWOhOxixmEqsHE6TUlM4LTNfyfmdMgv2Ji+tlZl
   VPFM/OPYr/NYfjmAk+jHJczSStoays398NFD5dDR5ZCXbFNZ7xBo6BPMM
   A==;
X-CSE-ConnectionGUID: 1NO9Rg+eR+q6mFl835qBCA==
X-CSE-MsgGUID: uySLU+c/Qcu57B3vW0cL2Q==
X-IPAS-Result: =?us-ascii?q?A0ArAACP8OFn/5T/Ja1aHAEBAQEBAQcBARIBAQQEAQGBf?=
 =?us-ascii?q?wcBAQsBgkqBT0NIjHKHNI4XkiGBJQNWDwEBAQ9EBAEBkCoCJjQJDgECBAEBA?=
 =?us-ascii?q?QEDAgMBAQEBAQEBAQEBAQsBAQUBAQECAQcFgQ4ThgiHEwGCFoMCgmUDrwOCL?=
 =?us-ascii?q?IEBhHzZOIFugUgBjUyFZycbgUlEgRWDaIUQhXcEgi+FKoZIhn2BDogaiEiLS?=
 =?us-ascii?q?0iBIQNZLAFVEw0KCwcFgWwDNQwLLhWBRXuCRGlJOgINAjWCG3yCKIRNhD6EP?=
 =?us-ascii?q?4VQghGCBIknhGAtT4MOQAMLGA1IESw3FBsGPm4Hom06hDwHAYELAgGoOKEGh?=
 =?us-ascii?q?CWhSBozhAOmUwGYfoJYoXOEaIFnPIFZTSMVgyJSGQ/UfyYyPAIHCwEBAwmRZ?=
 =?us-ascii?q?QEB?=
IronPort-Data: A9a23:FFjvuKJoEfJsdmSNFE+RmZQlxSXFcZb7ZxGr2PjKsXjdYENSgTEDz
 jcWCDjXaa6CMDf1e94gPd/g8x9UsJaExtYwSwod+CA2RRqmiyZq6fd1j6vUF3nPRiEWZBs/t
 63yUvGZcoZsCCea/kr1WlTYhSEU/bmSQbbhA/LzNCl0RAt1IA8skhsLd9QR2uaEuvDnRVrR0
 T/Oi5eHYgL9gGQoajh8B5+r8XuDgtyj4Fv0gXRmDRx7lAe2v2UYCpsZOZawIxPQKqFIHvS3T
 vr017qw+GXU5X8FUrtJRZ6iLyXm6paLVeS/oiI+t5qK23CulQRuukoPD8fwXG8M49m/c3+d/
 /0W3XC4YV9B0qQhA43xWTEAe811FfUuFLMqvRFTvOTLp3AqfUcAzN03KmZnB4Jb99w0GD9L2
 /hIc20URDuq0rfeLLKTEoGAh+w5J8XteYdasXZ6wHSAVLAtQIvIROPB4towMDUY358VW62BI
 ZBENHw2MESojx5nYj/7DLo5me60h2TkcxVTqUmeouw85G27IAlZi+S0aIWNK4zQLSlTtluJn
 Ub7vG++OxoHaYO1kiS6qnmI3NaayEsXX6pXTtVU7MVChFyV23xWFAcfXlb+rfSnh0qWRd1SM
 QoX9zAooKx081akJuQRRDWiq3KC+xpZUN1KHqhjsUeGy7Hf5ECSAW1soiN9VeHKffQeHVQCv
 mJlVfuwbdCzmNV5kU6gy4o=
IronPort-HdrOrdr: A9a23:+xWKCq/qHkoCLhtLG59uk+DLI+orL9Y04lQ7vn2ZLiYlEfBw+P
 rAoB1273XJYVUqOE3I5+rvBEDoexq1nqKdirN8AV7NZmTbUROTTb2LKeDZsljd8+qUzJ8+6Z
 td
X-Talos-CUID: 9a23:V4x/TWzbKylrUzGAdcFbBgVNPOd0SHKewU2TOhG9J2I5E+CMY3S5rfY=
X-Talos-MUID: =?us-ascii?q?9a23=3AzEz7JQ9z1sNE8dMR0DRrMBKQf9p52ICTS0tKqJ4?=
 =?us-ascii?q?b5paubjJPYzy51g3iFw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.14,273,1736812800"; 
   d="scan'208";a="341070982"
Received: from rcdn-l-core-11.cisco.com ([173.37.255.148])
  by rcdn-iport-9.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Mar 2025 23:59:12 +0000
Received: from sjc-ads-6997.cisco.com (sjc-ads-6997.cisco.com [10.30.218.117])
	by rcdn-l-core-11.cisco.com (Postfix) with ESMTP id 2B9E018000163
	for <linux-trace-devel@vger.kernel.org>; Mon, 24 Mar 2025 23:59:12 +0000 (GMT)
From: Oleh Matiusha <omatiush@cisco.com>
To: linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtracefs: improve reproducibility
Date: Mon, 24 Mar 2025 16:59:11 -0700
Message-Id: <20250324235911.576688-1-omatiush@cisco.com>
X-Mailer: git-send-email 2.35.6
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Outbound-SMTP-Client: 10.30.218.117, sjc-ads-6997.cisco.com
X-Outbound-Node: rcdn-l-core-11.cisco.com

Currently, the files generated by flex & bison are present among sources
to ease builds for people lacking these tools. However, make rules for them
are also present in Makefile, and while fetching source code, targets might
or might not be created with timestamps older than their prerequisites.
This means in build environments with flex and/or bison available, the
decision whether headers will be regenerated from sqlhist.l and sqlhist.y
is random. Since more fresh versions of these tools make different outputs,
this breaks build determinism, which is essential for people wanting their
builds to be reproducible. Assuming those who have their own flex & bison
want headers to be generated by fresh versions, I modified Makefile to check
for them and add corresponding targets to .PHONY to force re-generation,
retaining fallback option in case of their absence.

Signed-off-by: Oleh Matiusha <omatiush@cisco.com>
---
 src/Makefile | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/src/Makefile b/src/Makefile
index be81059..aa0f280 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -29,6 +29,14 @@ OBJS += sqlhist-lex.o
 OBJS += sqlhist.tab.o
 OBJS += tracefs-sqlhist.o
 
+# update lexer and parser headers if tools available
+ifneq ($(shell command -v bison),)
+.PHONY: sqlhist.tab.c
+endif
+ifneq ($(shell command -v flex),)
+.PHONY: sqlhist-lex.c
+endif
+
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 
 $(LIBTRACEFS_STATIC): $(OBJS)
-- 
2.35.6

