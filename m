Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30962B66C
	for <linux-trace-devel@vger.kernel.org>; Sat, 30 Sep 2023 20:40:13 +0000 (UTC)
Received: from smtpcmd13147.aruba.it (smtpcmd13147.aruba.it [62.149.156.147])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BC8CA
	for <linux-trace-devel@vger.kernel.org>; Sat, 30 Sep 2023 13:40:11 -0700 (PDT)
Received: from localhost.localdomain ([146.241.127.78])
	by Aruba Outgoing Smtp  with ESMTPSA
	id mgkzqsNaHa8HKmgkzqo8ux; Sat, 30 Sep 2023 22:40:09 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
	t=1696106409; bh=vbvvJSglB03SRfbGPyIDREambIiXBhoq2dMRs3ysQK8=;
	h=From:To:Subject:Date:MIME-Version;
	b=cnxARjTjmkLHEjNtmy2JIOksQGHL9JRbdSCEYUeG/9elYcm+j3S0q3kvPwrC5wlWr
	 K+c8WEvbcnd9GUXbwx5QiA/B0h1p7gv2CS8Rw6GFVn3XasyxlnG+0XPLyq3ZY8Z/6g
	 0BRkXoG4iEM9NO1Di9rTKhC1QojhAuQVnbNMmgKOy9eyWn8u0uIgrdKWk/bCZXYj0z
	 Ap03bDvdtdVMd1jiJxr7lzBtuKN/opA3VxjlMgoR1qVgZ2bNf9vcY1g7Biog3C2BsV
	 pu5P+fWx8NGE3bI0G6E3zYsKd4mpY3l8KwZCZKB3pg3aVQT3jGhiX1M9sF+CeGiRd/
	 nsBxJD6XZ0ieA==
From: Giulio Benetti <giulio.benetti@benettiengineering.com>
To: linux-trace-devel@vger.kernel.org
Cc: Giulio Benetti <giulio.benetti@benettiengineering.com>
Subject: [PATCH v2] libtracefs: add option to disable documentation
Date: Sat, 30 Sep 2023 22:40:08 +0200
Message-Id: <20230930204008.2528607-1-giulio.benetti@benettiengineering.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfDV2LXXjzL0szZhrYwzlpiMwY1n6ihFjTpCo9ZhPogKryplSuV3mHw+CTVbzX6eO2mpkU7G/zG4ug7oe8vZv+d3nA89gXpNdaNF4TbzDS/BX/oHF3Y0C
 bo5Fj941hIto6CaWNx95AI7mSrEgh+DqfR6mzGzp6l2g7BuJA3Nf9TET32PVSxgBwn91INLz2XAlRhllgPxe9nLpKHo10vQIyZxEKWBCG+eAsHN0faO72TFd
 uDz8QulsNfrZP2MmU1jhdIp+YefFPMxpfnIgQKRQvGYMtfAhDt/jpP8U9oXXLx3S
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On some Linux environment builder(i.e. Buildroot) host asciidoc is not
provided since by default all man/docs are not installed to target but
meson.build at the moment build ascii and html documentation and
requires asciidoc making the building to fail. So let's add doc option
set to true by default to let the user to override it and not produce
the documentation.

Signed-off-by: Giulio Benetti <giulio.benetti@benettiengineering.com>
---
V1->V2:
* improve commit log as suggested by Steve Rostedt
---
 meson.build       | 3 +++
 meson_options.txt | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/meson.build b/meson.build
index 9d42d78..f1e492e 100644
--- a/meson.build
+++ b/meson.build
@@ -39,6 +39,8 @@ if cunit_dep.found()
     subdir('utest')
 endif
 subdir('samples')
+
+if get_option('doc')
 subdir('Documentation')
 
 custom_target(
@@ -46,3 +48,4 @@ custom_target(
     output: 'docs',
     depends: [html, man],
     command: ['echo'])
+endif
diff --git a/meson_options.txt b/meson_options.txt
index 1d92c28..5533a88 100644
--- a/meson_options.txt
+++ b/meson_options.txt
@@ -14,3 +14,5 @@ option('man-bold-literal', type : 'boolean', value : false,
        description : 'enable bold literals')
 option('docbook-suppress-sp', type : 'boolean', value : false,
        description : 'docbook suppress sp')
+option('doc', type : 'boolean', value: true,
+       description : 'produce documentation')
-- 
2.34.1

