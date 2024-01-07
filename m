Received: from smtpcmd10102.aruba.it (smtpcmd10102.aruba.it [62.149.156.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D618125A8
	for <linux-trace-devel@vger.kernel.org>; Sun,  7 Jan 2024 23:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benettiengineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=benettiengineering.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aruba.it header.i=@aruba.it header.b="gfxvU+h6"
Received: from localhost.localdomain ([84.33.84.190])
	by Aruba Outgoing Smtp  with ESMTPSA
	id McEwrVFAs1f5IMcEwrAJPu; Mon, 08 Jan 2024 00:07:35 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1704668855; bh=xSh7UhaIe6XSQmVPANdaMFZWW6sJHCCYoEhVX48NTjg=;
	h=From:To:Subject:Date:MIME-Version;
	b=gfxvU+h6yMiPX1qnsQO8d8dakHStQXaYqlTR/wTJa+NC3na2bLAuqnoqGBI/p3GY0
	 oNtmqDZkxYG1OMebgFS3j525+lwgezeI6ECnhFfACfHeHkxoRk9IL0IHC8aGa59DYd
	 bOae0uLxjnRyUo/8YXMDa2bp1oEAHakog7zzMbFUD6PkIBP1UQ6SI3cEFLlCdfej0R
	 m2xx8OtvFoRhDBNed9h9IV7trAdVYV/rbd96aD/qkBQtGqliXnQldlRxS7uCUh/EE7
	 SG8UhoFrsezGmw7OZqiKrRwBeFltQgZfjL9KvYDr/zb7szfHti1gYRufRKI/OImv4e
	 jy+O8cIe7TH7w==
From: Giulio Benetti <giulio.benetti@benettiengineering.com>
To: linux-trace-devel@vger.kernel.org
Cc: Giulio Benetti <giulio.benetti@benettiengineering.com>
Subject: [PATCH] libtracefs: add option to disable samples
Date: Mon,  8 Jan 2024 00:07:33 +0100
Message-Id: <20240107230733.456099-1-giulio.benetti@benettiengineering.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfCOjVnrdehYyv/7IBQuTNy5zYKxtbMdll4I3LhTon3e6tH450t6nS/++nXaOEfodjmDCJCrXLw0fR9AputoaRdkoyZyV8iLGywMrcMu5m3w6h3mESFt+
 KWoA5mbNwm7ot369Ez2jB1C7XZXn5S9U8QAwdZQA9mGeG0zYK24Id74rmuetoLf4bUGnCivzQQifhEW+YONMEK3TadTCOF7vkl27QWOL8RMQ18j+rQpAPRM4
 x+dr9+Q0h199b4t4NSTyaudrfnkP48E+i23r2ZaCaFUOGCeeFamFGMgc7x7i4ilP

On some Linux environment builder(i.e. Buildroot) we don't want to produce
sample to reduce size usage and dependencies count. So let's add samples
option set to true by default to let the user to override it and not
build samples.

Signed-off-by: Giulio Benetti <giulio.benetti@benettiengineering.com>
---
 meson.build       | 2 ++
 meson_options.txt | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/meson.build b/meson.build
index 57ffe20..f7d3da6 100644
--- a/meson.build
+++ b/meson.build
@@ -38,7 +38,9 @@ subdir('include')
 if cunit_dep.found()
     subdir('utest')
 endif
+if get_option('samples')
 subdir('samples')
+endif
 
 if get_option('doc')
 subdir('Documentation')
diff --git a/meson_options.txt b/meson_options.txt
index 5533a88..8450992 100644
--- a/meson_options.txt
+++ b/meson_options.txt
@@ -16,3 +16,5 @@ option('docbook-suppress-sp', type : 'boolean', value : false,
        description : 'docbook suppress sp')
 option('doc', type : 'boolean', value: true,
        description : 'produce documentation')
+option('samples', type : 'boolean', value: true,
+       description : 'build samples')
-- 
2.34.1

